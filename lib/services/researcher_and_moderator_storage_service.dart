// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

import 'dart:html';

import 'package:firebase/firebase.dart' as fb;

const String _FIREBASE_STORAGE_URL = 'gs://thoughtnav-51841.appspot.com';

class ResearcherAndModeratorStorageService {
  final fb.StorageReference _researcherAndModeratorStorageReference =
      fb.app().storage().refFromURL(_FIREBASE_STORAGE_URL);


  Future<Uri> uploadAvatarToFirebase(String moderatorUID, File imageFile) async {

    var imageURI;

    await deletePreviousAvatar(moderatorUID);

    var uploadTaskSnapshot = _researcherAndModeratorStorageReference.child('moderatorAvatars/$moderatorUID').put(imageFile);

    await uploadTaskSnapshot.future.then((value) async {
      imageURI = await value.task.snapshot.ref.getDownloadURL();
    });

    return imageURI;
  }

  Future<void> deletePreviousAvatar(String moderatorUID) async {

    try{
      var previousAvatarMetaData = await _researcherAndModeratorStorageReference.child('moderatorAvatars/$moderatorUID').getMetadata();

      if(previousAvatarMetaData != null) {
        await _researcherAndModeratorStorageReference.child('moderatorAvatars/$moderatorUID').delete();
      }
    }
    catch (e) {
      return;
    }

  }

}
