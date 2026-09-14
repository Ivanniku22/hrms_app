class AttendanceModel {
  final String id;
  final String userId;
  final String date;
  final String? checkInTime;
  final String? checkOutTime;
  final String status;
  final String? siteId;
  final String? siteName;
  final double? latitude;
  final double? longitude;
  final String? selfiePath;
  final bool synced;

  AttendanceModel({
    required this.id,
    required this.userId,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    required this.status,
    this.siteId,
    this.siteName,
    this.latitude,
    this.longitude,
    this.selfiePath,
    required this.synced,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'status': status,
      'siteId': siteId,
      'siteName': siteName,
      'latitude': latitude,
      'longitude': longitude,
      'selfiePath': selfiePath,
      'synced': synced ? 1 : 0,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      date: map['date'] as String,
      checkInTime: map['checkInTime'] as String?,
      checkOutTime: map['checkOutTime'] as String?,
      status: map['status'] as String,
      siteId: map['siteId'] as String?,
      siteName: map['siteName'] as String?,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      selfiePath: map['selfiePath'] as String?,
      synced: (map['synced'] as int? ?? 0) == 1,
    );
  }
}