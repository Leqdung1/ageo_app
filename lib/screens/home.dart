import 'package:Ageo_solutions/lang/localization.dart';
import 'package:Ageo_solutions/screens/da_lat/control_panel.dart';
import 'package:Ageo_solutions/screens/da_lat/device.dart';
import 'package:Ageo_solutions/screens/da_lat/map.dart';
import 'package:Ageo_solutions/screens/da_lat/warn.dart';
import 'package:Ageo_solutions/screens/hung_yen/control_panel_hy.dart';
import 'package:Ageo_solutions/screens/hung_yen/device_hy.dart';
import 'package:Ageo_solutions/screens/hung_yen/map_hy.dart';
import 'package:Ageo_solutions/screens/hung_yen/warn_hy.dart';
import 'package:Ageo_solutions/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  String selectedSystem = 'dalat';

  void _updateSelectedSystem(String system) {
    setState(() {
      selectedSystem = system;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      body: Column(
        children: [
          Expanded(
            child: PersistentTabView(
              navBarHeight: 80,
              onTabChanged: (value) {
                setState(() {
                  currentPageIndex = value;
                });
              },
              tabs: [
                PersistentTabConfig(
                  screen: selectedSystem == 'dalat'
                      ? const ControlPanelScreen()
                      : const ControlPanelHyScreen(),
                  item: ItemConfig(
                    icon: SvgPicture.asset(
                      currentPageIndex == 0
                          ? 'assets/icons/home_yellow.svg'
                          : 'assets/icons/home_notFill.svg',
                    ),
                    title: LocalData.bottomlabel1.getString(context),
                    textStyle: TextStyle(
                      overflow: TextOverflow.fade,
                      fontSize: 12,
                      color: currentPageIndex == 0 ? Colors.black : Colors.grey,
                      fontWeight: currentPageIndex == 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    activeForegroundColor:
                        const Color.fromRGBO(237, 146, 39, 1),
                  ),
                ),
                PersistentTabConfig(
                  screen: selectedSystem == 'dalat'
                      ? const MapScreen()
                      : const MapHyScreen(),
                  item: ItemConfig(
                    icon: SvgPicture.asset(
                      currentPageIndex == 1
                          ? 'assets/icons/map-pin_yellow.svg'
                          : 'assets/icons/map_notFIll.svg',
                    ),
                    title: LocalData.bottomlabel2.getString(context),
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: currentPageIndex == 1 ? Colors.black : Colors.grey,
                      fontWeight: currentPageIndex == 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    activeForegroundColor:
                        const Color.fromRGBO(237, 146, 39, 1),
                  ),
                ),
                PersistentTabConfig(
                  screen: selectedSystem == 'dalat'
                      ? const DeviceScreen()
                      : const DeviceHyScreen(),
                  item: ItemConfig(
                    icon: SvgPicture.asset(
                      currentPageIndex == 2
                          ? 'assets/icons/signal-alt-3_yellow.svg'
                          : 'assets/icons/signal-alt-3.svg',
                    ),
                    title: LocalData.bottomlabel4.getString(context),
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: currentPageIndex == 2 ? Colors.black : Colors.grey,
                      fontWeight: currentPageIndex == 2
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    activeForegroundColor:
                        const Color.fromRGBO(237, 146, 39, 1),
                  ),
                ),
                PersistentTabConfig(
                  screen: selectedSystem == 'dalat'
                      ? const WarningScreen()
                      : const WarningHyScreen(),
                  item: ItemConfig(
                    icon: SvgPicture.asset(
                      currentPageIndex == 3
                          ? 'assets/icons/alert-triangle_yellow.svg'
                          : 'assets/icons/alert-triangle.svg',
                    ),
                    title: LocalData.bottomlabel5.getString(context),
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: currentPageIndex == 3 ? Colors.black : Colors.grey,
                      fontWeight: currentPageIndex == 3
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    activeForegroundColor:
                        const Color.fromRGBO(237, 146, 39, 1),
                  ),
                ),
                PersistentTabConfig(
                  screen:
                      SettingsScreen(onSystemSelected: _updateSelectedSystem),
                  item: ItemConfig(
                    icon: SvgPicture.asset(
                      currentPageIndex == 4
                          ? 'assets/icons/user_yellow.svg'
                          : 'assets/icons/userNotFill.svg',
                    ),
                    title: LocalData.bottomLabel6.getString(context),
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: currentPageIndex == 4 ? Colors.black : Colors.grey,
                      fontWeight: currentPageIndex == 4
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    activeForegroundColor:
                        const Color.fromRGBO(237, 146, 39, 1),
                  ),
                ),
              ],
              navBarBuilder: (navBarConfig) => Style1BottomNavBar(
                navBarDecoration: NavBarDecoration(
                  color: Theme.of(context).colorScheme.surface,
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
