import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/date_picker_section_widget/bloc/date_picker_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/date_picker_section_widget/date_picker_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/poster_section_widget/bloc/poster_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/poster_section_widget/poster_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/thumbnail_section_widget/bloc/thumbnail_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/thumbnail_section_widget/thumbnail_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/title_section_widget/title_section_widget.dart';
import 'package:dashboard/feature/season/data/remote/model/season.dart';
import 'package:dashboard/feature/season/presentation/bloc/season_page_cubit.dart';
import 'package:dashboard/feature/season/presentation/widget/integer_field_widget/bloc/integer_field_cubit.dart';
import 'package:dashboard/feature/season/presentation/widget/integer_field_widget/integer_field_widget.dart';
import 'package:dashboard/feature/season/presentation/widget/season_append_dialog/bloc/season_append_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:toastification/toastification.dart';

class SeasonAppendDialog extends StatefulWidget {
  final int? seasonId;
  final int seriesId;
  final double width;

  const SeasonAppendDialog(
      {super.key, this.seasonId, required this.width, required this.seriesId});

  @override
  State<SeasonAppendDialog> createState() => _SeasonAppendDialogState();
}

class _SeasonAppendDialogState extends State<SeasonAppendDialog> {
  late final TextEditingController titleController;
  late final TextEditingController numberController;
  late final DateRangePickerController datePickerController;
  Season? _season;

  int? get seasonId => widget.seasonId;

  int get seriesId => widget.seriesId;

  @override
  void initState() {
    titleController = TextEditingController();
    numberController = TextEditingController();
    datePickerController = DateRangePickerController();

    if (widget.seasonId != null) {
      BlocProvider.of<SeasonAppendCubit>(context)
          .getSeason(id: widget.seasonId!);
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    numberController.dispose();
    datePickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SeasonAppendCubit, SeasonAppendState>(
        listener: (context, state) {
      if (state is SeasonAppendSuccessAppend) {
        BlocProvider.of<SeasonPageCubit>(context).refresh();
        Navigator.of(context).pop();
      } else if (state is SeasonAppendSuccessUpdate) {
        BlocProvider.of<SeasonPageCubit>(context).refresh();
        Navigator.of(context).pop();
      } else if (state is SeasonAppendFailed) {
        toastification.showCustom(
            animationDuration: const Duration(milliseconds: 300),
            context: context,
            alignment: Alignment.bottomRight,
            autoCloseDuration: const Duration(seconds: 4),
            direction: TextDirection.rtl,
            builder: (BuildContext context, ToastificationItem holder) {
              return ErrorSnackBarWidget(
                item: holder,
                title: "حطا در ارتباطات",
                message: state.message,
              );
            });
      } else if (state is SeasonAppendSuccess) {
        _season = state.season;
        titleController.text = _season?.name ?? "";
        numberController.text = _season?.number?.toString() ?? "1";
        BlocProvider.of<PosterSectionCubit>(context)
            .initialFile(_season?.poster);
        BlocProvider.of<ThumbnailSectionCubit>(context)
            .initialFile(_season?.thumbnail);
        BlocProvider.of<DatePickerSectionCubit>(context).setDate(
            intl.DateFormat('yyyy-MM-ddTHH:mm')
                .tryParse(_season?.publicationDate ?? ""));
      }
    }, builder: (context, state) {
      List<Widget> children = [];

      children.add(_portraitLayout(state));

      if (state is SeasonAppendLoading) {
        children.add(Positioned.fill(
          child: Container(
            color: Colors.black26,
            child: Center(
                child: RepaintBoundary(
                    child: SpinKitThreeBounce(
              color: CustomColor.loginBackgroundColor.getColor(context),
            ))),
          ),
        ));
      }

      return Stack(
        children: children,
      );
    });
  }

  Widget _actionBar() => Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              textStyle: WidgetStateProperty.all(
                  Theme.of(context).textTheme.labelSmall),
              padding: WidgetStateProperty.all(const EdgeInsets.all(16)),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
            ),
            child: const Text(
              "انصراف",
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
              style: ButtonStyle(
                  textStyle: WidgetStateProperty.all(
                      Theme.of(context).textTheme.labelSmall),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(16)),
                  alignment: Alignment.center,
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)))),
              onPressed: () {
                if (seasonId != null && _season != null) {
                  edit();
                } else if (seasonId == null) {
                  save();
                }
              },
              child: const Text(
                "ثبت",
              )),
        ],
      );

  Widget _portraitLayout(SeasonAppendState state) => Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                seasonId == null ? "فصل جدید" : "ویرایش فصل",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              IntegerFieldWidget(
                controller: numberController,
                label: "شماره فصل",
                hint: "مثلاً 1",
              ),
              const SizedBox(height: 8),
              TitleSectionWidget(
                  label: "عنوان فصل",
                  hintText: null,
                  controller: titleController,
                  readOnly: false),
              const SizedBox(height: 8),
              DatePickerSectionWidget(
                  readOnly: false, datePickerController: datePickerController),
              const SizedBox(height: 8),
              PosterSectionWidget(
                  textBackgroundColor: Theme.of(context).colorScheme.surface),
              const SizedBox(height: 8),
              ThumbnailSectionWidget(
                  textBackgroundColor: Theme.of(context).colorScheme.surface),
              const SizedBox(height: 24),
              _actionBar()
            ],
          ),
        ),
      );

  void save() {
    var isValid = true;

    var posterBloc = BlocProvider.of<PosterSectionCubit>(context);
    var thumbnailBloc = BlocProvider.of<ThumbnailSectionCubit>(context);
    var dateBloc = BlocProvider.of<DatePickerSectionCubit>(context);

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

    if (numberController.text.isEmpty) {
      isValid = false;
      BlocProvider.of<IntegerFieldCubit>(context)
          .setError("شماره فصل اجباری است.");
    } else {
      BlocProvider.of<IntegerFieldCubit>(context).clearError();
    }

    if (isValid == true) {
      BlocProvider.of<SeasonAppendCubit>(context).saveSeason(
          seriesId: seriesId,
          name: titleController.text,
          publicationDate: intl.DateFormat("yyyy-MM-ddTHH:mm")
              .format(dateBloc.state.selectedDate),
          thumbnail: thumbnailBloc.state.file!,
          poster: posterBloc.state.file!,
          number: int.parse(numberController.text));
    }
  }

  void edit() {
    var isValid = true;

    var posterBloc = BlocProvider.of<PosterSectionCubit>(context);
    var thumbnailBloc = BlocProvider.of<ThumbnailSectionCubit>(context);
    var dateBloc = BlocProvider.of<DatePickerSectionCubit>(context);

    String? name, releaseDate;
    Uint8List? thumbnail, poster;
    int? number;

    if ((posterBloc.state.file == null &&
            posterBloc.state.networkUrl == null) ||
        posterBloc.state.filename == null) {
      isValid = false;
      posterBloc.setError("ریز عکس اجباری است.");
    } else if (posterBloc.state.file != null) {
      poster = Uint8List.fromList(posterBloc.state.file!);
    }

    if ((thumbnailBloc.state.file == null &&
            thumbnailBloc.state.networkUrl == null) ||
        thumbnailBloc.state.filename == null) {
      isValid = false;
      thumbnailBloc.setError("تصویر شاخص اجباری است.");
    } else if (thumbnailBloc.state.file != null) {
      thumbnail = Uint8List.fromList(thumbnailBloc.state.file!);
    }

    if (titleController.text.isEmpty) {
      name = null;
    } else {
      name = titleController.text;
    }

    if (numberController.text.isEmpty) {
      isValid = false;
      BlocProvider.of<IntegerFieldCubit>(context)
          .setError("شماره فصل اجباری است.");
    } else if (int.parse(numberController.text) != _season?.number) {
      number = int.parse(numberController.text);
    }

    if (dateBloc.state.selectedDate !=
        intl.DateFormat('yyyy-MM-ddTHH:mm')
            .tryParse(_season?.publicationDate ?? "")) {
      releaseDate = intl.DateFormat("yyyy-MM-ddTHH:mm")
          .format(dateBloc.state.selectedDate);
    }

    if (isValid == true) {
      BlocProvider.of<SeasonAppendCubit>(context).updateSeason(
          id: seasonId!,
          publicationDate: releaseDate,
          thumbnail: thumbnail,
          poster: poster,
          name: name,
          number: number);
    }
  }
}
