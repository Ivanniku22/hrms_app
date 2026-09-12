import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Login Code
  Future<UserModel> login(String email, String password) async {
    try {
      // 1. Sign in with Firebase Authentication
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        throw Exception('Login failed. Please try again.');
      }

      // 2. Get the user's Firestore profile
      final userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      // 3. Profile must exist
      if (!userDoc.exists || userDoc.data() == null) {
        await _auth.signOut();
        throw Exception('User profile not found.');
      }

      // 4. Convert Firestore data to UserModel
      final user = UserModel.fromFirestore(
        firebaseUser.uid,
        userDoc.data()!,
      );

      // 5. Role must exist
      if (user.role.isEmpty) {
        await _auth.signOut();
        throw Exception('User role is not configured.');
      }

      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          throw Exception('Invalid email or password.');

        case 'invalid-email':
          throw Exception('Please enter a valid email address.');

        case 'user-disabled':
          throw Exception('This account has been disabled.');

        case 'network-request-failed':
          throw Exception(
            'No internet connection. Please check your connection.',
          );

        default:
          throw Exception(
            e.message ?? 'Login failed. Please try again.',
          );
      }
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw Exception(
          'No internet connection. Please check your connection.',
        );
      }

      throw Exception(
        e.message ?? 'Something went wrong. Please try again.',
      );
    }
  }


  // Logout Code
  Future<void> logout() async {
    await _auth.signOut();
  }
}