import 'package:flutter/material.dart';
import 'package:homeassist/base/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({super.key});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  late Future<List<Map<String, dynamic>>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = _fetchBookings(); // Initialize the future
  }

  Future<List<Map<String, dynamic>>> _fetchBookings() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return [];
    }

    final response = await Supabase.instance.client
        .from('bookings')
        .select('*, service_providers(provider_name, image_url,provider_number), service_types(service_type)')
        .eq('user_id', user.id)
        .eq('is_completed', true);

    return response;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }  else {
            final bookings = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  shape:const  RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                  ),
                  expandedHeight: 50.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      'Past Bookings',
                      style: TextStyle(
                          color: ColorConstants.textDarkGreen, fontSize: 28),
                    ),
                  ),
                  //backgroundColor: ColorConstants.navBackground,
                ),
                 if (bookings.isEmpty) 
                  const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Icon(
                            Icons.clear_all_rounded,
                            size: 150,
                            color: Colors.black,
                          ),
                           SizedBox(height: 20),
                           Text(
                            'No Bookings Yet!',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            'You can keep a track of all your completed bookings here.',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                )
                
                else 
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final booking = bookings[index];
                      final provider = booking['service_providers'];
                      final service = booking['service_types'];

                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Provider Image
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      provider['image_url'] ?? '',
                                    ),
                                    radius: 30,
                                  ),
                                  const SizedBox(width: 10),

                                  // Provider Name and Service Type
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          provider['provider_name'] ?? 'Unknown Provider',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          service['service_type'] ?? 'Unknown Service',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        GestureDetector(
                                          onTap: () async {
                                            final phoneNumber = provider['provider_number'];
                                            if (phoneNumber != null && phoneNumber.isNotEmpty) {
                                              final Uri launchUri = Uri(
                                                scheme: 'tel',
                                                path: phoneNumber,
                                              );
                                              if (await canLaunchUrl(launchUri)) {
                                                await launchUrl(launchUri);
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Cannot make a call at this moment'),
                                                  ),
                                                );
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Phone number not available'),
                                                ),
                                              );
                                            }
                                          },
                                          child: Text(
                                            'Phone: ${provider['provider_number'] ?? 'Not Provided'}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Booking Date (booked_for)
                              Text(
                                'Scheduled on: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(booking['booked_for']))}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 5),

                              // Payment Mode
                              Text(
                                'Payment Mode: ${booking['payment_mode'] ?? 'Not Specified'}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: bookings.length,
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
