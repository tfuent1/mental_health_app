import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'duty_provider.dart';
import 'journal_provider.dart';
import 'mood_provider.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
      if (user != null) {
        _initializeUserProviders();
      } else {
        _clearUserProviders();
      }
    });
  }

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  Future<void> register(String email, String username, String password) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: username).get();
      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('Username is already taken');
      }
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
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
      if (!emailOrUsername.contains('@')) {
        final querySnapshot = await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: emailOrUsername).get();
        if (querySnapshot.docs.isEmpty) {
          throw Exception('Username not found');
        }
        email = querySnapshot.docs.first.data()['email'];
      }
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    _clearUserProviders();
    Provider.of<DutyProvider>(context, listen: false).clearDuties();
    Provider.of<JournalProvider>(context, listen: false).clearEntries();
    Provider.of<MoodProvider>(context, listen: false).clearMoods();
  }

  void _initializeUserProviders() {
    // Trigger data fetching for providers
    notifyListeners();
  }

  void _clearUserProviders() {
    // Clear data for providers
    notifyListeners();
  }
}
