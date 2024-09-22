import 'package:Ageo_solutions/components/localization.dart';
import 'package:Ageo_solutions/core/api_client.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

var _username = "";
var _password = "";
final _apiClient = ApiClient();

final usernameFocus = FocusNode();
final passwordFocus = FocusNode();

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _usernameController = TextEditingController();
  static final TextStyle style =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black);
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
            LocalData.forgotPassword.getString(context),
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tên đăng nhập',
                style: style,
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _usernameController,
                focusNode: usernameFocus,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocalData.numberMustWrite.getString(context);
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  fontSize: 13,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  hintStyle: const TextStyle(
                    color: Color.fromRGBO(225, 225, 225, 1),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              TextFormField(
                focusNode: usernameFocus,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocalData.numberMustWrite.getString(context);
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  fontSize: 13,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  hintStyle: const TextStyle(
                    color: Color.fromRGBO(225, 225, 225, 1),
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      _usernameController.clear();
                      setState(() {
                        _username = "";
                      });
                    },
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/email.svg",
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
              TextFormField(
                controller: _usernameController,
                focusNode: usernameFocus,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Tên đăng nhập không được để trống.";
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  fontSize: 13,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  hintStyle: const TextStyle(
                    color: Color.fromRGBO(225, 225, 225, 1),
                  ),
                  hintText: "Tên đăng nhập",
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
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/user.svg",
                          colorFilter: ColorFilter.mode(
                            usernameFocus.hasFocus
                                ? const Color(0xFF1B1D29)
                                : const Color.fromRGBO(225, 225, 225, 1),
                            BlendMode.srcATop,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 40,
                          width: 0.5,
                          color: const Color.fromRGBO(225, 225, 225, 1),
                        ),
                      ],
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _usernameController.clear();
                      setState(() {
                        _username = "";
                      });
                    },
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _username = value;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Email',
                style: style,
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                focusNode: usernameFocus,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email không được để trống.";
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  fontSize: 13,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  hintStyle: const TextStyle(
                    color: Color.fromRGBO(225, 225, 225, 1),
                  ),
                  hintText: "Email liên hệ",
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
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/email.svg",
                          colorFilter: ColorFilter.mode(
                            usernameFocus.hasFocus
                                ? const Color(0xFF1B1D29)
                                : const Color.fromRGBO(225, 225, 225, 1),
                            BlendMode.srcATop,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 40,
                          width: 0.5,
                          color: const Color.fromRGBO(225, 225, 225, 1),
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
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.05,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(237, 146, 39, 1),
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
                    "Quên mật khẩu",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
