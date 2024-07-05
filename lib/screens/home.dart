import 'package:ageo_app/components/menu_side_bar.dart';
import 'package:ageo_app/screens/camera.dart';
import 'package:ageo_app/screens/control_panel.dart';
import 'package:ageo_app/screens/device.dart';
import 'package:ageo_app/screens/map.dart';
import 'package:ageo_app/screens/warn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(21, 101, 192, 1),
        title: Text(
          'KHE SANH, WARD 10, DA LAT CITY',
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const NavigatorDrawer(),
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          ControlPanelScreen(),
          MapScreen(),
          CameraScreen(),
          DeviceScreen(),
          WarningScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.16),
              offset: const Offset(0, -3),
              blurRadius: 10,
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentPageIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  SvgPicture.asset(
                    currentPageIndex == 0
                        ? 'assets/icons/control_panel_fill.svg'
                        : 'assets/icons/control_panel.svg',
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Control Panel',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: currentPageIndex == 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: currentPageIndex == 0 ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  SvgPicture.asset(
                    currentPageIndex == 1
                        ? 'assets/icons/map_fill.svg'
                        : 'assets/icons/map.svg',
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Map',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: currentPageIndex == 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: currentPageIndex == 1 ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  SvgPicture.asset(
                    currentPageIndex == 2
                        ? 'assets/icons/Camera_fill.svg'
                        : 'assets/icons/Camera.svg',
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Camera',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: currentPageIndex == 2
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: currentPageIndex == 2 ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  SvgPicture.asset(
                    currentPageIndex == 3
                        ? 'assets/icons/thiet_bi_fill.svg'
                        : 'assets/icons/thiet_bi.svg',
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Device',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: currentPageIndex == 3
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: currentPageIndex == 3 ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  SvgPicture.asset(
                    currentPageIndex == 4
                        ? 'assets/icons/waring_fill.svg'
                        : 'assets/icons/warning.svg',
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Warning',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: currentPageIndex == 4
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: currentPageIndex == 4 ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
              label: '',
            ),
          ],
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
