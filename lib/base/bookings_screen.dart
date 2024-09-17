import 'package:flutter/material.dart';
import 'package:homeassist/base/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  Future<List<Map<String, dynamic>>> _fetchBookings() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return [];
    }

    final response = await Supabase.instance.client
        .from('bookings')
        .select('*, service_providers(provider_name, image_url)')
        .eq('user_id', user.id);

    if (response == null) {
      print('Error fetching bookings');
      return [];
    }

    return response as List<Map<String, dynamic>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookings available'));
          } else {
            final bookings = snapshot.data!;
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
                      'My Bookings',
                      style: TextStyle(
                          color: ColorConstants.textDarkGreen, fontSize: 28),
                    ),
                  ),
                  backgroundColor: ColorConstants.navBackground,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final booking = bookings[index];
                      final provider = booking['service_providers'];
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
                                  provider['image_url'] ?? '',
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
                                      provider['provider_name'] ??
                                          'Unknown Provider',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                        'Booking Date: ${booking['booking_date']}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: bookings.length,
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
