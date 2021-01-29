import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/response.dart';
import 'package:thoughtnav/services/participant_firestore_service.dart';
import 'package:thoughtnav/services/participant_storage_service.dart';
import 'package:video_player/video_player.dart';

class ParticipantResponseField extends StatefulWidget {
  final String studyName;
  final String topicUID;
  final Response response;

  // final String questionNumber;
  // final String questionTitle;
  // final Response response;
  final Question question;
  final Participant participant;
  final TextEditingController responseController;

  final Function onTap;

  const ParticipantResponseField({
    Key key,
    // this.response,
    this.question,
    this.participant,
    this.onTap,
    this.studyName,
    this.topicUID,
    this.responseController,
    this.response,
    // this.questionNumber,
    // this.questionTitle
  }) : super(key: key);

  @override
  _ParticipantResponseFieldState createState() =>
      _ParticipantResponseFieldState();
}

class _ParticipantResponseFieldState extends State<ParticipantResponseField> {
  final _participantStorageService = ParticipantStorageService();

  final _participantFirestoreService = ParticipantFirestoreService();

  final _mediaPickerDialogKey = GlobalKey();

  String _studyUID;
  String _participantUID;

  bool _uploadingImage = false;
  bool _uploadingVideo = false;
  bool _mediaPicked = false;

  bool _smartphoneScreen;

  NetworkImage _pickedImage;

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  // Response _response;

  Future<void> _pickImage(BuildContext buildContext) async {
    var pickedImageFile =
        await ImagePickerWeb.getImage(outputType: ImageType.file);

    if (pickedImageFile != null) {
      _mediaPickerDialogKey.currentState.setState(() {
        _uploadingImage = true;
      });

      widget.response.hasMedia = true;
      widget.response.mediaType = 'image';
      widget.response.media = pickedImageFile;

      var imageURI = await _participantStorageService.uploadImageToFirebase(
          widget.studyName,
          _participantUID,
          widget.question.questionNumber,
          widget.question.questionTitle,
          pickedImageFile);

      widget.response.mediaURL = imageURI.toString();

      _mediaPickerDialogKey.currentState.setState(() {
        _uploadingImage = false;
      });

      setState(() {
        _mediaPicked = true;
      });

      Navigator.of(buildContext).pop();
    }
  }

  Future<void> _pickVideo(BuildContext buildContext) async {
    File pickedVideoFile =
        await ImagePickerWeb.getVideo(outputType: VideoType.file);

    if (pickedVideoFile != null) {
      _mediaPickerDialogKey.currentState.setState(() {
        _uploadingVideo = true;
      });

      widget.response.hasMedia = true;
      widget.response.mediaType = 'video';
      widget.response.media = pickedVideoFile;

      var videoURI = await _participantStorageService.uploadVideoToFirebase(
          widget.studyName,
          widget.participant.participantUID,
          widget.question.questionNumber,
          widget.question.questionTitle,
          pickedVideoFile);

      widget.response.mediaURL = videoURI.toString();

      _videoPlayerController =
          VideoPlayerController.network(widget.response.mediaURL);

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        looping: true,
        showControls: false,
      );

      _mediaPickerDialogKey.currentState.setState(() {
        _uploadingVideo = false;
      });

      setState(() {
        _mediaPicked = true;
      });

      Navigator.of(buildContext).pop();
    }
  }

  void _showMediaPickerDialog(bool smartphoneScreen) async {
    await showGeneralDialog(
      context: context,
      barrierLabel: 'Media Picker',
      barrierDismissible: false,
      pageBuilder: (BuildContext mediaPickerContext,
          Animation<double> animation, Animation<double> secondaryAnimation) {
        return StatefulBuilder(
          key: _mediaPickerDialogKey,
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Center(
              child: Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.4),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: _uploadingVideo || _uploadingImage
                        ? _smartphoneScreen
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    _uploadingVideo
                                        ? 'Uploading Video'
                                        : 'Uploading Image',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    _uploadingVideo
                                        ? 'Uploading Video'
                                        : 'Uploading Image',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(),
                                  Text(
                                    'Pick Media',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(mediaPickerContext).pop();
                                    },
                                    splashColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.red[700],
                                      size: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                height: 1.0,
                                width: double.maxFinite,
                                color: Colors.grey[300],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  widget.question.allowImage
                                      ? Expanded(
                                          child: RaisedButton(
                                            onPressed: () async {
                                              await _pickImage(
                                                  mediaPickerContext);
                                            },
                                            child: Text('Image'),
                                          ),
                                        )
                                      : SizedBox(),
                                  widget.question.allowImage &&
                                          widget.question.allowVideo
                                      ? SizedBox(
                                          width: 20.0,
                                        )
                                      : SizedBox(),
                                  widget.question.allowVideo
                                      ? Expanded(
                                          child: RaisedButton(
                                            onPressed: () async {
                                              await _pickVideo(
                                                  mediaPickerContext);
                                            },
                                            child: Text('Video'),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              )
                            ],
                          ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    var getStorage = GetStorage();

    _studyUID = getStorage.read('studyUID');
    _participantUID = getStorage.read('participantUID');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _smartphoneScreen =
        MediaQuery.of(context).size.width < MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Card(
        color: Colors.white,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.participant.profilePhotoURL,
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: PROJECT_LIGHT_GREEN,
                            ),
                            child: Image(
                              image: imageProvider,
                              width: 18.0,
                              height: 18.0,
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        widget.participant.displayName,
                        style: TextStyle(
                          color: TEXT_COLOR,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[100],
                    ),
                    child: _smartphoneScreen
                        ? Column(
                            children: [
                              TextFormField(
                                minLines: 3,
                                maxLines: 20,
                                controller: widget.responseController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: 'Write your response here',
                                ),
                                onChanged: (responseStatement) {
                                  setState(() {
                                    widget.response.responseStatement =
                                        responseStatement;
                                  });
                                },
                              ),
                              SizedBox(
                                width: widget.question.allowImage ||
                                        widget.question.allowVideo
                                    ? 20.0
                                    : 0.0,
                              ),
                              widget.response.questionHasMedia
                                  ? _mediaPicked
                                      ? widget.response.mediaType == 'image'
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  widget.response.mediaURL,
                                              imageBuilder:
                                                  (context, imageProvider) {
                                                return Align(
                                                  child: InkWell(
                                                    onTap: () {
                                                      _showMediaPickerDialog(
                                                          _smartphoneScreen);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          color: Colors.white),
                                                      constraints:
                                                          BoxConstraints(
                                                        maxHeight: 200.0,
                                                        maxWidth: 300.0,
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(10.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Image(
                                                          fit: BoxFit.cover,
                                                          image: imageProvider,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              padding: EdgeInsets.all(10.0),
                                              constraints: BoxConstraints(
                                                maxHeight: 200.0,
                                                maxWidth: 300.0,
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  _showMediaPickerDialog(
                                                      _smartphoneScreen);
                                                },
                                                child: Chewie(
                                                  controller: _chewieController,
                                                ),
                                              ),
                                            )
                                      : InkWell(
                                          onTap: () {
                                            _showMediaPickerDialog(
                                                _smartphoneScreen);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              border: Border.all(
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.add_circle_outline,
                                                  color: Colors.grey[900],
                                                  size: 16.0,
                                                ),
                                                SizedBox(
                                                  width: 20.0,
                                                ),
                                                Text(
                                                  'Image/Video',
                                                  style: TextStyle(
                                                    color: Colors.grey[900],
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                  : SizedBox(),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  minLines: 3,
                                  maxLines: 20,
                                  controller: widget.responseController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: 'Write your response here',
                                  ),
                                  onChanged: (responseStatement) {
                                    setState(() {
                                      widget.response.responseStatement =
                                          responseStatement;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: widget.question.allowImage ||
                                        widget.question.allowVideo
                                    ? 20.0
                                    : 0.0,
                              ),
                              widget.response.questionHasMedia
                                  ? _mediaPicked
                                      ? widget.response.mediaType == 'image'
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  widget.response.mediaURL,
                                              imageBuilder:
                                                  (context, imageProvider) {
                                                return Align(
                                                  child: InkWell(
                                                    onTap: () {
                                                      _showMediaPickerDialog(
                                                          _smartphoneScreen);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          color: Colors.white),
                                                      constraints:
                                                          BoxConstraints(
                                                        maxHeight: 200.0,
                                                        maxWidth: 300.0,
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(10.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Image(
                                                          fit: BoxFit.cover,
                                                          image: imageProvider,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              padding: EdgeInsets.all(10.0),
                                              constraints: BoxConstraints(
                                                maxHeight: 200.0,
                                                maxWidth: 300.0,
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  _showMediaPickerDialog(
                                                      _smartphoneScreen);
                                                },
                                                child: Chewie(
                                                  controller: _chewieController,
                                                ),
                                              ),
                                            )
                                      : InkWell(
                                          onTap: () {
                                            _showMediaPickerDialog(
                                                _smartphoneScreen);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              border: Border.all(
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.add_circle_outline,
                                                  color: Colors.grey[900],
                                                  size: 16.0,
                                                ),
                                                SizedBox(
                                                  height: 20.0,
                                                ),
                                                Text(
                                                  'Image/Video',
                                                  style: TextStyle(
                                                    color: Colors.grey[900],
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                  : SizedBox(),
                            ],
                          ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: widget.response.responseStatement == null
                  ? widget.onTap
                  : widget.response.responseStatement.isEmpty
                      ? null
                      : widget.onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.response.responseStatement == null
                      ? Colors.grey[300]
                      : widget.response.responseStatement.isEmpty
                          ? Colors.grey[300]
                          : PROJECT_GREEN,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(4.0),
                    bottomRight: Radius.circular(4.0),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            'POST',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
