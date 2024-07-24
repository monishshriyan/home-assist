import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        height: 200,
        width: 350,
        child: RiveAnimation.asset(
          'animations/onboarding_screen1.riv',
          fit: BoxFit.fitWidth,
          alignment: Alignment.center,
        ),
      ),
      SizedBox(
        height: 50,
      ),
      Column(
        children: [
          Text(
            "Find your service",
            style: TextStyle(fontSize: 40, fontFamily: 'Cubano'),
          ),
          SizedBox(
            width: 400,
            child: Text(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
                "Discover a wide range of trusted home services tailored to your needs."),
          )
        ],
      )
    ]));
  }
}
