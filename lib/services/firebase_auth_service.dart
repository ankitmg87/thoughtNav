import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signInUser(String email, String password) async {
    String uid;
    await _firebaseAuth
        .signInWithEmailAndPassword(
            email: email, password: password)
        .then((value) {
      uid = value.user.uid;
    });

    return uid;
  }

  Future<String> signUpUser(String email, String password) async {
    String userUID;

    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((userCredential){
      userUID = userCredential.user.uid;
    });

    return userUID;
  }

}
