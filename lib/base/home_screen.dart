import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homeassist/base/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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

final List<String> carouselImages = [
  'images/HomeCleaningCard1.png',
  'images/techSupportCard2.png',
  'images/petGroomingCard3.png',
];

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.backgroundWhite,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(children: [
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: ValueConstants.containerMargin),
              child: Row(
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
                            fontWeight: FontWeight.w900),
                      ),
                      Text(
                        "${DateTime.now().day} ${months[DateTime.now().month - 1]} ${DateTime.now().year}",
                        style: TextStyle(color: ColorConstants.darkSlateGrey),
                      ),
                    ],
                  ),

                  Container(
                      /* padding: const EdgeInsets.all(10), */
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: ColorConstants.navLabelHighlight,
                            width: 0.5),
                      ),
                      child: const CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage('images/pfp.png'),
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            //search bar
            Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: ValueConstants.containerMargin),
                decoration: BoxDecoration(
                    color: ColorConstants.navBackground,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                        color: ColorConstants.navLabelHighlight, width: 1)
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
            const SizedBox(
              height: 25,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: ValueConstants.containerMargin),
              child: Row(
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
            ),
            //cards
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: CarouselSlider(
                items: carouselImages
                    .map((e) => Center(
                          child: Image.asset(
                            e,
/*                             fit: BoxFit.cover,
 */
                            width: 1000,
                          ),
                        ))
                    .toList(),
                options: CarouselOptions(
                  viewportFraction: 0.8,
                  autoPlay: false,
                  enableInfiniteScroll: true,
                  height: 170,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.1,
                  autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                    print('Current Index: $currentIndex');
                  },
                ),
              ),
            ),
            //dot indicator
            Container(
              padding: const EdgeInsets.only(top: 5),
              child: AnimatedSmoothIndicator(
                activeIndex: currentIndex,
                count: 3,
                effect: ScaleEffect(
                  activeDotColor: ColorConstants.textDarkGreen,
                  dotHeight: 3,
                  dotWidth: 10,
/*                   dotColor: const Color.fromARGB(155, 175, 175, 175),
 */
                ),
              ),
            )

            //services card rows
            //Electrician, Plumbers, Carpenters
            ,
            const SizedBox(height: 20),
            Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: ValueConstants.containerMargin),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        children: [
                          Text(
                            "New Services",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w800),
                          )
                        ],
                      ),
                      Text("See all >",
                          style: TextStyle(
                              color: ColorConstants.deepGreenAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w500))
                    ])),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: ValueConstants.containerMargin),
              height: 250,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  //card 1
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 140,
                    color: ColorConstants.backgroundWhite,
                    child: Column(children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            "images/bathroom-clean.webp",
                            fit: BoxFit.cover,
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bathroom Cleaning",
                                  style: headerServiceCardTextStyle,
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Color.fromARGB(155, 22, 22, 22),
                                      size: 20,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "4.5",
                                      style: subServiceCardTextStyle,
                                    ),
                                    Text(
                                      "(53k)",
                                      style: subServiceCardTextStyle,
                                    )
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text("₹186", style: priceServiceCardTextStyle)
                              ],
                            )),
                      )
                    ]),
                  ),

                  //card 2
                  Container(
                    width: 140,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: ColorConstants.backgroundWhite,
                    child: Column(children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            "images/ac-repair.webp",
                            fit: BoxFit.cover,
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "AC Repair",
                                  style: headerServiceCardTextStyle,
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Color.fromARGB(155, 22, 22, 22),
                                      size: 20,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "4.5",
                                      style: subServiceCardTextStyle,
                                    ),
                                    Text(
                                      "(53k)",
                                      style: subServiceCardTextStyle,
                                    )
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text("₹162", style: priceServiceCardTextStyle)
                              ],
                            )),
                      )
                    ]),
                  )

                  //card 3
                  ,
                  Container(
                    width: 140,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: ColorConstants.backgroundWhite,
                    child: Column(children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            "images/sofa-cleaning.webp",
                            fit: BoxFit.cover,
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sofa Cleaning",
                                  style: headerServiceCardTextStyle,
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Color.fromARGB(155, 22, 22, 22),
                                      size: 20,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "4.5",
                                      style: subServiceCardTextStyle,
                                    ),
                                    Text(
                                      "(53k)",
                                      style: subServiceCardTextStyle,
                                    )
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text("₹250", style: priceServiceCardTextStyle)
                              ],
                            )),
                      )
                    ]),
                  )
                ],
              ),
            )
          ]),
        )));
  }
}
