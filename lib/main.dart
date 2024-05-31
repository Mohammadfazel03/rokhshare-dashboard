import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      darkTheme: Themes.dark,
      theme: Themes.light,
      themeMode: ThemeMode.dark,
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
  }
}
