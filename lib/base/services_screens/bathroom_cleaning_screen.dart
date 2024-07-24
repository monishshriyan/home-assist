import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeassist/base/constants.dart';

class BathroomCleaningScreen extends StatelessWidget {
  const BathroomCleaningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
            ),
            backgroundColor: ColorConstants.navBackground,
            leading: null,
            pinned: true, // pin the app bar
            floating: true, // float the app bar
            snap: true, // snap the app bar
            expandedHeight: 150, // expanded height of the app bar
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Bathroom Cleaning',
                style: TextStyle(
                    color: ColorConstants.textDarkGreen, fontSize: 28),
              ),
              background: Container(
                decoration: BoxDecoration(
                    color: ColorConstants.navBackground,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: ValueConstants.containerMargin),
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://picsum.photos/200/300', // placeholder image
                            ),
                            radius: 30,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Service Provider $index',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('Rating: 4.5/5'),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                overlayColor: ColorConstants.darkSlateGrey,
                                elevation: 0,
                                backgroundColor: ColorConstants.navBackground,
                                shape: (RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)))),
                            onPressed: () {
                              // book button pressed
                              print('Book button pressed');
                            },
                            child: Text('Book',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: ColorConstants.darkSlateGrey)),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: 10, // number of items in the list
            ),
          ),
        ],
      ),
    );
  }
}
