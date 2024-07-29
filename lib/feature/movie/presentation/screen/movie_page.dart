import 'dart:ui';

import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/movies_table/bloc/movies_table_cubit.dart';
import 'package:dashboard/feature/movie/data/remote/model/movie.dart';
import 'package:dashboard/feature/movie/presentation/bloc/movie_page_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/artists_autocomplete_widget/artists_autocomplete_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/artists_section_widget/artist_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/artists_section_widget/bloc/artist_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/country_multi_selector_widget/bloc/country_multi_selector_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/country_multi_selector_widget/country_multi_selector_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/date_picker_section_widget/bloc/date_picker_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/date_picker_section_widget/date_picker_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/genre_section_widget/bloc/genre_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/genre_section_widget/genre_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/movie_upload_section_widget/bloc/movie_upload_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/movie_upload_section_widget/movie_upload_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/poster_section_widget/bloc/poster_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/poster_section_widget/poster_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/synopsis_section_widget/bloc/synopsis_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/synopsis_section_widget/synopsis_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/thumbnail_section_widget/bloc/thumbnail_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/thumbnail_section_widget/thumbnail_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/title_section_widget/bloc/title_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/title_section_widget/title_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/trailer_upload_section_widget/bloc/trailer_upload_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/trailer_upload_section_widget/trailer_upload_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/value_section_widget/bloc/value_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/value_section_widget/value_section_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:toastification/toastification.dart';

class MoviePage extends StatefulWidget {
  final int? movieId;

  const MoviePage({super.key, this.movieId});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  late final TextEditingController titleController;
  late final TextEditingController synopsisController;
  late final DateRangePickerController datePickerController;
  late final ArtistsAutocompleteController artistsAutocompleteController;
  Movie? _movie;

  get movieId => widget.movieId;

  @override
  void initState() {
    if (movieId != null) {
      BlocProvider.of<MoviePageCubit>(context).getMovie(id: movieId);
    } else {
      BlocProvider.of<GenreSectionCubit>(context).getData();
      BlocProvider.of<CountryMultiSelectorCubit>(context).getData();
    }
    synopsisController = TextEditingController();
    titleController = TextEditingController();
    datePickerController = DateRangePickerController();
    artistsAutocompleteController = ArtistsAutocompleteController();
    super.initState();
  }

  @override
  void dispose() {
    synopsisController.dispose();
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
      return BlocConsumer<MoviePageCubit, MoviePageState>(buildWhen: (p, c) {
        return p is MoviePageLoading || c is MoviePageLoading;
      }, listener: (context, state) {
        if (state is MoviePageSuccessAppend) {
          BlocProvider.of<MoviesTableCubit>(context).getData();
          context.pop();
        } else if (state is MoviePageFailAppend) {
          if (state.code == 403) {
            getIt.get<LocalStorageService>().logout().then((value) {
              if (value) {
                context.go(RoutePath.login.fullPath);
              }
            });
          }
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
        } else if (state is MoviePageFail) {
          if (state.code == 403) {
            getIt.get<LocalStorageService>().logout().then((value) {
              if (value) {
                context.go(RoutePath.login.fullPath);
              }
            });
          }
        } else if (state is MoviePageSuccess) {
          _movie = state.data;
          BlocProvider.of<GenreSectionCubit>(context).getData();
          BlocProvider.of<CountryMultiSelectorCubit>(context).getData();

          titleController.text = state.data.media?.name ?? "";
          synopsisController.text = state.data.media?.synopsis ?? "";
          BlocProvider.of<CountryMultiSelectorCubit>(context)
              .initialSelectedItem(state.data.media?.countries ?? []);
          BlocProvider.of<GenreSectionCubit>(context)
              .initialSelectedItem(state.data.media?.genres ?? []);
          BlocProvider.of<ArtistSectionCubit>(context)
              .initialSelectedItem(state.data.casts ?? []);
          BlocProvider.of<ValueSectionCubit>(context)
              .selectValue(state.data.media?.value);
          BlocProvider.of<DatePickerSectionCubit>(context).setDate(
              intl.DateFormat('yyyy-MM-ddTHH:mm')
                  .tryParse(state.data.media?.releaseDate ?? ""));
          BlocProvider.of<ThumbnailSectionCubit>(context)
              .initialFile(state.data.media?.thumbnail);
          BlocProvider.of<PosterSectionCubit>(context)
              .initialFile(state.data.media?.poster);
          BlocProvider.of<MovieUploadSectionCubit>(context)
              .initialMovie(state.data.video, state.data.time);
          BlocProvider.of<TrailerUploadSectionCubit>(context)
              .initialTrailer(state.data.media?.trailer);
        } else if (state is MoviePageSuccessUpdate) {
          BlocProvider.of<MoviesTableCubit>(context).refreshPage();
          context.pop();
        }
      }, builder: (context, state) {
        return Stack(children: [
          if (state is! MoviePageFail) ...[
            AbsorbPointer(
              absorbing: state is MoviePageLoading,
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
                      if (widget.movieId != null) ...[
                        Text("ویرایش فیلم / ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: CustomColor.navRailTextColorDisable
                                        .getColor(context)))
                      ] else ...[
                        Text("افزودن فیلم / ",
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
              ]),
            )
          ],
          if (state is MoviePageLoading) ...[
            Center(
                child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
              child: SpinKitCubeGrid(
                color: CustomColor.loginBackgroundColor.getColor(context),
                size: 50.0,
              ),
            ))
          ],
          if (state is MoviePageFail) ...[
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
                        height: width / 3 > 250 ? width / 9 : width / 3),
                    const SizedBox(height: 8),
                    TrailerUploadSectionWidget(
                        height: width / 3 > 250 ? width / 9 : width / 3),
                    const SizedBox(height: 8),
                    const PosterSectionWidget(),
                    const SizedBox(height: 8),
                    const ThumbnailSectionWidget(),
                    if (width / 3 > 250) ...[
                      const SizedBox(height: 8),
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
                            if (movieId != null) {
                              edit();
                            } else {
                              save();
                            }
                          },
                          child: const Text(
                            "ثبت",
                          )),
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
                    TitleSectionWidget(controller: titleController),
                    const SizedBox(height: 16),
                    SynopsisSectionWidget(controller: synopsisController),
                    const SizedBox(height: 16),
                    const CountryMultiSelectorWidget(),
                    const SizedBox(height: 16),
                    const GenreSectionWidget(),
                    const SizedBox(height: 16),
                    ArtistSectionWidget(
                        width: width * 2 / 3,
                        controller: artistsAutocompleteController),
                    const SizedBox(height: 16),
                    if (width / 3 > 200) ...[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: DatePickerSectionWidget(
                                  datePickerController: datePickerController)),
                          const SizedBox(width: 8),
                          const Expanded(child: ValueSectionWidget())
                        ],
                      )
                    ] else ...[
                      Expanded(
                          child: DatePickerSectionWidget(
                              datePickerController: datePickerController)),
                      const SizedBox(height: 16),
                      const ValueSectionWidget()
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
              height: width / 3 > 250 ? width / 9 : width / 3),
          const SizedBox(height: 16),
          TrailerUploadSectionWidget(
              height: width / 3 > 250 ? width / 9 : width / 3),
          const SizedBox(height: 16),
          const PosterSectionWidget(),
          const SizedBox(height: 16),
          const ThumbnailSectionWidget(),
          const SizedBox(height: 16),
          TitleSectionWidget(controller: titleController),
          const SizedBox(height: 16),
          SynopsisSectionWidget(controller: synopsisController),
          const SizedBox(height: 16),
          const CountryMultiSelectorWidget(),
          const SizedBox(height: 16),
          const GenreSectionWidget(),
          const SizedBox(height: 16),
          ArtistSectionWidget(
              width: width, controller: artistsAutocompleteController),
          const SizedBox(height: 16),
          if (width / 3 > 200) ...[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: DatePickerSectionWidget(
                        datePickerController: datePickerController)),
                const SizedBox(width: 8),
                const Expanded(child: ValueSectionWidget())
              ],
            )
          ] else ...[
            Expanded(
                child: DatePickerSectionWidget(
                    datePickerController: datePickerController)),
            const SizedBox(height: 16),
            const ValueSectionWidget()
          ],
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
                if (movieId != null) {
                  edit();
                } else {
                  save();
                }
              },
              child: const Text(
                "ثبت",
              ))
        ]);
  }

  void save() {
    var isValid = true;

    var movieBloc = BlocProvider.of<MovieUploadSectionCubit>(context);
    var trailerBloc = BlocProvider.of<TrailerUploadSectionCubit>(context);
    var posterBloc = BlocProvider.of<PosterSectionCubit>(context);
    var thumbnailBloc = BlocProvider.of<ThumbnailSectionCubit>(context);
    var genresBloc = BlocProvider.of<GenreSectionCubit>(context);
    var countriesBloc = BlocProvider.of<CountryMultiSelectorCubit>(context);
    var valueBloc = BlocProvider.of<ValueSectionCubit>(context);
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

    if (synopsisController.text.isEmpty) {
      isValid = false;
      BlocProvider.of<SynopsisSectionCubit>(context)
          .setError("خلاصه داستان اجباری است.");
    } else {
      BlocProvider.of<SynopsisSectionCubit>(context).clearError();
    }

    if (titleController.text.isEmpty) {
      isValid = false;
      BlocProvider.of<TitleSectionCubit>(context)
          .setError("عنوان فیلم اجباری است.");
    } else {
      BlocProvider.of<TitleSectionCubit>(context).clearError();
    }

    if (countriesBloc.state.selectedItem.isEmpty) {
      isValid = false;
      countriesBloc.setError("کشور", "حداقل یک کشور را انتخاب کنید.");
    } else {
      countriesBloc.clearError();
    }

    if (genresBloc.state.selectedItem.isEmpty) {
      isValid = false;
      genresBloc.setError("ژانر", "حداقل یک ژانر را انتخاب کنید.");
    } else {
      genresBloc.clearError();
    }

    if (valueBloc.state.selectedValue == null) {
      isValid = false;
      valueBloc.setError('ارزش فیلم اجباری است');
    } else {
      valueBloc.clearError();
    }

    if (castBloc.state.casts.isEmpty) {
      isValid = false;
      castBloc.setError("هنرمندان کار را مشحص کنید.");
    } else {
      castBloc.clearError();
    }

    if (isValid == true) {
      BlocProvider.of<MoviePageCubit>(context).saveMovie(
          synopsis: synopsisController.text,
          name: titleController.text,
          time: movieBloc.state.duration ?? 1,
          genres: genresBloc.state.selectedItem.map((e) => e.id!).toList(),
          countries:
              countriesBloc.state.selectedItem.map((e) => e.id!).toList(),
          video: movieBloc.state.fileId ?? 0,
          releaseDate: intl.DateFormat("yyyy-MM-ddTHH:mm")
              .format(dateBloc.state.selectedDate),
          trailer: trailerBloc.state.fileId ?? 0,
          thumbnail: thumbnailBloc.state.file!,
          poster: posterBloc.state.file!,
          thumbnailName: thumbnailBloc.state.filename!,
          posterName: posterBloc.state.filename!,
          value: valueBloc.state.selectedValue!.serverNameSpace,
          casts: castBloc.state.casts.map((e) => e.toJson()).toList());
    }
  }

  void edit() {
    var isValid = true;

    var movieBloc = BlocProvider.of<MovieUploadSectionCubit>(context);
    var trailerBloc = BlocProvider.of<TrailerUploadSectionCubit>(context);
    var posterBloc = BlocProvider.of<PosterSectionCubit>(context);
    var thumbnailBloc = BlocProvider.of<ThumbnailSectionCubit>(context);
    var genresBloc = BlocProvider.of<GenreSectionCubit>(context);
    var countriesBloc = BlocProvider.of<CountryMultiSelectorCubit>(context);
    var valueBloc = BlocProvider.of<ValueSectionCubit>(context);
    var castBloc = BlocProvider.of<ArtistSectionCubit>(context);
    var dateBloc = BlocProvider.of<DatePickerSectionCubit>(context);

    String? synopsis, name, releaseDate, thumbnailName, posterName, value;
    List<int>? genres, countries;
    int? time, video, trailer;
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

    if (synopsisController.text.isEmpty) {
      isValid = false;
      BlocProvider.of<SynopsisSectionCubit>(context)
          .setError("خلاصه داستان اجباری است.");
    } else if (synopsisController.text != _movie?.media?.synopsis) {
      synopsis = synopsisController.text;
    }

    if (titleController.text.isEmpty) {
      isValid = false;
      BlocProvider.of<TitleSectionCubit>(context)
          .setError("عنوان فیلم اجباری است.");
    } else if (titleController.text != _movie?.media?.name) {
      name = titleController.text;
    }

    if (countriesBloc.state.selectedItem.isEmpty) {
      isValid = false;
      countriesBloc.setError("کشور", "حداقل یک کشور را انتخاب کنید.");
    } else if (!listEquals(
        countriesBloc.state.selectedItem, _movie?.media?.countries ?? [])) {
      countries = countriesBloc.state.selectedItem.map((e) => e.id!).toList();
    }

    if (genresBloc.state.selectedItem.isEmpty) {
      isValid = false;
      genresBloc.setError("ژانر", "حداقل یک ژانر را انتخاب کنید.");
    } else if (!listEquals(
        genresBloc.state.selectedItem, _movie?.media?.genres ?? [])) {
      genres = genresBloc.state.selectedItem.map((e) => e.id!).toList();
    }

    if (valueBloc.state.selectedValue == null) {
      isValid = false;
      valueBloc.setError('ارزش فیلم اجباری است');
    } else if (valueBloc.state.selectedValue != _movie?.media?.value) {
      value = valueBloc.state.selectedValue!.serverNameSpace;
    }

    if (castBloc.state.casts.isEmpty) {
      isValid = false;
      castBloc.setError("هنرمندان کار را مشحص کنید.");
    } else if (!listEquals(castBloc.state.casts, _movie?.casts ?? [])) {
      casts = castBloc.state.casts.map((e) => e.toJson()).toList();
    }

    if (dateBloc.state.selectedDate !=
        intl.DateFormat('yyyy-MM-ddTHH:mm')
            .tryParse(_movie?.media?.releaseDate ?? "")) {
      releaseDate = intl.DateFormat("yyyy-MM-ddTHH:mm")
          .format(dateBloc.state.selectedDate);
    }

    if (isValid == true) {
      BlocProvider.of<MoviePageCubit>(context).editMovie(
          id: movieId,
          time: time,
          genres: genres,
          countries: countries,
          video: video,
          releaseDate: releaseDate,
          trailer: trailer,
          thumbnail: thumbnail,
          poster: poster,
          thumbnailName: thumbnailName,
          posterName: posterName,
          casts: casts,
          synopsis: synopsis,
          name: name,
          value: value);
    }
  }
}
