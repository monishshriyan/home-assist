import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homeassist/base/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<String> months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello Broda!",
                      style: TextStyle(
                          /* fontFamily: , */
                          color: ColorConstants.textDarkGreen,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${DateTime.now().day} ${months[DateTime.now().month]} ${DateTime.now().year}",
                      style: TextStyle(color: ColorConstants.darkSlateGrey),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColorConstants.navLabelHighlight,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: ColorConstants.textDarkGreen,
                    size: 26,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            //search bar
            Container(
                decoration: BoxDecoration(
                  color: ColorConstants.navBackground,
                  borderRadius: BorderRadius.circular(50),
                  /* border: Border.all(
                        width: 0.5, color: ColorConstants.darkSlateGrey) */
                ),
                padding: const EdgeInsets.all(15),
                child: Container(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                      /* mainAxisAlignment: MainAxisAlignment.spaceBetween, */
                      children: [
                        const Icon(Icons.search),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Find Services",
                          style: GoogleFonts.getFont(FontConstants.fontBody,
                              textStyle: TextStyle(
                                  color: ColorConstants.textDarkGreen)),
                        )
                      ]),
                )),
            //cards
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "POPULAR AROUND YOU",
                    style: TextStyle(
                        /* fontFamily: 'Nikkei', */
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            //cards
            Container()
          ]),
        ),
      ),
    );
  }
}
