import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth;
  User? _user;

  AuthProvider({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  Future<void> register(String email, String username, String password) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('users_public').where('username', isEqualTo: username).get();
      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('Username is already taken');
      }
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance.collection('users_public').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'email': email,
        'username': username,
      });
      await FirebaseFirestore.instance.collection('users_private').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'email': email,
        // Add any other private information here
      });
      _user = userCredential.user;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> login(String emailOrUsername, String password) async {
    try {
      String email = emailOrUsername;
      if (!emailOrUsername.contains('@')) {
        final querySnapshot = await FirebaseFirestore.instance.collection('users_public').where('username', isEqualTo: emailOrUsername).get();
        if (querySnapshot.docs.isEmpty) {
          throw Exception('Username not found');
        }
        email = querySnapshot.docs.first.data()['email'];
      }
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
