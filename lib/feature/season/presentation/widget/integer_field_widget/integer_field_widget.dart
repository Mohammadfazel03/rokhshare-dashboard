import 'package:dashboard/feature/season/presentation/widget/integer_field_widget/bloc/integer_field_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntegerFieldWidget extends StatelessWidget {
  final TextEditingController _controller;
  final bool readOnly;
  final String label;
  final String hint;

  IntegerFieldWidget(
      {super.key,
      TextEditingController? controller,
      this.readOnly = false,
      required this.label,
      required this.hint})
      : _controller = controller ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntegerFieldCubit, IntegerFieldState>(
      builder: (context, state) {
        return TextField(
          readOnly: readOnly,
          controller: _controller,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            _NumberTextInputFormatter(1, 100000)
          ],
          decoration: InputDecoration(
              hintText: hint, label: Text(label), errorText: state.error),
          onChanged: (value) {
            if (value.isNotEmpty) {
              BlocProvider.of<IntegerFieldCubit>(context).clearError();
            }
          },
        );
      },
    );
  }
}

class _NumberTextInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  _NumberTextInputFormatter(this.min, this.max);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (const ['-', ''].contains(newValue.text)) return newValue;
    final intValue = int.tryParse(newValue.text);
    if (intValue == null) return oldValue;
    if (intValue < min) return newValue.copyWith(text: min.toString());
    if (intValue > max) return newValue.copyWith(text: max.toString());
    return newValue.copyWith(text: intValue.toString());
  }
}
