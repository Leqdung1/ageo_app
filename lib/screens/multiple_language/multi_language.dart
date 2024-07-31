import 'package:Ageo_solutions/components/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class ChooseLanguage extends StatefulWidget {
  const ChooseLanguage({super.key});

  @override
  State<ChooseLanguage> createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  late FlutterLocalization _flutterLocalization;

  @override
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(LocalData.changeLanguage.getString(context)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              _flutterLocalization.translate("vi");
            },
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 15,
              ),
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.flag_circle),
                  Text(
                    LocalData.language1.getString(context),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _flutterLocalization.translate("en");
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 15,
              ),
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.flag_circle),
                  Text(
                    LocalData.language2.getString(context),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
