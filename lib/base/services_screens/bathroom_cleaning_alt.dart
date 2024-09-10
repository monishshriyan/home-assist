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
      .from('services')
      .select() /* .eq('service_name', 'Electrician') */;

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
                    title: Text('Electrician Services'),
                  ),
                  backgroundColor: ColorConstants.navBackground,
                ),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  service!['image_url'].toString(),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
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
                                      'Book Now',
                                      style: TextStyle(
                                        color: ColorConstants.textWhite,
                                      ),
                                    ),
                                  ),
                                  Text('from ₹${service['price'].toString()}'),
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
