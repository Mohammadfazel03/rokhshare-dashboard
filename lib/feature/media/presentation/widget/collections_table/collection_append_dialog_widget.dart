import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/collections_table/bloc/collection_append_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/collections_table/bloc/collections_table_cubit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toastification/toastification.dart';

class CollectionAppendDialogWidget extends StatefulWidget {
  final double width;
  final int? id;

  const CollectionAppendDialogWidget({super.key, required this.width, this.id});

  @override
  State<CollectionAppendDialogWidget> createState() =>
      _CollectionAppendDialogWidgetState();
}

class _CollectionAppendDialogWidgetState
    extends State<CollectionAppendDialogWidget> {
  Uint8List? file;
  late final TextEditingController collectionInputController;

  @override
  void initState() {
    if (widget.id != null) {
      BlocProvider.of<CollectionAppendCubit>(context)
          .getCollection(id: widget.id!);
    }
    collectionInputController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    collectionInputController.dispose();
    file = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CollectionAppendCubit, CollectionAppendState>(
      listener: (context, state) {
        if (state is CollectionAppendSuccessAppend) {
          BlocProvider.of<CollectionsTableCubit>(context).getData();
          Navigator.of(context).pop();
        } else if (state is CollectionAppendSuccessUpdate) {
          BlocProvider.of<CollectionsTableCubit>(context).getData(
              page: BlocProvider.of<CollectionsTableCubit>(context)
                  .state
                  .pageIndex);
          Navigator.of(context).pop();
        } else if (state is CollectionAppendFailed) {
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
        } else if (state is CollectionAppendSuccess) {
          collectionInputController.text = state.collection.name ?? "";
        }
      },
      builder: (context, state) {
        List<Widget> children = [];

        if (widget.width > 400) {
          children.add(_landscapeLayout(state));
        } else {
          children.add(_portraitLayout(state));
        }

        if (state is CollectionAppendLoading) {
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
                  BlocProvider.of<CollectionAppendCubit>(context)
                      .updateCollection(
                          id: widget.id!,
                          title: collectionInputController.text,
                          poster: file);
                } else {
                  if (collectionInputController.text.isEmpty || file == null) {
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
                            message: "لطفا تمام مقادیر را وارد کنید.",
                          );
                        });
                  } else {
                    BlocProvider.of<CollectionAppendCubit>(context)
                        .saveCollection(
                            title: collectionInputController.text,
                            poster: file);
                  }
                }
              },
              child: const Text(
                "ثبت",
              )),
        ],
      );

  Widget _landscapeLayout(CollectionAppendState state) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.id == null ? "مجموعه جدید" : "ویرایش مجموعه",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(type: FileType.image);

                      if (result != null) {
                        file = await result.files.single.xFile.readAsBytes();
                        setState(() {});
                      }
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child:
                            (state is CollectionAppendSuccess && file == null)
                                ? Image.network(state.collection.poster!)
                                : (file == null)
                                    ? DottedBorder(
                                        dashPattern: const [3, 2],
                                        radius: const Radius.circular(4),
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
                                            const SizedBox(height: 8),
                                            Text(
                                              "ریز عکس مجموعه خود را بارگذاری کنید",
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
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("عنوان مجموعه",
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      TextField(
                        controller: collectionInputController,
                        decoration:
                            const InputDecoration(hintText: "اکشن، درام ..."),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            _actionBar()
          ],
        ),
      );

  Widget _portraitLayout(CollectionAppendState state) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.id == null ? "مجموعه جدید" : "ویرایش مجموعه",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom, allowedExtensions: ['png', 'jpg']);

                if (result != null) {
                  file = await result.files.single.xFile.readAsBytes();
                  setState(() {});
                }
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: SizedBox(
                  height: widget.width,
                  width: widget.width,
                  child: (state is CollectionAppendSuccess && file == null)
                      ? Image.network(state.collection.poster!)
                      : (file == null)
                          ? DottedBorder(
                              dashPattern: const [3, 2],
                              radius: const Radius.circular(4),
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
                                  const SizedBox(height: 8),
                                  Text(
                                    "ریز عکس مجموعه خود را بارگذاری کنید",
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
            const SizedBox(height: 8),
            TextField(
              controller: collectionInputController,
              decoration: const InputDecoration(
                  hintText: "اکشن، درام ...", label: Text("عنوان مجموعه")),
            ),
            const SizedBox(height: 24),
            _actionBar()
          ],
        ),
      );
}
