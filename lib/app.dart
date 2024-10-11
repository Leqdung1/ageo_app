import 'package:Ageo_solutions/core/helpers.dart';
import 'package:Ageo_solutions/core/theme_provider.dart';
import 'package:Ageo_solutions/lang/localization.dart';
import 'package:Ageo_solutions/screens/home.dart';
import 'package:Ageo_solutions/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';

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
        localizationsDelegates: localization.localizationsDelegates,
        supportedLocales: localization.supportedLocales,
        locale: const Locale('vi', ''),
        home: FutureBuilder(
          future: secureStorage.readSecureData("logged_in"),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.hasData) {
              return const HomeScreen();
            }
            return const LoginScreen();
          },
        ));
  }

  void configLocal() {
    localization.init(mapLocales: Local, initLanguageCode: 'vi');
    localization.onTranslatedLanguage = onTranslateLang;
  }

  void onTranslateLang(Locale? locale) {
    setState(() {});
  }
}