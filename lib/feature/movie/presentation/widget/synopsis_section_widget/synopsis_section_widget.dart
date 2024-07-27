import 'package:dashboard/feature/movie/presentation/widget/synopsis_section_widget/bloc/synopsis_section_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SynopsisSectionWidget extends StatelessWidget {
  final TextEditingController _controller;

  SynopsisSectionWidget({super.key, TextEditingController? controller})
      : _controller = controller ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SynopsisSectionCubit, SynopsisSectionState>(
      builder: (context, state) {
        return TextField(
          controller: _controller,
          maxLines: 5,
          decoration: InputDecoration(
              hintText: "خلاصه داستان...",
              label: const Text("خلاصه داستان"),
              errorText: state.error),
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
