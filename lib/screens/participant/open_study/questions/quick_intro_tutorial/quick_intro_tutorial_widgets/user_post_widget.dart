import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/participant/open_study/questions/quick_intro_tutorial/quick_intro_tutorial_widgets/comment_widget.dart';
import 'package:thoughtnav/screens/researcher/models/comment.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/screens/researcher/models/response.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/participant_firestore_service.dart';

class UserResponseWidget extends StatefulWidget {
  final ParticipantFirestoreService participantFirestoreService;
  final String studyUID;
  final String topicUID;
  final String questionUID;
  final String participantUID;
  final Response response;
  final Comment comment;
  final Function postCommentFunction;
  final Participant participant;
  final TextEditingController commentController;
  final StreamBuilder commentStreamBuilder;
  final Widget expansionTileTitle;

  const UserResponseWidget({
    Key key,
    this.response,
    this.participantUID,
    this.postCommentFunction,
    this.comment,
    this.participantFirestoreService,
    this.studyUID,
    this.topicUID,
    this.questionUID,
    this.participant,
    this.commentController,
    this.commentStreamBuilder,
    this.expansionTileTitle,
  }) : super(key: key);

  @override
  _UserResponseWidgetState createState() => _UserResponseWidgetState();
}

class _UserResponseWidgetState extends State<UserResponseWidget> {
  final _participantFirestoreService = ParticipantFirestoreService();

  Stream<QuerySnapshot> _commentsStream;

  bool _clapped = false;

  bool _expanded = false;

  String _commentStatement;
  String _responseUID;

  Comment _comment;

  Stream<QuerySnapshot> _firstCommentStream;

  void _getFirstCommentStream(String studyUID, String topicUID,
      String questionUID, String responseUID) {
    _firstCommentStream = _participantFirestoreService.streamFirstComment(
        studyUID, topicUID, questionUID, responseUID);
  }

  void _getResponseUIDIfNull() async {
    _responseUID = await _participantFirestoreService.getResponseUID(
        widget.studyUID,
        widget.topicUID,
        widget.questionUID,
        widget.participantUID);

    setState(() {
      // _commentsStream = _getCommentsAsStream(_responseUID);
    });
  }

  // void _getFirstComment() async {
  //   _comment = await _participantFirestoreService.getFirstComment(
  //       widget.studyUID,
  //       widget.topicUID,
  //       widget.questionUID,
  //       widget.response.responseUID);
  //
  //   setState(() {});
  // }

  @override
  void initState() {
    if (widget.response.claps.contains(widget.participantUID)) {
      _clapped = true;
    }

    _getFirstCommentStream(widget.studyUID, widget.topicUID, widget.questionUID,
        widget.response.responseUID);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _responseUID = widget.response.responseUID;

    if (_responseUID == null) {
      _getResponseUIDIfNull();
    } else {
      setState(() {
        // _commentsStream = _getCommentsAsStream(_responseUID);
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var formatDate = DateFormat.yMd();
    var formatTime = DateFormat.jm();

    var date = formatDate.format(widget.response.responseTimestamp.toDate());
    var time = formatTime.format(widget.response.responseTimestamp.toDate());

    var timeNow = DateTime.now();
    var difference = timeNow.difference(DateTime.fromMillisecondsSinceEpoch(
        widget.response.responseTimestamp.millisecondsSinceEpoch));

    var timeElapsed = '';

    if (difference.inDays >= 7) {
      if (difference.inDays == 7) {
        timeElapsed = (difference.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        timeElapsed = (difference.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    } else if (difference.inDays > 0 && difference.inDays < 7) {
      if (difference.inDays == 1) {
        timeElapsed = difference.inDays.toString() + ' DAY AGO';
      } else {
        timeElapsed = difference.inDays.toString() + ' DAYS AGO';
      }
    } else if (difference.inHours > 0 && difference.inDays == 0) {
      if (difference.inHours == 1) {
        timeElapsed = difference.inHours.toString() + ' HOUR AGO';
      } else {
        timeElapsed = difference.inHours.toString() + ' HOURS AGO';
      }
    } else if (difference.inMinutes > 0 && difference.inHours == 0) {
      if (difference.inMinutes == 1) {
        timeElapsed = difference.inMinutes.toString() + ' MINUTE AGO';
      } else {
        timeElapsed = difference.inMinutes.toString() + ' MINUTES AGO';
      }
    } else if (difference.inSeconds <= 0 ||
        difference.inSeconds > 0 && difference.inMinutes == 0) {
      timeElapsed = 'NOW';
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
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
                        '$date at $time',
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
                    timeElapsed,
                    style: TextStyle(
                      color: TEXT_COLOR.withOpacity(0.6),
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
          Text(
            widget.response.responseStatement,
            style: TextStyle(
              color: TEXT_COLOR,
              fontSize: 12.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              InkWell(
                onTap: () async {
                  if (widget.response.claps.contains(widget.participantUID)) {
                    setState(() {
                      _clapped = false;
                      widget.response.claps.remove(widget.participantUID);
                    });
                    await widget.participantFirestoreService.decrementClap(
                        widget.studyUID,
                        widget.topicUID,
                        widget.questionUID,
                        widget.response,
                        widget.participantUID);
                  } else {
                    setState(() {
                      _clapped = true;
                      widget.response.claps.add(widget.participantUID);
                    });
                    await widget.participantFirestoreService.incrementClap(
                      studyUID: widget.studyUID,
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
                  color:
                      _clapped ? Colors.lightBlue : TEXT_COLOR.withOpacity(0.8),
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
              InkWell(
                onTap: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Image(
                  image: AssetImage('images/questions_icons/comment_icon.png'),
                  width: 15.0,
                  color: TEXT_COLOR.withOpacity(0.8),
                ),
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
                  controller: widget.commentController,
                  onChanged: (commentStatement) {
                    setState(() {
                      _commentStatement = commentStatement;
                      if (_commentStatement.trim().isNotEmpty) {
                        widget.comment.commentStatement = commentStatement;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.grey[100],
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
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
                onPressed: widget.commentController.value.text.trim().isNotEmpty
                    ? widget.postCommentFunction
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
          ExpansionTile(
            onExpansionChanged: (expansion) {
              setState(() {
                _expanded = expansion;
              });
            },
            initiallyExpanded: _expanded,
            title: StreamBuilder<QuerySnapshot>(
              stream: _firstCommentStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  if (snapshot.hasData) {
                    if (_expanded) {
                      return Text('All comments');
                    } else {
                      if(snapshot.data.docs.isNotEmpty){
                        var comment =
                        Comment.fromMap(snapshot.data.docs.first.data());

                        return Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: comment.avatarURL,
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
                            Text(
                              comment.displayName,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              comment.commentStatement,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        );
                      }
                      else {
                        return Text('No comments yet');
                      }
                    }
                  } else {
                    return Text('No comments yet 1');
                  }
                } else {
                  return Text('No comments yet 2');
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
              widget.commentStreamBuilder,
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
