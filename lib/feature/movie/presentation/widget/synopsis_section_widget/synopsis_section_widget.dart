import 'package:dashboard/feature/movie/presentation/widget/synopsis_section_widget/bloc/synopsis_section_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SynopsisSectionWidget extends StatelessWidget {
  final TextEditingController _controller;
  final bool readOnly;
  final String? hintText;
  final String label;
  final int maxLines;

  SynopsisSectionWidget({super.key,
    TextEditingController? controller,
    this.readOnly = false,
    this.hintText = "خلاصه داستان...",
    this.label = "خلاصه داستان",
    this.maxLines = 5})
      : _controller = controller ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SynopsisSectionCubit, SynopsisSectionState>(
      builder: (context, state) {
        return TextField(
          readOnly: readOnly,
          controller: _controller,
          maxLines: maxLines,
          decoration: InputDecoration(
              hintText: hintText, label: Text(label), errorText: state.error),
          onChanged: (value) {
            if (value.isNotEmpty) {
              BlocProvider.of<SynopsisSectionCubit>(context).clearError();
            }
          },
        );
      },
    );
  }
}
