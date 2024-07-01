import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  //list is iterated using index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Center(child: Text("HomeAssist")),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
        /* color: const Color.fromARGB(255, 13, 13, 13) */
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 13, 13, 13),
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(37, 0, 0, 0),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, -5), // Add this
            ),
          ],
        ), // Add this),

        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: GNav(
              backgroundColor: Color.fromARGB(255, 13, 13, 13),
              color: Color.fromARGB(246, 255, 255, 255),
              activeColor: Color.fromARGB(243, 255, 255, 255),
              tabBackgroundColor: Color.fromARGB(47, 18, 234, 65),
              gap: 4,
              duration: Duration(milliseconds: 200),
              iconSize: 28,
              padding: EdgeInsets.all(15),
              haptic: true,
              curve: Curves.easeInExpo,
              tabs: [
                GButton(
                  icon: FluentSystemIcons.ic_fluent_home_regular,
                  text: 'Home',
                ),
                GButton(
                    icon: FluentSystemIcons.ic_fluent_search_regular,
                    text: 'Search'),
                GButton(
                    icon: FluentSystemIcons.ic_fluent_person_regular,
                    text: 'Account'),
                GButton(
                    icon: FluentSystemIcons.ic_fluent_settings_regular,
                    text: 'Settings')
              ]),
        ),
      ),
    );
  }
}
