import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase_storage/firebase_storage.dart';

const String _FIREBASE_STORAGE_URL = 'gs://thoughtnav-51841.appspot.com';

class ParticipantStorageService {
  final fb.StorageReference participantStorageReference =
      fb.app().storage().refFromURL(_FIREBASE_STORAGE_URL);

  Future<Uri> uploadImageToFirebase(
      String studyName, String participantUID, File imageFile) async {
    var imageURI;

    var timestamp = Timestamp.now();

    var uploadTaskSnapshot = participantStorageReference
        .child(
            '$studyName/$participantUID/${timestamp.millisecondsSinceEpoch}${imageFile.name}')
        .put(imageFile);

    await uploadTaskSnapshot.future.then((value) async {
      imageURI = await value.task.snapshot.ref.getDownloadURL();
    });

    return imageURI;
  }

  Future<Uri> uploadVideoToFirebase(
      String studyName, String participantUID, File videoFile) async {
    var videoURI;

    var timestamp = Timestamp.now();

    var uploadTaskSnapshot = participantStorageReference
        .child(
            '$studyName/$participantUID/${timestamp.millisecondsSinceEpoch}${videoFile.name}')
        .put(videoFile);

    await uploadTaskSnapshot.future.then((value) async {
      videoURI = await value.task.snapshot.ref.getDownloadURL();
    });

    return videoURI;
  }
}
