import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeassist/base/bottom_nav_bar.dart';
import 'package:homeassist/base/home_screen.dart';
import 'package:homeassist/base/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomeAssist',
      theme: ThemeData(
          useMaterial3: true, textTheme: GoogleFonts.interTightTextTheme()),
      home: const OnboardingScreen(),
      routes: {
        '/home': (context) => const MaterialNav(),
      },
    );
  }
}
