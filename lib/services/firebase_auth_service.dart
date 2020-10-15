import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future handleAuth() async {
    String uid;
    await _firebaseAuth
        .signInWithEmailAndPassword(
            email: 'anonymous@123.com', password: 'anonymous')
        .then((value) {
      uid = value.user.uid;
    });

    return uid;
  }
}
