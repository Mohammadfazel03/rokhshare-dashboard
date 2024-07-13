import 'dart:ui';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/genres_table/bloc/genre_append_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/genres_table/bloc/genres_table_cubit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toastification/toastification.dart';

class GenreAppendDialogWidget extends StatefulWidget {
  final double width;
  final int? id;

  const GenreAppendDialogWidget({super.key, required this.width, this.id});

  @override
  State<GenreAppendDialogWidget> createState() =>
      _GenreAppendDialogWidgetState();
}

class _GenreAppendDialogWidgetState extends State<GenreAppendDialogWidget> {
  Uint8List? file;
  late final TextEditingController genreInputController;

  @override
  void initState() {
    if (widget.id != null) {
      BlocProvider.of<GenreAppendCubit>(context).getGenre(id: widget.id!);
    }
    genreInputController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GenreAppendCubit, GenreAppendState>(
      listener: (context, state) {
        if (state is GenreAppendSuccessAppend) {
          BlocProvider.of<GenresTableCubit>(context).getData();
          Navigator.of(context).pop();
        } else if (state is GenreAppendSuccessUpdate) {
          BlocProvider.of<GenresTableCubit>(context).getData(
              page: BlocProvider.of<GenresTableCubit>(context).state.pageIndex);
          Navigator.of(context).pop();
        } else if (state is GenreAppendFailed) {
          toastification.showCustom(
              animationDuration: Duration(milliseconds: 300),
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
        } else if (state is GenreAppendSuccess) {
          genreInputController.text = state.genre.title ?? "";
        }
      },
      builder: (context, state) {
        List<Widget> children = [];

        if (widget.width > 400) {
          children.add(_landscapeLayout(state));
        } else {
          children.add(_portraitLayout(state));
        }

        if (state is GenreAppendLoading) {
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
            child: Text(
              "انصراف",
            ),
            style: ButtonStyle(
              textStyle: WidgetStateProperty.all(
                  Theme.of(context).textTheme.labelSmall),
              padding: WidgetStateProperty.all(EdgeInsets.all(16)),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
            ),
          ),
          SizedBox(width: 8),
          FilledButton(
              style: ButtonStyle(
                  textStyle: WidgetStateProperty.all(
                      Theme.of(context).textTheme.labelSmall),
                  padding: WidgetStateProperty.all(EdgeInsets.all(16)),
                  alignment: Alignment.center,
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)))),
              onPressed: () {
                if (widget.id != null) {
                  BlocProvider.of<GenreAppendCubit>(context).updateGenre(
                      id: widget.id!,
                      title: genreInputController.text,
                      poster: file);
                } else {
                  if (genreInputController.text.isEmpty || file == null) {
                    toastification.showCustom(
                        animationDuration: Duration(milliseconds: 300),
                        context: context,
                        alignment: Alignment.bottomRight,
                        autoCloseDuration: const Duration(seconds: 4),
                        direction: TextDirection.rtl,
                        builder:
                            (BuildContext context, ToastificationItem holder) {
                          return ErrorSnackBarWidget(
                            item: holder,
                            title: "خطا",
                            message: "لطفا تمام مقادیر را وارد کنید.",
                          );
                        });
                  } else {
                    BlocProvider.of<GenreAppendCubit>(context).saveGenre(
                        title: genreInputController.text, poster: file);
                  }
                }
              },
              child: Text(
                "ثبت",
              )),
        ],
      );

  Widget _landscapeLayout(GenreAppendState state) => Padding(
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
            SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['png', 'jpg']);

                      if (result != null) {
                        if (['jpg', 'png']
                            .any((e) => e == result.files.first.extension)) {
                          file = result.files.single.bytes;
                          setState(() {});
                        } else {
                          toastification.showCustom(
                              animationDuration: Duration(milliseconds: 300),
                              context: context,
                              alignment: Alignment.bottomRight,
                              autoCloseDuration: const Duration(seconds: 4),
                              direction: TextDirection.rtl,
                              builder: (BuildContext context,
                                  ToastificationItem holder) {
                                return ErrorSnackBarWidget(
                                  item: holder,
                                  title: "خطا",
                                  message: "فایل انتخابی معتبر نمیباشد.",
                                );
                              });
                        }
                      }
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: (state is GenreAppendSuccess && file == null)
                            ? Image.network(state.genre.poster!)
                            : (file == null)
                                ? DottedBorder(
                                    dashPattern: [3, 2],
                                    radius: Radius.circular(4),
                                    color: Theme.of(context).dividerColor,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Image.asset(
                                          Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? "assets/images/upload_image_light.png"
                                              : "assets/images/upload_image_dark.png",
                                          height: widget.width / 4,
                                          width: widget.width / 4,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "ریز عکس ژانر خود را بارگذاری کنید",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  )
                                : Image.memory(file!),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("عنوان ژانر",
                          style: Theme.of(context).textTheme.titleSmall),
                      SizedBox(height: 8),
                      TextField(
                        controller: genreInputController,
                        decoration: InputDecoration(hintText: "اکشن، درام ..."),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 24),
            _actionBar()
          ],
        ),
      );

  Widget _portraitLayout(GenreAppendState state) => Padding(
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
            SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom, allowedExtensions: ['png', 'jpg']);

                if (result != null) {
                  if (['jpg', 'png']
                      .any((e) => e == result.files.first.extension)) {
                    file = result.files.single.bytes;
                    setState(() {});
                  } else {
                    toastification.showCustom(
                        animationDuration: Duration(milliseconds: 300),
                        context: context,
                        alignment: Alignment.bottomRight,
                        autoCloseDuration: const Duration(seconds: 4),
                        direction: TextDirection.rtl,
                        builder:
                            (BuildContext context, ToastificationItem holder) {
                          return ErrorSnackBarWidget(
                            item: holder,
                            title: "خطا",
                            message: "فایل انتخابی معتبر نمیباشد.",
                          );
                        });
                  }
                }
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: SizedBox(
                  height: widget.width,
                  width: widget.width,
                  child: (state is GenreAppendSuccess && file == null)
                      ? Image.network(state.genre.poster!)
                      : (file == null)
                          ? DottedBorder(
                              dashPattern: [3, 2],
                              radius: Radius.circular(4),
                              color: Theme.of(context).dividerColor,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Image.asset(
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? "assets/images/upload_image_light.png"
                                        : "assets/images/upload_image_dark.png",
                                    height: widget.width / 2,
                                    width: widget.width / 2,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "ریز عکس ژانر خود را بارگذاری کنید",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            )
                          : Image.memory(file!),
                ),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: genreInputController,
              decoration: InputDecoration(
                  hintText: "اکشن، درام ...", label: Text("عنوان ژانر")),
            ),
            SizedBox(height: 24),
            _actionBar()
          ],
        ),
      );
}
