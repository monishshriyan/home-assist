import 'package:flutter/material.dart';
import 'package:homeassist/base/constants.dart';
import 'package:homeassist/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
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
        .select(
            '*, service_providers(provider_name, image_url), service_types(service_type)')
        .eq('user_id', user.id)
        .eq('is_completed', false);

    if (response == null) {
      print('Error fetching bookings');
      return [];
    }

    return response as List<Map<String, dynamic>>;
  }

  Future<void> cancelService(int bookingId) async {
    try {
      final response = await Supabase.instance.client
          .from('bookings')
          .delete()
          .eq('booking_id', bookingId);

      if (response.error != null) {
        throw Exception('Failed to cancel service: ${response.error!.message}');
      }

      // Uncomment this if you have a method to fetch bookings.
    } catch (e) {
      // Print the error to the console
      print('Error: $e');
    }
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
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.hourglass_empty,
                    size: 80,
                    color: Color.fromARGB(137, 62, 62, 62),
                  ),
                  Text(
                    'No bookings yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 107, 107, 107),
                    ),
                  ),
                ],
              ),
            );
          } else {
            final bookings = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  shape: const RoundedRectangleBorder(
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
                          color: ColorConstants.darkSlateGrey, fontSize: 28),
                    ),
                  ),
                  backgroundColor: ColorConstants.navBackground,
                ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          provider['provider_name'] ??
                                              'Unknown Provider',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          service['service_type'] ??
                                              'Unknown Service',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        GestureDetector(
                                          onTap: () async {
                                            final phoneNumber =
                                                booking['provider_number'];
                                            if (phoneNumber != null &&
                                                phoneNumber.isNotEmpty) {
                                              final Uri launchUri = Uri(
                                                scheme: 'tel',
                                                path: phoneNumber,
                                              );
                                              if (await canLaunchUrl(
                                                  launchUri)) {
                                                await launchUrl(launchUri);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Cannot make a call at this moment'),
                                                  ),
                                                );
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Phone number not available'),
                                                ),
                                              );
                                            }
                                          },
                                          child: Text(
                                            'Phone: ${booking['provider_number'] ?? 'Not Provided'}',
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
                                'Scheduled for: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(booking['booked_for']))}',
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
                              const SizedBox(height: 20),

                              // Cancel Service Button
                              SizedBox(
                                width: double
                                    .infinity, // Make the button as wide as the card
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Cancel Service'),
                                          content: const Text(
                                              'Are you sure you want to cancel this service?'),
                                          actions: <Widget>[
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                //backgroundColor: ColorConstants.navBackground, // Set the button color
                                                foregroundColor: ColorConstants
                                                    .deepGreenAccent,
                                                textStyle: const TextStyle(
                                                  fontSize:
                                                      18, // Adjust the font size
                                                ), // Set the text color
                                              ),
                                              child: const Text('Discard'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                //backgroundColor: ColorConstants.navBackground, // Set the button color
                                                foregroundColor: ColorConstants
                                                    .deepGreenAccent,
                                                textStyle: const TextStyle(
                                                  fontSize:
                                                      18, // Adjust the font size
                                                ), // Set the text color
                                              ),
                                              child: const Text('Proceed'),
                                              onPressed: () async {
                                                // Proceed to cancel the service
                                                await cancelService(booking[
                                                    'booking_id']); // Call the cancelService method
                                                Navigator.of(context)
                                                    .pop(); // Close the confirmation dialog

                                                // Show cancellation success message
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Service Cancelled'),
                                                      content: const Text(
                                                          'The service has been cancelled. Please refresh the page.'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                ColorConstants
                                                                    .deepGreenAccent,
                                                            textStyle:
                                                                const TextStyle(
                                                              fontSize:
                                                                  18, // Adjust the font size
                                                            ), // Set the text color
                                                          ),
                                                          child:
                                                              const Text('OK'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            setState(() {
                                                              _bookingsFuture =
                                                                  _fetchBookings();
                                                            }); // Close the success dialog
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ColorConstants.darkSlateGrey,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      elevation: 0),
                                  child: const Text(
                                    'Cancel Service',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
