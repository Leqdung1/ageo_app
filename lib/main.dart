import 'package:Ageo_solutions/components/theme_provider.dart';
import 'package:Ageo_solutions/screens/device.dart';
import 'package:Ageo_solutions/screens/device_screen/rain_gauge.dart';
import 'package:Ageo_solutions/screens/home.dart';
import 'package:Ageo_solutions/screens/home.dart';
import 'package:Ageo_solutions/screens/testcam.dart';
import 'package:flutter/material.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // theme mode 
      theme: Provider.of<ThemeProvider>(context).themeData,

      // language mode 
      localizationsDelegates: const  [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi', ''), // Vietnamese
        Locale('en', ''), // English
      ],
      locale: const Locale('vi', ''),
      home: const HomeScreen(),
    );
  }
}
