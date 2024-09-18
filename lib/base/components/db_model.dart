class ServiceModel {
  final String id;
  final String serviceName;
  final String providerName;
  final double rating;
  final int price;
  final String imgUrl;
  final String description;

  ServiceModel({
    required this.id,
    required this.serviceName,
    required this.providerName,
    required this.rating,
    required this.price,
    required this.imgUrl,
    this.description = '',
  });

  // Method to convert Map to ServiceModel
  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'] as String,
      serviceName: map['service_type'] as String,
      providerName: map['provider_name'] as String,
      rating: map['rating'] as double,
      price: map['starting_price'] as int,
      imgUrl: map['image_url'] as String,
      description: map['description'] as String? ?? '',
    );
  }

  // Method to convert ServiceModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'service_type': serviceName,
      'provider_name': providerName,
      'rating': rating,
      'starting_price': price,
      'image_url': imgUrl,
      'description': description,
    };
  }
}