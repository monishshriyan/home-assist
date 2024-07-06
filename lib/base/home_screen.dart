import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:homeassist/base/constants.dart';

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
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(children: [
          const SizedBox(
            height: 30,
          ),
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
                        color: colorConstants.textDarkGreen,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${DateTime.now().day} ${months[DateTime.now().month]} ${DateTime.now().year}",
                    style: TextStyle(color: colorConstants.darkSlateGrey),
                  ),
                ],
              ),

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorConstants.navLabelHighlight,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.notifications,
                  color: colorConstants.textDarkGreen,
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
                color: colorConstants.navBackground,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(15),
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Find Services"), Icon(Icons.search)]),
              ))
        ]),
      ),
    );
  }
}
