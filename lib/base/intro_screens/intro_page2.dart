import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        height: 200,
        child: RiveAnimation.asset(
          'animations/onboarding_screen2.riv',
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
      SizedBox(
        height: 50,
      ),
      Column(
        children: [
          Text(
            "Book a session",
            style: TextStyle(fontSize: 40, fontFamily: 'Cubano'),
          ),
          SizedBox(
            width: 300,
            child: Text(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
                "Select the best time for you with just a few taps."),
          )
        ],
      )
    ]));
  }
}
