import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homeassist/base/bottom_nav_bar.dart';
import 'package:homeassist/base/constants.dart';
import 'package:homeassist/base/intro_screens/intro_page1.dart';
import 'package:homeassist/base/intro_screens/intro_page2.dart';
import 'package:homeassist/base/intro_screens/intro_page3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  //controller to keep track of current page
  PageController _controller = PageController();
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = index == 2;
              });
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ]),
        Container(
            alignment: const Alignment(0, 0.7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: ElevatedButton(
                    onPressed: () {
                      _controller.jumpToPage(2);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: ColorConstants.navBackground,
                        shape: (RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)))),
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: ColorConstants.darkSlateGrey,
                      ),
                    ),
                  )
                  /* const Text('Skip',
                      style: TextStyle(fontWeight: FontWeight.w900)) */
                  ,
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: ScaleEffect(
                      activeDotColor: ColorConstants.darkSlateGrey,
                      dotHeight: 7,
                      dotWidth: 10),
                ),
                onLastPage
                    ? GestureDetector(
                        child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return MaterialNav();
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOutExpo;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 800),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: ColorConstants.navBackground,
                            shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)))),
                        child: Text(
                          "Done",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: ColorConstants.darkSlateGrey,
                          ),
                        ),
                      ))
                    : GestureDetector(
                        child: ElevatedButton(
                        onPressed: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 450),
                              curve: Curves.easeInOutQuart);
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: ColorConstants.navBackground,
                            shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)))),
                        child: Text(
                          "Next",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: ColorConstants.darkSlateGrey),
                        ),
                      ))
              ],
            ))
      ],
    ));
  }
}
