import 'package:dashboard/feature/movie/presentation/widget/title_section_widget/bloc/title_section_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TitleSectionWidget extends StatelessWidget {
  final TextEditingController _controller;
  final bool readOnly;
  final String? hintText;
  final String? label;

  TitleSectionWidget({super.key,
    TextEditingController? controller,
    this.readOnly = false,
    required this.hintText,
    required this.label})
      : _controller = controller ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TitleSectionCubit, TitleSectionState>(
      builder: (context, state) {
        return TextField(
          readOnly: readOnly,
          controller: _controller,
          decoration: InputDecoration(
            hintText: hintText,
            label: label != null ? Text(label!) : null,
            errorText: state.error,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              BlocProvider.of<TitleSectionCubit>(context).clearError();
            }
          },
        );
      },
    );
  }
}
