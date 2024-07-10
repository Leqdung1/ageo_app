import 'package:Ageo_solutions/components/menu_side_bar.dart';
import 'package:flutter/material.dart';


class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(21, 101, 192, 1),
        title: Text(
          "Thông báo",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Color.fromRGBO(255, 255, 255, 1)),
      ),
      drawer: const NavigatorDrawer(),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.message_outlined,
                color: Colors.lightBlue,
                size: MediaQuery.sizeOf(context).height * 0.2,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                'Bạn chưa có thông báo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              )
            ],
          ),
        ),
      ),
    );
  }
}
