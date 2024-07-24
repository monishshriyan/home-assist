import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        height: 200,
        width: 350,
        child: Transform.scale(
          scale: 2,
          child: const RiveAnimation.asset(
            'animations/onboarding_screen3.riv',
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
          ),
        ),
      ),
      SizedBox(
        height: 50,
      ),
      Column(
        children: [
          Text(
            "Your Data is Safe",
            style: TextStyle(fontSize: 40, fontFamily: 'Cubano'),
          ),
          SizedBox(
            width: 400,
            child: Text(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
                "We protect your personal information with end-to-end encryption."),
          )
        ],
      )
    ]));
  }
}
