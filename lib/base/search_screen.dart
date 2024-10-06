import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:homeassist/base/constants.dart';
import 'package:homeassist/base/components/db_model.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  List<ServiceModel> allservices = [];
  List<ServiceModel> filteredServices = [];
  final SupabaseClient supabase = Supabase.instance.client;
  TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  Future<void> _bookServiceProvider(String serviceProviderId,
      DateTime selectedDate, String serviceId, String providerNumber) async {
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
    });
  }

  Future<bool> _isProviderAvailable(
      String serviceProviderId, DateTime selectedDate, String userId) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    final response = await supabase
        .from('bookings')
        .select()
        .eq('provider_id', serviceProviderId)
        .eq('booked_for', formattedDate);

    for (var booking in response) {
      String bookedUserId = booking['user_id'];
      DateTime bookedForDate = DateTime.parse(booking['booked_for']);
      bool isAvailable = booking['is_available'] ?? false;
      // Check if the user has already booked the provider on the same date
      if (bookedUserId == userId &&
          DateFormat('yyyy-MM-dd').format(bookedForDate) == formattedDate) {
        // User has already booked the provider for this date
        return false;
      }
      // Check if the provider is already booked by someone else for the same date
      else if (bookedUserId != userId && !isAvailable) {
        return false;
      }
    }
      return true;
  }

  Future<List<ServiceModel>> _fetchServices() async {
    //print("Fetching services...");
    final response = await supabase.from('service_providers').select();
    //print("Database response: $response");

    if (response is List<dynamic>) {
      // Map the response to your model
      List<ServiceModel> allservices = response
          .map((item) => ServiceModel.fromMap(item as Map<String, dynamic>))
          .toList();
      //print('Data fetched: $allservices');
      return allservices;
    } else {
      throw Exception('Failed to load services');
      //print('failed to load services');
    }
  }

  Future<void> _fetchData() async {
    List<ServiceModel> services = await _fetchServices();
    setState(() {
      allservices = services;
      filteredServices = services;
    });
  }

  void _filterServices(String searchText) {
    List<ServiceModel> filtered = allservices.where((service) {
      final serviceName = service.serviceName.toLowerCase();
      final providerName = service.providerName.toLowerCase();
      final searchLower = searchText.toLowerCase();

      return serviceName.contains(searchLower) ||
          providerName.contains(searchLower);
    }).toList();

    setState(() {
      filteredServices = filtered;
    });
    //print('Filtered services: $filteredServices');
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    searchController.addListener(() {
      _filterServices(searchController.text);
    });
    _scrollController.addListener(() {
      // Unfocus the TextField when scrolling
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        _focusNode.unfocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        //backgroundColor: ColorConstants.backgroundWhite,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: ValueConstants.containerMargin,
                      vertical: 18.0),
                  decoration: BoxDecoration(
                    color: ColorConstants.navBackground,
                    border: Border.all(
                        color: ColorConstants.navLabelHighlight, width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: _focusNode,
                          controller: searchController,
                          // onChanged: (value) => _filterServices(value),
                          decoration: const InputDecoration(
                            hintText: 'Find Services',
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 18),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 25,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          searchController.clear();
                          _filterServices('');
                        },
                      )
                    ],
                  ),
                ),
              ),
              filteredServices.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'No results found',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final service = filteredServices[index];
                          return Card(
                            color: ColorConstants.navBackground,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  // Image
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      service.imgUrl
                                          .toString(), // placeholder image
                                    ),
                                    radius: 30,
                                  ),
                                  const SizedBox(
                                      width:
                                          10), // Space between image and text

                                  // Title and subtitle
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          service.providerName.toString(),
                                          style: headerServiceProviderTextStyle,
                                        ),
                                        Text(
                                          service.serviceName.toString(),
                                          style:
                                              subheaderServiceProviderTextStyle,
                                        ),
                                        Text(service.description),
                                        Text('✦ ${service.rating.toString()}'),
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
                                        onPressed: () async {
                                          // Add your booking logic here
                                          DateTime today = DateTime.now();
                                          DateTime? selectedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: today,
                                            firstDate: today,
                                            lastDate: today
                                                .add(const Duration(days: 5)),
                                            builder: (BuildContext context,
                                                Widget? child) {
                                              return Theme(
                                                data:
                                                    ThemeData.light().copyWith(
                                                  // Customize the color of the date picker dialog
                                                  primaryColor: Colors
                                                      .teal, // Header background color
                                                  hintColor: ColorConstants
                                                      .deepGreenAccent, // Selected date color
                                                  colorScheme:
                                                      const ColorScheme.light(
                                                    primary: Colors
                                                        .teal, // Header background color
                                                    onPrimary: Colors
                                                        .white, // Header text color
                                                    surface: Colors
                                                        .white, // Background color of date cells
                                                    onSurface: Colors
                                                        .black, // Default text color
                                                  ),
                                                  dialogBackgroundColor: Colors
                                                      .white, // Background color of the date picker
                                                  textButtonTheme:
                                                      TextButtonThemeData(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          ColorConstants
                                                              .textDarkGreen, // Button text color
                                                    ),
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                            initialEntryMode: DatePickerEntryMode.calendarOnly
                                          );
                                          if (selectedDate != null) {
                                            // Step 2: Insert booking into Supabase
                                            // Assuming you have access to providerId and userId
                                            String providerId = service
                                                .id; // Provider ID from the current service
                                            String serviceId =
                                                service.service_id;
                                            String providerNumber =
                                                service.providerNumber ?? '';
                                            final user = Supabase
                                                .instance
                                                .client
                                                .auth
                                                .currentUser; // Replace with the actual user ID, e.g., from user session
                                            String userId = user!.id;
                                            bool isAvailable =
                                                await _isProviderAvailable(
                                                    providerId,
                                                    selectedDate,
                                                    userId);
                                            if (!isAvailable) {
                                              // Show appropriate popup based on the availability
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Booking Unavailable',textAlign: TextAlign.center,),
                                                    content: const Text(
                                                        'Provider currently not available\n choose another date or wait for some time.',textAlign: TextAlign.center,),
                                                    actions: <Widget>[
                                                      Center(
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                ColorConstants
                                                                    .navBackground, // Set the button color
                                                            foregroundColor:
                                                                ColorConstants
                                                                    .textDarkGreen, // Set the text color
                                                          ),
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              await _bookServiceProvider(
                                                  providerId,
                                                  selectedDate,
                                                  serviceId,
                                                  providerNumber);

                                              String formattedDate =
                                                  DateFormat('dd MMMM')
                                                      .format(selectedDate);

                                              // Step 3: Display the toast with the formatted date
                                              // Fluttertoast.showToast(
                                              //   msg: 'Booking successfully scheduled for $formattedDate!',
                                              //   toastLength: Toast.LENGTH_SHORT,
                                              //   gravity: ToastGravity.BOTTOM,
                                              // );
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor: Colors.white,
                                                    title: const Text(
                                                        'Booking Successful!',textAlign: TextAlign.center,),
                                                    content: Text(
                                                        'Your booking is scheduled for $formattedDate.\nPayment is based on the service provided. We kindly accept cash only.',textAlign: TextAlign.center,),
                                                    actions: <Widget>[
                                                      Center(
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                ColorConstants
                                                                    .navBackground, // Set the button color
                                                            foregroundColor:
                                                                ColorConstants
                                                                    .textDarkGreen, // Set the text color
                                                          ),
                                                          child:
                                                              const Text('OK'),
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
                                        'from ₹${service.price.toString()}',
                                        style: TextStyle(
                                            color:
                                                ColorConstants.textLightGrey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: filteredServices.length,
                      ),
                    ),
            ],
          ),
        )));
  }
}
