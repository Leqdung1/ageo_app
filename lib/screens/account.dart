import 'package:Ageo_solutions/components/menu_side_bar.dart';
import 'package:Ageo_solutions/screens/login.dart';
import 'package:Ageo_solutions/screens/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  static final TextStyle style = TextStyle(
      fontSize: 15,
      color: Color.fromRGBO(167, 171, 195, 1),
      fontWeight: FontWeight.normal);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(21, 101, 192, 1),
        title: const Text(
          'Thông tin cá nhân',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Color.fromRGBO(255, 255, 255, 1)),
      ),
      drawer: const NavigatorDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // TODO: add API user
          Container(
            height: MediaQuery.sizeOf(context).height * 0.1,
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4)
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.02,
                ),
                Icon(
                  Icons.account_circle,
                  size: 50,
                  color: Colors.blueAccent,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.03,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Le Van A',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'BQLDA',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Color.fromRGBO(167, 171, 195, 1),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20, left: 12),
                  child: Text(
                    'Cài đặt tài khoản',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/icons/account.svg'),
                  title: Text('Thông tin cá nhân', style: style),
                  trailing: SvgPicture.asset('assets/icons/arrow_right.svg'),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  color: Color.fromRGBO(236, 236, 236, 1),
                  height: 1,
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/icons/noti_fill.svg'),
                  title: Text('Thông báo', style: style),
                  trailing: SvgPicture.asset('assets/icons/arrow_right.svg'),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationsScreen())),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  color: Color.fromRGBO(236, 236, 236, 1),
                  height: 1,
                ),
                ListTile(
                    leading: SvgPicture.asset('assets/icons/password.svg'),
                    title: Text('Đổi mật khẩu', style: style),
                    trailing: SvgPicture.asset('assets/icons/arrow_right.svg'),
                    onTap: () {}),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  color: Color.fromRGBO(236, 236, 236, 1),
                  height: 1,
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/icons/log-out.svg'),
                  title: Text('Đăng xuất', style: style),
                  trailing: SvgPicture.asset('assets/icons/arrow_right.svg'),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen())),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  color: Color.fromRGBO(236, 236, 236, 1),
                  height: 1,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
