import 'dart:ui';

import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/login/presentation/bloc/login_cubit.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:toastification/toastification.dart';

import '../widget/password_input_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Column(
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
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text("ورود",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge),
                                          const SizedBox(height: 24),
                                          Text("نام\u200cکاربری یا ایمیل",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall),
                                          const SizedBox(height: 8),
                                          BlocBuilder<LoginCubit, LoginState>(
                                            builder: (context, state) {
                                              return TextField(
                                                  readOnly: state is LoggingIn,
                                                  enabled: state is! LoggingIn,
                                                  controller:
                                                      usernameController,
                                                  decoration: const InputDecoration(
                                                      hintText:
                                                          "test@email.com"));
                                            },
                                          ),
                                          const SizedBox(height: 24),
                                          Text("رمز عبور",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall),
                                          const SizedBox(height: 8),
                                          BlocBuilder<LoginCubit, LoginState>(
                                              builder: (context, state) {
                                            return PasswordInputWidget(
                                              enable: state is! LoggingIn,
                                              readOnly: state is LoggingIn,
                                              controller: passwordController,
                                            );
                                          }),
                                          const SizedBox(height: 32),
                                          loginButton()
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
          BlocConsumer<LoginCubit, LoginState>(
            builder: (context, state) {
              // print(state);
              if (state is LoggingIn) {
                return Center(
                    child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                  child: SpinKitCubeGrid(
                    color: CustomColor.loginBackgroundColor.getColor(context),
                    size: 50.0,
                  ),
                ));
              }
              return const SizedBox();
            },
            listener: (BuildContext context, LoginState state) async {
              if (state is LoginSuccessfully) {
                if (await getIt
                    .get<LocalStorageService>()
                    .login(state.accessToken, state.refreshToken)) {
                  context.go(RoutePath.dashboard.fullPath);
                }
              } else if (state is LoginFailed) {
                toastification.showCustom(
                    animationDuration: const Duration(milliseconds: 300),
                    context: context,
                    alignment: Alignment.bottomRight,
                    autoCloseDuration: const Duration(seconds: 4),
                    direction: TextDirection.rtl,
                    builder: (BuildContext context, ToastificationItem holder) {
                      return ErrorSnackBarWidget(
                        item: holder,
                        title: "خطا",
                        message: state.error,
                      );
                    });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget loginButton() {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return FilledButton(
          style: ButtonStyle(
              textStyle: WidgetStateProperty.resolveWith((state) {
                if (state.contains(WidgetState.disabled)) {
                  return Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.38));
                }
                return Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimary);
              }),
              padding: WidgetStateProperty.all(const EdgeInsets.all(16)),
              alignment: Alignment.center,
              backgroundColor: WidgetStateProperty.resolveWith((state) {
                if (state.contains(WidgetState.disabled)) {
                  return Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.12);
                }
                return Theme.of(context).colorScheme.primary;
              })),
          onPressed: state is LoggingIn
              ? null
              : () {
                  BlocProvider.of<LoginCubit>(context)
                      .login(usernameController.text, passwordController.text);
                  // context.pushReplacement(RoutePath.dashboard.path);
                },
          child: const Text("ورود"));
    });
  }
}
