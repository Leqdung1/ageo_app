// ignore: file_names
import 'package:Ageo_solutions/lang/localization.dart';
import 'package:Ageo_solutions/core/api_client.dart';
import 'package:Ageo_solutions/core/helpers.dart';
import 'package:Ageo_solutions/screens/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class ChangePWScreen extends StatefulWidget {
  const ChangePWScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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

  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  int? userId;
  String? displayName;
  String? email;
  String? confirmPassword;
  String? dob;
  String? gender;
  int? id;
  String? idOrganization;
  String? idPosition;
  String? newPassword;
  String? oldPassword;
  String? phoneNumber;
  String? startPageId;
  String? username;
  int? typeId;
  int? status;
  int? branchId;
  String? avatar;
  bool isSuperUser = false;

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
      setState(() {
        userId = decodedToken['userid'] != null
            ? int.tryParse(decodedToken['userid'])
            : null;
        displayName = decodedToken['displayName'] ?? 'Unknown';
        email = decodedToken['email'] ?? 'Unknown';
        username = decodedToken['username'] ?? 'Unknown';
        idOrganization = decodedToken['idOrganization'] ?? 'Unknown';
        idPosition = decodedToken['idPosition'] ?? 'Unknown';
        startPageId = decodedToken['startPageId'] ?? 'Unknown';
        id = decodedToken['id'] ?? 'Unknown';
        dob = decodedToken['dateOfBirth'] ?? 'Unknown';
        gender = decodedToken['gender'] ?? 'Unknown';
        typeId = decodedToken['typeId'] ?? 'Unknown';
        status = decodedToken['status'] ?? 'Unknown';
        avatar = decodedToken['avatar'] ?? 'Unknown';
        isSuperUser = decodedToken['isSuperUser'] ?? 'Unknown';
        phoneNumber = decodedToken['phoneNumber'] ?? 'Unknown';
        newPassword = decodedToken['newPassword'] ?? 'Unlnown';
      });
    } else {
      if (kDebugMode) {
        print("Token is either null or expired.");
      }
    }
  }

  Future<void> _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      if (userId != null && displayName != null && email != null) {
        Map<String, dynamic> userData = {
          "userId": userId,
          "displayName": displayName,
          "email": email,
          "username": username,
          "idOrganization": idOrganization,
          "idPosition": idPosition,
          "startPageId": startPageId,
          "id": id,
          'status': status,
          'typeId': typeId,
          'branchId': branchId,
          'dateOfBirth': dob,
          'avatar': avatar,
          'isSuperUser': isSuperUser,
          'phoneNumber': phoneNumber,
        };

        String oldPassword = _oldPasswordController.text;
        String newPassword = _newPasswordController.text;

        Map<String, dynamic> response =
            await apiClient.changePassWord(userData, oldPassword, newPassword);

        setState(() {
          _isLoading = false;
        });

        // Handle the response (success or failure)
        if (response['status'] == 'success') {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Password changed successfully!'),
            backgroundColor: Colors.green,
          ));
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Password change failed: ${response['error'] ?? 'Unknown error'}'),
            backgroundColor: Colors.red,
          ));
        }
        pushWithoutNavBar(
          // ignore: use_build_context_synchronously
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
                  obscureText: !_oldPasswordVisible,
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
                      icon: _oldPasswordVisible
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
                          _oldPasswordVisible = !_oldPasswordVisible;
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
                  obscureText: !_newPasswordVisible,
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
                      icon: _newPasswordVisible
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
                          _newPasswordVisible = !_newPasswordVisible;
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
                  obscureText: !_confirmPasswordVisible,
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
                      icon: _confirmPasswordVisible
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
                          _confirmPasswordVisible = !_confirmPasswordVisible;
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
                                  vertical: 22,
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
