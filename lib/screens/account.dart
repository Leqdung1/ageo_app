import 'package:Ageo_solutions/core/api_client.dart';
import 'package:Ageo_solutions/core/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Ageo_solutions/components/menu_side_bar.dart';
import 'package:Ageo_solutions/screens/login.dart';
import 'package:Ageo_solutions/screens/notifications.dart';

class AccountScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final String name;
  final String avatar;

  const AccountScreen(
      {super.key,
      required this.userData,
      required this.avatar,
      required this.name});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  static const TextStyle style = TextStyle(
      fontSize: 15,
      color: Color.fromRGBO(167, 171, 195, 1),
      fontWeight: FontWeight.normal);
  Future<Map<String, dynamic>>? _userData;

  @override
  void initState() {
    super.initState();

    _userData = ApiClient().getUserData('1');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: _userData,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            SecureStorage().writeSecureData(
                'staffName', snapshot.data?["data"]["staffName"]);
            SecureStorage().writeSecureData(
                'imageURL', snapshot.data?["data"]["imageURL"]);
          }
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(21, 101, 192, 1),
              title: const Text(
                'Thông tin cá nhân',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              iconTheme:
                  const IconThemeData(color: Color.fromRGBO(255, 255, 255, 1)),
            ),
            drawer: const NavigatorDrawer(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height * 0.1,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 1),
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        widget.avatar.isNotEmpty
                            ? Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(widget.avatar),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.account_circle,
                                size: 50,
                                color: Colors.blueAccent,
                              ),
                        SizedBox(
                          width: size.width * 0.03,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.name.isNotEmpty
                                ? Text(
                                    widget.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : const CircularProgressIndicator(),
                            const Text(
                              'BQLDA',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Color.fromRGBO(167, 171, 195, 1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20, left: 12),
                        child: Text(
                          'Cài đặt tài khoản',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: SvgPicture.asset('assets/icons/account.svg'),
                        title: const Text('Thông tin cá nhân', style: style),
                        trailing:
                            SvgPicture.asset('assets/icons/arrow_right.svg'),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        color: const Color.fromRGBO(236, 236, 236, 1),
                        height: 1,
                      ),
                      ListTile(
                        leading: SvgPicture.asset('assets/icons/noti_fill.svg'),
                        title: const Text('Thông báo', style: style),
                        trailing:
                            SvgPicture.asset('assets/icons/arrow_right.svg'),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NotificationsScreen()),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        color: const Color.fromRGBO(236, 236, 236, 1),
                        height: 1,
                      ),
                      ListTile(
                        leading: SvgPicture.asset('assets/icons/password.svg'),
                        title: const Text('Đổi mật khẩu', style: style),
                        trailing:
                            SvgPicture.asset('assets/icons/arrow_right.svg'),
                        onTap: () {},
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        color: const Color.fromRGBO(236, 236, 236, 1),
                        height: 1,
                      ),
                      ListTile(
                        leading: SvgPicture.asset('assets/icons/log-out.svg'),
                        title: const Text('Đăng xuất', style: style),
                        trailing:
                            SvgPicture.asset('assets/icons/arrow_right.svg'),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        color: const Color.fromRGBO(236, 236, 236, 1),
                        height: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
