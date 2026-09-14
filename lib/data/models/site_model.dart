class SiteModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double radius;

  SiteModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  factory SiteModel.fromFirestore(
      String id,
      Map<String, dynamic> data,
      ) {
    return SiteModel(
      id: id,
      name: data['name'] ?? '',
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      radius: (data['radius'] as num).toDouble(),
    );
  }
}