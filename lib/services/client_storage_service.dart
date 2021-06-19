// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file carries various methods for communicating with Firebase storage

import 'dart:html';

import 'package:firebase/firebase.dart' as fb;

const String _FIREBASE_STORAGE_URL = 'gs://thoughtnav-51841.appspot.com';

class ClientStorageService {
  final fb.StorageReference _clientStorageReference =
      fb.app().storage().refFromURL(_FIREBASE_STORAGE_URL);


  Future<Uri> uploadAvatarToFirebase(String clientUID, File imageFile) async {
    var imageURI;


    await deletePreviousAvatar(clientUID);

    var uploadTaskSnapshot = _clientStorageReference.child('clientAvatars/$clientUID').put(imageFile);

    await uploadTaskSnapshot.future.then((value) async {
      imageURI = await value.task.snapshot.ref.getDownloadURL();
    });

    return imageURI;
  }

  Future<void> deletePreviousAvatar(String clientUID) async {

    try{
      var previousAvatarMetaData = await _clientStorageReference.child('clientAvatars/$clientUID').getMetadata();

      if(previousAvatarMetaData != null) {
        await _clientStorageReference.child('clientAvatars/$clientUID').delete();
      }
    }
    catch (e) {
      return;
    }

  }

}
