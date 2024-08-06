import 'dart:async';
import 'package:Ageo_solutions/components/localization.dart';
import 'package:Ageo_solutions/components/theme.dart';
import 'package:Ageo_solutions/core/theme_provider.dart';
import 'package:Ageo_solutions/core/api_client.dart';
import 'package:Ageo_solutions/screens/login.dart';
import 'package:Ageo_solutions/screens/multiple_language/multi_language.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final Function(String) onSystemSelected;
  const SettingsScreen({super.key, required this.onSystemSelected});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic>? response;
  bool isLoading = true;
  String selectedIndex = "";

  @override
  void initState() {
    super.initState();
    _loadSelectedIndex();
  }

  Future<void> fetchUserData() async {
    if (response == null || response!['userId'] == null) {
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print("User ID is null");
      }
      return;
    }

    final apiClient = ApiClient();
    final userId = response!['userId'].toString();
    final res = await apiClient.getUserData(userId);

    setState(() {
      response = res['data'];
      isLoading = false;
    });

    if (!res['success']) {
      if (kDebugMode) {
        print("Failed to fetch user data: ${res['message']}");
      }
    }
  }

  Widget _getAvatarWidget() {
    if (response?["imageURL"] != null && response?["imageURL"].isNotEmpty) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              response?["imageURL"],
            ),
          ),
        ),
      );
    } else {
      return const Icon(Icons.account_circle, size: 40);
    }
  }

  // keep icon success always appear
  Future<void> _loadSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedIndex = prefs.getString('selectedIndex') ?? '';
    });
  }

  Future<void> _saveSelectedIndex(String index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedIndex', index);
  }

  void _selectIndex(String index) {
    setState(() {
      selectedIndex = index;
      _saveSelectedIndex(index);
      widget.onSystemSelected(
        index == '0' ? 'dalat' : 'hy',
      );
    });
    Navigator.pop(context);
  }

// modal bottom sheet
  void _openModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.48,
          child: Wrap(
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    height: 4,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  AppBar(
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Theme.of(context).iconTheme.color,
                          size: 20,
                        ),
                      ),
                    ),
                    title: Text(
                      LocalData.changeSystem.getString(context),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    centerTitle: true,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ],
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0),
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            title: Text(
                              LocalData.title1.getString(context),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                            trailing: selectedIndex == "0"
                                ? SvgPicture.asset("assets/icons/success.svg")
                                : null,
                            onTap: () {
                              setState(
                                () {
                                  _selectIndex("0");
                                },
                              );
                            }),
                        Divider(
                          height: 0,
                          indent: 15,
                          endIndent: 15,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          title: Text(
                            LocalData.title2.getString(context),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          trailing: selectedIndex == "1"
                              ? SvgPicture.asset("assets/icons/success.svg")
                              : null,
                          onTap: () {
                            setState(() {
                              _selectIndex("1");
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).themeData == darkMode;
    var size = MediaQuery.of(context).size;

    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4e86af),
            Color(0xFFbcd1e1),
            Colors.white,
            Colors.white,
          ],
          stops: [
            0.01 / 100,
            72.27 / 100,
            100.79 / 100,
            100.79 / 100,
          ],
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
          constraints: const BoxConstraints.expand(),
          width: size.width * 0.9,
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppBar(
                  title: Text(
                    LocalData.setting.getString(context),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.transparent,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _getAvatarWidget(),
                            SizedBox(width: size.width * 0.02),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(LocalData.hello.getString(context)),
                                isLoading
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        response?["staffName"] ?? "N/A",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.color,
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 5,
                  ),
                  child: Text(
                    LocalData.accountSetting.getString(context),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ],
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        title: Text(
                          LocalData.infomation.getString(context),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        leading: Icon(
                          Icons.person_outline_outlined,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.grey.withOpacity(0.5),
                          size: 18,
                        ),
                        onTap: () {
                          // TODO: add screen user information
                        },
                      ),
                      Divider(
                        height: 0,
                        indent: 15,
                        endIndent: 15,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        title: Text(
                          LocalData.changeLanguage.getString(context),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        leading: Icon(
                          Icons.language_outlined,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const ChooseLanguage(),
                            ),
                          );
                        },
                      ),
                      Divider(
                        height: 0,
                        indent: 15,
                        endIndent: 15,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        title: Text(
                          LocalData.darkMode.getString(context),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        leading: Icon(
                          Icons.dark_mode_outlined,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        trailing: Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            activeTrackColor:
                                const Color.fromARGB(255, 246, 193, 49),
                            activeColor: const Color.fromRGBO(21, 101, 192, 1),
                            value: isDarkMode,
                            onChanged: (value) {
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .toggleTheme();
                            },
                          ),
                        ),
                      ),
                      Divider(
                        height: 0,
                        indent: 15,
                        endIndent: 15,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        title: Text(
                          LocalData.changeSystem.getString(context),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        leading: Icon(
                          Icons.change_circle,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.grey.withOpacity(0.5),
                          size: 18,
                        ),
                        onTap: () {
                          _openModalBottomSheet(context);
                        },
                      ),
                      Divider(
                        height: 0,
                        indent: 15,
                        endIndent: 15,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        title: Text(
                          LocalData.changePassWord.getString(context),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        leading: Icon(
                          Icons.lock_outline,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.grey.withOpacity(0.5),
                          size: 18,
                        ),
                        onTap: () {
                          // TODO: add screen change password
                        },
                      ),
                      Divider(
                        height: 0,
                        indent: 15,
                        endIndent: 15,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        title: Text(
                          LocalData.logOut.getString(context),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        leading: Icon(
                          Icons.logout_outlined,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onTap: () {
                          // Implement logout functionality
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const LoginScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
