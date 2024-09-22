import 'dart:async';
import 'package:Ageo_solutions/components/localization.dart';
import 'package:Ageo_solutions/components/theme.dart';
import 'package:Ageo_solutions/core/helpers.dart';
import 'package:Ageo_solutions/core/theme_provider.dart';
import 'package:Ageo_solutions/core/api_client.dart';
import 'package:Ageo_solutions/models/user_data.dart';
import 'package:Ageo_solutions/screens/account.dart';
import 'package:Ageo_solutions/screens/changePassword.dart';
import 'package:Ageo_solutions/screens/login.dart';
import 'package:Ageo_solutions/screens/multiple_language/multi_language.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
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
  final apiClient = ApiClient();
  int? userId;
  Future<List<UserData>>? _userDataBuilder;
  late List<UserData> _userData = [];
  final SecureStorage _ss = SecureStorage();

  @override
  void initState() {
    super.initState();
    _loadSelectedIndex();
    _userDataBuilder = fetchUserData();
    _initializeUserIdAndFetchData();
  }

  Future<int?> _getUserIdFromToken() async {
    final token = await _ss
        .readSecureData("access_token"); // Read the token from secure storage
    if (token != null && JwtDecoder.isExpired(token)) {
      print("Token is expired");
      return null;
    }
    if (token != null) {
      final decodedToken = JwtDecoder.decode(token);
      final userIdString = decodedToken['userid'];
      return int.tryParse(userIdString);
    }
    return null;
  }

  Future<void> _initializeUserIdAndFetchData() async {
    userId = await _getUserIdFromToken();
    if (userId != null) {
      _userDataBuilder = fetchUserData();
      setState(() {});
    } else {
      print('Error: userId is still null after loading');
    }
  }

  Future<List<UserData>> fetchUserData() async {
    if (userId == null) {
      print('Error: userId is null');
      return [];
    }

    try {
      final response = await apiClient.getUser(userId!);
      print(response);

      if (response['success']) {
        UserData data = UserData.fromJson(response['data']);

        print('UserData: $data');
        print('Updated UserId: $userId');

        setState(() {
          _userData = [data];
        });
        return _userData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load UserData');
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
    Navigator.of(context, rootNavigator: true).pop();
  }

  // modal bottom sheet
  void _openModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      useRootNavigator: true,
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
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  AppBar(
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Color.fromRGBO(237, 146, 39, 1),
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
                                ? const Icon(
                                    LucideIcons.check,
                                    color: Color.fromRGBO(237, 146, 39, 1),
                                  )
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
                              ? const Icon(
                                  LucideIcons.check,
                                  color: Color.fromRGBO(237, 146, 39, 1),
                                )
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

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          LocalData.bottomLabel6.getString(context),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
            constraints: const BoxConstraints.expand(),
            width: size.width * 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: FutureBuilder<List<UserData>>(
                        future: _userDataBuilder,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data!.isNotEmpty) {
                            _userData = snapshot.data!;

                            var userData = _userData[0];

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: userData.imageUrl as String,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey,
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          LocalData.hello.getString(context),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFA7ABC3),
                                          ),
                                        ),
                                        Text(
                                          userData.name ?? "N/A",
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
                            );
                          } else {
                            return const Center(
                                child: Text('No data available'));
                          }
                        },
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
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          leading: const Icon(
                            LucideIcons.user,
                            color: Color.fromRGBO(237, 146, 39, 1),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Theme.of(context).iconTheme.color,
                            size: 15,
                          ),
                          onTap: () {
                            pushWithoutNavBar(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AccountScreen(),
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
                            LocalData.changeLanguage.getString(context),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          leading: const Icon(
                            Icons.language_outlined,
                            color: Color.fromRGBO(237, 146, 39, 1),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 15,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onTap: () {
                            pushWithoutNavBar(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChooseLanguage(),
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
                        GestureDetector(
                          onTap: () {
                            Provider.of<ThemeProvider>(context, listen: false)
                                .toggleTheme();
                          },
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            title: Text(
                              LocalData.darkMode.getString(context),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                            leading: const Icon(
                              Icons.dark_mode_outlined,
                              color: Color.fromRGBO(237, 146, 39, 1),
                            ),
                            trailing: Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                trackOutlineColor: const WidgetStatePropertyAll(
                                  Colors.transparent,
                                ),
                                inactiveTrackColor: Colors.grey.shade400,
                                activeTrackColor:
                                    const Color.fromRGBO(237, 146, 39, 1),
                                inactiveThumbColor: Colors.white,
                                activeColor: Colors.white,
                                value: isDarkMode,
                                onChanged: (value) {
                                  Provider.of<ThemeProvider>(context,
                                          listen: false)
                                      .toggleTheme();
                                },
                              ),
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
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          leading: const Icon(
                            Icons.switch_left_outlined,
                            color: Color.fromRGBO(237, 146, 39, 1),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Theme.of(context).iconTheme.color,
                            size: 15,
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
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          leading: const Icon(
                            LucideIcons.lock,
                            color: Color.fromRGBO(237, 146, 39, 1),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Theme.of(context).iconTheme.color,
                            size: 15,
                          ),
                          onTap: () {
                            pushWithoutNavBar(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangePWScreen(),
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
                            LocalData.logOut.getString(context),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.redAccent,
                            ),
                          ),
                          leading: const Icon(
                            Icons.logout_outlined,
                            color: Colors.redAccent,
                          ),
                          onTap: () {
                            pushWithoutNavBar(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
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
      ),
    );
  }
}
