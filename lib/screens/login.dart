import "package:Ageo_solutions/components/localization.dart";
import "package:Ageo_solutions/screens/forgot_password.dart";
import "package:Ageo_solutions/screens/home.dart";
import "package:Ageo_solutions/screens/home.dart";

import "package:flutter/material.dart";
import "package:flutter_localization/flutter_localization.dart";
import 'package:flutter_svg/flutter_svg.dart';

import "package:flutter_svg/svg.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../core/api_client.dart";
import "../core/helpers.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late FlutterLocalization _flutterLocalization;
  String selectedLanguage = "";
  var _username = "";
  var _password = "";
  var _lastUserName = "";
  var _lastUserPhoneNumber = "";

  final _formKey = GlobalKey<FormState>();
  final _apiClient = ApiClient();

  final usernameFocus = FocusNode();
  final passwordFocus = FocusNode();

  var _passwordVisible = false;

  void _readLastLoggedInData() async {
    final name =
        await SecureStorage().readSecureData("last_logged_in_user_name");
    final number = await SecureStorage()
        .readSecureData("last_logged_in_user_phone_number");
    final username =
        await SecureStorage().readSecureData("last_logged_in_username");

    if (name != null && number != null && username != null) {
      setState(() {
        _lastUserName = name;
        _lastUserPhoneNumber = number;
        _username = username;
      });
    }
  }

  bool _checkLastLoggedInData() {
    return _lastUserName.isNotEmpty && _lastUserPhoneNumber.isNotEmpty;
  }

  Future<void> _handleLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Dialog(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              child: Center(
                widthFactor: 0.5,
                heightFactor: 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          });

      dynamic res = await _apiClient.login(_username, _password);
      if (context.mounted) {
        if (res["error"] != null) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(res["error_description"]),
            backgroundColor: Colors.red,
          ));

          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        } else {
          await SecureStorage()
              .writeSecureData("access_token", res["access_token"]);
          await SecureStorage().writeSecureData("logged_in", "true");
          await SecureStorage()
              .writeSecureData("last_logged_in_username", _username);

          // ignore: use_build_context_synchronously
          Navigator.pop(context);

          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        }
      }
    }
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
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _readLastLoggedInData();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
              image: AssetImage("assets/images/background.png"),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/logo.png'),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: size.width * 0.9,
                      padding: EdgeInsets.fromLTRB(
                          24, _checkLastLoggedInData() ? 0 : 24, 24, 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 0,
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 0,
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          if (!_checkLastLoggedInData()) ...[
                            Column(
                              children: [
                                const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "AGEO SOLUTIONS",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    LocalData.typeNameandNumber
                                        .getString(context),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _selectLanguage("vi");
                                      },
                                      icon: SvgPicture.asset(
                                          'assets/icons/Vietnam.svg'),
                                    ),
                                    const SizedBox(
                                      width: 32,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _selectLanguage("en");
                                      },
                                      icon: SvgPicture.asset(
                                          'assets/icons/Us.svg'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              focusNode: usernameFocus,
                              textInputAction: TextInputAction.next,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LocalData.numberMustWrite
                                      .getString(context);
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                hintStyle: const TextStyle(
                                  color: Color(0xFFA7ABC3),
                                ),
                                hintText: LocalData.userName.getString(context),
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE4E5F0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(21, 101, 192, 1),
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE43434),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE43434),
                                  ),
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/user.svg",
                                        colorFilter: ColorFilter.mode(
                                          usernameFocus.hasFocus
                                              ? const Color(0xFF1B1D29)
                                              : const Color(0xFFA7ABC3),
                                          BlendMode.srcATop,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        height: 40,
                                        width: 0.5,
                                        color: const Color(0xFFA7ABC3),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _username = value;
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                          ],
                          TextFormField(
                            focusNode: passwordFocus,
                            textInputAction: TextInputAction.done,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText: !_passwordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return LocalData.passwordMustWrite
                                    .getString(context);
                              }

                              return null;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 0),
                              hintStyle: const TextStyle(
                                color: Color(0xFFA7ABC3),
                              ),
                              hintText: LocalData.logOut.getString(context),
                              isDense: true,
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/password_lock.svg",
                                      colorFilter: ColorFilter.mode(
                                        passwordFocus.hasFocus
                                            ? const Color(0xFF1B1D29)
                                            : const Color(0xFFA7ABC3),
                                        BlendMode.srcATop,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 0.5,
                                      height: 40,
                                      color: const Color(0xFFA7ABC3),
                                    )
                                  ],
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: _passwordVisible
                                    ? SvgPicture.asset(
                                        "assets/icons/password_visible.svg",
                                        colorFilter: ColorFilter.mode(
                                          passwordFocus.hasFocus
                                              ? const Color(0xFF1B1D29)
                                              : const Color(0xFFA7ABC3),
                                          BlendMode.srcATop,
                                        ),
                                      )
                                    : SvgPicture.asset(
                                        "assets/icons/password_not_visible.svg",
                                        colorFilter: ColorFilter.mode(
                                          passwordFocus.hasFocus
                                              ? const Color(0xFF1B1D29)
                                              : const Color(0xFFA7ABC3),
                                          BlendMode.srcATop,
                                        ),
                                      ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE4E5F0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(21, 101, 192, 1),
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE43434),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE43434),
                                ),
                              ),
                              suffixIconColor: passwordFocus.hasFocus
                                  ? const Color(0xFF1B1D29)
                                  : const Color(0xFFA7ABC3),
                            ),
                            onChanged: (value) {
                              _password = value;
                            },
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(21, 101, 192, 1),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 13,
                                    ),
                                  ),
                                  child: Text(
                                    LocalData.logIn.getString(context),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const ForgotPasswordScreen()))
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF3A9EFC),
                                  ),
                                  child: Text(
                                    LocalData.forgotPassword.getString(context),
                                    style: const TextStyle(
                                      color: Color.fromRGBO(21, 101, 192, 1),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
