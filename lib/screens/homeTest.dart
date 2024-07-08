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
        title: const Text(
          'KHE SANH, WARD 10, DA LAT CITY',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const NavigatorDrawer(
        
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(
              index: currentPageIndex,
              children: [
                ControlPanelScreen(),
                MapScreen(),
                CameraScreen(),
                DeviceScreen(),
                WarningScreen(),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildFloatingNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavBar() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(16),
            blurRadius: 20,
            offset: const Offset(1, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, 'assets/icons/control_panel.svg',
              'assets/icons/control_panel_fill.svg', 'Control panel'),
          _buildNavItem(
              1, 'assets/icons/map.svg', 'assets/icons/map_fill.svg', 'Map'),
          _buildNavItem(2, 'assets/icons/Camera.svg',
              'assets/icons/Camera_fill.svg', 'Camera'),
          _buildNavItem(3, 'assets/icons/thiet_bi.svg',
              'assets/icons/thiet_bi_fill.svg', 'Device'),
          _buildNavItem(4, 'assets/icons/warning.svg',
              'assets/icons/waring_fill.svg', 'Warning'),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      int index, String iconPath, String selectedIconPath, String label) {
    bool isSelected = currentPageIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(
            () {
              currentPageIndex = index;
            },
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isSelected
                ? SvgPicture.asset(selectedIconPath)
                : SvgPicture.asset(iconPath),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
