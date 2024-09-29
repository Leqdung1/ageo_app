import "package:Ageo_solutions/components/localization.dart";
import "package:Ageo_solutions/screens/forgot_password.dart";
import "package:Ageo_solutions/screens/home.dart";
import "package:Ageo_solutions/screens/home.dart";
import "package:Ageo_solutions/screens/hung_yen/device_screen/ap_lu_lo_rong.dart";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_localization/flutter_localization.dart";
import 'package:flutter_svg/flutter_svg.dart';

import "package:flutter_svg/svg.dart";
import "package:local_auth/local_auth.dart";
import "package:lucide_icons/lucide_icons.dart";
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

  final LocalAuthentication localAuth = LocalAuthentication();
  bool isBiometricAvailable = false;
  bool biometricSetting = false;

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

  void _checkBiometric() async {
    isBiometricAvailable = await localAuth.canCheckBiometrics;

    List<BiometricType> availableBiometrics =
        await localAuth.getAvailableBiometrics();
    if (availableBiometrics.isNotEmpty) {
      isBiometricAvailable = true;
    } else {
      isBiometricAvailable = false;
    }
  }

  void _checkBiometricSettings() async {
    var result = await const SecureStorage().readSecureData("save_password");
    if (result != null) {
      setState(() {
        biometricSetting = result == "true";
      });
    }
  }

  void _notifyNoBiometric() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Thông báo"),
          content: const Text(
              "Thiết bị không hỗ trợ xác thực bằng vân tay hoặc FaceID"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

  void _handleBiometricAuth() async {
    bool auth = false;
    try {
      auth = await localAuth.authenticate(
          localizedReason:
              "Vui lòng xác thực bằng vân tay hoặc FaceID để tiếp tục.",
          options: const AuthenticationOptions(biometricOnly: true));
    } on PlatformException {
      const SnackBar(
        content: Text("Xác thực không thành công."),
        backgroundColor: Colors.red,
      );
    } finally {
      if (auth) {
        await const SecureStorage().writeSecureData("logged_in", "true");
        var result =
            await const SecureStorage().readSecureData("held_access_token");
        await const SecureStorage().writeSecureData("access_token", result);
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return const HomeScreen();
            }),
            (route) => false,
          );
        }
      }
    }
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Form(
                key: _formKey,
                child: Container(
                  width: size.width * 1,
                  padding: EdgeInsets.fromLTRB(
                      24, _checkLastLoggedInData() ? 0 : 24, 24, 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
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
                                LocalData.typeNameandNumber.getString(context),
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
                                  width: 20,
                                ),
                                IconButton(
                                  onPressed: () {
                                    _selectLanguage("en");
                                  },
                                  icon: SvgPicture.asset('assets/icons/Us.svg'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          focusNode: usernameFocus,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            fillColor: Theme.of(context).colorScheme.secondary,
                            filled: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
                            hintStyle: const TextStyle(
                              color: Color.fromRGBO(225, 225, 225, 1),
                            ),
                            hintText: LocalData.userName.getString(context),
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(225, 225, 225, 1),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(237, 146, 39, 1),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/user.svg",
                                    // ignore: deprecated_member_use
                                    color: Theme.of(context).iconTheme.color,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          fillColor: Theme.of(context).colorScheme.secondary,
                          filled: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                          hintStyle: const TextStyle(
                            color: Color.fromRGBO(225, 225, 225, 1),
                          ),
                          hintText: LocalData.password.getString(context),
                          isDense: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/password_lock.svg",
                                  // ignore: deprecated_member_use
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ],
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: _passwordVisible
                                ? Icon(
                                    LucideIcons.eye,
                                    color: Theme.of(context).iconTheme.color,
                                  )
                                : Icon(
                                    LucideIcons.eyeOff,
                                    color: Theme.of(context).iconTheme.color,
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
                              color: Color.fromRGBO(225, 225, 225, 1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(237, 146, 39, 1),
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
                              : const Color.fromRGBO(225, 225, 225, 1),
                        ),
                        onChanged: (value) {
                          _password = value;
                        },
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Expanded(
                          child: TextButton(
                            onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const ForgotPasswordScreen(),
                                ),
                              )
                            },
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  const Color.fromRGBO(237, 146, 39, 1),
                            ),
                            child: Text(
                              LocalData.forgotPassword.getString(context),
                              style: const TextStyle(
                                color: Color.fromRGBO(237, 146, 39, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
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
                                    const Color.fromRGBO(237, 146, 39, 1),
                                foregroundColor: Colors.black,
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
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          biometricSetting
                              ? Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 5,
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        fixedSize: const Size(48, 48),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            const Color.fromRGBO(237, 146, 39, 1),
                                        shadowColor: Colors.transparent,
                                      ),
                                      onPressed: () {
                                        _handleBiometricAuth();
                                      },
                                      child: const Icon(LucideIcons.scanFace),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
