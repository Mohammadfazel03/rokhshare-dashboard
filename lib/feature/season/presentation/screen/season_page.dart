import 'dart:math';
import 'dart:ui';

import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/dio_config.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/date_picker_section_widget/bloc/date_picker_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/poster_section_widget/bloc/poster_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/thumbnail_section_widget/bloc/thumbnail_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/title_section_widget/bloc/title_section_cubit.dart';
import 'package:dashboard/feature/season/data/remote/model/season.dart';
import 'package:dashboard/feature/season/presentation/bloc/season_page_cubit.dart';
import 'package:dashboard/feature/season/presentation/widget/integer_field_widget/bloc/integer_field_cubit.dart';
import 'package:dashboard/feature/season/presentation/widget/season_append_dialog/bloc/season_append_cubit.dart';
import 'package:dashboard/feature/season/presentation/widget/season_append_dialog/season_append_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart' as intl;
import 'package:toastification/toastification.dart';

class SeasonPage extends StatefulWidget {
  final int seriesId;

  const SeasonPage({super.key, required this.seriesId});

  @override
  State<SeasonPage> createState() => _SeasonPageState();
}

class _SeasonPageState extends State<SeasonPage> {
  final PagingController<int, Season?> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((page) async {
      if (page == 0) {
        _pagingController.appendPage([null], 1);
      } else {
        BlocProvider.of<SeasonPageCubit>(context)
            .getData(seriesId: widget.seriesId);
      }
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width - 32;
    if (width > 1024) {
      width -= 332;
    }
    return BlocListener<SeasonPageCubit, SeasonPageState>(
      listener: (context, state) {
        if (state is SeasonPageSuccess) {
          final isLastPage =
              state.data.totalPages == _pagingController.value.nextPageKey;
          if (isLastPage) {
            _pagingController.appendLastPage(state.data.results ?? []);
          } else {
            final nextPageKey = (_pagingController.value.nextPageKey ?? 1) + 1;
            _pagingController.appendPage(state.data.results ?? [], nextPageKey);
          }
        } else if (state is SeasonPageError) {
          if (state.code == 403) {
            getIt.get<LocalStorageService>().logout().then((value) {
              context.go(RoutePath.login.fullPath);
            });
          }
          if (state.code == 1) {
            toastification.showCustom(
                animationDuration: const Duration(milliseconds: 300),
                context: context,
                alignment: Alignment.bottomRight,
                autoCloseDuration: const Duration(seconds: 4),
                direction: TextDirection.rtl,
                builder: (BuildContext context, ToastificationItem holder) {
                  return ErrorSnackBarWidget(
                    item: holder,
                    title: state.title ?? "خطا در دریافت فصل ها",
                    message: state.error,
                  );
                });
          }
          _pagingController.error = state.error;
        } else if (state is SeasonPageRefresh) {
          _pagingController.refresh();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: Text("فیلم و سریال / ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: CustomColor.navRailTextColor
                                          .getColor(context))),
                        ),
                      ),
                      Text("فصل ها / ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: CustomColor.navRailTextColorDisable
                                      .getColor(context))),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: PagedGridView<int, Season?>(
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<Season?>(
                          itemBuilder: (context, item, index) {
                        if (index == 0) {
                          return addWidget();
                        } else {
                          return seasonCard(item!);
                        }
                      }),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: (width / (300 * 3 / 4)).round(),
                        childAspectRatio: 3 / 4,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<SeasonPageCubit, SeasonPageState>(
              buildWhen: (p, c) {
                return (p is SeasonPageLoading && p.code != 1) ||
                    (c is SeasonPageLoading && c.code != 1);
              },
              builder: (context, state) {
                if (state is SeasonPageLoading) {
                  return Positioned.fill(
                    child: Container(
                      color: Colors.transparent,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                        child: SpinKitCubeGrid(
                          color: CustomColor.loginBackgroundColor
                              .getColor(context),
                          size: 50.0,
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            )
          ],
        ),
      ),
      // child: CustomScrollView(
      //   slivers: [
      //
      //     SliverPadding(
      //       padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      //       sliver: SliverToBoxAdapter(
      //         child: Wrap(
      //           spacing: 8,
      //           runSpacing: 4,
      //           alignment: WrapAlignment.start,
      //           runAlignment: WrapAlignment.center,
      //           crossAxisAlignment: WrapCrossAlignment.center,
      //           children: [
      //             MouseRegion(
      //               cursor: SystemMouseCursors.click,
      //               child: GestureDetector(
      //                 onTap: () {
      //                   context.pop();
      //                 },
      //                 child: Text("فیلم و سریال / ",
      //                     style: Theme
      //                         .of(context)
      //                         .textTheme
      //                         .bodyMedium
      //                         ?.copyWith(
      //                         color: CustomColor.navRailTextColor
      //                             .getColor(context))),
      //               ),
      //             ),
      //             Text("فصل ها / ",
      //                 style: Theme
      //                     .of(context)
      //                     .textTheme
      //                     .bodyMedium
      //                     ?.copyWith(
      //                     color: CustomColor.navRailTextColorDisable
      //                         .getColor(context))),
      //           ],
      //         ),
      //       ),
      //     ),
      //     SliverPadding(
      //       padding: const EdgeInsets.all(16),
      //       sliver:
      //     )
      //   ],
      // ),
    );
  }

  Widget addWidget() {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return Dialog(
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                      width: min(MediaQuery.sizeOf(context).width * 0.8, 560),
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                              value: BlocProvider.of<SeasonPageCubit>(context)),
                          BlocProvider(
                              create: (context) =>
                                  SeasonAppendCubit(repository: getIt.get())),
                          BlocProvider(
                              create: (context) => IntegerFieldCubit()),
                          BlocProvider(
                              create: (context) => PosterSectionCubit()),
                          BlocProvider(
                              create: (context) => ThumbnailSectionCubit()),
                          BlocProvider(
                              create: (context) => TitleSectionCubit()),
                          BlocProvider(
                              create: (context) => DatePickerSectionCubit()),
                        ],
                        child: SeasonAppendDialog(
                            seriesId: widget.seriesId,
                            width: min(
                                MediaQuery.sizeOf(context).width * 0.8, 560)),
                      )),
                );
              });
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle_rounded, size: 100),
            const SizedBox(height: 4),
            Text("افزودن فصل جدید",
                style: Theme.of(context).textTheme.labelLarge)
          ],
        ),
      ),
    );
  }

  Widget seasonCard(Season season) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned.fill(
              child: Image.network(
            "$baseUrl${season.poster}",
            fit: BoxFit.fill,
          )),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              top: 0,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: <Color>[
                      Color(0xb31c1b1e),
                      Color(0x66201f22),
                      Color(0x4d232225),
                      Color(0x33272629),
                      Color(0x1a2a292d),
                      Color(0x0d2a2d31),
                      Color(0x05313034),
                      Color(0x002e2d31)
                    ],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        season.name != null
                            ? "فصل ${season.number}: ${season.name}"
                            : "فصل ${season.number}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: const Color(0xffe5e1e6)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "تاریخ انتشار: ${intl.DateFormat.yMMMMd('fa_IR').format(intl.DateFormat('yyyy-MM-ddTHH:mm').parse(season.publicationDate ?? ""))}",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: const Color(0xffe5e1e6)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "تعداد قسمت ها: ${season.episodeNumber}",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: const Color(0xffe5e1e6)),
                      ), // Icons.
                    ],
                  ),
                ),
              )),
          Positioned(
            top: 8,
            right: 8,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                  color: Color(0x4d2e2d31), shape: BoxShape.circle),
              child: PopupMenuButton<String>(
                iconColor: Colors.white,
                onSelected: (String value) {
                  if (value == "0") {
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
                                        value: BlocProvider.of<SeasonPageCubit>(
                                            context)),
                                    BlocProvider(
                                        create: (context) => SeasonAppendCubit(
                                            repository: getIt.get())),
                                    BlocProvider(
                                        create: (context) =>
                                            IntegerFieldCubit()),
                                    BlocProvider(
                                        create: (context) =>
                                            PosterSectionCubit()),
                                    BlocProvider(
                                        create: (context) =>
                                            ThumbnailSectionCubit()),
                                    BlocProvider(
                                        create: (context) =>
                                            TitleSectionCubit()),
                                    BlocProvider(
                                        create: (context) =>
                                            DatePickerSectionCubit()),
                                  ],
                                  child: SeasonAppendDialog(
                                      seriesId: widget.seriesId,
                                      seasonId: season.id,
                                      width: min(
                                          MediaQuery.sizeOf(context).width *
                                              0.8,
                                          560)),
                                )),
                          );
                        });
                  } else {
                    showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                                title: Text(
                                  "حذف فصل",
                                  style: Theme.of(dialogContext)
                                      .textTheme
                                      .headlineSmall,
                                ),
                                content: Text(
                                    "آیا از حذف فصل با شناسه ${season.id} اظمینان دارید؟",
                                    style: Theme.of(dialogContext)
                                        .textTheme
                                        .bodyMedium),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                    },
                                    style: ButtonStyle(
                                      textStyle: WidgetStateProperty.all(
                                          Theme.of(dialogContext)
                                              .textTheme
                                              .labelSmall),
                                      padding: WidgetStateProperty.all(
                                          const EdgeInsets.all(16)),
                                      shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4))),
                                    ),
                                    child: const Text(
                                      "انصراف",
                                    ),
                                  ),
                                  FilledButton(
                                      style: ButtonStyle(
                                          textStyle: WidgetStateProperty.all(
                                              Theme.of(dialogContext)
                                                  .textTheme
                                                  .labelSmall),
                                          padding: WidgetStateProperty.all(
                                              const EdgeInsets.all(16)),
                                          alignment: Alignment.center,
                                          shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4)))),
                                      onPressed: () {
                                        BlocProvider.of<SeasonPageCubit>(
                                                context)
                                            .delete(id: season.id!);
                                        Navigator.of(dialogContext).pop();
                                      },
                                      child: const Text(
                                        "بله",
                                      )),
                                ]));
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    ["0", "ویرایش"],
                    ["1", "حذف"]
                  ].map((List<String> e) {
                    return PopupMenuItem<String>(
                        value: e[0],
                        child: Text(e[1],
                            style: Theme.of(context).textTheme.labelSmall));
                  }).toList();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
