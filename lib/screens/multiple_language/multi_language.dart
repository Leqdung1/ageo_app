import 'package:Ageo_solutions/lang/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseLanguage extends StatefulWidget {
  const ChooseLanguage({super.key});

  @override
  State<ChooseLanguage> createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  late FlutterLocalization _flutterLocalization;
  String selectedLanguage = "";

  @override
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _loadSelectedLanguage();
  }

  // keep icon success always appear
  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('selectedLanguage') ?? '';
    });
  }

  Future<void> _saveSelectedLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
  }

  void _selectLanguage(String language) {
    setState(() {
      _flutterLocalization.translate(language);
      selectedLanguage = language;
      _saveSelectedLanguage(language);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).iconTheme.color,
            size: 18,
          ),
        ),
        title: Text(
          LocalData.changeLanguage.getString(context),
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () => _selectLanguage("vi"),
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: selectedLanguage == "vi"
                    ? Border.all(
                        color: const Color.fromRGBO(237, 146, 39, 1),
                      )
                    : Border.all(color: const Color.fromRGBO(225, 225, 225, 1)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: SvgPicture.asset(
                      'assets/icons/Vietnam.svg',
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                      ),
                      child: Text(
                        LocalData.language1.getString(context),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ),
                  if (selectedLanguage == 'vi')
                    const Icon(
                      LucideIcons.check,
                      color: Color.fromRGBO(237, 146, 39, 1),
                    ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () => _selectLanguage("en"),
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: selectedLanguage == "en"
                    ? Border.all(
                        color: const Color.fromRGBO(237, 146, 39, 1),
                      )
                    : Border.all(color: const Color.fromRGBO(225, 225, 225, 1)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/Us.svg',
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                      ),
                      child: Text(
                        LocalData.language2.getString(context),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ),
                  if (selectedLanguage == 'en')
                    const Icon(
                      LucideIcons.check,
                      color: Color.fromRGBO(237, 146, 39, 1),
                    ),
                  const SizedBox(
                    width: 20,
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
