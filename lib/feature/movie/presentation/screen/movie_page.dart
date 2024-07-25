import 'dart:ui';

import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/movies_table/bloc/movies_table_cubit.dart';
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
  late DateTime selectedDate;
  late final TextEditingController titleController;
  late final TextEditingController synopsisController;
  late final DateRangePickerController datePickerController;
  late final ArtistsAutocompleteController artistsAutocompleteController;

  @override
  void initState() {
    selectedDate = DateTime.now();
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
      return BlocConsumer<MoviePageCubit, MoviePageState>(
        buildWhen: (p, c) {
          return p is MoviePageLoading || c is MoviePageLoading;
        },
        listener: (context, state) {
          if (state is MoviePageSuccess) {
            BlocProvider.of<MoviesTableCubit>(context).getData();
            context.pop();
          } else if (state is MoviePageFail) {
            if (state.code == 403) {
              getIt.get<LocalStorageService>().logout().then((value){
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
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
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
                                  child: body(width))))),
                ]),
              ),
              if (state is MoviePageLoading) ...[
                Center(
                    child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                  child: SpinKitCubeGrid(
                    color: CustomColor.loginBackgroundColor.getColor(context),
                    size: 50.0,
                  ),
                ))
              ]
            ],
          );
        },
      );
    });
  }

  Widget body(double width) {
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
                            save();
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
                save();
              },
              child: const Text(
                "ثبت",
              ))
        ]);
  }

  void save() {
    var isValid = true;

    var movieBloc = context.read<MovieUploadSectionCubit>();
    var trailerBloc = context.read<TrailerUploadSectionCubit>();
    var posterBloc = context.read<PosterSectionCubit>();
    var thumbnailBloc = context.read<ThumbnailSectionCubit>();
    var genresBloc = context.read<GenreSectionCubit>();
    var countriesBloc = context.read<CountryMultiSelectorCubit>();
    var valueBloc = context.read<ValueSectionCubit>();
    var castBloc = context.read<ArtistSectionCubit>();
    var dateBloc = context.read<DatePickerSectionCubit>();

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
      context.read<SynopsisSectionCubit>().setError("خلاصه داستان اجباری است.");
    } else {
      context.read<SynopsisSectionCubit>().clearError();
    }

    if (titleController.text.isEmpty) {
      isValid = false;
      context.read<TitleSectionCubit>().setError("عنوان فیلم اجباری است.");
    } else {
      context.read<TitleSectionCubit>().clearError();
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
      context.read<MoviePageCubit>().saveMovie(
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
}
