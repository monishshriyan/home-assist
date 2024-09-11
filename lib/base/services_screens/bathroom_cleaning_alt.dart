import 'package:flutter/material.dart';
import 'package:homeassist/base/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BathroomCleaningAlt extends StatefulWidget {
  const BathroomCleaningAlt({super.key});

  @override
  State<BathroomCleaningAlt> createState() => _BathroomCleaningAltState();
}

class _BathroomCleaningAltState extends State<BathroomCleaningAlt> {
  final _future = Supabase.instance.client
      .from('service_providers')
      .select()
      .eq('service_type_id', 'c0ba4eae-0931-43c1-b85a-9226e7ae28d7');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final services = snapshot.data;
            print('Data fetched: $services');
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                  ),
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      'Bathroom Cleaning',
                      style: TextStyle(
                          color: ColorConstants.textDarkGreen, fontSize: 28),
                    ),
                  ),
                  backgroundColor: ColorConstants.navBackground,
                ),
                SliverToBoxAdapter(
                    child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: ValueConstants.containerMargin,
                      vertical: ValueConstants.containerMargin),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: Image.asset(
                      width: 50,
                      height: 200,
                      "images/bathroom-clean.webp",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                )),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final service = services?[index];
                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              // Image
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  service!['image_url']
                                      .toString(), // placeholder image
                                ),
                                radius: 30,
                              ),
                              const SizedBox(
                                  width: 10), // Space between image and text

                              // Title and subtitle
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      service['provider_name'].toString(),
                                      style: headerServiceProviderTextStyle,
                                    ),
                                    Text('${service['description']}'),
                                    Text('✦ ${service['rating'].toString()}'),
                                  ],
                                ),
                              ),

                              // Book Now button and price
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ColorConstants.darkSlateGrey,
                                      elevation: 0.1, // Remove elevation
                                    ),
                                    onPressed: () {
                                      // Add your booking logic here
                                      print(
                                          'Book Now pressed for ${service['provider_name']}');
                                    },
                                    child: Text(
                                      'Book',
                                      style: TextStyle(
                                        color: ColorConstants.textWhite,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'from ₹${service['starting_price'].toString()}',
                                    style: TextStyle(
                                        color: ColorConstants.textLightGrey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: services?.length,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
