import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/media/data/remote/model/slider.dart';
import 'package:dashboard/feature/media/presentation/widget/sliders_table/bloc/slider_append_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/sliders_table/bloc/sliders_table_cubit.dart';
import 'package:dashboard/feature/media_collection/presentation/widget/media_autocomplete_field/media_autocomplete_field.dart';
import 'package:dashboard/feature/movie/presentation/widget/poster_section_widget/bloc/poster_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/poster_section_widget/poster_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/synopsis_section_widget/bloc/synopsis_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/synopsis_section_widget/synopsis_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/thumbnail_section_widget/bloc/thumbnail_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/thumbnail_section_widget/thumbnail_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/title_section_widget/bloc/title_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/title_section_widget/title_section_widget.dart';
import 'package:dashboard/feature/season/presentation/widget/integer_field_widget/bloc/integer_field_cubit.dart';
import 'package:dashboard/feature/season/presentation/widget/integer_field_widget/integer_field_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toastification/toastification.dart';

class SliderAppendDialogWidget extends StatefulWidget {
  final double width;
  final int? id;

  const SliderAppendDialogWidget({super.key, required this.width, this.id});

  @override
  State<SliderAppendDialogWidget> createState() =>
      _SliderAppendDialogWidgetState();
}

class _SliderAppendDialogWidgetState extends State<SliderAppendDialogWidget> {
  Uint8List? file;
  late final TextEditingController titleInputController;
  late final TextEditingController descriptionInputController;
  late final TextEditingController integerInputController;
  late final MediaAutocompleteController mediaController;
  SliderModel? sliderModel;

  @override
  void initState() {
    if (widget.id != null) {
      BlocProvider.of<SliderAppendCubit>(context).getSlider(id: widget.id!);
    }
    titleInputController = TextEditingController();
    integerInputController = TextEditingController();
    descriptionInputController = TextEditingController();
    mediaController = MediaAutocompleteController();
    super.initState();
  }

  @override
  void dispose() {
    titleInputController.dispose();
    descriptionInputController.dispose();
    file = null;
    mediaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SliderAppendCubit, SliderAppendState>(
      listener: (context, state) {
        if (state is SliderAppendSuccessAppend) {
          BlocProvider.of<SlidersTableCubit>(context).getData();
          Navigator.of(context).pop();
        } else if (state is SliderAppendSuccessUpdate) {
          BlocProvider.of<SlidersTableCubit>(context).getData(
              page:
                  BlocProvider.of<SlidersTableCubit>(context).state.pageIndex);
          Navigator.of(context).pop();
        } else if (state is SliderAppendFailed) {
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
        } else if (state is SliderAppendSuccess) {
          integerInputController.text = state.slider.priority?.toString() ?? "";
          titleInputController.text = state.slider.title ?? "";
          descriptionInputController.text = state.slider.description ?? "";
          BlocProvider.of<ThumbnailSectionCubit>(context)
              .initialFile(state.slider.thumbnail);
          BlocProvider.of<PosterSectionCubit>(context)
              .initialFile(state.slider.poster);
          mediaController.setMedia(state.slider.media);
          sliderModel = state.slider;
        }
      },
      builder: (context, state) {
        List<Widget> children = [];

        if (widget.width > 400) {
          children.add(_landscapeLayout(state));
        } else {
          children.add(_portraitLayout(state));
        }

        if (state is SliderAppendLoading) {
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
      },
    );
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
                if (widget.id != null) {
                  edit();
                } else {
                  save();
                }
              },
              child: const Text(
                "ثبت",
              )),
        ],
      );

  void edit() {
    var valid = true;
    if (mediaController.media == null) {
      valid = false;
      mediaController.setError("لطفا یک مورد را انتخاب کنید.");
    }
    if (integerInputController.text.isEmpty) {
      BlocProvider.of<IntegerFieldCubit>(context)
          .setError("این فیلد اجباری است");
      valid = false;
    }

    if (titleInputController.text.isEmpty) {
      BlocProvider.of<TitleSectionCubit>(context)
          .setError("این فیلد اجباری است");
      valid = false;
    }
    if (descriptionInputController.text.isEmpty) {
      BlocProvider.of<SynopsisSectionCubit>(context)
          .setError("این فیلد اجباری است");
      valid = false;
    }
    var posterCubit = BlocProvider.of<PosterSectionCubit>(context);
    var thumbnailCubit = BlocProvider.of<ThumbnailSectionCubit>(context);
    if (posterCubit.state.file == null &&
        posterCubit.state.networkUrl == null) {
      posterCubit.setError("این فیلد اجباری است");
      valid = false;
    }
    if (thumbnailCubit.state.file == null &&
        thumbnailCubit.state.networkUrl == null) {
      thumbnailCubit.setError("این فیلد اجباری است");
      valid = false;
    }
    if (valid) {
      BlocProvider.of<SliderAppendCubit>(context).updateSlider(
          id: sliderModel!.id!,
          mediaId: sliderModel?.media?.id != mediaController.media?.id
              ? mediaController.media!.id!
              : null,
          priority:
              integerInputController.text != sliderModel?.priority?.toString()
                  ? int.parse(integerInputController.text)
                  : null,
          title: titleInputController.text != sliderModel?.title
              ? titleInputController.text
              : null,
          description:
              descriptionInputController.text != sliderModel?.description
                  ? descriptionInputController.text
                  : null,
          thumbnail: thumbnailCubit.state.networkUrl == null
              ? thumbnailCubit.state.file!
              : null,
          poster: posterCubit.state.networkUrl == null
              ? posterCubit.state.file!
              : null,
          thumbnailName: thumbnailCubit.state.networkUrl == null
              ? thumbnailCubit.state.filename ?? "thumbnail.jpeg"
              : null,
          posterName: posterCubit.state.networkUrl == null
              ? posterCubit.state.filename ?? "poster.jpeg"
              : null);
    }
  }

  void save() {
    var valid = true;
    if (mediaController.media == null) {
      valid = false;
      mediaController.setError("لطفا یک مورد را انتخاب کنید.");
    }
    if (integerInputController.text.isEmpty) {
      BlocProvider.of<IntegerFieldCubit>(context)
          .setError("این فیلد اجباری است");
      valid = false;
    }

    if (titleInputController.text.isEmpty) {
      BlocProvider.of<TitleSectionCubit>(context)
          .setError("این فیلد اجباری است");
      valid = false;
    }
    if (descriptionInputController.text.isEmpty) {
      BlocProvider.of<SynopsisSectionCubit>(context)
          .setError("این فیلد اجباری است");
      valid = false;
    }
    var posterCubit = BlocProvider.of<PosterSectionCubit>(context);
    var thumbnailCubit = BlocProvider.of<ThumbnailSectionCubit>(context);
    if (posterCubit.state.file == null) {
      posterCubit.setError("این فیلد اجباری است");
      valid = false;
    }
    if (thumbnailCubit.state.file == null) {
      thumbnailCubit.setError("این فیلد اجباری است");
      valid = false;
    }
    if (valid) {
      BlocProvider.of<SliderAppendCubit>(context).saveSlider(
          mediaId: mediaController.media!.id!,
          priority: int.parse(integerInputController.text),
          title: titleInputController.text,
          description: descriptionInputController.text,
          thumbnail: thumbnailCubit.state.file!,
          poster: posterCubit.state.file!,
          thumbnailName: thumbnailCubit.state.filename ?? "thumbnail.jpeg",
          posterName: posterCubit.state.filename ?? "poster.jpeg");
    }
  }

  Widget _landscapeLayout(SliderAppendState state) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.id == null ? "ژانر جدید" : "ویرایش ژانر",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MediaAutocompleteField(
                            selectMedia: (_) {}, controller: mediaController),
                        const SizedBox(height: 8),
                        TitleSectionWidget(
                          hintText: "پدر خوانده",
                          label: "عنوان",
                          controller: titleInputController,
                        ),
                        const SizedBox(height: 8),
                        ThumbnailSectionWidget(
                            textBackgroundColor:
                                Theme.of(context).colorScheme.surface),
                      ]),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IntegerFieldWidget(
                            controller: integerInputController,
                            label: "الویت نمایش",
                            hint: "مثلاً 1"),
                        const SizedBox(height: 8),
                        SynopsisSectionWidget(
                          maxLines: 1,
                          hintText: "تاک شو جذاب",
                          label: "توضیجات",
                          controller: descriptionInputController,
                        ),
                        const SizedBox(height: 8),
                        PosterSectionWidget(
                            textBackgroundColor:
                                Theme.of(context).colorScheme.surface)
                      ]),
                )
              ],
            ),
            const SizedBox(height: 24),
            _actionBar()
          ],
        ),
      );

  Widget _portraitLayout(SliderAppendState state) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.id == null ? "صفحه اول جدید" : "ویرایش صفحه اول",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            MediaAutocompleteField(
                selectMedia: (_) {}, controller: mediaController),
            const SizedBox(height: 8),
            IntegerFieldWidget(
                controller: integerInputController,
                label: "الویت نمایش",
                hint: "مثلاً 1"),
            const SizedBox(height: 8),
            TitleSectionWidget(
              hintText: "پدر خوانده",
              label: "عنوان",
              controller: titleInputController,
            ),
            const SizedBox(height: 8),
            SynopsisSectionWidget(
              maxLines: 1,
              hintText: "تاک شو جذاب",
              label: "توضیجات",
              controller: descriptionInputController,
            ),
            const SizedBox(height: 8),
            ThumbnailSectionWidget(
                textBackgroundColor: Theme.of(context).colorScheme.surface),
            const SizedBox(height: 8),
            PosterSectionWidget(
                textBackgroundColor: Theme.of(context).colorScheme.surface),
            const SizedBox(height: 24),
            _actionBar()
          ],
        ),
      );
}
