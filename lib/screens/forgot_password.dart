import 'package:Ageo_solutions/core/api_client.dart';

import 'package:flutter/material.dart';
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
          ),
          title: Text(
            'Quên mật khẩu',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                    color: Color(0xFFA7ABC3),
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
                    color: Color(0xFFA7ABC3),
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
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.15),
              ElevatedButton(
                // TODO: get password
                onPressed: () {},

                style: ElevatedButton.styleFrom(
                  fixedSize: Size.copy(
                    Size.fromWidth(MediaQuery.sizeOf(context).width),
                  ),
                  backgroundColor: const Color.fromRGBO(21, 101, 192, 1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Lấy lại mật khẩu",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
