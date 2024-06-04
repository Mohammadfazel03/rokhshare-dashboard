import 'package:flutter/material.dart';

class PasswordInputWidget extends StatefulWidget {

  final TextEditingController controller;
  final bool readOnly;
  final bool enable;

  const PasswordInputWidget({super.key, required this.controller, required this.readOnly, required this.enable});

  @override
  State<PasswordInputWidget> createState() => _PasswordInputWidgetState();
}

class _PasswordInputWidgetState extends State<PasswordInputWidget> {
  late bool obscureText;

  @override
  void initState() {
    obscureText = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.enable,
      readOnly: widget.readOnly,
      controller: widget.controller,
      decoration: InputDecoration(
          hintText: "••••••••",
          suffixIcon: IconButton(
            onPressed: () {
              obscureText = !obscureText;
              setState(() {});
            },
            icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          )),
      obscureText: obscureText,
      obscuringCharacter: '•',
      autocorrect: false,
      enableSuggestions: false,
    );
  }
}
