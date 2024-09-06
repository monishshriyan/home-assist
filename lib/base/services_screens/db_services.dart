import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:homeassist/service_model.dart';

class DbServices{
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<ServiceModel>> fetchServices(String searchText) async {
    final response = await supabase
        .from('services')
        .select()
        .ilike('provider_name', '%$searchText%')
        .ilike('service_name', '%$searchText%'); // Use `eq` for exact match

    if (response is List<dynamic>) {
      // Map the response to your model
      List<ServiceModel> services = response
          .map((item) => ServiceModel.fromMap(item as Map<String, dynamic>))
          .toList();
      return services;
    } else {
      throw Exception('Failed to load services');
    }
  }
}