import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      .select(
          'id, service_type_id, image_url, provider_name, description, rating, starting_price')
      .eq('service_type_id', 'c0ba4eae-0931-43c1-b85a-9226e7ae28d7')
      .eq('is_booked', false);

  Future<void> _bookServiceProvider(
      BuildContext context, String serviceProviderId, String serviceId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      Fluttertoast.showToast(
        msg: 'You need to be logged in to book a service.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    // Insert a new booking
    await Supabase.instance.client.from('bookings').insert({
      'user_id': user.id,
      'provider_id': serviceProviderId,
      'service_id': serviceId,
      'booking_date': DateTime.now().toIso8601String(),
    });

    // Update the service provider's status to indicate they're booked
    await Supabase.instance.client
        .from('service_providers')
        .update({'is_booked': true}).eq('id', serviceProviderId);

    Fluttertoast.showToast(
      msg: 'Booking successful!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

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
            final services = snapshot.data as List<Map<String, dynamic>>;
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
                      final service = services[index];
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
                                  service['image_url'] ?? '',
                                ),
                                radius: 30,
                              ),
                              const SizedBox(width: 10),

                              // Title and subtitle
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      service['provider_name'] ?? '',
                                      style: headerServiceProviderTextStyle,
                                    ),
                                    Text(service['description'] ?? ''),
                                    Text('✦ ${service['rating'] ?? 'N/A'}'),
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
                                      elevation: 0.1,
                                    ),
                                    onPressed: () async {
                                      await _bookServiceProvider(
                                        context,
                                        service['id'],
                                        service['service_type_id'],
                                      );
                                    },
                                    child: Text(
                                      'Book',
                                      style: TextStyle(
                                        color: ColorConstants.textWhite,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'from ₹${service['starting_price'] ?? 'N/A'}',
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
                    childCount: services.length,
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
