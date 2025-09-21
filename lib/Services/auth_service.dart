import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String address,
    String? role,
  }) async {
    final userCredential = await _auth
        .createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        )
        .timeout(const Duration(seconds: 25));

    final uid = userCredential.user!.uid;

    await _firestore
        .collection('users')
        .doc(uid)
        .set({
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'email': email.trim(),
      // never store plaintext password
      'phone': phone.trim(),
      'address': address.trim(),
      'role': role ?? 'User',
      'createdAt': FieldValue.serverTimestamp(),
      'profileImageUrl': null,
      'rating': null,
    })
        .timeout(const Duration(seconds: 25));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
  }
}


