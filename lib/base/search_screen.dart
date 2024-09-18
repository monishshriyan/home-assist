import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:homeassist/base/constants.dart';
import 'package:homeassist/base/components/db_model.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<ServiceModel> allservices = [];
  List<ServiceModel> filteredServices = [];
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<ServiceModel>> _fetchServices() async {
    print("Fetching services...");  
    final response = await supabase
        .from('service_providers')
        .select(); 
    print("Database response: $response");

    if (response is List<dynamic>) {
      // Map the response to your model
      List<ServiceModel> allservices = response
          .map((item) =>ServiceModel.fromMap(item as Map<String, dynamic>))
          .toList();
      print('Data fetched: $allservices');
      return allservices;
      
    } else {
      throw Exception('Failed to load services');
      print('failed to load services');
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
      
      return serviceName.contains(searchLower) || providerName.contains(searchLower);
    }).toList();

    setState(() {
      filteredServices = filtered;
    });
    print('Filtered services: $filteredServices');
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child:  CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: ValueConstants.containerMargin,
                          vertical: 18.0),
                        decoration: BoxDecoration(
                          color: ColorConstants.navBackground,
                         border: Border.all(
                          color: ColorConstants.navLabelHighlight, width: 1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: TextField(
                          onChanged: (value) => _filterServices(value),
                          decoration: InputDecoration(
                            hintText: 'Find Services',
                            hintStyle: TextStyle(color: Colors.black,fontSize: 18),
                            prefixIcon: Icon(Icons.search, color: Colors.black,size: 25,),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final service = filteredServices[index];
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
                                  service.imgUrl
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
                                      service.providerName.toString(),
                                      style: headerServiceProviderTextStyle,
                                    ),
                                    Text(
                                      service.serviceName.toString(),
                                      style: subheaderServiceProviderTextStyle,
                                    ),
                                    Text('${service.description}'),
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
                                    onPressed: () {
                                      // Add your booking logic here
                                      print(
                                          'Book Now pressed for ${service.providerName}');
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
                                        color: ColorConstants.textLightGrey),
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
        )
      )
    );
  }
}
