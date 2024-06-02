import 'package:dashboard/config/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

import '../widget/password_input_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (width / 3 * 2 >= 400) ...[
                        DecoratedBox(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor),
                          child: SizedBox(
                            height: width / 3 < height ? height : width / 3,
                            child: Lottie.asset("assets/lottie/login.json",
                                width: width / 3,
                                height: width / 3,
                                repeat: true),
                          ),
                        )
                      ],
                      Expanded(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: height),
                          child: Center(
                            child: Card(
                              elevation: 3,
                              shadowColor: Theme.of(context).shadowColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 32, horizontal: 32),
                                child: SizedBox(
                                  width: width / 3 > 400
                                      ? 400
                                      : width / 3 < 300
                                          ? 300
                                          : width / 3,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text("ورود",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium),
                                      SizedBox(height: 24),
                                      Text("نام\u200cکاربری یا ایمیل",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium),
                                      SizedBox(height: 8),
                                      const TextField(
                                          decoration: InputDecoration(
                                              hintText: "test@email.com")),
                                      SizedBox(height: 24),
                                      Text("رمز عبور",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium),
                                      SizedBox(height: 8),
                                      const PasswordInputWidget(),
                                      SizedBox(height: 32),
                                      FilledButton(
                                          style: ButtonStyle(
                                            padding: WidgetStateProperty.all(EdgeInsets.all(16)),
                                              alignment: Alignment.center,
                                              backgroundColor:
                                                  WidgetStateProperty.all(
                                                      CustomColor
                                                          .loginBackgroundColor
                                                          .getColor(context))),
                                          onPressed: () {
                                            // context.go(RoutePath.dashboard.path);
                                          },
                                          child: Text(
                                            "ورود",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
            )
          ]),
    );
  }
}
