import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore;

  ProfileRepository(this._firestore);

  Future<UserModel?> getUserProfile(String uid) async {
    final document = await _firestore
        .collection('users')
        .doc(uid)
        .get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return UserModel.fromFirestore(
      document.id,
      document.data()!,
    );
  }
}