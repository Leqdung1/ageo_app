import 'package:Ageo_solutions/lang/localization.dart';
import 'package:Ageo_solutions/core/api_client.dart';
import 'package:Ageo_solutions/core/helpers.dart';
import 'package:Ageo_solutions/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class ChangePWScreen extends StatefulWidget {
  @override
  _ChangePWScreenState createState() => _ChangePWScreenState();
}

class _ChangePWScreenState extends State<ChangePWScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final apiClient = ApiClient();
  final SecureStorage _ss = const SecureStorage();
  var _passwordVisible = false;

  int? userId;
  String? displayName;
  String? email;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final token = await _ss.readSecureData("access_token");
    if (token != null && !JwtDecoder.isExpired(token)) {
      final decodedToken = JwtDecoder.decode(token);

      // Extract userId, displayName, and email from the token
      setState(() {
        userId = decodedToken['userid'] != null
            ? int.tryParse(decodedToken['userid'])
            : null;
        displayName = decodedToken['displayName'] ?? 'Unknown';
        email = decodedToken['email'] ?? 'Unknown';
      });
    } else {
      print("Token is either null or expired.");
    }
  }

  Future<void> _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Ensure that userId, displayName, and email are not null
      if (userId != null && displayName != null && email != null) {
        Map<String, dynamic> userData = {
          "userId": userId,
          "displayName": displayName,
          "email": email,
          // Add other relevant fields as needed
        };

        String oldPassword = _oldPasswordController.text;
        String newPassword = _newPasswordController.text;

        // Call your changePassword function
        Map<String, dynamic> response =
            await apiClient.changePassWord(userData, oldPassword, newPassword);

        setState(() {
          _isLoading = false;
        });

        // Handle the response (success or failure)
        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Password changed successfully!'),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Password change failed: ${response['error'] ?? 'Unknown error'}'),
            backgroundColor: Colors.red,
          ));
        }
        pushWithoutNavBar(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to retrieve user data.'),
          backgroundColor: Colors.red,
        ));
      }
    }
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
          LocalData.changePassWord.getString(context),
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      LocalData.oldPassword.getString(context),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: !_passwordVisible,
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocalData.passwordMustWrite.getString(context);
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    hintStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                    ),
                    hintText: LocalData.typePass.getString(context),
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
                        color: Color(0xFFA7ABC3),
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
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      LocalData.newPassword.getString(context),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocalData.passwordMustWrite.getString(context);
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    hintStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                    ),
                    hintText: LocalData.typePass.getString(context),
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
                        color: Color(0xFFA7ABC3),
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
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      LocalData.reNewPassword.getString(context),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocalData.passwordMustWrite.getString(context);
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    hintStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                    ),
                    hintText: LocalData.typePass.getString(context),
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
                        color: Color(0xFFA7ABC3),
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
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.4,
                ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _handleChangePassword,
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
                                LocalData.changePassWord.getString(context),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
    );
  }
}