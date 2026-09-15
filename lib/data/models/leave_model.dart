class LeaveModel {
  final String id;
  final String userId;
  final String leaveType;
  final String startDate;
  final String endDate;
  final String reason;
  final String status;

  LeaveModel({
    required this.id,
    required this.userId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'leaveType': leaveType,
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
      'status': status,
    };
  }

  factory LeaveModel.fromFirestore(
      String id,
      Map<String, dynamic> data,
      ) {
    return LeaveModel(
      id: id,
      userId: data['userId']?.toString() ?? '',
      leaveType: data['leaveType']?.toString() ?? '',
      startDate: data['startDate']?.toString() ?? '',
      endDate: data['endDate']?.toString() ?? '',
      reason: data['reason']?.toString() ?? '',
      status: data['status']?.toString() ?? 'pending',
    );
  }
}