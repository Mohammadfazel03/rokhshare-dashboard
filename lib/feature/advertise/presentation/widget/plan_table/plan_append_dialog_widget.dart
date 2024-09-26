import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/title_section_widget/bloc/title_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/title_section_widget/title_section_widget.dart';
import 'package:dashboard/feature/season/presentation/widget/integer_field_widget/bloc/integer_field_cubit.dart';
import 'package:dashboard/feature/season/presentation/widget/integer_field_widget/integer_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toastification/toastification.dart';

import 'bloc/plan_append_cubit.dart';
import 'bloc/plan_table_cubit.dart';

class PlanAppendDialogWidget extends StatefulWidget {
  final double width;
  final int? id;

  const PlanAppendDialogWidget({super.key, required this.width, this.id});

  @override
  State<PlanAppendDialogWidget> createState() => _PlanAppendDialogWidgetState();
}

class _PlanAppendDialogWidgetState extends State<PlanAppendDialogWidget> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController priceController;
  late final TextEditingController daysController;
  late final IntegerFieldCubit priceFieldCubit;
  late final IntegerFieldCubit daysFieldCubit;
  late final TitleSectionCubit titleFieldCubit;
  late final TitleSectionCubit descriptionFieldCubit;

  @override
  void initState() {
    if (widget.id != null) {
      BlocProvider.of<PlanAppendCubit>(context).getPlan(id: widget.id!);
    }
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    priceController = TextEditingController();
    daysController = TextEditingController();
    priceFieldCubit = IntegerFieldCubit();
    daysFieldCubit = IntegerFieldCubit();
    titleFieldCubit = TitleSectionCubit();
    descriptionFieldCubit = TitleSectionCubit();
    super.initState();
  }

  @override
  void dispose() {
    priceFieldCubit.close();
    daysFieldCubit.close();
    titleFieldCubit.close();
    descriptionFieldCubit.close();
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlanAppendCubit, PlanAppendState>(
      listener: (context, state) {
        if (state is PlanAppendSuccessAppend) {
          BlocProvider.of<PlanTableCubit>(context).getData();
          Navigator.of(context).pop();
        } else if (state is PlanAppendFailed) {
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
        } else if (state is PlanAppendSuccess) {
          titleController.text = state.plan.title ?? "";
          descriptionController.text = state.plan.description ?? "";
          daysController.text = state.plan.days?.toString() ?? "";
          priceController.text = state.plan.price?.toString() ?? "";
        }
      },
      builder: (context, state) {
        List<Widget> children = [];

        if (widget.width > 400) {
          children.add(_landscapeLayout(state));
        } else {
          children.add(_portraitLayout(state));
        }

        if (state is PlanAppendLoading) {
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
                var isValid = true;
                if (titleController.text.isEmpty) {
                  isValid = false;
                  titleFieldCubit.setError("عنوان طرح اجباری است.");
                } else {
                  titleFieldCubit.clearError();
                }
                if (descriptionController.text.isEmpty) {
                  isValid = false;
                  descriptionFieldCubit.setError("توضیجات طرح اجباری است.");
                } else {
                  descriptionFieldCubit.clearError();
                }
                if (priceController.text.isEmpty) {
                  isValid = false;
                  priceFieldCubit.setError("قیمت طرح اجباری است.");
                } else {
                  priceFieldCubit.clearError();
                }
                if (daysController.text.isEmpty) {
                  isValid = false;
                  daysFieldCubit.setError("مدت زمان طرح اجباری است.");
                } else {
                  daysFieldCubit.clearError();
                }

                if (isValid) {
                  BlocProvider.of<PlanAppendCubit>(context).savePlan(
                      title: titleController.text,
                      description: descriptionController.text,
                      days: int.parse(daysController.text),
                      price: int.parse(priceController.text));
                }
              },
              child: const Text(
                "ثبت",
              )),
        ],
      );

  Widget _landscapeLayout(PlanAppendState state) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "طرح جدید",
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
                        Text("عنوان طرح",
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        BlocProvider.value(
                          value: titleFieldCubit,
                          child: TitleSectionWidget(
                              controller: titleController,
                              hintText: "طرح ظلایی",
                              readOnly: widget.id != null,
                              label: null),
                        ),
                        const SizedBox(height: 8),
                        Text("مدت زمان طرح (روز)",
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        BlocProvider.value(
                          value: daysFieldCubit,
                          child: IntegerFieldWidget(
                            controller: daysController,
                            label: null,
                            readOnly: widget.id != null,
                            hint: "30",
                          ),
                        ),
                      ]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("توضیحات طرح",
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      BlocProvider.value(
                        value: descriptionFieldCubit,
                        child: TitleSectionWidget(
                          controller: descriptionController,
                          readOnly: widget.id != null,
                          hintText: "توضیجات",
                          label: null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("قیمت (تومان)",
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      BlocProvider.value(
                        value: priceFieldCubit,
                        child: IntegerFieldWidget(
                          controller: priceController,
                          label: null,
                          readOnly: widget.id != null,
                          hint: "124000",
                          max: 1000000,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            if (widget.id == null) ...[const SizedBox(height: 24), _actionBar()]
          ],
        ),
      );

  Widget _portraitLayout(PlanAppendState state) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "طرح جدید",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            BlocProvider.value(
              value: titleFieldCubit,
              child: TitleSectionWidget(
                  controller: titleController,
                  readOnly: widget.id != null,
                  hintText: "طرح ظلایی",
                  label: "عنوان طرح"),
            ),
            const SizedBox(height: 8),
            BlocProvider.value(
              value: descriptionFieldCubit,
              child: TitleSectionWidget(
                controller: descriptionController,
                readOnly: widget.id != null,
                hintText: "توضیجات",
                label: "توضیحات طرح",
              ),
            ),
            const SizedBox(height: 8),
            BlocProvider.value(
              value: daysFieldCubit,
              child: IntegerFieldWidget(
                controller: daysController,
                readOnly: widget.id != null,
                label: "مدت زمان طرح (روز)",
                hint: "30",
              ),
            ),
            const SizedBox(height: 8),
            BlocProvider.value(
              value: priceFieldCubit,
              child: IntegerFieldWidget(
                controller: priceController,
                readOnly: widget.id != null,
                label: "قیمت (تومان)",
                hint: "124000",
                max: 1000000,
              ),
            ),
            if (widget.id == null) ...[const SizedBox(height: 24), _actionBar()]
          ],
        ),
      );
}
