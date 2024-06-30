import 'package:flutter/material.dart';
import 'package:homeassist/base/bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'HomeAssist',
        theme: ThemeData(useMaterial3: false),
        home: const BottomNavBar());
  }
}
