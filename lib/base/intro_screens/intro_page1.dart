import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('animations/searchAnimation.json'),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 250),
            child: const Text(
              'All services in one app',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cubano',
                fontSize: 36,
              ),
            ),
          )
        ],
      ),
    );
  }
}
