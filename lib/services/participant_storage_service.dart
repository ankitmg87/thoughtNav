// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

import 'dart:html';

import 'package:firebase/firebase.dart' as fb;

const String _FIREBASE_STORAGE_URL = 'gs://thoughtnav-51841.appspot.com';

class ParticipantStorageService {
  final fb.StorageReference participantStorageReference =
      fb.app().storage().refFromURL(_FIREBASE_STORAGE_URL);

  Future<Uri> uploadImageToFirebase(
      String studyName, String participantUID, String questionNumber, String questionTitle, File imageFile) async {
    var imageURI;

    await deletePreviousMedia(studyName, participantUID, questionNumber, questionTitle);

    var uploadTaskSnapshot = participantStorageReference
        .child(
            '$studyName/$participantUID/$questionNumber/$questionTitle')
        .put(imageFile);

    await uploadTaskSnapshot.future.then((value) async {
      imageURI = await value.task.snapshot.ref.getDownloadURL();
    });

    return imageURI;
  }

  Future<Uri> uploadVideoToFirebase(String studyName, String participantUID, String questionNumber,
      String questionTitle, File videoFile) async {
    var videoURI;

    await deletePreviousMedia(studyName, participantUID, questionNumber, questionTitle);

    var uploadTaskSnapshot = participantStorageReference
        .child('$studyName/$participantUID/$questionNumber/$questionTitle')
        .put(videoFile);

    await uploadTaskSnapshot.future.then((value) async {
      videoURI = await value.task.snapshot.ref.getDownloadURL();
    });

    return videoURI;
  }

  Future<void> deletePreviousMedia(
      String studyName, String participantUID, String questionNumber, String questionTitle) async {

    try {
      var previousMediaMetadata = await participantStorageReference
          .child('$studyName/$participantUID/$questionNumber/$questionTitle').getMetadata();

      if(previousMediaMetadata != null) {
        await participantStorageReference.child('$studyName/$participantUID/$questionNumber/$questionTitle').delete();
      }
    }
    catch (e) {
      return;
    }



  }
}
