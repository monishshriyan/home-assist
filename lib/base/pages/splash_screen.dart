import 'package:flutter/material.dart';
import 'package:homeassist/base/pages/account_page.dart';
import 'package:homeassist/main.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (!mounted) {
      return;
    }

    final session = supabase.auth.currentSession;
    if (session != null) {
      final userId = session.user.id;
      final response = await supabase
          .from('profiles')
          .select('is_profile_complete')
          .eq('id', userId)
          .single();
      final isProfileComplete = response['is_profile_complete'] as bool;

      if (isProfileComplete) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AccountPage()),
        );
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
