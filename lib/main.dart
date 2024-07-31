import 'package:Ageo_solutions/components/localization.dart';
import 'package:Ageo_solutions/components/theme_provider.dart';
import 'package:Ageo_solutions/screens/device.dart';
import 'package:Ageo_solutions/screens/device_screen/rain_gauge.dart';
import 'package:Ageo_solutions/screens/home.dart';
import 'package:Ageo_solutions/screens/home.dart';
import 'package:Ageo_solutions/screens/multiple_language/multi_language.dart';
import 'package:Ageo_solutions/screens/testcam.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    super.initState();
    configLocal();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // theme mode
      theme: Provider.of<ThemeProvider>(context).themeData,

      // language mode
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,

      // ],

      // supportedLocales: const [
      //   Locale('vi', ''), // Vietnamese
      //   Locale('en', ''), // English
      // ],
      localizationsDelegates: localization.localizationsDelegates,
      supportedLocales: localization.supportedLocales,
      locale: const Locale('vi', ''),

      home: const ChooseLanguage(),
    );
  }

  void configLocal() {
    localization.init(mapLocales: Local, initLanguageCode: 'de');
    localization.onTranslatedLanguage = onTranslateLang;
  }

  void onTranslateLang(Locale? locale) {
    setState(() {});
  }
}
