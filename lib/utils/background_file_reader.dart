import 'dart:async';
import 'dart:isolate';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';


class BackgroundFileReader {
  final SendPort _commands;
  final ReceivePort _responses;
  final Map<int, Completer<Uint8List>> _activeRequests = {};
  int _idCounter = 0;
  bool _closed = false;

  Future<Uint8List> readChunkFile(XFile file, int chunkSize, int chunkIndex) async {
    if (_closed) throw StateError('Closed');
    final completer = Completer<Uint8List>.sync();
    final id = _idCounter++;
    _activeRequests[id] = completer;
    _commands.send((id, file, chunkSize, chunkIndex));
    return await completer.future;
  }

  static Future<BackgroundFileReader> spawn() async {
    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    initPort.handler = (initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete((
      ReceivePort.fromRawReceivePort(initPort),
      commandPort,
      ));
    };

    try {
      await Isolate.spawn(_startRemoteIsolate, (initPort.sendPort));
    } on Object {
      initPort.close();
      rethrow;
    }

    final (ReceivePort receivePort, SendPort sendPort) =
    await connection.future;

    return BackgroundFileReader._(receivePort, sendPort);
  }

  BackgroundFileReader._(this._responses, this._commands) {
    _responses.listen(_handleResponsesFromIsolate);
  }

  void _handleResponsesFromIsolate(dynamic message) {
    final (int id, Uint8List response) = message as (int, Uint8List);
    final completer = _activeRequests.remove(id)!;

    if (response is RemoteError) {
      completer.completeError(response);
    } else {
      completer.complete(response);
    }

    if (_closed && _activeRequests.isEmpty) _responses.close();
  }

  static void _handleCommandsToIsolate(ReceivePort receivePort,
      SendPort sendPort,) {
    receivePort.listen((message) {
      if (message == 'shutdown') {
        receivePort.close();
        return;
      }
      final (int id, XFile file, int chunkSize, int chunkIndex) = message as (int, XFile, int, int);
      try {
        List<int> temp = [];
        file.openRead(chunkIndex * chunkSize, (chunkIndex + 1) * chunkSize).listen((e) {
          temp.addAll(e);
        }, onDone: () {
          sendPort.send((id, Uint8List.fromList(temp)));
        }, onError: (e) {
          sendPort.send((id, RemoteError(e.toString(), '')));
        });
      } catch (e) {
        sendPort.send((id, RemoteError(e.toString(), '')));
      }
    });
  }

  static void _startRemoteIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    _handleCommandsToIsolate(receivePort, sendPort);
  }

  void close() {
    if (!_closed) {
      _closed = true;
      _commands.send('shutdown');
      if (_activeRequests.isEmpty) _responses.close();
    }
  }
}