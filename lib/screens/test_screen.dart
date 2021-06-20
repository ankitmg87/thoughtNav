// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This is screen which is build for testing various modules and widgets

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';
import 'package:thoughtnav/models/avatar_and_display_name.dart';

import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  final service = ResearcherAndModeratorFirestoreService();

  Future<void> _pickImage(BuildContext buildContext) async {
    File pickedImageFile =
    await ImagePickerWeb.getImage(outputType: ImageType.file);

    print(pickedImageFile.type);

    // if (pickedImageFile != null) {
    //   _mediaPickerDialogKey.currentState.setState(() {
    //     _uploadingImage = true;
    //   });
    //
    //   widget.response.hasMedia = true;
    //   widget.response.mediaType = 'image';
    //   widget.response.media = pickedImageFile;
    //
    //   var imageURI = await _participantStorageService.uploadImageToFirebase(
    //       widget.studyName,
    //       _participantUID,
    //       widget.question.questionNumber,
    //       widget.question.questionTitle,
    //       pickedImageFile);
    //
    //   widget.response.mediaURL = imageURI.toString();
    //
    //   _mediaPickerDialogKey.currentState.setState(() {
    //     _uploadingImage = false;
    //   });
    //
    //   setState(() {
    //     _mediaPicked = true;
    //   });
    //
    //   Navigator.of(buildContext).pop();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () async {
            var someVar =  FirebaseFirestore.instance.collection('avatarsAndDisplayNames');
            for(var avatarAndDisplayName in avatarAndDisplayNames){
              await someVar.doc(avatarAndDisplayName.id).set(avatarAndDisplayName.toMap());
            }
          },
          child: Text('Upload', style: TextStyle(color: Colors.black),),
        ),
      ),
    );
  }

  List<AvatarAndDisplayName> avatarAndDisplayNames = [
    AvatarAndDisplayName(
      id: 'Alien.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FAlien.png?alt=media&token=ffd70195-d28f-4997-b908-8ca5d1e51bb8',
      displayName: 'Alien',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Artist.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FArtist.png?alt=media&token=26916c8a-0543-4b21-a3bc-7b2aae7e9dc4',
      displayName: 'Artist',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Bandit.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FBandit.png?alt=media&token=9c140616-04e7-4395-a01e-79ec293c6b8d',
      displayName: 'Bandit',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Batgirl.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FBatgirl.png?alt=media&token=70e138f1-652a-4c45-8d69-addd2274da99',
      displayName: 'Batgirl',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Batman.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FBatman.png?alt=media&token=f50ae31a-e78e-4a44-8af2-fbb9461eef7f',
      displayName: 'Batman',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Black Panther.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FBlack%20Panther.png?alt=media&token=fe9312ff-7fba-4aed-8f4f-af881fbee4cc',
      displayName: 'Black Panther',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Black Widow.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FBlack%20Widow.png?alt=media&token=3f277292-eced-4df4-b31f-a9bbef0d532f',
      displayName: 'Black Widow',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Blackbeard.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FBlackbeard.png?alt=media&token=066e9e40-0b21-40e3-b92b-407c70b7f23b',
      displayName: 'Blackbeard',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Captain Jack.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FCaptain%20Jack.png?alt=media&token=d7500b14-22dc-4889-b574-dce6a57c03fe',
      displayName: 'Captain Jack',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Cat Woman.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FCat%20Woman.png?alt=media&token=e7a31dfc-69ef-431e-b5e6-760d842cd708',
      displayName: 'Cat Woman',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Chaplin.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FChaplin.png?alt=media&token=3e4bdc58-a0c1-43b2-a0ce-2b375a1fe6f1',
      displayName: 'Chaplin',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Chef.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FChef.png?alt=media&token=0f6e4bfd-65c2-4372-b406-938e7c035612',
      displayName: 'Chef',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Clark Kent.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FClark%20Kent.png?alt=media&token=be3c9da3-cea4-447e-8610-64b04b85709b',
      displayName: 'Clark Kent',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Clown.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FClown.png?alt=media&token=9f166c01-605b-485a-a284-036446f3878d',
      displayName: 'Clown',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Cowgirl.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FCowgirl.png?alt=media&token=233bfef4-0674-4bed-a7c9-1077d0c26e3e',
      displayName: 'Cowgirl',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Cyberman.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FCyberman.png?alt=media&token=d2076ba6-d24a-4984-900e-deea4a1f263b',
      displayName: 'Cyberman',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Deadpool.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FDeadpool.png?alt=media&token=0a7a5437-b9bf-45ad-bcca-9c201d2c5f06',
      displayName: 'Deadpool',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Einstein.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FEinstein.png?alt=media&token=5bf189f6-4753-4ef0-875c-9a40e6f48699',
      displayName: 'Einstein',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Farmer.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FFarmer.png?alt=media&token=e35f11a8-f528-456d-b72e-c8ed1618d6e2',
      displayName: 'Farmer',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Firefighter.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FFirefighter.png?alt=media&token=ec7783ce-3bb0-4457-bbf8-577e376838c1',
      displayName: 'Firefighter',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'General.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FGeneral.png?alt=media&token=9aab72ab-8603-4582-8d08-b10fb35970d4',
      displayName: 'General',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Innovator.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FInnvator.png?alt=media&token=66f2ae45-9b2f-4981-9424-80d7b53c1aca',
      displayName: 'Innovator',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Investigator.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FInvestigator.png?alt=media&token=de3cd3f0-34c9-4900-85d2-ebf4014e0804',
      displayName: 'Investigator',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Mad Hatter.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FMad%20Hatter.png?alt=media&token=1a14a67e-c6dd-444b-b646-7f7c1002bd03',
      displayName: 'Mad Hatter',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Marilyn.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FMarilyn.png?alt=media&token=19a35471-4022-408b-9ea7-bb5abea3751f',
      displayName: 'Marilyn',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Morpheus.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FMorpheus.png?alt=media&token=96bfff65-5802-47f2-9468-314bd2ba0d60',
      displayName: 'Morpheus',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Nefertiti.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FNefertiti.png?alt=media&token=c897a0c6-6316-4ccc-a738-7de80d7736e0',
      displayName: 'Nefertiti',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Neo.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FNeo.png?alt=media&token=9a1b3159-ad3f-4811-8b5a-ac84d52fd863',
      displayName: 'Neo',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Ninja.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FNinja.png?alt=media&token=cfaafc25-ce8a-4a47-affd-172066756ba4',
      displayName: 'Ninja',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Paleontologist.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FPaleontologist.png?alt=media&token=dfa848b8-e567-4acd-94d0-b98ef7bbad76',
      displayName: 'Paleontologist',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Parisian.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FParisian.png?alt=media&token=ac441425-b290-422a-8854-7fd3d26d5412',
      displayName: 'Parisian',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Physician.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FPhysician.png?alt=media&token=30f32bcc-b640-4ae5-9249-ab67310f13ed',
      displayName: 'Physician',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Pirate.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FPirate.png?alt=media&token=7d0095d2-d35c-4f98-a472-60d0dba67490',
      displayName: 'Pirate',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Pop Star.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FPop%20Star.png?alt=media&token=0f3bcc97-b163-43f3-b82f-b85811639f7d',
      displayName: 'Pop Star',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Queen.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FQueen.png?alt=media&token=3b63d5a9-60ce-4d65-9bee-c4d92fc957e9',
      displayName: 'Queen',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Rapper.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FRapper.png?alt=media&token=51dbc5b8-00cd-4769-8908-0a1c9bb78c41',
      displayName: 'Rapper',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Ringmaster.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FRingmaster.png?alt=media&token=b0d6a4c3-580e-4812-b8a3-f862b3709b2c',
      displayName: 'Ringmaster',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Robot.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FRobot.png?alt=media&token=3b9daf16-0ec1-404c-9456-9fe3587078ae',
      displayName: 'Robot',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Rock Star.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FRock%20Star.png?alt=media&token=a1e046c8-d10c-46b8-8089-5100c8f207c8',
      displayName: 'Rock Star',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Scuba Diver.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FScuba%20Diver.png?alt=media&token=866a5354-35c4-48b1-8bac-03fdfd7a84cc',
      displayName: 'Scuba Diver',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Sea Dog.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FSea%20Dog.png?alt=media&token=f6d7a919-3ce8-452b-897d-c44b94b5aa9e',
      displayName: 'Sea Dog',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Secret Agent.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FSecret%20Agent.png?alt=media&token=9af584a5-5468-48e7-8458-f44b5e2940bc',
      displayName: 'Secret Agent',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Sherlock.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FSherlock.png?alt=media&token=126145ad-95b7-4062-b493-7e1d343043ee',
      displayName: 'Sherlock',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Showman.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FShowman.png?alt=media&token=6ceaf083-510a-42f3-aa89-c809038ed1a4',
      displayName: 'Showman',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Spiderman.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FSpiderman.png?alt=media&token=d75a5794-033a-4873-9744-4883e8a9c60d',
      displayName: 'Spiderman',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Tesla.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FTesla.png?alt=media&token=6591b971-ca07-4d54-b3a6-cb94c60555a2',
      displayName: 'Tesla',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Trinity.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FTrinity.png?alt=media&token=1a83e996-9e7a-4921-95c9-f3856e6c621b',
      displayName: 'Trinity',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Watson.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-web.appspot.com/o/avatars_new%2FWatson.png?alt=media&token=7e2728df-bda9-44fa-a97d-b474b0a7de03',
      displayName: 'Watson',
      selected: false,
    ),

  ];

}
