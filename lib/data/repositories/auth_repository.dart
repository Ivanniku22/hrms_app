import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> login(String email, String password) async {
    try {
      // STEP 1: Firebase Authentication
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      print('STEP 1: Firebase Auth successful');

      // STEP 2: Get Firebase user
      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        throw Exception('Login failed. Please try again.');
      }

      print('STEP 2: UID = ${firebaseUser.uid}');

      // STEP 3: Get Firestore profile
      final userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      print('STEP 3: Firestore document fetched');
      print('STEP 4: Document exists = ${userDoc.exists}');
      print('STEP 5: Document data = ${userDoc.data()}');

      // STEP 4: Profile must exist
      if (!userDoc.exists || userDoc.data() == null) {
        await _auth.signOut();
        throw Exception('User profile not found.');
      }

      // STEP 5: Convert Firestore data to UserModel
      final user = UserModel.fromFirestore(
        firebaseUser.uid,
        userDoc.data()!,
      );

      print('STEP 6: UserModel created');
      print('STEP 7: Role = ${user.role}');

      // STEP 6: Role must exist
      if (user.role.isEmpty) {
        await _auth.signOut();
        throw Exception('User role is not configured.');
      }

      print('STEP 8: Login repository completed successfully');

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
    } catch (e) {
      print('UNEXPECTED ERROR: $e');

      throw Exception(
        'Unexpected error: $e',
      );
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}