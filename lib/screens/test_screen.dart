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
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FAlien.png?alt=media&token=bc33e43f-1364-4fa8-9d1c-52cf5a274fc8',
      displayName: 'Alien',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Artist.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FArtist.png?alt=media&token=b6bd90df-9b98-4807-ab52-d12c821bf0b1',
      displayName: 'Artist',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Bandit.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FBandit.png?alt=media&token=a4cc8044-4616-46db-9030-dc9c480a339b',
      displayName: 'Bandit',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Batgirl.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FBatgirl.png?alt=media&token=ac9bff5b-6552-4e18-b68f-23564641b826',
      displayName: 'Batgirl',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Batman.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FBatman.png?alt=media&token=dd27c85d-f4af-4255-a5d5-c7a3dfa8bf4c',
      displayName: 'Batman',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Black Panther.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FBlack%20Panther.png?alt=media&token=01e63cac-3358-4eb1-b6a9-d812af139b3a',
      displayName: 'Black Panther',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Black Widow.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FBlack%20Widow.png?alt=media&token=2b3c3e9e-1fdd-4842-8caa-8f98af725cff',
      displayName: 'Black Widow',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Blackbeard.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FBlackbeard.png?alt=media&token=fec411e4-9bcc-4680-bd0f-9a5d71ba5c75',
      displayName: 'Blackbeard',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Captain Jack.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FCaptain%20Jack.png?alt=media&token=cc865c9d-6fdf-4478-8ad8-3c0d16fa60dc',
      displayName: 'Captain Jack',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Cat Woman.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FCat%20Woman.png?alt=media&token=729e3eb8-a34f-45b8-9593-ad145a36facb',
      displayName: 'Cat Woman',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Chaplin.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FChaplin.png?alt=media&token=991d7c64-883e-43b3-9b9d-dce26c28f439',
      displayName: 'Chaplin',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Chef.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FChef.png?alt=media&token=090d41ea-c5f3-4e33-86d2-f3d0e32615b6',
      displayName: 'Chef',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Clark Kent.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FClark%20Kent.png?alt=media&token=35d3e9ca-bc12-428e-a5aa-78a5b58bfa2d',
      displayName: 'Clark Kent',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Clown.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FClown.png?alt=media&token=2248a8b6-f384-47ce-89f3-4b06cce00793',
      displayName: 'Clown',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Cowgirl.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FCowgirl.png?alt=media&token=19bed87a-bf36-47c3-bcb7-749a4874ed8e',
      displayName: 'Cowgirl',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Cyberman.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FCyberman.png?alt=media&token=637c9630-fccc-49ac-9ad9-60078844b479',
      displayName: 'Cyberman',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Deadpool.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FDeadpool.png?alt=media&token=34313e0e-8258-4ad6-baaf-fe6dc4ae99f3',
      displayName: 'Deadpool',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Einstein.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FEinstein.png?alt=media&token=d29956df-5c90-4124-b7d9-852be693723f',
      displayName: 'Einstein',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Farmer.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FFarmer.png?alt=media&token=e58a6e54-c428-48f4-8378-b117b8dde606',
      displayName: 'Farmer',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Firefighter.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FFirefighter.png?alt=media&token=c0277a24-3092-4928-9282-a7b7dd63d1e7',
      displayName: 'Firefighter',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'General.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FGeneral.png?alt=media&token=6e95111f-c11a-4874-b930-f3bd1c69e208',
      displayName: 'General',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Innovator.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FInnvator.png?alt=media&token=fac00e3c-4b19-41fd-8c92-8c147231ad36',
      displayName: 'Innovator',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Investigator.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FInvestigator.png?alt=media&token=75cf1b10-47dd-4902-bd76-32f6a1c1527c',
      displayName: 'Investigator',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Mad Hatter.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FMad%20Hatter.png?alt=media&token=290624f8-f978-4d2e-b93a-8c0c3af1acd1',
      displayName: 'Mad Hatter',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Marilyn.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FMarilyn.png?alt=media&token=1bec652b-cad7-4d0d-9789-64c3a6133105',
      displayName: 'Marilyn',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Morpheus.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FMorpheus.png?alt=media&token=4893249e-3076-4407-83e8-71eb44fc8e47',
      displayName: 'Morpheus',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Nefertiti.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FNefertiti.png?alt=media&token=59fe1619-d3b0-49de-adfa-4b460361ac4b',
      displayName: 'Nefertiti',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Neo.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FNeo.png?alt=media&token=d2a38067-82f0-4ad5-8e53-7b38d8af2f60',
      displayName: 'Neo',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Ninja.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FNinja.png?alt=media&token=3f246545-da85-4d60-88a4-840203a61fd6',
      displayName: 'Ninja',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Paleontologist.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FPaleontologist.png?alt=media&token=4d4196e2-a448-4534-9468-641f0a52b6e7',
      displayName: 'Paleontologist',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Parisian.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FParisian.png?alt=media&token=1e7f2140-4891-456b-8688-15b7c0ff0469',
      displayName: 'Parisian',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Physician.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FPhysician.png?alt=media&token=be4325f3-56b5-49ff-a47a-38b11d23767a',
      displayName: 'Physician',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Pirate.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FPirate.png?alt=media&token=771dc2da-9893-4416-a9e5-b5953acb3b12',
      displayName: 'Pirate',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Pop Star.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FPop%20Star.png?alt=media&token=3abfb47d-a7e6-4061-941a-1dc939643f5f',
      displayName: 'Pop Star',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Queen.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FQueen.png?alt=media&token=b65a9c84-808a-49bd-a7ed-f491fb959292',
      displayName: 'Queen',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Rapper.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FRapper.png?alt=media&token=ce23ed4c-50a7-4006-826e-30643083c366',
      displayName: 'Rapper',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Ringmaster.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FRingmaster.png?alt=media&token=3dec312a-fe48-45c4-a911-5d419a48b737',
      displayName: 'Ringmaster',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Robot.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FRobot.png?alt=media&token=d970b53b-b652-47f6-bed6-0d00c8df52b7',
      displayName: 'Robot',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Rock Star.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FRock%20Star.png?alt=media&token=48549316-a4fc-4966-a985-36b4b1e2557e',
      displayName: 'Rock Star',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Scuba Diver.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FScuba%20Diver.png?alt=media&token=e003b952-da8b-4352-8a88-181d8707e293',
      displayName: 'Scuba Diver',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Sea Dog.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FSea%20Dog.png?alt=media&token=f8238216-4003-451d-8901-f78cb9dc2a91',
      displayName: 'Sea Dog',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Secret Agent.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FSecret%20Agent.png?alt=media&token=3a97795b-5f27-4df4-9b29-646318fb8532',
      displayName: 'Secret Agent',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Sherlock.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FSherlock.png?alt=media&token=22f9d8f4-91c7-4453-9373-0e116a8677ac',
      displayName: 'Sherlock',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Showman.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FShowman.png?alt=media&token=68c1a682-8716-4f7a-8c6d-3946644d9c5b',
      displayName: 'Showman',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Spiderman.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FSpiderman.png?alt=media&token=c03eec31-1c39-4de0-84a0-207b956153c1',
      displayName: 'Spiderman',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Tesla.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FTesla.png?alt=media&token=98cf6a35-8e00-4002-8d6b-a14b88780447',
      displayName: 'Tesla',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Trinity.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FTrinity.png?alt=media&token=4683c91c-c858-4dc1-8915-67e52d906041',
      displayName: 'Trinity',
      selected: false,
    ),
    AvatarAndDisplayName(
      id: 'Watson.png',
      avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-dev.appspot.com/o/avatars_new%2FWatson.png?alt=media&token=62862b10-8c56-4f47-b72f-c80e18f267a0',
      displayName: 'Watson',
      selected: false,
    ),

  ];

}
