import 'dart:io';

import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/trailer_upload_section_widget/bloc/trailer_upload_section_cubit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:video_player/video_player.dart';

class TrailerUploadSectionWidget extends StatefulWidget {
  final double height;
  final bool readOnly;

  const TrailerUploadSectionWidget(
      {super.key, required this.height, this.readOnly = false});

  @override
  State<TrailerUploadSectionWidget> createState() =>
      _TrailerUploadSectionWidgetState();
}

class _TrailerUploadSectionWidgetState
    extends State<TrailerUploadSectionWidget> {
  VideoPlayerController? _videoPlayerController;

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TrailerUploadSectionCubit, TrailerUploadSectionState>(
      listenWhen: (p, c) {
        return p.networkUrl != c.networkUrl || p.file != c.file;
      },
      listener: (context, state) async {
        if (state.file != null) {
          await _videoPlayerController?.dispose();
          _videoPlayerController =
              VideoPlayerController.file(File(state.file!.path));
          _videoPlayerController?.initialize().then((value) {
            BlocProvider.of<TrailerUploadSectionCubit>(context).videoIsReady();
          });
        } else if (state.networkUrl != null) {
          await _videoPlayerController?.dispose();
          _videoPlayerController =
              VideoPlayerController.networkUrl(Uri.parse(state.networkUrl!));
          _videoPlayerController?.initialize().then((value) {
            BlocProvider.of<TrailerUploadSectionCubit>(context).videoIsReady();
          });
        } else {
          await _videoPlayerController?.dispose();
          _videoPlayerController = null;
        }
      },
      child: BlocConsumer<TrailerUploadSectionCubit, TrailerUploadSectionState>(
        listener: (context, state) {
          if (state.error != null) {
            toastification.showCustom(
                animationDuration: const Duration(milliseconds: 300),
                context: context,
                alignment: Alignment.bottomRight,
                autoCloseDuration: const Duration(seconds: 4),
                direction: TextDirection.rtl,
                builder: (BuildContext context, ToastificationItem holder) {
                  return ErrorSnackBarWidget(
                    item: holder,
                    title: state.error?.title ?? "خطا در بارگذاری پیش نمایش",
                    message: state.error!.message,
                  );
                });
          }
        },
        buildWhen: (p, c) {
          return p.isUploading != c.isUploading ||
              p.isPaused != c.isPaused ||
              p.isUploaded != c.isUploaded ||
              p.file != c.file;
        },
        builder: (context, state) {
          Widget child = selectFile();
          if (state.isUploading == true) {
            child = uploadingFile(state.isPaused ?? false);
          } else if (state.isUploaded == true) {
            child = uploadedFile();
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[AspectRatio(aspectRatio: 5 / 3, child: child)],
            ),
          );
        },
      ),
    );
  }

  Widget selectFile() {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<TrailerUploadSectionCubit>(context).pickFile();
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: DottedBorder(
          dashPattern: const [3, 2],
          radius: const Radius.circular(4),
          color: Theme.of(context).colorScheme.outline,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.cloud_upload_rounded,
                size: widget.height,
              ),
              const SizedBox(height: 8),
              Text(
                "پیش نمایش را بارگذاری کنید",
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget uploadingFile(bool isPaused) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child:
              BlocBuilder<TrailerUploadSectionCubit, TrailerUploadSectionState>(
            buildWhen: (p, c) {
              return p.networkVideoIsReady != c.networkVideoIsReady;
            },
            builder: (context, state) {
              return DecoratedBox(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(4)),
                child: Stack(
                  children: [
                    state.networkVideoIsReady == true
                        ? Positioned.fill(
                            child: VideoPlayer(_videoPlayerController!))
                        : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.video_file_rounded,
                                  size: widget.height,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "در حال بارگذاری",
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                    if (!widget.readOnly) ...[
                      Positioned(
                        top: 8,
                        right: 8,
                        child: PopupMenuButton<String>(
                          onSelected: (String value) {
                            if (value == "0") {
                              if (!isPaused) {
                                BlocProvider.of<TrailerUploadSectionCubit>(
                                        context)
                                    .pauseUpload();
                              } else {
                                BlocProvider.of<TrailerUploadSectionCubit>(
                                        context)
                                    .resumeUpload();
                              }
                            } else {
                              BlocProvider.of<TrailerUploadSectionCubit>(
                                      context)
                                  .cancelUpload();
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              [
                                "0",
                                isPaused ? "سرگیری بارگذاری" : "توقف بارگذاری"
                              ],
                              ["1", "حذف فایل"]
                            ].map((List<String> e) {
                              return PopupMenuItem<String>(
                                value: e[0],
                                child: Text(e[1],
                                    style:
                                        Theme.of(context).textTheme.labelLarge),
                              );
                            }).toList();
                          },
                        ),
                      )
                    ]
                  ],
                ),
              );
            },
          ),
        ),
        BlocBuilder<TrailerUploadSectionCubit, TrailerUploadSectionState>(
          buildWhen: (c, p) {
            return c.progress != p.progress;
          },
          builder: (context, state) {
            return LinearProgressIndicator(
              value: state.progress,
            );
          },
        )
      ],
    );
  }

  Widget uploadedFile() {
    return BlocBuilder<TrailerUploadSectionCubit, TrailerUploadSectionState>(
      buildWhen: (p, c) {
        return p.networkVideoIsReady != c.networkVideoIsReady;
      },
      builder: (context, state) {
        return DecoratedBox(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(4)),
            child: Stack(
              children: [
                state.networkVideoIsReady == true
                    ? Positioned.fill(
                        child: VideoPlayer(_videoPlayerController!))
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.video_file_rounded,
                              size: widget.height,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "پیش نمایش آماده انتشار است.",
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                if (!widget.readOnly) ...[
                  Positioned(
                    top: 8,
                    right: 8,
                    child: PopupMenuButton<String>(
                      onSelected: (String value) {
                        BlocProvider.of<TrailerUploadSectionCubit>(context)
                            .cancelUpload();
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem<String>(
                            value: "1",
                            child: Text("حذف فایل",
                                style: Theme.of(context).textTheme.labelLarge),
                          )
                        ];
                      },
                    ),
                  )
                ]
              ],
            ));
      },
    );
  }
}
