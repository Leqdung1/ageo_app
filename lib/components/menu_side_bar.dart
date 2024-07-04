import 'package:ageo_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavigatorDrawer extends StatelessWidget {
  const NavigatorDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buidMenuItems(context),
            ]),
      ),
    );
  }
}

Widget buildHeader(BuildContext context) => Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(178, 192, 224, 1),
            Color.fromRGBO(75, 108, 183, 1),
          ],
          stops: [38 / 100, 100 / 100],
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.15,
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset('assets/images/logo.png'),
      ]),
    );

Widget buidMenuItems(BuildContext context) => Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 15,
      ),
      child: Wrap(
        runSpacing: 5,
        children: [
          ListTile(
              leading: SvgPicture.asset('assets/icons/home_icon.svg'),
              title: const Text(
                'Home',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()))),
          ListTile(
              leading: SvgPicture.asset('assets/icons/notifi.svg'),
              title: const Text(
                'Notifications',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              onTap: () {}),
          ListTile(
              leading: SvgPicture.asset('assets/icons/menu.svg'),
              title: const Text(
                'Menu',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              onTap: () {}),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.4,
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 5),
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          ListTile(
              leading: SvgPicture.asset('assets/icons/tai_khoan.svg'),
              title: const Text(
                'Account',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              onTap: () {}),
        ],
      ),
    );
