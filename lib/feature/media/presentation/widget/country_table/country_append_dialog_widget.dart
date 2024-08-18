import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/media/presentation/widget/country_table/bloc/countries_table_cubit.dart';
import 'package:dashboard/feature/media/presentation/widget/country_table/bloc/country_append_cubit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toastification/toastification.dart';

class CountryAppendDialogWidget extends StatefulWidget {
  final double width;
  final int? id;

  const CountryAppendDialogWidget({super.key, required this.width, this.id});

  @override
  State<CountryAppendDialogWidget> createState() =>
      _CountryAppendDialogWidgetState();
}

class _CountryAppendDialogWidgetState extends State<CountryAppendDialogWidget> {
  Uint8List? file;
  late final TextEditingController countryInputController;

  @override
  void initState() {
    if (widget.id != null) {
      BlocProvider.of<CountryAppendCubit>(context).getCountry(id: widget.id!);
    }
    countryInputController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    countryInputController.dispose();
    file = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CountryAppendCubit, CountryAppendState>(
      listener: (context, state) {
        if (state is CountryAppendSuccessAppend) {
          BlocProvider.of<CountriesTableCubit>(context).getData();
          Navigator.of(context).pop();
        } else if (state is CountryAppendSuccessUpdate) {
          BlocProvider.of<CountriesTableCubit>(context).getData(
              page: BlocProvider.of<CountriesTableCubit>(context)
                  .state
                  .pageIndex);
          Navigator.of(context).pop();
        } else if (state is CountryAppendFailed) {
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
        } else if (state is CountryAppendSuccess) {
          countryInputController.text = state.country.name ?? "";
        }
      },
      builder: (context, state) {
        List<Widget> children = [];

        if (widget.width > 400) {
          children.add(_landscapeLayout(state));
        } else {
          children.add(_portraitLayout(state));
        }

        if (state is CountryAppendLoading) {
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
                  BlocProvider.of<CountryAppendCubit>(context).updateCountry(
                      id: widget.id!,
                      name: countryInputController.text,
                      flag: file);
                } else {
                  if (countryInputController.text.isEmpty || file == null) {
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
                    BlocProvider.of<CountryAppendCubit>(context).saveCountry(
                        name: countryInputController.text, flag: file);
                  }
                }
              },
              child: const Text(
                "ثبت",
              )),
        ],
      );

  Widget _landscapeLayout(CountryAppendState state) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.id == null ? "کشور جدید" : "ویرایش کشور",
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
                        child: (state is CountryAppendSuccess && file == null)
                            ? Image.network(state.country.flag!)
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
                                          "پرچم کشور خود را بارگذاری کنید",
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
                      Text("نام کشور",
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      TextField(
                        controller: countryInputController,
                        decoration: const InputDecoration(hintText: "ایران"),
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

  Widget _portraitLayout(CountryAppendState state) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.id == null ? "کشور جدید" : "ویرایش کشور",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles(type: FileType.image);

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
                  child: (state is CountryAppendSuccess && file == null)
                      ? Image.network(state.country.flag!)
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
                                    "پرچم کشور خود را بارگذاری کنید",
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
              controller: countryInputController,
              decoration: const InputDecoration(
                  hintText: "ایران", label: Text("نام کشور")),
            ),
            const SizedBox(height: 24),
            _actionBar()
          ],
        ),
      );
}
