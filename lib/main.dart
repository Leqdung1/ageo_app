import 'package:Ageo_solutions/screens/device.dart';
import 'package:Ageo_solutions/screens/device_screen/rain_gauge.dart';
import 'package:Ageo_solutions/screens/home.dart';
import 'package:Ageo_solutions/screens/hometest.dart';
import 'package:Ageo_solutions/screens/testcam.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('vi', ''), // Vietnamese
        Locale('en', ''), // English
      ],
      locale: Locale('vi', ''),
      home: HomeTest(),
    );
  }
}
