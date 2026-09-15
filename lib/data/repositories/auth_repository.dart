import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/firebase_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseService _firebaseService;

  AuthRepository({
    required FirebaseService firebaseService,
  }) : _firebaseService = firebaseService;

  Future<UserModel> login(String email, String password) async {
    try {
      final credential =
      await _firebaseService.auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        throw Exception('Login failed. Please try again.');
      }

      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        await _firebaseService.auth.signOut();
        throw Exception('User profile not found.');
      }

      final user = UserModel.fromFirestore(
        firebaseUser.uid,
        userDoc.data()!,
      );

      if (user.role.isEmpty) {
        await _firebaseService.auth.signOut();
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
    } catch (e) {
      throw Exception(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _firebaseService.auth.currentUser;

    // No existing Firebase session.
    if (firebaseUser == null) {
      return null;
    }


    try {
      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      // Firebase session exists, but Firestore profile doesn't.
      if (!userDoc.exists || userDoc.data() == null) {
        await _firebaseService.auth.signOut();
        throw Exception('User profile not found.');
      }

      final user = UserModel.fromFirestore(
        firebaseUser.uid,
        userDoc.data()!,
      );

      // Profile exists but role is missing.
      if (user.role.isEmpty) {
        await _firebaseService.auth.signOut();
        throw Exception('User role is not configured.');
      }

      return user;
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw Exception(
          'Unable to restore session. Please check your internet connection.',
        );
      }

      throw Exception(
        e.message ?? 'Unable to restore session.',
      );
    } catch (e) {
      throw Exception(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> logout() async {
    await _firebaseService.auth.signOut();
  }
}