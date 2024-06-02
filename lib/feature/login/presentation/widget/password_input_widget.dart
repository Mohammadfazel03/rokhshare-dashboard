import 'package:flutter/material.dart';

class PasswordInputWidget extends StatefulWidget {
  const PasswordInputWidget({super.key});

  @override
  State<PasswordInputWidget> createState() => _PasswordInputWidgetState();
}

class _PasswordInputWidgetState extends State<PasswordInputWidget> {
  late bool obscureText;

  @override
  void initState() {
    obscureText = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
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
