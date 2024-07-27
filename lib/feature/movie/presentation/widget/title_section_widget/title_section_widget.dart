import 'package:dashboard/feature/movie/presentation/widget/title_section_widget/bloc/title_section_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TitleSectionWidget extends StatelessWidget {
  final TextEditingController _controller;

  TitleSectionWidget({super.key, TextEditingController? controller})
      : _controller = controller ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TitleSectionCubit, TitleSectionState>(
      builder: (context, state) {
        return TextField(
          controller: _controller,
          decoration: InputDecoration(
              hintText: "جدایی نادر از سیمین",
              label: const Text("عنوان فیلم"),
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
