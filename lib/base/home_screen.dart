import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:homeassist/base/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:homeassist/base/pages/splash_screen.dart';
import 'package:homeassist/base/services_screens/ac_repair_screen.dart';
import 'package:homeassist/base/services_screens/bathroom_cleaning_alt.dart';
import 'package:homeassist/base/services_screens/bathroom_cleaning_screen.dart';
import 'package:homeassist/base/services_screens/sofa_cleaning_screen.dart';
import 'package:homeassist/main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  var searchhistory = [];
  int currentIndex = 0;
  String _username = '';

  final SearchController controller = SearchController();

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _fetchUsername();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      searchhistory = prefs.getStringList('search_history') ?? [];
    });
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'search_history', List<String>.from(searchhistory));
  }

  void _handleSearchSubmit() {
    String itext = controller.text.trim();
    if (itext.isNotEmpty) {
      setState(() {
        searchhistory.insert(0, itext);
        searchhistory =
            searchhistory.toSet().toList(); // Ensures unique entries
        if (searchhistory.length > 5) {
          searchhistory = searchhistory.sublist(0, 5);
        }
        _saveSearchHistory();
        controller.clear(); // Clear the search bar after submission
      });
    }
  }

  Future<void> _fetchUsername() async {
    final userId = supabase.auth.currentSession?.user.id;
    if (userId != null) {
      final response = await supabase
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

                    Container(
                        /* padding: const EdgeInsets.all(10), */
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: ColorConstants.navLabelHighlight,
                              width: 0.5),
                        ),
                        child: const InkWell(
                          child: CircleAvatar(
                            radius: 28,
                            backgroundImage: AssetImage('images/pfp.png'),
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              //search bar
              SearchAnchor(
                searchController: controller,
                //search view
                viewHintText: "Find Services",
                headerHintStyle: TextStyle(
                  color: ColorConstants.textDarkGreen,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
                viewBackgroundColor: Color.fromARGB(255, 255, 255, 255),
                //viewBackgroundColor: ColorConstants.backgroundWhite,
                viewConstraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                viewTrailing: [
                  IconButton(
                    onPressed: () {
                      _handleSearchSubmit();
                    },
                    icon: const Icon(Icons.search),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.clear();
                    },
                    icon: const Icon(Icons.clear_rounded),
                  ),
                ],
                viewOnSubmitted: (value) => _handleSearchSubmit(),
                //the search bar that is appearing on the home screen
                builder: (context, controller) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: ColorConstants.navLabelHighlight, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: SearchBar(
                      elevation: const WidgetStatePropertyAll(0.0),
                      controller: controller,
                      leading: IconButton(
                        onPressed: () => controller.openView(),
                        icon: const Icon(Icons.search),
                      ),
                      /*                     trailing: [
                        IconButton(
                          onPressed: (){
                          }, 
                          icon: const Icon(Icons.mic),
                        )
                      ], 
    */
                      hintText: "Find Services",
                      backgroundColor:
                          WidgetStatePropertyAll(ColorConstants.navBackground),
                      onTap: () => controller.openView(),
                    ),
                  );
                },
                //suggestion screen
                suggestionsBuilder: (context, controller) {
                  return [
                    if (searchhistory
                        //displaying the list with context
                        .isNotEmpty) //displaying the list with context
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: ValueConstants.containerMargin),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.history,
                                color: ColorConstants.textDarkGreen,
                                size: 26,
                              ),
                              //context
                              const SizedBox(width: 8.0),
                              Text(
                                //context
                                'Recents',
                                style: TextStyle(
                                  color: ColorConstants.textDarkGreen,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: ValueConstants.containerMargin),
                      child: Wrap(
                          children: List.generate(
                        searchhistory.length,
                        (index) {
                          final item = searchhistory[index];
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 4.0, right: 4.0),
                            child: ChoiceChip(
                              label: Text(
                                item,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: item == controller.text
                                        ? const Color.fromARGB(255, 0, 0, 0)
                                        : const Color.fromARGB(
                                            255, 14, 25, 19)),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4.0),
                              selected: item == controller.text,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              backgroundColor: ColorConstants.navBackground,
                              selectedColor:
                                  const Color.fromARGB(255, 154, 237, 186),
                              onSelected: (value) {
                                controller.text = item;
                                controller.closeView(item);
                              },
                            ),
                          );
                        },
                      )),
                    )
                  ];
                },
              ),
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
                              builder: (context) => BathroomCleaningAlt()),
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
                                    Text("₹186",
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
                                    Text("₹162",
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
                                    Text("₹250",
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
