import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> checkUserType(String uid) async {

    String userType;

    await _firestore.collection('users').doc(uid).get().then((value) {
      userType = value.get('userType');
    });

    return userType;
  }

  Future createStudy() async {

  }

  Future saveStudy() async {

  }

}