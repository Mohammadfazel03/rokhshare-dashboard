import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/trailer_upload_section_widget/bloc/trailer_upload_section_cubit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

class TrailerUploadSectionWidget extends StatelessWidget {
  final double height;

  const TrailerUploadSectionWidget({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrailerUploadSectionCubit, TrailerUploadSectionState>(
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
        Widget child = selectFile(context);
        if (state.isUploading == true) {
          child = uploadingFile(state.isPaused ?? false);
        } else if (state.isUploaded == true) {
          child = uploadedFile(state.thumbnailDataUrl);
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[AspectRatio(aspectRatio: 5 / 3, child: child)],
          ),
        );
      },
    );
  }

  Widget selectFile(context) {
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
                size: height,
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
              return p.thumbnailDataUrl != c.thumbnailDataUrl;
            },
            builder: (context, state) {
              return DecoratedBox(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(4)
                ),
                child: Stack(
                  children: [
                    state.thumbnailDataUrl != null
                        ? Positioned.fill(
                            child: Image.network(
                            state.thumbnailDataUrl!,
                            fit: BoxFit.fitHeight,
                          ))
                        : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.video_file_rounded,
                                  size: height,
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
                            BlocProvider.of<TrailerUploadSectionCubit>(context)
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

  Widget uploadedFile(String? thumbnailDataUrl) {
    return BlocBuilder<TrailerUploadSectionCubit, TrailerUploadSectionState>(
      buildWhen: (p, c) {
        return p.thumbnailDataUrl != c.thumbnailDataUrl;
      },
      builder: (context, state) {
        return DecoratedBox(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(4)
            ),
            child: Stack(
              children: [
                state.thumbnailDataUrl != null
                    ? Positioned.fill(
                        child: Image.network(
                        state.thumbnailDataUrl!,
                        fit: BoxFit.fitHeight,
                      ))
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.video_file_rounded,
                              size: height,
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
              ],
            ));
      },
    );
  }
}


