import 'package:ageo_app/components/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(21, 101, 192, 1),
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.menu,
        //     color: Colors.white,
        //     size: 35,
        //   ),
        //   onPressed: () {},
        // ),
        title: Text(
          'KHE SANH, WARD 10, DA LAT CITY',
          style: TextStyle(
              fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: NavigatorDrawer(),
    );
  }
}
