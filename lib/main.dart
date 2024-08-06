import 'package:Ageo_solutions/components/localization.dart';
import 'package:Ageo_solutions/core/theme_provider.dart';
import 'package:Ageo_solutions/screens/home.dart';
import 'package:Ageo_solutions/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
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

      home: HomeScreen(),
    );
  }

  void configLocal() {
    localization.init(mapLocales: Local, initLanguageCode: 'vi');
    localization.onTranslatedLanguage = onTranslateLang;
  }

  void onTranslateLang(Locale? locale) {
    setState(() {});
  }
}
