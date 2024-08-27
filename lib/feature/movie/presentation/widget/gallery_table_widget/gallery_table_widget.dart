import 'dart:math';

import 'package:dashboard/common/paginator_widget/pagination_widget.dart';
import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/movie/data/remote/model/gallery.dart';
import 'package:dashboard/feature/movie/presentation/widget/gallery_table_widget/bloc/gallery_append_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/gallery_table_widget/bloc/gallery_table_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/gallery_table_widget/gallery_append_dialog_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/media_selector_widget/bloc/media_selector_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/synopsis_section_widget/bloc/synopsis_section_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toastification/toastification.dart';

class GalleryTableWidget extends StatefulWidget {
  final int? mediaId;
  final int? episodeId;

  const GalleryTableWidget(
      {super.key, required this.mediaId, required this.episodeId});

  @override
  State<GalleryTableWidget> createState() => _GalleryTableWidgetState();
}

class _GalleryTableWidgetState extends State<GalleryTableWidget> {
  @override
  void initState() {
    if (widget.mediaId != null || widget.episodeId != null) {
      BlocProvider.of<GalleryTableCubit>(context)
          .getData(mediaId: widget.mediaId, episodeId: widget.episodeId);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width - 32;
    if (width > 1024) {
      width -= 332;
    }
    return BlocListener<GalleryTableCubit, GalleryTableState>(
      listener: (context, state) {
        if (state is GalleryTableError) {
          if (state.data?.results?.isNotEmpty ?? false) {
            toastification.showCustom(
                animationDuration: const Duration(milliseconds: 300),
                context: context,
                alignment: Alignment.bottomRight,
                autoCloseDuration: const Duration(seconds: 4),
                direction: TextDirection.rtl,
                builder: (BuildContext context, ToastificationItem holder) {
                  return ErrorSnackBarWidget(
                    item: holder,
                    title: state.title ?? "خطا در دریافت گالری",
                    message: state.error,
                  );
                });
          }
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "گالری",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (widget.mediaId != null || widget.episodeId != null) ...[
                  FilledButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return Dialog(
                              clipBehavior: Clip.hardEdge,
                              child: SizedBox(
                                  width: min(
                                      MediaQuery.sizeOf(context).width * 0.8,
                                      560),
                                  child: MultiBlocProvider(
                                    providers: [
                                      BlocProvider.value(
                                          value: BlocProvider.of<
                                              GalleryTableCubit>(context)),
                                      BlocProvider<GalleryAppendCubit>(
                                          create: (context) =>
                                              GalleryAppendCubit(
                                                  repository: getIt.get())),
                                      BlocProvider<MediaSelectorCubit>(
                                          create: (context) =>
                                              MediaSelectorCubit(
                                                  repository: getIt.get())),
                                      BlocProvider<SynopsisSectionCubit>(
                                          create: (context) =>
                                              SynopsisSectionCubit()),
                                    ],
                                    child: GalleryAppendDialogWidget(
                                        episodeId: widget.episodeId,
                                        width: min(
                                            MediaQuery.sizeOf(context).width *
                                                0.8,
                                            560),
                                        mediaId: widget.mediaId),
                                  )),
                            );
                          });
                    },
                    label: const Text(
                      "افزودن",
                    ),
                    icon: const Icon(Icons.add),
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 16)),
                      textStyle: WidgetStateProperty.all(
                          Theme.of(context).textTheme.labelMedium),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                    ),
                  )
                ]
              ],
            ),
          ),
          Expanded(
              child: Stack(
            children: [
              BlocBuilder<GalleryTableCubit, GalleryTableState>(
                buildWhen: (p, c) {
                  return listEquals(
                      p.data?.results ?? [], p.data?.results ?? []);
                },
                builder: (context, state) {
                  if (state is GalleryTableSuccess) {
                    if (state.data?.results?.isEmpty ?? true) {
                      return Center(
                        child: Text(
                          "تصویری وجود ندارد",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      );
                    }
                  }
                  if (state.data?.results?.isNotEmpty ?? false) {
                    return Positioned.fill(
                        child: table(state.data?.results ?? [], width));
                  }
                  return Positioned.fill(child: _error(null));
                },
              ),
              BlocBuilder<GalleryTableCubit, GalleryTableState>(
                buildWhen: (p, c) {
                  return p is GalleryTableLoading || c is GalleryTableLoading;
                },
                builder: (context, state) {
                  if (state is GalleryTableLoading) {
                    return Positioned.fill(
                        child: Container(
                      color: Colors.black12,
                      child: Center(
                          child: RepaintBoundary(
                              child: SpinKitThreeBounce(
                        color:
                            CustomColor.loginBackgroundColor.getColor(context),
                      ))),
                    ));
                  }
                  return const SizedBox.shrink();
                },
              ),
              BlocBuilder<GalleryTableCubit, GalleryTableState>(
                buildWhen: (p, c) {
                  return p is GalleryTableError || c is GalleryTableError;
                },
                builder: (context, state) {
                  if (state is GalleryTableError) {
                    if (state.data?.results?.isEmpty ?? true) {
                      return Positioned.fill(child: _error(state.error));
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          )),
          BlocBuilder<GalleryTableCubit, GalleryTableState>(
            buildWhen: (current, previous) {
              return current.numberPages != previous.numberPages ||
                  current.pageIndex != previous.pageIndex;
            },
            builder: (context, state) {
              if (state.numberPages != 0) {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PaginationWidget(
                            totalPages: state.numberPages,
                            currentPage: state.pageIndex,
                            onChangePage: (page) {
                              if (BlocProvider.of<GalleryTableCubit>(context)
                                  .state is! GalleryTableLoading) {
                                BlocProvider.of<GalleryTableCubit>(context)
                                    .getData(
                                        page: page,
                                        mediaId: widget.mediaId,
                                        episodeId: widget.episodeId);
                              }
                            }),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          )
        ],
      ),
    );
  }

  Widget table(final List<Gallery> galleries, double width) {
    return GridView.builder(
        itemCount: galleries.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: max((width / 300).round(), 1),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          var item = galleries[index];
          if (item.file?.mimetype?.contains('video') ?? false) {
            return _GalleryItem(
                episodeId: widget.episodeId,
                mediaId: widget.mediaId,
                isVideo: true,
                image: "${item.file?.thumbnail}",
                item: item,
                index: index);
          } else if (item.file?.mimetype?.contains('image') ?? false) {
            return _GalleryItem(
                episodeId: widget.episodeId,
                mediaId: widget.mediaId,
                isVideo: false,
                image: "${item.file?.file}",
                item: item,
                index: index);
          }
          return _GalleryItem(
              episodeId: widget.episodeId,
              mediaId: widget.mediaId,
              isVideo: false,
              image: null,
              item: item,
              index: index);
        });
  }

  Widget _error(String? error) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              error ?? "خطا در دریافت اطلاعات!",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 8),
            OutlinedButton(
                onPressed: () {
                  BlocProvider.of<GalleryTableCubit>(context).getData(
                      mediaId: widget.mediaId, episodeId: widget.episodeId);
                },
                child: Text(
                  "تلاش مجدد",
                  style: Theme.of(context).textTheme.labelSmall,
                ))
          ],
        ),
      ],
    );
  }
}

class _GalleryItem extends StatefulWidget {
  final String? image;
  final Gallery item;
  final int index;
  final int? mediaId;
  final int? episodeId;
  final bool isVideo;

  const _GalleryItem(
      {required this.image,
      required this.item,
      required this.index,
      required this.isVideo,
      required this.mediaId,
      required this.episodeId});

  @override
  State<_GalleryItem> createState() => _GalleryItemState();
}

class _GalleryItemState extends State<_GalleryItem>
    with TickerProviderStateMixin {
  late final AnimationController containerAnimationController;
  late final AnimationController contentAnimationController;

  @override
  void initState() {
    containerAnimationController = AnimationController(vsync: this);
    contentAnimationController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    contentAnimationController.dispose();
    containerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (_) {
          containerAnimationController.forward().then((_) {
            contentAnimationController.forward();
          });
        },
        onExit: (_) {
          contentAnimationController.reverse().then((_) {
            containerAnimationController.reverse();
          });
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Theme.of(context).colorScheme.surfaceContainerHighest),
          child: Stack(
            children: [
              if (widget.image != null) ...[
                Positioned.fill(
                    child: Image.network(
                  widget.image!,
                  fit: BoxFit.fill,
                ))
              ] else ...[
                Positioned.fill(
                    child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.image_not_supported_outlined, size: 64),
                    const SizedBox(height: 8),
                    Text(
                      "فایل انتخابی پشتیبانی نمیشود.",
                      style: Theme.of(context).textTheme.labelLarge,
                    )
                  ],
                ))
              ],
              Positioned.fill(
                child: Animate(
                  autoPlay: false,
                  controller: containerAnimationController,
                ).custom(
                    duration: 200.milliseconds,
                    builder: (context, value, child) {
                      return Transform.scale(
                          scale: value,
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(
                                      (1 - value) * 300))));
                    }),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Animate(
                  effects: const [FadeEffect()],
                  autoPlay: false,
                  controller: contentAnimationController,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.isVideo) ...[
                        const Icon(Icons.play_circle_outline_rounded, size: 64),
                        const SizedBox(height: 8)
                      ],
                      Text(
                        widget.item.description ?? "",
                        style: Theme.of(context).textTheme.labelMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            tooltip: "ویرایش",
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return Dialog(
                                      clipBehavior: Clip.hardEdge,
                                      child: SizedBox(
                                          width: min(
                                              MediaQuery.sizeOf(context).width *
                                                  0.8,
                                              560),
                                          child: MultiBlocProvider(
                                            providers: [
                                              BlocProvider.value(
                                                  value: BlocProvider.of<
                                                          GalleryTableCubit>(
                                                      context)),
                                              BlocProvider<GalleryAppendCubit>(
                                                  create: (context) =>
                                                      GalleryAppendCubit(
                                                          repository:
                                                              getIt.get())),
                                              BlocProvider<MediaSelectorCubit>(
                                                  create: (context) =>
                                                      MediaSelectorCubit(
                                                          repository:
                                                              getIt.get())),
                                              BlocProvider<
                                                      SynopsisSectionCubit>(
                                                  create: (context) =>
                                                      SynopsisSectionCubit()),
                                            ],
                                            child: GalleryAppendDialogWidget(
                                                episodeId: widget.episodeId,
                                                width: min(
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.8,
                                                    560),
                                                mediaId: widget.mediaId,
                                                id: widget.item.id),
                                          )),
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.edit,
                            ),
                            style: ButtonStyle(
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8)))),
                          ),
                          IconButton(
                            tooltip: "حذف",
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                          title: Text(
                                            "حذف تصویر",
                                            style: Theme.of(dialogContext)
                                                .textTheme
                                                .headlineSmall,
                                          ),
                                          content: Text(
                                              "آیا از حذف تصویر با شناسه ${widget.item.id} اظمینان دارید؟",
                                              style: Theme.of(dialogContext)
                                                  .textTheme
                                                  .bodyMedium),
                                          actions: [
                                            OutlinedButton(
                                              onPressed: () {
                                                Navigator.of(dialogContext)
                                                    .pop();
                                              },
                                              style: ButtonStyle(
                                                textStyle:
                                                    WidgetStateProperty.all(
                                                        Theme.of(dialogContext)
                                                            .textTheme
                                                            .labelSmall),
                                                padding:
                                                    WidgetStateProperty.all(
                                                        const EdgeInsets.all(
                                                            16)),
                                                shape: WidgetStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4))),
                                              ),
                                              child: const Text(
                                                "انصراف",
                                              ),
                                            ),
                                            FilledButton(
                                                style: ButtonStyle(
                                                    textStyle:
                                                        WidgetStateProperty.all(
                                                            Theme.of(dialogContext)
                                                                .textTheme
                                                                .labelSmall),
                                                    padding:
                                                        WidgetStateProperty.all(
                                                            const EdgeInsets.all(
                                                                16)),
                                                    alignment: Alignment.center,
                                                    shape: WidgetStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(4)))),
                                                onPressed: () {
                                                  BlocProvider.of<
                                                              GalleryTableCubit>(
                                                          context)
                                                      .delete(
                                                          episodeId:
                                                              widget.episodeId,
                                                          id: widget.item.id!,
                                                          mediaId:
                                                              widget.mediaId);
                                                  Navigator.of(dialogContext)
                                                      .pop();
                                                },
                                                child: const Text(
                                                  "بله",
                                                )),
                                          ]));
                            },
                            icon: const Icon(
                              Icons.delete,
                            ),
                            style: ButtonStyle(
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8)))),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ))
            ],
          ),
        ));
  }
}
