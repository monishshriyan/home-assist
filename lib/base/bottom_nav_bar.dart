import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:homeassist/base/account_screen.dart';
import 'package:homeassist/base/bookings_screen.dart';
import 'package:homeassist/base/home_screen.dart';
import 'package:homeassist/base/constants.dart';
import 'package:homeassist/base/search_screen.dart';
import 'package:homeassist/main.dart';

class MaterialNav extends StatefulWidget {
  MaterialNav({Key? key}) : super(key: navKey);
  @override
  State<MaterialNav> createState() => MaterialNavState();
}

class MaterialNavState extends State<MaterialNav> {
  int index = 0;

  final screens = [
    const HomeScreen(),
    const SearchScreen(),
    const BookingsScreen(),
    const AccountScreen(),
  ];

  // Method to update the index programmatically
  void updateIndex(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          body: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 0),
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
              return FadeThroughTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
            child: screens[index],
          ),
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
                        Icons.search_outlined,
                        size: 30,
                      ),
                      selectedIcon: Icon(
                        Icons.search,
                        size: 30,
                      ),
                      label: 'Search'),
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
                      icon: Icon(Icons.account_circle, size: 30),
                      selectedIcon: Icon(Icons.account_circle, size: 30),
                      label: 'Profile'),
                ],
              ),
            ),
          )),
    );
  }
}
