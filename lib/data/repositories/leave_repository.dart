import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/leave_model.dart';

class LeaveRepository {
  final FirebaseFirestore _firestore;

  LeaveRepository(this._firestore);

  Future<void> applyLeave(LeaveModel leave) async {
    await _firestore
        .collection('leave_requests')
        .doc(leave.id)
        .set(leave.toMap());
  }

  Stream<List<LeaveModel>> getUserLeaves(String userId) {
    return _firestore
        .collection('leave_requests')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) {
        return snapshot.docs
            .map(
              (doc) => LeaveModel.fromFirestore(
            doc.id,
            doc.data(),
          ),
        )
            .toList();
      },
    );
  }

  Stream<List<LeaveModel>> getPendingLeaves() {
    return _firestore
        .collection('leave_requests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map(
          (snapshot) {
        return snapshot.docs
            .map(
              (doc) => LeaveModel.fromFirestore(
            doc.id,
            doc.data(),
          ),
        )
            .toList();
      },
    );
  }

  Future<void> updateLeaveStatus(
      String leaveId,
      String status,
      ) async {
    await _firestore
        .collection('leave_requests')
        .doc(leaveId)
        .update({
      'status': status,
    });
  }
}