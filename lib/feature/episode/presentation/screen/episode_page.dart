import 'dart:ui';

import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/episode/presentation/bloc/episode_page_cubit.dart';
import 'package:dashboard/feature/episode/presentation/widget/comment_table_widget/comment_table_widget.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/artists_autocomplete_widget/artists_autocomplete_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/artists_section_widget/artist_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/artists_section_widget/bloc/artist_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/date_picker_section_widget/bloc/date_picker_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/date_picker_section_widget/date_picker_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/movie_upload_section_widget/bloc/movie_upload_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/movie_upload_section_widget/movie_upload_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/poster_section_widget/bloc/poster_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/poster_section_widget/poster_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/synopsis_section_widget/synopsis_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/thumbnail_section_widget/bloc/thumbnail_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/thumbnail_section_widget/thumbnail_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/title_section_widget/title_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/trailer_upload_section_widget/bloc/trailer_upload_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/trailer_upload_section_widget/trailer_upload_section_widget.dart';
import 'package:dashboard/feature/season/presentation/widget/integer_field_widget/bloc/integer_field_cubit.dart';
import 'package:dashboard/feature/season/presentation/widget/integer_field_widget/integer_field_widget.dart';
import 'package:dashboard/feature/season_episode/data/remote/model/episode.dart';
import 'package:dashboard/feature/season_episode/presentation/bloc/season_episode_page_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:toastification/toastification.dart';

class EpisodePage extends StatefulWidget {
  final int? episodeId;
  final int seasonId;
  final bool isDetail;

  const EpisodePage(
      {super.key,
      this.episodeId,
      this.isDetail = false,
      required this.seasonId});

  @override
  State<EpisodePage> createState() => _EpisodePageState();
}

class _EpisodePageState extends State<EpisodePage> {
  late final TextEditingController titleController;
  late final TextEditingController synopsisController;
  late final TextEditingController numberController;
  late final DateRangePickerController datePickerController;
  late final ArtistsAutocompleteController artistsAutocompleteController;
  final GlobalKey _trailerWidgetKey = GlobalKey();
  final GlobalKey _movieWidgetKey = GlobalKey();
  Episode? _episode;

  get episodeId => widget.episodeId;

  get isDetail => widget.isDetail;

  @override
  void initState() {
    if (episodeId != null) {
      BlocProvider.of<EpisodePageCubit>(context).getEpisode(id: episodeId);
    }
    synopsisController = TextEditingController();
    numberController = TextEditingController();
    titleController = TextEditingController();
    datePickerController = DateRangePickerController();
    artistsAutocompleteController = ArtistsAutocompleteController();
    super.initState();
  }

  @override
  void dispose() {
    synopsisController.dispose();
    numberController.dispose();
    titleController.dispose();
    datePickerController.dispose();
    artistsAutocompleteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.constrainWidth();
      double height = constraints.constrainHeight();
      return BlocConsumer<EpisodePageCubit, EpisodePageState>(
          buildWhen: (p, c) {
        return p is EpisodePageLoading || c is EpisodePageLoading;
      }, listener: (context, state) {
        if (state is EpisodePageSuccessAppend) {
          BlocProvider.of<SeasonEpisodePageCubit>(context)
              .getData(seasonId: widget.seasonId);
          context.pop();
        } else if (state is EpisodePageFailAppend) {
          toastification.showCustom(
              animationDuration: const Duration(milliseconds: 300),
              context: context,
              alignment: Alignment.bottomRight,
              autoCloseDuration: const Duration(seconds: 4),
              direction: TextDirection.rtl,
              builder: (BuildContext context, ToastificationItem holder) {
                return ErrorSnackBarWidget(
                  item: holder,
                  title: "خطا در ثبت اظلاعات",
                  message: state.message,
                );
              });
        } else if (state is EpisodePageFail) {
          toastification.showCustom(
              animationDuration: const Duration(milliseconds: 300),
              context: context,
              alignment: Alignment.bottomRight,
              autoCloseDuration: const Duration(seconds: 4),
              direction: TextDirection.rtl,
              builder: (BuildContext context, ToastificationItem holder) {
                return ErrorSnackBarWidget(
                  item: holder,
                  title: "خطا در دریافت اظلاعات",
                  message: state.message,
                );
              });
        } else if (state is EpisodePageSuccess) {
          _episode = state.data;

          titleController.text = state.data.name ?? "";
          numberController.text = state.data.number?.toString() ?? "";
          synopsisController.text = state.data.synopsis ?? "";
          BlocProvider.of<ArtistSectionCubit>(context)
              .initialSelectedItem(state.data.casts ?? []);

          BlocProvider.of<DatePickerSectionCubit>(context).setDate(
              intl.DateFormat('yyyy-MM-ddTHH:mm')
                  .tryParse(state.data.publicationDate ?? ""));
          BlocProvider.of<ThumbnailSectionCubit>(context)
              .initialFile(state.data.thumbnail);
          BlocProvider.of<PosterSectionCubit>(context)
              .initialFile(state.data.poster);
          BlocProvider.of<MovieUploadSectionCubit>(context)
              .initialMovie(state.data.video, state.data.time);
          BlocProvider.of<TrailerUploadSectionCubit>(context)
              .initialTrailer(state.data.trailer);
        } else if (state is EpisodePageSuccessUpdate) {
          BlocProvider.of<SeasonEpisodePageCubit>(context)
              .refreshPage(seasonId: widget.seasonId);
          context.pop();
        }
      }, builder: (context, state) {
        return Stack(children: [
          if (state is! EpisodePageFail) ...[
            AbsorbPointer(
              absorbing: state is EpisodePageLoading,
              child: CustomScrollView(slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  sliver: SliverToBoxAdapter(
                      child: Wrap(
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
                            int count = 0;
                            Navigator.of(context).popUntil((_) => count++ >= 3);
                          },
                          child: Text("فیلم و سریال /",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: CustomColor.navRailTextColor
                                          .getColor(context))),
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            int count = 0;
                            Navigator.of(context).popUntil((_) => count++ >= 2);
                          },
                          child: Text("فصل ها /",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: CustomColor.navRailTextColor
                                          .getColor(context))),
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: Text("قسمت ها /",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: CustomColor.navRailTextColor
                                          .getColor(context))),
                        ),
                      ),
                      if (episodeId != null) ...[
                        Text(isDetail ? "قسمت /" : "ویرایش قسمت /",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: CustomColor.navRailTextColorDisable
                                        .getColor(context)))
                      ] else ...[
                        Text("افزودن قسمت / ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: CustomColor.navRailTextColorDisable
                                        .getColor(context)))
                      ],
                    ],
                  )),
                ),
                SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                        child: Card(
                            child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: body(width, state))))),
                if (isDetail &&
                    state is EpisodePageSuccess &&
                    state.data.id != null) ...[
                  SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      sliver: SliverToBoxAdapter(
                          child: SizedBox(
                        height: 410,
                        child: Card(
                            child:
                                CommentTableWidget(episodeId: state.data.id!)),
                      )))
                ]
              ]),
            )
          ],
          if (state is EpisodePageLoading) ...[
            Center(
                child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
              child: SpinKitCubeGrid(
                color: CustomColor.loginBackgroundColor.getColor(context),
                size: 50.0,
              ),
            ))
          ],
          if (state is EpisodePageFail) ...[
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "خطا در دریافت اطلاعات",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text(
                        "بازگشت",
                        style: Theme.of(context).textTheme.labelMedium,
                      ))
                ],
              ),
            )
          ]
        ]);
      });
    });
  }

  Widget body(double width, state) {
    if (width > 750) {
      return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MovieUploadSectionWidget(
                        key: _movieWidgetKey,
                        readOnly: isDetail,
                        height: width / 3 > 250 ? width / 9 : width / 3),
                    const SizedBox(height: 8),
                    TrailerUploadSectionWidget(
                        key: _trailerWidgetKey,
                        readOnly: isDetail,
                        height: width / 3 > 250 ? width / 9 : width / 3),
                    const SizedBox(height: 8),
                    PosterSectionWidget(
                        readOnly: isDetail,
                        textBackgroundColor:
                            Theme.of(context).colorScheme.surfaceContainerLow),
                    const SizedBox(height: 8),
                    ThumbnailSectionWidget(
                        readOnly: isDetail,
                        textBackgroundColor:
                            Theme.of(context).colorScheme.surfaceContainerLow),
                    const SizedBox(height: 8),
                    if (!isDetail) ...[
                      OutlinedButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text(
                          "انصراف",
                        ),
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                          onPressed: () {
                            if (episodeId != null) {
                              edit();
                            } else {
                              save();
                            }
                          },
                          child: const Text(
                            "ثبت",
                          ))
                    ]
                  ],
                )),
            const SizedBox(width: 16),
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IntegerFieldWidget(
                        controller: numberController,
                        label: "شماره قسمت",
                        hint: "مثلاً 1"),
                    const SizedBox(height: 16),
                    TitleSectionWidget(
                        label: "عنوان قسمت",
                        hintText: null,
                        controller: titleController,
                        readOnly: isDetail),
                    const SizedBox(height: 16),
                    SynopsisSectionWidget(
                        controller: synopsisController, readOnly: isDetail),
                    const SizedBox(height: 16),
                    ArtistSectionWidget(
                        width: width * 2 / 3,
                        controller: artistsAutocompleteController,
                        readOnly: isDetail),
                    const SizedBox(height: 16),
                    if (width / 3 > 200) ...[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: DatePickerSectionWidget(
                                  datePickerController: datePickerController,
                                  readOnly: isDetail)),
                        ],
                      )
                    ] else ...[
                      Expanded(
                          child: DatePickerSectionWidget(
                              datePickerController: datePickerController,
                              readOnly: isDetail)),
                    ],
                  ],
                ))
          ]);
    }

    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MovieUploadSectionWidget(
              key: _movieWidgetKey,
              readOnly: isDetail,
              height: width / 3 > 250 ? width / 9 : width / 3),
          const SizedBox(height: 16),
          TrailerUploadSectionWidget(
              key: _trailerWidgetKey,
              readOnly: isDetail,
              height: width / 3 > 250 ? width / 9 : width / 3),
          const SizedBox(height: 16),
          PosterSectionWidget(
              readOnly: isDetail,
              textBackgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerLow),
          const SizedBox(height: 16),
          ThumbnailSectionWidget(
              readOnly: isDetail,
              textBackgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerLow),
          const SizedBox(height: 16),
          IntegerFieldWidget(
            controller: numberController,
            label: "شماره قسمت",
            hint: "مثلاً 1",
          ),
          const SizedBox(height: 16),
          TitleSectionWidget(
              label: "عنوان قسمت",
              hintText: null,
              controller: titleController,
              readOnly: isDetail),
          const SizedBox(height: 16),
          SynopsisSectionWidget(
              controller: synopsisController, readOnly: isDetail),
          const SizedBox(height: 16),
          ArtistSectionWidget(
              width: width,
              controller: artistsAutocompleteController,
              readOnly: isDetail),
          const SizedBox(height: 16),
          if (width / 3 > 200) ...[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: DatePickerSectionWidget(
                        datePickerController: datePickerController,
                        readOnly: isDetail)),
              ],
            )
          ] else ...[
            Expanded(
                child: DatePickerSectionWidget(
                    readOnly: isDetail,
                    datePickerController: datePickerController)),
          ],
          if (!isDetail) ...[
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text(
                "انصراف",
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
                onPressed: () {
                  if (episodeId != null) {
                    edit();
                  } else {
                    save();
                  }
                },
                child: const Text(
                  "ثبت",
                ))
          ]
        ]);
  }

  void save() {
    var isValid = true;

    var movieBloc = BlocProvider.of<MovieUploadSectionCubit>(context);
    var trailerBloc = BlocProvider.of<TrailerUploadSectionCubit>(context);
    var posterBloc = BlocProvider.of<PosterSectionCubit>(context);
    var thumbnailBloc = BlocProvider.of<ThumbnailSectionCubit>(context);
    var castBloc = BlocProvider.of<ArtistSectionCubit>(context);
    var dateBloc = BlocProvider.of<DatePickerSectionCubit>(context);

    if (movieBloc.state.isUploaded != true || movieBloc.state.fileId == null) {
      isValid = false;
      toastification.showCustom(
          animationDuration: const Duration(milliseconds: 300),
          context: context,
          alignment: Alignment.bottomRight,
          autoCloseDuration: const Duration(seconds: 4),
          direction: TextDirection.rtl,
          builder: (BuildContext context, ToastificationItem holder) {
            return ErrorSnackBarWidget(
              item: holder,
              title: "خطا",
              message: "لطفا ابتدا فیلم را به صورت کامل بارگذاری کنید.",
            );
          });
    }

    if (trailerBloc.state.isUploaded != true ||
        trailerBloc.state.fileId == null) {
      isValid = false;
      toastification.showCustom(
          animationDuration: const Duration(milliseconds: 300),
          context: context,
          alignment: Alignment.bottomRight,
          autoCloseDuration: const Duration(seconds: 4),
          direction: TextDirection.rtl,
          builder: (BuildContext context, ToastificationItem holder) {
            return ErrorSnackBarWidget(
              item: holder,
              title: "خطا",
              message: "لطفا ابتدا پیش نمایش را به صورت کامل بارگذاری کنید.",
            );
          });
    }

    if (posterBloc.state.file == null || posterBloc.state.filename == null) {
      isValid = false;
      posterBloc.setError("ریز عکس اجباری است.");
    } else {
      posterBloc.clearError();
    }

    if (thumbnailBloc.state.file == null ||
        thumbnailBloc.state.filename == null) {
      isValid = false;
      thumbnailBloc.setError("تصویر شاخص اجباری است.");
    } else {
      thumbnailBloc.clearError();
    }

    if (castBloc.state.casts.isEmpty) {
      isValid = false;
      castBloc.setError("هنرمندان کار را مشحص کنید.");
    } else {
      castBloc.clearError();
    }

    if (numberController.text.isEmpty) {
      isValid = false;
      BlocProvider.of<IntegerFieldCubit>(context)
          .setError("شماره قسمت اجباری است.");
    } else {
      BlocProvider.of<IntegerFieldCubit>(context).clearError();
    }

    if (isValid == true) {
      BlocProvider.of<EpisodePageCubit>(context).saveEpisode(
          synopsis:
              synopsisController.text.isEmpty ? null : synopsisController.text,
          name: titleController.text.isEmpty ? null : titleController.text,
          time: movieBloc.state.duration ?? 1,
          video: movieBloc.state.fileId ?? 0,
          releaseDate: intl.DateFormat("yyyy-MM-ddTHH:mm")
              .format(dateBloc.state.selectedDate),
          trailer: trailerBloc.state.fileId ?? 0,
          thumbnail: thumbnailBloc.state.file!,
          poster: posterBloc.state.file!,
          thumbnailName: thumbnailBloc.state.filename!,
          posterName: posterBloc.state.filename!,
          number: int.parse(numberController.text),
          casts: castBloc.state.casts.map((e) => e.toJson()).toList(),
          seasonId: widget.seasonId);
    }
  }

  void edit() {
    var isValid = true;

    var movieBloc = BlocProvider.of<MovieUploadSectionCubit>(context);
    var trailerBloc = BlocProvider.of<TrailerUploadSectionCubit>(context);
    var posterBloc = BlocProvider.of<PosterSectionCubit>(context);
    var thumbnailBloc = BlocProvider.of<ThumbnailSectionCubit>(context);
    var castBloc = BlocProvider.of<ArtistSectionCubit>(context);
    var dateBloc = BlocProvider.of<DatePickerSectionCubit>(context);

    String? releaseDate, thumbnailName, posterName;
    int? time, video, trailer, number;
    Uint8List? thumbnail, poster;
    List<Map<String, String?>>? casts;

    if (movieBloc.state.isUploaded != true || movieBloc.state.fileId == null) {
      isValid = false;
      toastification.showCustom(
          animationDuration: const Duration(milliseconds: 300),
          context: context,
          alignment: Alignment.bottomRight,
          autoCloseDuration: const Duration(seconds: 4),
          direction: TextDirection.rtl,
          builder: (BuildContext context, ToastificationItem holder) {
            return ErrorSnackBarWidget(
              item: holder,
              title: "خطا",
              message: "لطفا ابتدا فیلم را به صورت کامل بارگذاری کنید.",
            );
          });
    } else if (movieBloc.state.file != null) {
      video = movieBloc.state.fileId;
      time = movieBloc.state.duration;
    }

    if (trailerBloc.state.isUploaded != true ||
        trailerBloc.state.fileId == null) {
      isValid = false;
      toastification.showCustom(
          animationDuration: const Duration(milliseconds: 300),
          context: context,
          alignment: Alignment.bottomRight,
          autoCloseDuration: const Duration(seconds: 4),
          direction: TextDirection.rtl,
          builder: (BuildContext context, ToastificationItem holder) {
            return ErrorSnackBarWidget(
              item: holder,
              title: "خطا",
              message: "لطفا ابتدا پیش نمایش را به صورت کامل بارگذاری کنید.",
            );
          });
    } else if (trailerBloc.state.file != null) {
      trailer = trailerBloc.state.fileId;
    }

    if ((posterBloc.state.file == null &&
            posterBloc.state.networkUrl == null) ||
        posterBloc.state.filename == null) {
      isValid = false;
      posterBloc.setError("ریز عکس اجباری است.");
    } else if (posterBloc.state.file != null) {
      poster = Uint8List.fromList(posterBloc.state.file!);
      posterName = posterBloc.state.filename;
    }

    if ((thumbnailBloc.state.file == null &&
            thumbnailBloc.state.networkUrl == null) ||
        thumbnailBloc.state.filename == null) {
      isValid = false;
      thumbnailBloc.setError("تصویر شاخص اجباری است.");
    } else if (thumbnailBloc.state.file != null) {
      thumbnail = Uint8List.fromList(thumbnailBloc.state.file!);
      thumbnailName = thumbnailBloc.state.filename;
    }

    if (castBloc.state.casts.isEmpty) {
      isValid = false;
      castBloc.setError("هنرمندان کار را مشحص کنید.");
    } else if (!listEquals(castBloc.state.casts, _episode?.casts ?? [])) {
      casts = castBloc.state.casts.map((e) => e.toJson()).toList();
    }

    if (dateBloc.state.selectedDate !=
        intl.DateFormat('yyyy-MM-ddTHH:mm')
            .tryParse(_episode?.publicationDate ?? "")) {
      releaseDate = intl.DateFormat("yyyy-MM-ddTHH:mm")
          .format(dateBloc.state.selectedDate);
    }

    if (numberController.text.isEmpty) {
      isValid = false;
      BlocProvider.of<IntegerFieldCubit>(context)
          .setError("شماره قسمت اجباری است.");
    } else if (numberController.text != _episode?.number.toString()) {
      number = int.parse(numberController.text);
    }

    if (isValid == true) {
      BlocProvider.of<EpisodePageCubit>(context).editEpisode(
          id: episodeId,
          time: time,
          video: video,
          releaseDate: releaseDate,
          trailer: trailer,
          thumbnail: thumbnail,
          poster: poster,
          thumbnailName: thumbnailName,
          posterName: posterName,
          casts: casts,
          synopsis:
              synopsisController.text.isEmpty ? null : synopsisController.text,
          name: titleController.text.isEmpty ? null : titleController.text,
          number: number);
    }
  }
}
