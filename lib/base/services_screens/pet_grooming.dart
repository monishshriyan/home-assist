import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homeassist/base/constants.dart';
import 'package:homeassist/main.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PetGrooming extends StatefulWidget {
  const PetGrooming({super.key});

  @override
  State<PetGrooming> createState() => _PetGroomingState();
}

class _PetGroomingState extends State<PetGrooming> {
  final _future = Supabase.instance.client
      .from('service_providers')
      .select(
          'id, service_type_id, image_url, provider_name, description, rating, starting_price,provider_number')
      .eq('service_type_id', 'e4e30482-b459-4cb8-a558-a2545e0532f4')
      .eq('is_booked', false);
  Future<void> _bookServiceProvider(
       String serviceProviderId,DateTime selectedDate, String serviceId, String providerNumber) async {
    final timeNow = DateFormat('HH:mm:ss').format(DateTime.now());
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
      'booked_for': selectedDate.toIso8601String(),
      'booking_time': timeNow,
      'provider_number': providerNumber,
    });}


  Future<bool> _isProviderAvailable(String serviceProviderId,DateTime selectedDate, String userId) async {

  String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
  final response = await supabase
      .from('bookings')
      .select()
      .eq('provider_id', serviceProviderId)
      .eq('booked_for', formattedDate);

  if (response is List<dynamic>) {
    for (var booking in response) {
      String bookedUserId = booking['user_id'];
      DateTime bookedForDate = DateTime.parse(booking['booked_for']);
      // Check if the user has already booked the provider on the same date
      if (bookedUserId == userId && DateFormat('yyyy-MM-dd').format(bookedForDate) == formattedDate) {
        // User has already booked the provider for this date
        return false;
      } 
      // Check if the provider is already booked by someone else for the same date
      else if (bookedUserId != userId) {
        return false;
      }
    }
  }
  return true;
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
                      'Pet Grooming',
                      style: TextStyle(
                          color: ColorConstants.textDarkGreen, fontSize: 28),
                    ),
                  ),
                  backgroundColor: ColorConstants.navBackground,
                ),
                SliverToBoxAdapter(
                    child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: ValueConstants.containerMargin,
                      vertical: ValueConstants.containerMargin),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    child: Image.asset(
                      width: 50,
                      height: 200,
                      "images/petGroomingCard3.png",
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
                                       // Add your booking logic here
                                       DateTime today = DateTime.now();
                                        DateTime? selectedDate = await showDatePicker(
                                          context: context,
                                          initialDate: today,
                                          firstDate: today,
                                          lastDate: today.add(const Duration(days: 5)),
                                          builder: (BuildContext context, Widget? child) {
                                            return Theme(
                                              data: ThemeData.light().copyWith(
                                                // Customize the color of the date picker dialog
                                                primaryColor: Colors.teal,            // Header background color
                                                hintColor: ColorConstants.deepGreenAccent,              // Selected date color
                                                colorScheme: const ColorScheme.light(
                                                  primary: Colors.teal,               // Header background color
                                                  onPrimary: Colors.white,            // Header text color
                                                  surface:Colors.white,         // Background color of date cells
                                                  onSurface: Colors.black,            // Default text color
                                                ),
                                                dialogBackgroundColor: Colors.white,  // Background color of the date picker
                                                textButtonTheme: TextButtonThemeData(
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: ColorConstants.textDarkGreen,             // Button text color
                                                  ),
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (selectedDate != null) {
                                      // Step 2: Insert booking into Supabase
                                      // Assuming you have access to providerId and userId
                                      String providerId = service['id'];  // Provider ID from the current service
                                      String serviceId = service['service_type_id'];
                                      String providerNumber = service['provider_number'] ?? '';
                                      final user = Supabase.instance.client.auth.currentUser; // Replace with the actual user ID, e.g., from user session
                                      String userId = user!.id;
                                      bool isAvailable = await _isProviderAvailable(providerId, selectedDate, userId);
                                      if (!isAvailable) {
                                        // Show appropriate popup based on the availability
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Booking Unavailable'),
                                              content: const Text('Provider currently not available for selected date, choose another date'),
                                              actions: <Widget>[
                                                Center(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                    backgroundColor: ColorConstants.navBackground, // Set the button color
                                                    foregroundColor: ColorConstants.textDarkGreen, // Set the text color
                                                    ),
                                                    child: const Text('OK'),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                      else {
                                      await _bookServiceProvider(providerId, selectedDate, serviceId, providerNumber);
                                      
                                      String formattedDate = DateFormat('dd MMMM').format(selectedDate);

                                      // Step 3: Display the toast with the formatted date
                                      // Fluttertoast.showToast(
                                      //   msg: 'Booking successfully scheduled for $formattedDate!',
                                      //   toastLength: Toast.LENGTH_SHORT,
                                      //   gravity: ToastGravity.BOTTOM,
                                      // );
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Booking Successful!'),
                                              content: Text('Your booking is scheduled for $formattedDate.\nPayment is based on the service provided. We kindly accept cash only.'),
                                              actions: <Widget>[
                                                Center(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                    backgroundColor: ColorConstants.navBackground, // Set the button color
                                                    foregroundColor: ColorConstants.textDarkGreen, // Set the text color
                                                    ),
                                                    child: const Text('OK'),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }
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
