import 'dart:math';

import 'package:dashboard/feature/media_collection/presentation/widget/media_autocomplete_field/bloc/media_autocomplete_field_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../movie/data/remote/model/movie.dart';

class MediaAutocompleteController extends ChangeNotifier {
  Media? media;
  String? error;

  void setMedia(Media? media) {
    this.media = media;
    notifyListeners();
  }

  void setError(String error) {
    this.error = error;
    notifyListeners();
  }

  void clearError() {
    error = null;
    notifyListeners();
  }
}

class MediaAutocompleteField extends StatefulWidget {
  final void Function(Media media) selectMedia;
  final MediaAutocompleteController? controller;

  const MediaAutocompleteField(
      {super.key, required this.selectMedia, this.controller});

  @override
  State<MediaAutocompleteField> createState() => _MediaAutocompleteFieldState();
}

class _MediaAutocompleteFieldState extends State<MediaAutocompleteField> {
  final TextEditingController _textEditController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final ScrollController _scrollController = ScrollController();

  MediaAutocompleteController? get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _focusNode.addListener(_focusListener);
  }

  @override
  void dispose() {
    _textEditController.dispose();
    _focusNode.removeListener(_focusListener);
    _focusNode.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _overlayEntry?.dispose();
    super.dispose();
  }

  Future<void> _onScroll() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      BlocProvider.of<MediaAutocompleteFieldCubit>(context)
          .fetchMoreSuggestions();
    }
  }

  void _focusListener() {
    if (_focusNode.hasFocus && _overlayEntry == null) {
      if (BlocProvider.of<MediaAutocompleteFieldCubit>(context).state.status ==
          PostStatus.initial) {
        BlocProvider.of<MediaAutocompleteFieldCubit>(context)
            .fetchMoreSuggestions();
      }
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final upward = (position.dy + renderBox.size.height + 400 > screenHeight);
    return OverlayEntry(
      builder: (innerContext) => Positioned(
        width: renderBox.size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          followerAnchor: upward ? Alignment.bottomLeft : Alignment.topLeft,
          targetAnchor: upward ? Alignment.topLeft : Alignment.bottomLeft,
          offset: const Offset(0, 0),
          child: Material(
              elevation: 4.0,
              child: BlocBuilder<MediaAutocompleteFieldCubit,
                  MediaAutocompleteFieldState>(
                bloc: BlocProvider.of<MediaAutocompleteFieldCubit>(context),
                builder: (blocContext, state) {
                  var posterWidth = min(renderBox.size.width / 3, 100);
                  var posterHeight = posterWidth * 4 / 3;
                  return TapRegion(
                    onTapOutside: (e) {
                      setState(() {});
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        if (!_focusNode.hasFocus) {
                          _overlayEntry?.remove();
                          _overlayEntry = null;
                        }
                      });
                    },
                    child: SizedBox(
                      height: min(
                          ((posterHeight + 8) * state.media.length +
                                  (state.media.isEmpty ? 0 : 16)) +
                              (state.status == PostStatus.loading ? 72 : 0) +
                              (state.status == PostStatus.failure ? 150 : 0) +
                              (state.status == PostStatus.success &&
                                      state.media.isEmpty
                                  ? 72
                                  : 0),
                          400),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          reverse: upward,
                          controller: _scrollController,
                          itemCount: state.media.length +
                              (state.status == PostStatus.loading ||
                                      state.status == PostStatus.failure ||
                                      (state.status == PostStatus.success &&
                                          state.media.isEmpty)
                                  ? 1
                                  : 0),
                          itemBuilder: (listContext, index) {
                            if (index == state.media.length) {
                              if ((state.status == PostStatus.success &&
                                  state.media.isEmpty)) {
                                return const SizedBox(
                                    height: 72,
                                    child:
                                        Center(child: Text("موردی یافت نشد.")));
                              }
                              if (state.status == PostStatus.failure) {
                                return SizedBox(
                                  height: 150,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(state.error?.error ?? ""),
                                        const SizedBox(height: 4),
                                        TextButton.icon(
                                            onPressed: () {
                                              BlocProvider.of<
                                                          MediaAutocompleteFieldCubit>(
                                                      context)
                                                  .fetchMoreSuggestions(
                                                      retry: true);
                                            },
                                            label: const Text("تلاش دوباره"),
                                            icon: const Icon(Icons.refresh))
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox(
                                  height: 72,
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            }
                            final media = state.media.elementAt(index);
                            var genres = media.genres?.join(" | ");
                            var countries = media.countries?.join(" | ");
                            return InkWell(
                              onTap: () {
                                widget.selectMedia(media);
                                controller?.setMedia(media);
                                controller?.clearError();
                                _textEditController.clear();
                                _focusNode.unfocus();
                                _overlayEntry?.remove();
                                _overlayEntry = null;
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: posterWidth.toDouble(),
                                        height: posterHeight.toDouble(),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                                "${media.poster}",
                                                fit: BoxFit.fill))),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            media.name ?? "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            genres ?? "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "محصول کشور: $countries",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                          ),
                                          if (posterHeight > 100) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              media.synopsis ?? "",
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall,
                                            ),
                                          ]
                                        ],
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
        link: _layerLink,
        child: controller != null
            ? ListenableBuilder(
                listenable: controller!,
                builder: (BuildContext context, widget) {
                  return TextField(
                    controller: _textEditController,
                    focusNode: _focusNode,
                    onChanged: (text) {
                      BlocProvider.of<MediaAutocompleteFieldCubit>(context)
                          .fetchMoreSuggestions(
                              page: 1, query: text, retry: true);
                    },
                    decoration: InputDecoration(
                        labelText: 'انتخاب فیلم و سریال',
                        floatingLabelBehavior: controller?.media != null
                            ? FloatingLabelBehavior.always
                            : FloatingLabelBehavior.auto,
                        errorText: controller?.error,
                        prefixIcon: controller?.media != null
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 15),
                                  Text(
                                    controller?.media?.name ?? "",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                  ),
                                ],
                              )
                            : null,
                        suffixIcon: controller?.media != null ||
                                _textEditController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _textEditController.clear();
                                  controller!.setMedia(null);
                                },
                                icon:
                                    const Icon(Icons.clear, color: Colors.red),
                                padding: const EdgeInsets.all(4),
                              )
                            : null),
                  );
                },
              )
            : TextField(
                controller: _textEditController,
                focusNode: _focusNode,
                onChanged: (text) {
                  BlocProvider.of<MediaAutocompleteFieldCubit>(context)
                      .fetchMoreSuggestions(page: 1, query: text, retry: true);
                },
                decoration: const InputDecoration(
                  labelText: 'افزودن فیلم و سریال',
                ),
              ));
  }
}
