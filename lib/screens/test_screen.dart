import 'dart:html';

import 'package:flutter/material.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';

import 'dart:js' as js;

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
            await service.createAvatarAndDisplayNameList('');
          },
          child: Text('Pick Video'),
        ),
      ),
    );
  }
}
