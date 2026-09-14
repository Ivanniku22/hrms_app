class AttendanceModel {
  final String id;
  final String userId;
  final String siteId;
  final DateTime checkInTime;
  final double latitude;
  final double longitude;
  final bool locationVerified;
  final bool selfieVerified;

  AttendanceModel({
    required this.id,
    required this.userId,
    required this.siteId,
    required this.checkInTime,
    required this.latitude,
    required this.longitude,
    required this.locationVerified,
    required this.selfieVerified,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'siteId': siteId,
      'checkInTime': checkInTime.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'locationVerified': locationVerified,
      'selfieVerified': selfieVerified,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      siteId: map['siteId'] as String,
      checkInTime: DateTime.parse(map['checkInTime'] as String),
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      locationVerified: map['locationVerified'] as bool,
      selfieVerified: map['selfieVerified'] as bool,
    );
  }
}