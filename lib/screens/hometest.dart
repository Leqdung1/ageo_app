import 'package:Ageo_solutions/components/menu_side_bar.dart';
import 'package:Ageo_solutions/screens/camera.dart';
import 'package:Ageo_solutions/screens/control_panel.dart';
import 'package:Ageo_solutions/screens/device.dart';
import 'package:Ageo_solutions/screens/map.dart';
import 'package:Ageo_solutions/screens/warn.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      // appBar: AppBar(
      //   backgroundColor: const Color.fromRGBO(21, 101, 192, 1),
      //   title: const Text(
      //     'KHE SANH, WARD 10, DA LAT CITY',
      //     style: TextStyle(
      //       fontSize: 15,
      //       color: Colors.white,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   iconTheme: const IconThemeData(color: Colors.white),
      // ),
      // drawer: const NavigatorDrawer(),
      body: Column(
        children: [
          Expanded(
            child: PersistentTabView(
              navBarHeight: 80,
              onTabChanged: (value) => {
                setState(() {
                  currentPageIndex = value;
                })
              },
              tabs: [
                PersistentTabConfig(
                  screen: const ControlPanelScreen(),
                  item: ItemConfig(
                    icon: SvgPicture.asset(
                      currentPageIndex == 0
                          ? 'assets/icons/control_panel_fill.svg'
                          : 'assets/icons/control_panel.svg',
                    ),
                    title: "Control panel",
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: currentPageIndex == 0 ? Colors.black : Colors.grey,
                      fontWeight: currentPageIndex == 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                PersistentTabConfig(
                  screen: const MapScreen(),
                  item: ItemConfig(
                    icon: SvgPicture.asset(
                      currentPageIndex == 1
                          ? 'assets/icons/map_fill.svg'
                          : 'assets/icons/map.svg',
                    ),
                    title: "Map",
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: currentPageIndex == 1 ? Colors.black : Colors.grey,
                      fontWeight: currentPageIndex == 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                PersistentTabConfig(
                  screen: const CameraScreen(),
                  item: ItemConfig(
                    icon: SvgPicture.asset(
                      currentPageIndex == 2
                          ? 'assets/icons/camera_fill.svg'
                          : 'assets/icons/camera.svg',
                    ),
                    title: "Camera",
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: currentPageIndex == 2 ? Colors.black : Colors.grey,
                      fontWeight: currentPageIndex == 2
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                PersistentTabConfig(
                  screen: const DeviceScreen(),
                  item: ItemConfig(
                    icon: SvgPicture.asset(
                      currentPageIndex == 3
                          ? 'assets/icons/thiet_bi_fill.svg'
                          : 'assets/icons/thiet_bi.svg',
                    ),
                    title: "Device",
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: currentPageIndex == 3 ? Colors.black : Colors.grey,
                      fontWeight: currentPageIndex == 3
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                PersistentTabConfig(
                  screen: const WarningScreen(),
                  item: ItemConfig(
                    icon: SvgPicture.asset(
                      currentPageIndex == 4
                          ? 'assets/icons/waring_fill.svg'
                          : 'assets/icons/warning.svg',
                    ),
                    title: "Warning",
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: currentPageIndex == 4 ? Colors.black : Colors.grey,
                      fontWeight: currentPageIndex == 4
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                PersistentTabConfig(
                  screen: const WarningScreen(),
                  item: ItemConfig(
                    icon: const Icon(Icons.more_horiz_outlined),
                    title: "More",
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: currentPageIndex == 5 ? Colors.black : Colors.grey,
                      fontWeight: currentPageIndex == 5
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
              navBarBuilder: (navBarConfig) => Style4BottomNavBar(
                navBarDecoration: NavBarDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 20,
                      offset: const Offset(1, -1),
                    ),
                  ],
                ),
                navBarConfig: navBarConfig,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
