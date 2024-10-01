import 'package:Ageo_solutions/lang/localization.dart';
import 'package:Ageo_solutions/core/api_client.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  var _username = "";
  var _email = "";
  final _apiClient = ApiClient();

  final usernameFocus = FocusNode();
  final emailFocus = FocusNode();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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
            LocalData.passWordForgot.getString(context),
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
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text(
                    LocalData.userName.getString(context),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  hintStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  hintText: LocalData.typeUser.getString(context),
                  isDense: true,
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
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
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
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: _emailController,
                focusNode: emailFocus,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocalData.emailMustWrite.getString(context);
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  hintStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  hintText: LocalData.typeEmail.getString(context),
                  isDense: true,
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      LucideIcons.xCircle,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      _emailController.clear();
                      setState(() {
                        _email = "";
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
                    _email = value;
                  });
                },
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.5,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    backgroundColor: const Color.fromRGBO(237, 146, 39, 1),
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
                    LocalData.passWordForgot.getString(context),
                    style: const TextStyle(
                      fontSize: 18,
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
