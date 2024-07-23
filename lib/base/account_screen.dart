import 'package:flutter/material.dart';
import 'package:homeassist/base/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.backgroundWhite,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: ValueConstants.containerMargin),
                padding: const EdgeInsets.only(top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Back icon
                    IconButton(
  icon: const Icon(Icons.keyboard_arrow_left_outlined, size: 35),
  onPressed: () {
    Navigator.pushReplacementNamed(context, '/home');
  },
),

                    SizedBox(
                      width: 10
                    ),
                    //Profile Text
                    Text(
                          ' My Profile',
                          style: TextStyle(
                                /* fontFamily: , */
                                color: ColorConstants.textDarkGreen,
                                fontSize: 24,
                                fontWeight: FontWeight.w900),
                          ), 
                    SizedBox(
                      width: 10
                    ),
                    //Edit icon
                    const Icon(Icons.mode_edit_outline_outlined,size: 30,),
                  ],
                )
              ),
              SizedBox(
                height: 35,
              ),
              //Profile Info
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: ValueConstants.containerMargin),
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                          radius: 46,
                          backgroundImage: AssetImage('images/pfp.png'),
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Transform.translate(
                          offset: Offset(0, -15),
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                            "Ho Lee Fok",
                            style: TextStyle(
                                /* fontFamily: , */
                                color: ColorConstants.textDarkGreen,
                                fontSize: 26,
                                fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "+91 7206942069",
                            style: TextStyle(
                                /* fontFamily: , */
                                color: ColorConstants.textLightGrey,
                                fontSize: 16,
                                fontWeight: FontWeight.w900),
                          ),
                          ]
                        ),
                        ),
                  ]
                )
              ),
              ],
            ),
          ),
          )
        )
    );
  }
}
