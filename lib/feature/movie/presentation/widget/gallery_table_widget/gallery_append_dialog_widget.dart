import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/movie/data/remote/model/gallery.dart';
import 'package:dashboard/feature/movie/presentation/widget/gallery_table_widget/bloc/gallery_append_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/gallery_table_widget/bloc/gallery_table_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/media_selector_widget/bloc/media_selector_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/media_selector_widget/media_selector_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/synopsis_section_widget/bloc/synopsis_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/synopsis_section_widget/synopsis_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toastification/toastification.dart';

class GalleryAppendDialogWidget extends StatefulWidget {
  final double width;
  final int? id;
  final int? mediaId;
  final int? episodeId;

  const GalleryAppendDialogWidget(
      {super.key,
      required this.width,
      this.id,
      required this.mediaId,
      required this.episodeId});

  @override
  State<GalleryAppendDialogWidget> createState() =>
      _GalleryAppendDialogWidgetState();
}

class _GalleryAppendDialogWidgetState extends State<GalleryAppendDialogWidget> {
  late final TextEditingController descriptionInputController;
  Gallery? gallery;

  int? get mediaId => widget.mediaId;

  int? get episodeId => widget.episodeId;

  @override
  void initState() {
    if (widget.id != null) {
      BlocProvider.of<GalleryAppendCubit>(context).getGallery(id: widget.id!);
    }
    descriptionInputController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    descriptionInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GalleryAppendCubit, GalleryAppendState>(
      listener: (context, state) {
        if (state is GalleryAppendSuccessAppend) {
          BlocProvider.of<GalleryTableCubit>(context)
              .getData(mediaId: mediaId, episodeId: episodeId);
          Navigator.of(context).pop();
        } else if (state is GalleryAppendSuccessUpdate) {
          BlocProvider.of<GalleryTableCubit>(context).getData(
              episodeId: episodeId,
              mediaId: mediaId,
              page:
                  BlocProvider.of<GalleryTableCubit>(context).state.pageIndex);
          Navigator.of(context).pop();
        } else if (state is GalleryAppendFailed) {
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
        } else if (state is GalleryAppendSuccess) {
          descriptionInputController.text = state.gallery.description ?? "";
          BlocProvider.of<MediaSelectorCubit>(context)
              .initialMedia(state.gallery.file);
          gallery = state.gallery;
        }
      },
      builder: (context, state) {
        List<Widget> children = [];

        if (widget.width > 400) {
          children.add(_landscapeLayout(state));
        } else {
          children.add(_portraitLayout(state));
        }

        if (state is GalleryAppendLoading) {
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

    if (descriptionInputController.text.isEmpty) {
      BlocProvider.of<SynopsisSectionCubit>(context)
          .setError("این فیلد اجباری است");
      valid = false;
    }
    var mediaCubit = BlocProvider.of<MediaSelectorCubit>(context);
    if (mediaCubit.state.fileId == null &&
        mediaCubit.state.thumbnailNetworkUrl == null) {
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
              message: "لطفا ابتدا فایل را به صورت کامل بارگذاری کنید.",
            );
          });
      valid = false;
    }
    if (valid) {
      BlocProvider.of<GalleryAppendCubit>(context).updateGallery(
          id: gallery!.id!,
          description: descriptionInputController.text != gallery?.description
              ? descriptionInputController.text
              : null,
          fileId: mediaCubit.state.fileId);
    }
  }

  void save() {
    var valid = true;

    if (descriptionInputController.text.isEmpty) {
      BlocProvider.of<SynopsisSectionCubit>(context)
          .setError("این فیلد اجباری است");
      valid = false;
    }
    var mediaCubit = BlocProvider.of<MediaSelectorCubit>(context);
    if (mediaCubit.state.fileId == null) {
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
              message: "لطفا ابتدا فایل را به صورت کامل بارگذاری کنید.",
            );
          });
      valid = false;
    }

    if (valid) {
      BlocProvider.of<GalleryAppendCubit>(context).saveGallery(
        episodeId: episodeId,
        mediaId: mediaId,
        description: descriptionInputController.text,
        fileId: mediaCubit.state.fileId!,
      );
    }
  }

  Widget _landscapeLayout(GalleryAppendState state) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.id == null ? "تصویر جدید" : "ویرایش تصویر",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: MediaSelectorWidget(height: widget.width / 6)),
                const SizedBox(width: 8),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SynopsisSectionWidget(
                              maxLines: 3,
                              hintText: "ترانه علی دوستی در نقش شهرزاد",
                              label: "توضیجات",
                              controller: descriptionInputController,
                            ),
                          ),
                        ]),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            _actionBar()
          ],
        ),
      );

  Widget _portraitLayout(GalleryAppendState state) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.id == null ? "تصویر جدید" : "ویرایش تصویر",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            MediaSelectorWidget(height: widget.width / 3),
            const SizedBox(height: 8),
            SynopsisSectionWidget(
              maxLines: 3,
              hintText: "ترانه علی دوستی در نقش شهرزاد",
              label: "توضیجات",
              controller: descriptionInputController,
            ),
            const SizedBox(height: 24),
            _actionBar()
          ],
        ),
      );
}
