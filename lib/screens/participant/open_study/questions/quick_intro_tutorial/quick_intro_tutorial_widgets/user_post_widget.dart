import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/participant/open_study/questions/quick_intro_tutorial/quick_intro_tutorial_widgets/comment_widget.dart';
import 'package:thoughtnav/screens/researcher/models/comment.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/screens/researcher/models/response.dart';
import 'package:thoughtnav/services/participant_firestore_service.dart';
import 'package:thoughtnav/services/participant_storage_service.dart';
import 'package:video_player/video_player.dart';

class UserResponseWidget extends StatefulWidget {
  final String topicUID;
  final String questionUID;
  final Response response;
  final Participant participant;

  const UserResponseWidget({
    Key key,
    this.response,
    this.topicUID,
    this.questionUID,
    this.participant,
  }) : super(key: key);

  @override
  _UserResponseWidgetState createState() => _UserResponseWidgetState();
}

class _UserResponseWidgetState extends State<UserResponseWidget> {
  final _participantFirestoreService = ParticipantFirestoreService();
  final _participantStorageService = ParticipantStorageService();

  final _mediaPickerKey = GlobalKey();

  final TextEditingController _commentController = TextEditingController();

  bool _clapped = false;
  bool _editResponse = false;
  bool _expanded = false;
  bool _uploadingVideo = false;
  bool _uploadingImage = false;

  String _studyName;
  String _studyUID;
  String _participantUID;
  String _commentStatement;

  String _date;
  String _time;
  String _timeElapsed;

  // Comment _comment;

  Stream<QuerySnapshot> _lastCommentStream;
  Stream<QuerySnapshot> _commentsStream;

  List<Comment> _comments;

  bool _isExpanded = false;

  bool _mediaPicked = false;

  NetworkImage _pickedImage;

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  void _getLastCommentStream(String studyUID, String topicUID,
      String questionUID, String responseUID) {
    _lastCommentStream = _participantFirestoreService.streamLastComment(
        studyUID, topicUID, questionUID, responseUID);
  }

  Future<void> _postComment(
    String studyUID,
    String respondedParticipantUID,
    String participantUID,
    String topicUID,
    String questionUID,
    String responseUID,
    String questionNumber,
    String questionTitle,
    Comment comment,
  ) async {
    await _participantFirestoreService.postComment(
      studyUID,
      respondedParticipantUID,
      participantUID,
      topicUID,
      questionUID,
      responseUID,
      questionNumber,
      questionTitle,
      comment,
    );
  }

  Stream<QuerySnapshot> _getCommentsStream(String studyUID, String topicUID,
      String questionUID, String responseUID) {
    return _participantFirestoreService.getComments(
        studyUID, topicUID, questionUID, responseUID);
  }

  Future<void> _pickImage(BuildContext buildContext) async {
    var pickedImageFile =
        await ImagePickerWeb.getImage(outputType: ImageType.file);

    if (pickedImageFile != null) {
      _mediaPickerKey.currentState.setState(() {
        _uploadingImage = true;
      });

      widget.response.hasMedia = true;
      widget.response.mediaType = 'image';
      widget.response.media = pickedImageFile;

      var imageURI = await _participantStorageService.uploadImageToFirebase(
          _studyName,
          _participantUID,
          widget.response.questionNumber,
          widget.response.questionTitle,
          pickedImageFile);

      widget.response.mediaURL = imageURI.toString();

      _mediaPickerKey.currentState.setState(() {
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
      _mediaPickerKey.currentState.setState(() {
        _uploadingVideo = true;
      });

      widget.response.hasMedia = true;
      widget.response.mediaType = 'video';
      widget.response.media = pickedVideoFile;

      var videoURI = await _participantStorageService.uploadVideoToFirebase(
          _studyName,
          widget.participant.participantUID,
          widget.response.questionNumber,
          widget.response.questionTitle,
          pickedVideoFile);

      widget.response.mediaURL = videoURI.toString();

      _videoPlayerController =
          VideoPlayerController.network(widget.response.mediaURL);

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        //allowFullScreen: false,
        autoPlay: true,
        looping: true,
        showControls: false,
      );

      _mediaPickerKey.currentState.setState(() {
        _uploadingVideo = false;
      });

      setState(() {
        _mediaPicked = true;
      });

      Navigator.of(buildContext).pop();
    }
  }

  void _showMediaPickerDialog() async {
    await showGeneralDialog(
      context: context,
      barrierLabel: 'Media Picker',
      barrierDismissible: false,
      pageBuilder: (BuildContext mediaPickerContext,
          Animation<double> animation, Animation<double> secondaryAnimation) {
        return StatefulBuilder(
          key: _mediaPickerKey,
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Center(
              child: Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.3),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: _uploadingVideo || _uploadingImage
                        ? Row(
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
                                  Expanded(
                                    child: RaisedButton(
                                      onPressed: () async {
                                        await _pickImage(mediaPickerContext);
                                      },
                                      child: Text('Image'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Expanded(
                                    child: RaisedButton(
                                      onPressed: () async {
                                        await _pickVideo(mediaPickerContext);
                                      },
                                      child: Text('Video'),
                                    ),
                                  )
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

  void _calculateTimeDifference() {
    var formatDate = DateFormat(DateFormat.ABBR_MONTH_DAY);
    var formatTime = DateFormat.jm();

    _date = formatDate.format(widget.response.responseTimestamp.toDate());
    _time = formatTime.format(widget.response.responseTimestamp.toDate());

    var timeNow = DateTime.now();
    var difference = timeNow.difference(DateTime.fromMillisecondsSinceEpoch(
        widget.response.responseTimestamp.millisecondsSinceEpoch));

    _timeElapsed = '';

    if (difference.inDays >= 7) {
      if (difference.inDays == 7) {
        _timeElapsed = (difference.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        _timeElapsed = (difference.inDays / 7).ceil().toString() + ' WEEKS AGO';
      }
    } else if (difference.inDays > 0 && difference.inDays < 7) {
      if (difference.inDays == 1) {
        _timeElapsed = difference.inDays.toString() + ' DAY AGO';
      } else {
        _timeElapsed = difference.inDays.toString() + ' DAYS AGO';
      }
    } else if (difference.inHours > 0 && difference.inDays == 0) {
      if (difference.inHours == 1) {
        _timeElapsed = difference.inHours.toString() + ' HOUR AGO';
      } else {
        _timeElapsed = difference.inHours.toString() + ' HOURS AGO';
      }
    } else if (difference.inMinutes > 0 && difference.inHours == 0) {
      if (difference.inMinutes == 1) {
        _timeElapsed = difference.inMinutes.toString() + ' MINUTE AGO';
      } else {
        _timeElapsed = difference.inMinutes.toString() + ' MINUTES AGO';
      }
    } else if (difference.inSeconds <= 0 ||
        difference.inSeconds > 0 && difference.inMinutes == 0) {
      _timeElapsed = 'NOW';
    }
  }

  @override
  void initState() {
    var getStorage = GetStorage();

    _studyName = getStorage.read('studyName');
    _studyUID = getStorage.read('studyUID');
    _participantUID = getStorage.read('participantUID');

    if (widget.response.hasMedia) {
      if (widget.response.mediaType == 'video') {
        _videoPlayerController = VideoPlayerController.network(
          widget.response.mediaURL,
        );
        _videoPlayerController.initialize();
        _chewieController = ChewieController(
          allowFullScreen: false,
          videoPlayerController: _videoPlayerController,
          autoPlay: false,
          looping: true,
          showControls: true,
        );
      }
    }

    if (widget.response.claps != null) {
      if (widget.response.claps.contains(_participantUID)) {
        _clapped = true;
      }
    }
    _calculateTimeDifference();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    Future.delayed(Duration(seconds: 2), () {
      try {
        _commentsStream = _getCommentsStream(_studyUID, widget.topicUID,
            widget.questionUID, widget.response.responseUID);
        _getLastCommentStream(_studyUID, widget.topicUID, widget.questionUID,
            widget.response.responseUID);
        setState(() {});
      } catch (e) {
        print(e);
      }
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (_videoPlayerController != null) {
      _videoPlayerController.dispose();
      _chewieController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: widget.response.participantUID == _participantUID
            ? Colors.lightBlue.withOpacity(0.08)
            : Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.response.avatarURL,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.indigo[300],
                          shape: BoxShape.circle,
                        ),
                        child: Image(
                          width: 20.0,
                          image: imageProvider,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.response.participantDisplayName,
                        style: TextStyle(
                          color: TEXT_COLOR.withOpacity(0.6),
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        '$_date at $_time',
                        style: TextStyle(
                          color: TEXT_COLOR.withOpacity(0.6),
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$_timeElapsed',
                    style: TextStyle(
                      color: PROJECT_GREEN,
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  minLines: 3,
                  maxLines: 20,
                  enabled: _editResponse,
                  initialValue: widget.response.responseStatement,
                  onChanged: (responseStatement) {
                    if (responseStatement.trim().isNotEmpty) {
                      setState(() {
                        widget.response.responseStatement = responseStatement;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    fillColor: Colors.grey[100],
                    filled: _editResponse,
                  ),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              widget.response.questionHasMedia
                  ? widget.response.hasMedia
                      ? widget.response.mediaType == 'image'
                          ? CachedNetworkImage(
                              imageUrl: widget.response.mediaURL,
                              imageBuilder: (context, imageProvider) {
                                return Align(
                                  child: InkWell(
                                    onTap: _editResponse
                                        ? () {
                                            _showMediaPickerDialog();
                                          }
                                        : null,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white),
                                      constraints: BoxConstraints(
                                        maxHeight: 200.0,
                                        maxWidth: 300.0,
                                      ),
                                      padding: EdgeInsets.all(10.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.all(10.0),
                              constraints: BoxConstraints(
                                maxHeight: 200.0,
                                maxWidth: 300.0,
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    child: Chewie(
                                      controller: _chewieController,
                                    ),
                                  ),
                                  _editResponse
                                      ? Positioned(
                                          right: 0,
                                          top: 0,
                                          child: InkWell(
                                            onTap: (){
                                              _showMediaPickerDialog();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: PROJECT_GREEN,
                                              ),
                                              padding: EdgeInsets.all(10.0),
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 16.0,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            )
                      : widget.response.participantUID == _participantUID &&
                              _editResponse
                          ? InkWell(
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                _showMediaPickerDialog();
                              },
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey[700],
                                    )),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.grey[700],
                                      size: 16.0,
                                    ),
                                    SizedBox(
                                      height: 16.0,
                                    ),
                                    Text(
                                      'Image/Video',
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : SizedBox()
                  : SizedBox(),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      if (widget.response.claps.contains(_participantUID)) {
                        setState(() {
                          _clapped = false;
                          widget.response.claps.remove(_participantUID);
                        });
                        await _participantFirestoreService.decrementClap(
                            _studyUID,
                            widget.topicUID,
                            widget.questionUID,
                            widget.response,
                            _participantUID);
                      } else {
                        setState(() {
                          _clapped = true;
                          widget.response.claps.add(_participantUID);
                        });
                        await _participantFirestoreService.incrementClap(
                          studyUID: _studyUID,
                          topicUID: widget.topicUID,
                          questionUID: widget.questionUID,
                          response: widget.response,
                          participant: widget.participant,
                        );
                      }
                    },
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Image(
                      image: AssetImage('images/questions_icons/clap_icon.png'),
                      width: 30.0,
                      color: _clapped
                          ? Colors.lightBlue
                          : TEXT_COLOR.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    '${widget.response.claps.length}',
                    style: TextStyle(
                        color: TEXT_COLOR.withOpacity(0.8), fontSize: 12.0),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Image(
                    image:
                        AssetImage('images/questions_icons/comment_icon.png'),
                    width: 15.0,
                    color: TEXT_COLOR.withOpacity(0.8),
                  ),
                  SizedBox(
                    width: 6.0,
                  ),
                  Text(
                    '${widget.response.comments}',
                    style: TextStyle(
                      color: TEXT_COLOR.withOpacity(0.8),
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              _participantUID == widget.response.participantUID
                  ? InkWell(
                      child: Text(
                        _editResponse ? 'POST' : 'EDIT',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontWeight: _editResponse
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      onTap: () async {
                        setState(() {
                          _editResponse = !_editResponse;
                          if (_videoPlayerController != null) {
                            _videoPlayerController.pause();
                            _chewieController = ChewieController(
                              allowFullScreen: false,
                              videoPlayerController: _videoPlayerController,
                              showControls: !_editResponse,
                              autoPlay: false,
                              looping: true,
                            );
                          }
                        });
                        if (!_editResponse) {
                          await _participantFirestoreService.updateResponse(
                              _studyUID,
                              widget.topicUID,
                              widget.questionUID,
                              _participantUID,
                              widget.response);
                        }
                      },
                    )
                  : SizedBox(),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              CachedNetworkImage(
                imageUrl: widget.participant.profilePhotoURL,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.indigo[100],
                      shape: BoxShape.circle,
                    ),
                    child: Image(
                      width: 20.0,
                      image: imageProvider,
                    ),
                  );
                },
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                widget.participant.displayName,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: TextFormField(
                  maxLines: 3,
                  minLines: 1,
                  controller: _commentController,
                  onChanged: (commentStatement) {
                    setState(() {
                      _commentStatement = commentStatement;
                      if (_commentStatement.trim().isNotEmpty) {
                        // widget.comment.commentStatement = commentStatement;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.grey[100],
                    filled: true,
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    hintText: 'Write your comment',
                    hintStyle: TextStyle(
                      color: TEXT_COLOR.withOpacity(0.4),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              FlatButton(
                onPressed: _commentController.value.text.trim().isNotEmpty
                    ? () async {
                        setState(() {
                          _commentController.clear();
                        });

                        var comment = Comment(
                          avatarURL: widget.participant.profilePhotoURL,
                          displayName: widget.participant.displayName,
                          participantName:
                              '${widget.participant.userFirstName} ${widget.participant.userLastName}',
                          commentStatement: _commentStatement,
                          participantUID: widget.participant.participantUID,
                          commentTimestamp: Timestamp.now(),
                        );

                        await _postComment(
                            _studyUID,
                            widget.response.participantUID,
                            _participantUID,
                            widget.topicUID,
                            widget.questionUID,
                            widget.response.responseUID,
                            widget.response.questionNumber,
                            widget.response.questionTitle,
                            comment);
                      }
                    : null,
                disabledColor: Colors.grey[400],
                color: PROJECT_GREEN,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Text(
                    'Comment',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Theme(
            data: ThemeData(
              accentColor: PROJECT_GREEN,
              disabledColor: Colors.black,
            ),
            child: ExpansionTile(
              onExpansionChanged: (expansion) {
                setState(() {
                  _expanded = expansion;
                });
              },
              initiallyExpanded: _expanded,
              title: StreamBuilder<QuerySnapshot>(
                stream: _lastCommentStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return SizedBox();
                      break;
                    case ConnectionState.waiting:
                      return SizedBox();
                      break;
                    case ConnectionState.active:
                      if (snapshot.data != null && snapshot.data.size > 0) {
                        return _expanded
                            ? Text('All Comments')
                            : Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: snapshot.data.docs.last
                                        .data()['avatarURL'],
                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                        padding: EdgeInsets.all(4.0),
                                        decoration: BoxDecoration(
                                          color: Colors.indigo[100],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image(
                                          width: 20.0,
                                          image: imageProvider,
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    '${snapshot.data.docs.last.data()['displayName']}',
                                    style: TextStyle(
                                      color: TEXT_COLOR,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    '${snapshot.data.docs.last.data()['commentStatement']}',
                                    style: TextStyle(
                                      color: TEXT_COLOR,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              );
                      } else {
                        return Text('Please be the first to comment');
                      }
                      break;
                    case ConnectionState.done:
                      return SizedBox();
                      break;
                    default:
                      return Text('Something went wrong');
                  }
                },
              ),
              children: [
                Container(
                  height: 1.0,
                  color: Colors.grey[300],
                ),
                SizedBox(
                  height: 10.0,
                ),
                //widget.commentStreamBuilder,
                StreamBuilder<QuerySnapshot>(
                  stream: _commentsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return SizedBox();
                        break;
                      case ConnectionState.waiting:
                        return SizedBox();
                        break;
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          var commentDocs = snapshot.data.docs;

                          var comments = <Comment>[];

                          for (var commentDoc in commentDocs) {
                            comments.add(Comment.fromMap(commentDoc.data()));
                          }
                          return ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: comments.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (comments[index].commentUID != null) {
                                return CommentWidget(
                                  studyUID: _studyUID,
                                  topicUID: widget.topicUID,
                                  questionUID: widget.questionUID,
                                  responseUID: widget.response.responseUID,
                                  participantFirestoreService:
                                      _participantFirestoreService,
                                  participantUID: _participantUID,
                                  comment: comments[index],
                                );
                              } else {
                                return SizedBox();
                              }
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 10.0,
                              );
                            },
                          );
                        } else {
                          return SizedBox();
                        }
                        break;
                      case ConnectionState.done:
                        return SizedBox();
                        break;
                      default:
                        return SizedBox();
                    }
                  },
                ),

                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
