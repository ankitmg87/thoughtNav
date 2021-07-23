// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file carries various methods for communicating with Firebase authentication

import 'package:firebase_auth/firebase_auth.dart';

import 'dart:js' as js;

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signInUser(String email, String password) async {
    var uid = '';

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password).then((value) {
            uid = value.user.uid;
      });
    } catch (error) {
      switch(error.code){
        case 'user-not-found':
          uid = 'user-not-found';
          break;
        case 'wrong-password':
          uid = 'wrong-password';
          break;
        case 'invalid-email':
          uid = 'invalid-email';
          break;
        default:
          uid = 'user-not-found';
          break;
      }
    }

    return uid;
  }

  Future<String> signUpUser(String email, String password) async {
    String userUID;
    try{
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((userCredential) {
        userUID = userCredential.user.uid;
      });
    }
    catch (e){
      userUID = e.code;
      js.context.callMethod('alertMessage', ['The user with the email-id $email was not created.']);
    }
    return userUID;
  }

  Future changeUserPassword(String newPassword) async {
    var user = await _firebaseAuth.currentUser;
    await user.updatePassword(newPassword);
  }

  Future<String> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return null;
    }
    catch (e) {
      return e.message;
    }
  }

  Future signOutUser() async {
    await _firebaseAuth.signOut();
  }
}
