import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/config/theme/theme_cubit.dart';
import 'package:dashboard/config/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Flutter Demo',
            darkTheme: Themes.dark,
            theme: Themes.light,
            themeMode: state,
            locale: const Locale("fa", "IR"),
            localizationsDelegates: const [
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              Locale("fa", "IR")
            ],
            routerConfig: routerConfig,
          );
        },
      ),
    );
  }
}
