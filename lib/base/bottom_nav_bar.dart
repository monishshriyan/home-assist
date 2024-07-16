import 'package:flutter/material.dart';
import 'package:homeassist/base/account_screen.dart';
import 'package:homeassist/base/bookings_screen.dart';
import 'package:homeassist/base/home_screen.dart';
import 'package:homeassist/base/settings_screen.dart';
import 'package:homeassist/base/constants.dart';

class MaterialNav extends StatefulWidget {
  const MaterialNav({super.key});

  @override
  State<MaterialNav> createState() => _MaterialNavState();
}

class _MaterialNavState extends State<MaterialNav> {
  int index = 0;

  final screens = [
    const HomeScreen(),
    const BookingsScreen(),
    const AccountScreen(),
    const SettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[index],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: ColorConstants.navLabelHighlight,
            labelTextStyle: WidgetStateProperty.all(
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: NavigationBar(
              selectedIndex: index,
              height: 70,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              backgroundColor: ColorConstants.navBackground,
              onDestinationSelected: (index) => setState(() {
                this.index = index;
              }),
              destinations: const [
                NavigationDestination(
                    icon: Icon(
                      Icons.explore_outlined,
                      size: 30,
                    ),
                    selectedIcon: Icon(
                      Icons.explore,
                      size: 30,
                    ),
                    label: 'Discover'),
                NavigationDestination(
                    icon: Icon(
                      Icons.calendar_month_outlined,
                      size: 30,
                    ),
                    selectedIcon: Icon(
                      Icons.calendar_month,
                      size: 30,
                    ),
                    label: 'Bookings'),
                NavigationDestination(
                    icon: Icon(Icons.settings_outlined, size: 30),
                    selectedIcon: Icon(Icons.settings, size: 30),
                    label: 'Settings'),
              ],
            ),
          ),
        ));
  }
}
