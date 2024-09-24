import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeassist/base/bottom_nav_bar.dart';
import 'package:homeassist/base/constants.dart';
import 'package:homeassist/base/home_screen.dart';
import 'package:homeassist/base/onboarding_screen.dart';
import 'package:homeassist/base/pages/login_page.dart';
import 'package:homeassist/base/pages/new_user_signup.dart';
import 'package:homeassist/base/pages/signin_page.dart';
import 'package:homeassist/base/pages/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
final GlobalKey<MaterialNavState> navKey = GlobalKey<MaterialNavState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ebzceioxoljcufsrcgkx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImViemNlaW94b2xqY3Vmc3JjZ2t4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM1NjMzNzMsImV4cCI6MjAzOTEzOTM3M30.SScf3A41RidYH75lPnP-BdA3QMPxMB1Fy7qvGN9zck8',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'HomeAssist',
        theme: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
                cursorColor: ColorConstants.darkSlateGrey),
            useMaterial3: true,
            textTheme: GoogleFonts.interTightTextTheme()),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/login': (context) => const SigninPage(),
          '/edit': (context) => const NewUserSignup(),
          '/home': (context) => MaterialNav(),
        });
  }
}
