import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/participant/open_study/questions/quick_intro_tutorial/quick_intro_tutorial_widgets/comment_widget.dart';
import 'package:thoughtnav/screens/researcher/models/comment.dart';
import 'package:thoughtnav/screens/researcher/models/response.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class UserResponseWidget extends StatefulWidget {
  final FirebaseFirestoreService firebaseFirestoreService;
  final String studyUID;
  final String topicUID;
  final String questionUID;
  final String participantUID;
  final Response response;
  final Comment comment;
  final Function postCommentFunction;

  const UserResponseWidget({
    Key key,
    this.response,
    this.participantUID,
    this.postCommentFunction,
    this.comment,
    this.firebaseFirestoreService,
    this.studyUID,
    this.topicUID,
    this.questionUID,
  }) : super(key: key);

  @override
  _UserResponseWidgetState createState() => _UserResponseWidgetState();
}

class _UserResponseWidgetState extends State<UserResponseWidget> {
  Stream<QuerySnapshot> _commentsStream;

  bool _clapped = false;

  Stream<QuerySnapshot> _getCommentsAsStream() {
    return widget.firebaseFirestoreService.getCommentsAsStream(widget.studyUID,
        widget.topicUID, widget.questionUID, widget.response.responseUID);
  }

  @override
  void initState() {
    _commentsStream = _getCommentsAsStream();

    if(widget.response.claps.contains(widget.participantUID)){
      _clapped = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var formatDate = DateFormat.yMd();
    var formatTime = DateFormat.jm();

    var date = formatDate.format(widget.response.responseTimestamp.toDate());
    var time = formatTime.format(widget.response.responseTimestamp.toDate());

    var now = DateTime.now();


    var difference = DateTime.fromMillisecondsSinceEpoch(widget.response.responseTimestamp.millisecondsSinceEpoch).difference(now);
    var timeDifferenceFormat = DateFormat('HH:mm a');

    var timeElapsed = '';

    if (difference.inSeconds <= 0 || difference.inSeconds > 0 && difference.inMinutes == 0 || difference.inMinutes > 0 && difference.inHours == 0 || difference.inHours > 0 && difference.inDays == 0) {
      // timeElapsed = timeDifferenceFormat.format(widget.response.responseTimestamp.toDate());
      timeElapsed = 'TODAY';
    } else if (difference.inDays > 0 && difference.inDays < 7) {
      if (difference.inDays == 1) {
        timeElapsed = difference.inDays.toString() + ' DAY AGO';
      } else {
        timeElapsed = difference.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (difference.inDays == 7) {
        timeElapsed = (difference.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        timeElapsed = (difference.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
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
              )
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
                    await widget.firebaseFirestoreService.decrementClap(
                        widget.studyUID,
                        widget.topicUID,
                        widget.questionUID,
                        widget.response.responseUID,
                        widget.participantUID);
                  } else {
                    setState(() {
                      _clapped = true;
                      widget.response.claps.add(widget.participantUID);
                    });
                    await widget.firebaseFirestoreService.incrementClap(
                        widget.studyUID,
                        widget.topicUID,
                        widget.questionUID,
                        widget.response.responseUID,
                        widget.participantUID);
                  }
                },
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Image(
                  image: AssetImage('images/questions_icons/clap_icon.png'),
                  width: 30.0,
                  color: _clapped ? Colors.lightBlue : TEXT_COLOR.withOpacity(0.8),
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
                onTap: () {},
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
          ExpansionTile(
            title: Text(
              'Comments',
              style: TextStyle(
                  color: PROJECT_NAVY_BLUE,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0),
            ),
            children: [
              Container(
                child: Column(
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
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.response.participantDisplayName,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // SizedBox(
                            //   height: 4.0,
                            // ),
                            // Text(
                            //   'current Date',
                            //   style: TextStyle(
                            //     color: Colors.grey[500],
                            //     fontSize: 12.0,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: TextFormField(
                        maxLines: 3,
                        minLines: 3,
                        onChanged: (commentStatement) {
                          setState(() {
                            widget.comment.commentStatement = commentStatement;
                          });
                        },
                        decoration: InputDecoration(
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
                      height: 10.0,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: widget.comment.commentStatement != null &&
                                widget.comment.commentStatement.isNotEmpty
                            ? widget.postCommentFunction
                            : null,
                        disabledColor: Colors.grey[400],
                        color: PROJECT_GREEN,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Comment',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 1.0,
                color: Colors.grey[300],
              ),
              SizedBox(
                height: 10.0,
              ),
              StreamBuilder(
                stream: _commentsStream,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return SizedBox();
                      break;
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        var commentDocs = snapshot.data.documents;
                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: commentDocs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CommentWidget(
                              comment: Comment(
                                  commentUID: commentDocs[index]['commentUID'],
                                  avatarURL: commentDocs[index]['avatarURL'],
                                  alias: commentDocs[index]['alias'],
                                  userName: commentDocs[index]['userName'],
                                  commentStatement: commentDocs[index]
                                      ['commentStatement'],
                                  userUID: commentDocs[index]['userUID'],
                                  commentTimestamp: commentDocs[index]
                                      ['commentTimestamp']),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
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
        ],
      ),
    );
  }
}
