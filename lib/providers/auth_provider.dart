import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'duty_provider.dart';
import 'journal_provider.dart';
import 'mood_provider.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  Future<void> register(String email, String username, String password) async {
    try {
      // Check if username is already taken
      final querySnapshot = await _firestore.collection('users').where('username', isEqualTo: username).get();
      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('Username is already taken');
      }

      // Register user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Save user info in Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
        'username': username,
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> login(String emailOrUsername, String password) async {
    try {
      String email = emailOrUsername;

      // Check if input is a username and get the corresponding email
      if (!emailOrUsername.contains('@')) {
        final querySnapshot = await _firestore.collection('users').where('username', isEqualTo: emailOrUsername).get();
        if (querySnapshot.docs.isEmpty) {
          throw Exception('Username not found');
        }
        email = querySnapshot.docs.first.data()['email'];
      }

      // Login with email and password
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Provider.of<DutyProvider>(context, listen: false).clearDuties();
    Provider.of<JournalProvider>(context, listen: false).clearEntries();
    Provider.of<MoodProvider>(context, listen: false).clearMoods();
  }
}
