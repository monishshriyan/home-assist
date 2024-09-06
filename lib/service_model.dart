class ServiceModel {
  final String id;
  final String serviceName;
  final String providerName;
  final double rating;
  final double price;
  final String description;

  ServiceModel({
    required this.id,
    required this.serviceName,
    required this.providerName,
    required this.rating,
    required this.price,
    this.description = '',
  });

  // Method to convert Map to ServiceModel
  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'] as String,
      serviceName: map['service_name'] as String,
      providerName: map['provider_name'] as String,
      rating: map['rating'] as double,
      price: map['price'] as double,
      description: map['description'] as String? ?? '',
    );
  }

  // Method to convert ServiceModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'service_name': serviceName,
      'provider_name': providerName,
      'rating': rating,
      'price': price,
      'description': description,
    };
  }
}