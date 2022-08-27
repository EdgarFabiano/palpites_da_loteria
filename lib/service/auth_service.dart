import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthService._internal();
  static final AuthService _singleton = AuthService._internal();

  factory AuthService() {
    return _singleton;
  }

  FirebaseAuth getFirebaseAuthInstance() {
    return _firebaseAuth;
  }

  // GET UID
  String? getCurrentUID() {
    if (getCurrentUser() != null) {
      return getCurrentUser()!.uid;
    }
    return null;
  }

  // GET CURRENT USER
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  getProfileImage() {
    if (getCurrentUser() != null && getCurrentUser()?.photoURL != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(getCurrentUser()!.photoURL!),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  // Sign Out
  signOut() {
    return _firebaseAuth.signOut();
  }

  // GOOGLE
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await _firebaseAuth.signInWithCredential(credential);
  }
}
