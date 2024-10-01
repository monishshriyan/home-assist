import 'package:flutter/material.dart';
import 'package:homeassist/base/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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

  Future<void> _submitRating(int bookingId, int rating) async {
  final response = await Supabase.instance.client
      .from('bookings')
      .update({'rating': rating})
      .eq('booking_id', bookingId);
  }

  void _showRatingDialog(int bookingId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Rate this service', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 30, // Adjust the size of the stars
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  int integerRating = rating.toInt();
                  _submitRating(bookingId, integerRating);    
                },
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(
                fillColor: ColorConstants.navLabelHighlight,
                focusColor: ColorConstants.navLabelHighlight,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorConstants.darkSlateGrey,
                      width: 1), // Change this to the desired focus color
                ),
                hintText: 'Write a Review (optional)',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Call the thank you dialog
              _showThankYouDialog();
            },
            style: TextButton.styleFrom(
              foregroundColor: ColorConstants.deepGreenAccent, // Set the text color
            ),
            child: const Text(
              'Submit',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      );
    },
  );
}

void _showThankYouDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Thank You!'),
        content: const Text(
          'Thanks for your feedback!\nWe appreciate your support.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                // Call _fetchBookings to refresh the screen
                _bookingsFuture = _fetchBookings();
              }); // Close the dialog
            },
            style: TextButton.styleFrom(
              foregroundColor: ColorConstants.deepGreenAccent, // Set the text color
            ),
            child: const Text(
              'OK',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      );
    },
  );
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
                                    radius: 35,
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
                              const SizedBox(height: 5),
                                booking['rating'] == null || booking['rating'] == 0
                                ? 
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorConstants.darkSlateGrey),
                                        onPressed: () {
                                          // Show the rating dialog
                                          _showRatingDialog(booking['booking_id']);
                                        },
                                        child: const Text('Rate Now',style:TextStyle(color: Colors.white),)
                                        ),
                                  ],
                                )
                                // Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       const Text('Rate this service:',
                                //       style: TextStyle(fontSize: 16, color: Colors.black54)),
                                //       RatingBar.builder(
                                //         initialRating: 0,
                                //         minRating: 1,
                                //         direction: Axis.horizontal,
                                //         allowHalfRating: false,
                                //         itemCount: 5,
                                //         itemSize: 30,
                                //         itemBuilder: (context, _) => const Icon(
                                //           Icons.star,
                                //           color: Colors.amber,
                                //         ),
                                //         onRatingUpdate: (rating) {
                                //           // Convert the rating to int and submit
                                //           int integerRating = rating.toInt();
                                //           _submitRating(booking['booking_id'], integerRating);
                                //         },
                                //       ),
                                //     ],
                                //   )
                                : Row(
                                    children: [
                                      const Text(
                                        'You rated this service: ',
                                        style:  TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        booking['rating'].toString(),  // Safely handle the rating display
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                    ],
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
