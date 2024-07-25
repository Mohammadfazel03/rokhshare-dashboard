import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/artists_table/bloc/artist_append_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/artists_table/bloc/artists_table_cubit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

class ArtistAppendDialogWidget extends StatefulWidget {
  final double width;
  final int? id;

  const ArtistAppendDialogWidget({super.key, required this.width, this.id});

  @override
  State<ArtistAppendDialogWidget> createState() =>
      _ArtistAppendDialogWidgetState();
}

class _ArtistAppendDialogWidgetState extends State<ArtistAppendDialogWidget> {
  Uint8List? file;
  late final TextEditingController nameArtistInputController;
  late final TextEditingController bioArtistInputController;

  @override
  void initState() {
    if (widget.id != null) {
      BlocProvider.of<ArtistAppendCubit>(context).getArtist(id: widget.id!);
    }
    nameArtistInputController = TextEditingController();
    bioArtistInputController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ArtistAppendCubit, ArtistAppendState>(
      listener: (context, state) {
        if (state is ArtistAppendSuccessAppend) {
          BlocProvider.of<ArtistsTableCubit>(context).getData();
          Navigator.of(context).pop();
        } else if (state is ArtistAppendSuccessUpdate) {
          BlocProvider.of<ArtistsTableCubit>(context).getData(
              page:
                  BlocProvider.of<ArtistsTableCubit>(context).state.pageIndex);
          Navigator.of(context).pop();
        } else if (state is ArtistAppendFailed) {
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
                  title: "حطا در ارتباطات",
                  message: state.message,
                );
              });
        } else if (state is ArtistAppendSuccess) {
          nameArtistInputController.text = state.artist.name ?? "";
          bioArtistInputController.text = state.artist.biography ?? "";
        }
      },
      builder: (context, state) {
        List<Widget> children = [];

        if (widget.width > 400) {
          children.add(_landscapeLayout(state));
        } else {
          children.add(_portraitLayout(state));
        }

        if (state is ArtistAppendLoading) {
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
                  BlocProvider.of<ArtistAppendCubit>(context).updateArtist(
                      id: widget.id!,
                      name: nameArtistInputController.text,
                      image: file,
                      bio: bioArtistInputController.text);
                } else {
                  if (nameArtistInputController.text.isEmpty ||
                      file == null ||
                      bioArtistInputController.text.isEmpty) {
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
                    BlocProvider.of<ArtistAppendCubit>(context).saveArtist(
                        name: nameArtistInputController.text,
                        image: file,
                        bio: bioArtistInputController.text);
                  }
                }
              },
              child: const Text(
                "ثبت",
              )),
        ],
      );

  Widget _landscapeLayout(ArtistAppendState state) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.id == null ? "هنرمند جدید" : "ویرایش هنرمند",
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
                          .pickFiles(
                              type: FileType.image);

                      if (result != null) {
                          file = await result.files.single.xFile.readAsBytes();
                          setState(() {});
                      }
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: (state is ArtistAppendSuccess && file == null)
                            ? Image.network(state.artist.image!)
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
                                          "تصویر هنرمند خود را بارگذاری کنید",
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
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("نام هنرمند",
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        TextField(
                          controller: nameArtistInputController,
                          decoration:
                              const InputDecoration(hintText: "نوید محمد زاده"),
                        ),
                        const SizedBox(height: 16),
                        Text("زندگی\u200cنامه",
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        Expanded(
                          child: TextField(
                            expands: true,
                            minLines: null,
                            maxLines: null,
                            controller: bioArtistInputController,
                            decoration: const InputDecoration(
                                hintText: "زندگی\u200cنامه"),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            _actionBar()
          ],
        ),
      );

  Widget _portraitLayout(ArtistAppendState state) => Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.id == null ? "هنرمند جدید" : "ویرایش هنرمند",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                          type: FileType.image);

                  if (result != null) {
                    file = result.files.single.bytes;
                      setState(() {});
                  }
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: SizedBox(
                    height: widget.width,
                    width: widget.width,
                    child: (state is ArtistAppendSuccess && file == null)
                        ? Image.network(state.artist.image!)
                        : (file == null)
                            ? DottedBorder(
                                dashPattern: const [3, 2],
                                radius: const Radius.circular(4),
                                color: Theme.of(context).dividerColor,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
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
                                      "تصویر هنرمند خود را بارگذاری کنید",
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
                controller: nameArtistInputController,
                decoration: const InputDecoration(
                    hintText: "نوید محمد زاده", label: Text("نام هنرمند")),
              ),
              const SizedBox(height: 8),
              TextField(
                maxLines: 4,
                controller: bioArtistInputController,
                decoration: const InputDecoration(
                    hintText: "زندگی\u200cنامه",
                    label: Text("زندگی\u200cنامه")),
              ),
              const SizedBox(height: 24),
              _actionBar()
            ],
          ),
        ),
      );
}
