import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/ads.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/movie_upload_section_widget/bloc/movie_upload_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/movie_upload_section_widget/movie_upload_section_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/title_section_widget/bloc/title_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/title_section_widget/title_section_widget.dart';
import 'package:dashboard/feature/season/presentation/widget/integer_field_widget/bloc/integer_field_cubit.dart';
import 'package:dashboard/feature/season/presentation/widget/integer_field_widget/integer_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toastification/toastification.dart';

import 'bloc/advertise_append_cubit.dart';
import 'bloc/advertise_table_cubit.dart';

class AdvertiseAppendDialogWidget extends StatefulWidget {
  final double width;
  final int? id;
  final bool readOnly;

  const AdvertiseAppendDialogWidget(
      {super.key, required this.width, this.id, this.readOnly = false});

  @override
  State<AdvertiseAppendDialogWidget> createState() =>
      _AdvertiseAppendDialogWidgetState();
}

class _AdvertiseAppendDialogWidgetState
    extends State<AdvertiseAppendDialogWidget> {
  late final TextEditingController titleController;
  late final TextEditingController repeatedController;
  late final IntegerFieldCubit repeatedFieldCubit;
  late final TitleSectionCubit titleFieldCubit;
  late final MovieUploadSectionCubit movieUploadSectionCubit;
  Advertise? advertise;

  @override
  void initState() {
    if (widget.id != null) {
      BlocProvider.of<AdvertiseAppendCubit>(context)
          .getAdvertise(id: widget.id!);
    }
    titleController = TextEditingController();
    repeatedController = TextEditingController();
    repeatedFieldCubit = IntegerFieldCubit();
    titleFieldCubit = TitleSectionCubit();
    movieUploadSectionCubit = MovieUploadSectionCubit(repository: getIt.get());
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    repeatedController.dispose();
    repeatedFieldCubit.close();
    titleFieldCubit.close();
    movieUploadSectionCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdvertiseAppendCubit, AdvertiseAppendState>(
      listener: (context, state) {
        if (state is AdvertiseAppendSuccessAppend) {
          BlocProvider.of<AdvertiseTableCubit>(context).getData();
          Navigator.of(context).pop();
        } else if (state is AdvertiseAppendSuccessUpdate) {
          BlocProvider.of<AdvertiseTableCubit>(context).getData(
              page: BlocProvider.of<AdvertiseTableCubit>(context)
                  .state
                  .pageIndex);
          Navigator.of(context).pop();
        } else if (state is AdvertiseAppendFailed) {
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
        } else if (state is AdvertiseAppendSuccess) {
          advertise = state.advertise;
          titleController.text = state.advertise.title ?? "";
          repeatedController.text =
              state.advertise.mustPlayed?.toString() ?? "";
          movieUploadSectionCubit.initialMovie(
              state.advertise.file, state.advertise.time);
        }
      },
      builder: (context, state) {
        List<Widget> children = [];

        if (widget.width > 400) {
          children.add(_landscapeLayout(state));
        } else {
          children.add(_portraitLayout(state));
        }

        if (state is AdvertiseAppendLoading) {
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
                bool isValid = true;
                if (titleController.text.isEmpty) {
                  isValid = false;
                  titleFieldCubit.setError("عنوان تبلیغ اجباری است.");
                } else {
                  titleFieldCubit.clearError();
                }

                if (repeatedController.text.isEmpty) {
                  isValid = false;
                  repeatedFieldCubit.setError("تعداد تکرار تبلیغ اجباری است.");
                } else {
                  repeatedFieldCubit.clearError();
                }

                if (movieUploadSectionCubit.state.isUploaded != true ||
                    movieUploadSectionCubit.state.fileId == null) {
                  isValid = false;
                  toastification.showCustom(
                      animationDuration: const Duration(milliseconds: 300),
                      context: context,
                      alignment: Alignment.bottomRight,
                      autoCloseDuration: const Duration(seconds: 4),
                      direction: TextDirection.rtl,
                      builder:
                          (BuildContext context, ToastificationItem holder) {
                        return ErrorSnackBarWidget(
                          item: holder,
                          title: "خطا",
                          message:
                              "لطفا ابتدا تبلیغ را به صورت کامل بارگذاری کنید.",
                        );
                      });
                }

                if (isValid) {
                  if (widget.id == null) {
                    BlocProvider.of<AdvertiseAppendCubit>(context)
                        .saveAdvertise(
                            title: titleController.text,
                            numberRepeated: int.parse(repeatedController.text),
                            fileId: movieUploadSectionCubit.state.fileId!,
                            time: movieUploadSectionCubit.state.duration ?? 0);
                  } else {
                    String? title;
                    int? repeated, fileId, duration;
                    if (titleController.text != advertise?.title) {
                      title = titleController.text;
                    }
                    if (repeatedController.text !=
                        advertise?.mustPlayed?.toString()) {
                      repeated = int.parse(repeatedController.text);
                    }
                    if (movieUploadSectionCubit.state.fileId !=
                        advertise?.file?.id) {
                      fileId = movieUploadSectionCubit.state.fileId;
                      duration = movieUploadSectionCubit.state.duration;
                    }
                    BlocProvider.of<AdvertiseAppendCubit>(context)
                        .updateAdvertise(
                            id: widget.id!,
                            title: title,
                            time: duration,
                            fileId: fileId,
                            numberRepeated: repeated);
                  }
                }
              },
              child: const Text(
                "ثبت",
              )),
        ],
      );

  Widget _landscapeLayout(AdvertiseAppendState state) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.id == null ? "تبلیغ جدید" : "ویرایش تبلیغ",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: BlocProvider.value(
                    value: movieUploadSectionCubit,
                    child: AspectRatio(
                        aspectRatio: 1,
                        child: MovieUploadSectionWidget(
                            readOnly: widget.readOnly,
                            height: widget.width / 6,
                            ratio: 1)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("عنوان تبلیغ",
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      BlocProvider.value(
                        value: titleFieldCubit,
                        child: TitleSectionWidget(
                          readOnly: widget.readOnly,
                          controller: titleController,
                          hintText: "شوینده پرقدرت تاژ",
                          label: null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("تعداد تکرار",
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      BlocProvider.value(
                        value: repeatedFieldCubit,
                        child: IntegerFieldWidget(
                          readOnly: widget.readOnly,
                          controller: repeatedController,
                          hint: "مثلا 1",
                          label: null,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            if (!widget.readOnly) _actionBar()
          ],
        ),
      );

  Widget _portraitLayout(AdvertiseAppendState state) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.id == null ? "تبلیغ جدید" : "ویرایش تبلیغ",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            BlocProvider.value(
              value: movieUploadSectionCubit,
              child: MovieUploadSectionWidget(
                  readOnly: widget.readOnly,
                  height: widget.width / 3,
                  ratio: 1),
            ),
            const SizedBox(height: 8),
            BlocProvider.value(
              value: titleFieldCubit,
              child: TitleSectionWidget(
                readOnly: widget.readOnly,
                controller: titleController,
                hintText: "شوینده پرقدرت تاژ",
                label: "عنوان تبلیغ",
              ),
            ),
            const SizedBox(height: 8),
            BlocProvider.value(
              value: repeatedFieldCubit,
              child: IntegerFieldWidget(
                readOnly: widget.readOnly,
                controller: repeatedController,
                hint: "مثلا 1",
                label: "تعداد تکرار",
              ),
            ),
            const SizedBox(height: 24),
            if (!widget.readOnly) _actionBar()
          ],
        ),
      );
}
