import 'package:flutter/material.dart';
import 'package:homeassist/base/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:homeassist/base/services_screens/ac_repair_screen.dart';
import 'package:homeassist/base/services_screens/bathroom_cleaning_alt.dart';
import 'package:homeassist/base/services_screens/carpenter_screen.dart';
import 'package:homeassist/base/services_screens/electrician_screen.dart';
import 'package:homeassist/base/services_screens/home_cleaning_screen.dart';
import 'package:homeassist/base/services_screens/pet_grooming.dart';
import 'package:homeassist/base/services_screens/plumber_screen.dart';
import 'package:homeassist/base/services_screens/sofa_cleaning_screen.dart';
import 'package:homeassist/base/services_screens/tech_support.dart';
import 'package:homeassist/main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  String _username = '';
  String _avatarUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await _fetchUsername(); // Load Username
    await _fetchAvatarUrl(); // Load Avatar URL
  }

  String? _getCurrentUserId() {
    final user = Supabase.instance.client.auth.currentUser;
    return user?.id;
  }

  Future<void> _fetchUsername() async {
    final userId = _getCurrentUserId();
    if (userId != null) {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('username')
          .eq('id', userId)
          .single();

      final username = response['username'] as String;

      setState(() {
        _username = username;
      });
    }
  }

  Future<void> _fetchAvatarUrl() async {
    final userId = _getCurrentUserId();
    if (userId != null) {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('avatar_url')
          .eq('id', userId)
          .single();

      final avatarUrl = response['avatar_url'] as String;

      setState(() {
        _avatarUrl = avatarUrl;
      });
    }
  }

  void _navigateToScreen(int index) {
    switch (index) {
      case 0:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HomeCleaningScreen()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const TechSupport()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PetGrooming()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.backgroundWhite,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: ValueConstants.containerMargin),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //name
                    Container(
                      margin: const EdgeInsets.only(top: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello $_username',
                            style: TextStyle(
                                /* fontFamily: , */
                                color: ColorConstants.textDarkGreen,
                                fontSize: 24,
                                fontWeight: FontWeight.w900),
                          ),
                          Text(
                            "${DateTime.now().day} ${months[DateTime.now().month - 1]} ${DateTime.now().year}",
                            style:
                                TextStyle(color: ColorConstants.darkSlateGrey),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        navKey.currentState?.updateIndex(3);
                      },
                      child: Container(
                        /* padding: const EdgeInsets.all(10), */
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: ColorConstants.navLabelHighlight,
                              width: 0.5),
                        ),
                        child: _avatarUrl != null
                            ? CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(_avatarUrl!),
                              )
                            : CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(_avatarUrl!),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  navKey.currentState?.updateIndex(1);
                },
                child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: ValueConstants.containerMargin,
                        vertical: 18.0),
                    decoration: BoxDecoration(
                      color: ColorConstants.navBackground,
                      border: Border.all(
                          color: ColorConstants.navLabelHighlight, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                          /* mainAxisAlignment: MainAxisAlignment.spaceBetween, */
                          children: [
                            const Icon(Icons.search,
                                color: Colors.black, size: 25),
                            const SizedBox(
                              width: 12,
                            ),
                            Text("Find Services",
                                style: TextStyle(
                                    color: ColorConstants.darkSlateGrey,
                                    fontSize: 18)),
                          ]),
                    )),
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
                      .asMap()
                      .entries
                      .map((entry) => Center(
                            child: GestureDetector(
                              onTap: () {
                                _navigateToScreen(entry.key);
                              },
                              child: Image.asset(
                                entry.value,
                                width: 1000,
                              ),
                            ),
                          ))
                      .toList(),
                  options: CarouselOptions(
                    viewportFraction: 0.8,
                    autoPlay: true,
                    enableInfiniteScroll: true,
                    height: 170,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.2,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 1000),
                    autoPlayInterval: const Duration(seconds: 5),
                    /*                     autoPlayCurve: Curves.fastOutSlowIn, */
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

              //services card rows1
              //New Services
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const BathroomCleaningAlt()),
                        );
                      },
                      child: Container(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color:
                                              Color.fromARGB(155, 22, 22, 22),
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
                                    Text("from ₹186",
                                        style: priceServiceCardTextStyle)
                                  ],
                                )),
                          )
                        ]),
                      ),
                    ),

                    //card 2
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AcRepairScreen()),
                        );
                      },
                      child: Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 5),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color:
                                              Color.fromARGB(155, 22, 22, 22),
                                          size: 20,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "4.2",
                                          style: subServiceCardTextStyle,
                                        ),
                                        Text(
                                          "(53k)",
                                          style: subServiceCardTextStyle,
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text("from ₹162",
                                        style: priceServiceCardTextStyle)
                                  ],
                                )),
                          )
                        ]),
                      ),
                    )

                    //card 3
                    ,
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SofaCleaningScreen()),
                        );
                      },
                      child: Container(
                        width: 140,
                        margin: const EdgeInsets.only(left: 5),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color:
                                              Color.fromARGB(155, 22, 22, 22),
                                          size: 20,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "4.0",
                                          style: subServiceCardTextStyle,
                                        ),
                                        Text(
                                          "(53k)",
                                          style: subServiceCardTextStyle,
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text("from ₹250",
                                        style: priceServiceCardTextStyle)
                                  ],
                                )),
                          )
                        ]),
                      ),
                    )
                  ],
                ),
              ),

              //service card rows 2

              Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: ValueConstants.containerMargin),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          children: [
                            Text(
                              "Repairs & Fixes",
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ElectricianScreen()),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 140,
                        color: ColorConstants.backgroundWhite,
                        child: Column(children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "images/electrician.jpg",
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
                                      "Electrician",
                                      style: headerServiceCardTextStyle,
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color:
                                              Color.fromARGB(155, 22, 22, 22),
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
                                    Text("from ₹220",
                                        style: priceServiceCardTextStyle)
                                  ],
                                )),
                          )
                        ]),
                      ),
                    ),

                    //card 2
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PlumberScreen()));
                      },
                      child: Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 5),
                        color: ColorConstants.backgroundWhite,
                        child: Column(children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "images/plumber.jpg",
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
                                      "Plumber",
                                      style: headerServiceCardTextStyle,
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color:
                                              Color.fromARGB(155, 22, 22, 22),
                                          size: 20,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "4.0",
                                          style: subServiceCardTextStyle,
                                        ),
                                        Text(
                                          "(53k)",
                                          style: subServiceCardTextStyle,
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text("from ₹190",
                                        style: priceServiceCardTextStyle)
                                  ],
                                )),
                          )
                        ]),
                      ),
                    )

                    //card 3
                    ,
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CarpenterScreen()));
                      },
                      child: Container(
                        width: 140,
                        margin: const EdgeInsets.only(left: 5),
                        color: ColorConstants.backgroundWhite,
                        child: Column(children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "images/carpentar.jpg",
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
                                      "Carpenter",
                                      style: headerServiceCardTextStyle,
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color:
                                              Color.fromARGB(155, 22, 22, 22),
                                          size: 20,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "4.2",
                                          style: subServiceCardTextStyle,
                                        ),
                                        Text(
                                          "(53k)",
                                          style: subServiceCardTextStyle,
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text("from ₹200",
                                        style: priceServiceCardTextStyle)
                                  ],
                                )),
                          )
                        ]),
                      ),
                    )
                  ],
                ),
              )

              //referral card
              ,
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 15, horizontal: ValueConstants.containerMargin),
                child: Image.asset('images/referralCard.png'),
              )
            ]),
          ),
        )));
  }
}
