// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/comment.dart';
import 'package:thoughtnav/screens/researcher/models/response.dart';
import 'package:thoughtnav/screens/researcher/widgets/comment_widget.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';
import 'package:video_player/video_player.dart';

import 'dart:js' as js;

class ResponseWidget extends StatefulWidget {
  final String studyUID;
  final String topicUID;
  final String questionUID;
  final Response response;

  const ResponseWidget({
    Key key,
    this.response,
    this.studyUID,
    this.topicUID,
    this.questionUID,
  }) : super(key: key);

  @override
  _ResponseWidgetState createState() => _ResponseWidgetState();
}

class _ResponseWidgetState extends State<ResponseWidget>
    with AutomaticKeepAliveClientMixin {

  String _userType;

  final _researcherAndModeratorFirestoreService =
      ResearcherAndModeratorFirestoreService();

  Stream<QuerySnapshot> _commentsStream;

  ChewieController _chewieController;
  VideoPlayerController _videoPlayerController;

  Stream<QuerySnapshot> _getCommentsStream(String studyUID, String topicUID,
      String questionUID, String responseUID) {
    return _researcherAndModeratorFirestoreService.streamComments(
        studyUID, topicUID, questionUID, responseUID);
  }

  String _calculateDateAndTime(Timestamp responseTimestamp) {
    var dateFormat = DateFormat(DateFormat.ABBR_MONTH_DAY);
    var timeFormat = DateFormat.jm();

    var date = dateFormat.format(responseTimestamp.toDate());
    var time = timeFormat.format(responseTimestamp.toDate());

    return '$date at $time';
  }

  String _calculateTimeDifference() {
    var timeNow = DateTime.now();
    var difference = timeNow.difference(DateTime.fromMillisecondsSinceEpoch(
        widget.response.responseTimestamp.millisecondsSinceEpoch));

    if (difference.inDays >= 7) {
      if (difference.inDays == 7) {
        return (difference.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        return (difference.inDays / 7).ceil().toString() + ' WEEKS AGO';
      }
    } else if (difference.inDays > 0 && difference.inDays < 7) {
      if (difference.inDays == 1) {
        return difference.inDays.toString() + ' DAY AGO';
      } else {
        return difference.inDays.toString() + ' DAYS AGO';
      }
    } else if (difference.inHours > 0 && difference.inDays == 0) {
      if (difference.inHours == 1) {
        return difference.inHours.toString() + ' HOUR AGO';
      } else {
        return difference.inHours.toString() + ' HOURS AGO';
      }
    } else if (difference.inMinutes > 0 && difference.inHours == 0) {
      if (difference.inMinutes == 1) {
        return difference.inMinutes.toString() + ' MINUTE AGO';
      } else {
        return difference.inMinutes.toString() + ' MINUTES AGO';
      }
    } else if (difference.inSeconds <= 0 ||
        difference.inSeconds > 0 && difference.inMinutes == 0) {
      return 'NOW';
    } else {
      return 'NOW';
    }
  }

  @override
  void initState() {

    var getStorage = GetStorage();

    _userType = getStorage.read('userType');

    _commentsStream = _getCommentsStream(widget.studyUID, widget.topicUID,
        widget.questionUID, widget.response.responseUID);

    if (widget.response.hasMedia) {
      if (widget.response.mediaType == 'video') {
        _videoPlayerController =
            VideoPlayerController.network(widget.response.mediaURL);
        _chewieController = ChewieController(
          allowFullScreen: false,
          videoPlayerController: _videoPlayerController,
          looping: true,
        );
      }
    }

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Card(
          elevation: 2.0,
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.response.avatarURL,
                  imageBuilder: (avatarContext, imageProvider) {
                    return Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image(
                        image: imageProvider,
                      ),
                    );
                  },
                  errorWidget: (context, string, dynamic){
                    return Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image(
                        image: AssetImage(
                          'images/researcher_images/researcher_dashboard/participant_icon.png',
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${widget.response.participantDisplayName} - ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: widget.response.userName,
                                      style: TextStyle(
                                        color: PROJECT_GREEN,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                _calculateDateAndTime(
                                    widget.response.responseTimestamp),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _calculateTimeDifference(),
                            style: TextStyle(
                              color: PROJECT_GREEN,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SelectableText(
                              widget.response.responseStatement,
                            ),
                          ),
                          widget.response.hasMedia
                              ? SizedBox(
                                  width: 20.0,
                                )
                              : SizedBox(),
                          widget.response.hasMedia
                              ? widget.response.mediaType == 'image'
                                  ? CachedNetworkImage(
                                      imageUrl: widget.response.mediaURL,
                                      imageBuilder:
                                          (imageContext, imageProvider) {
                                        return Container(
                                          padding: EdgeInsets.all(10.0),
                                          constraints: BoxConstraints(
                                            maxWidth: 300.0,
                                            maxHeight: 200.0,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Image(
                                            image: imageProvider,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      constraints: BoxConstraints(
                                        maxHeight: 200.0,
                                        maxWidth: 300.0,
                                      ),
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child:
                                          Chewie(controller: _chewieController),
                                    )
                              : SizedBox(),
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image(
                                image: AssetImage(
                                    'images/questions_icons/clap_icon.png'),
                                width: 24.0,
                                height: 24.0,
                                color: PROJECT_GREEN,
                              ),
                              SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                '${widget.response.claps.length}',
                                style: TextStyle(color: PROJECT_GREEN),
                              ),
                              SizedBox(
                                width: 6.0,
                              ),
                              Icon(
                                CupertinoIcons.chat_bubble,
                                color: PROJECT_GREEN,
                                size: 20.0,
                              ),
                              SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                '${widget.response.comments}',
                                style: TextStyle(color: PROJECT_GREEN),
                              ),
                            ],
                          ),

                          _userType != 'client' ?

                          RaisedButton(
                            color: PROJECT_GREEN,
                            onPressed: () {
                              _buildCommentGeneralDialog();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Comment',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ) : SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _commentsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return SizedBox();
                break;
              case ConnectionState.waiting:
                return SizedBox();
                break;
              case ConnectionState.active:
                if (snapshot.hasData) {
                  if (snapshot.data.docs.isNotEmpty) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CommentWidget(
                          comment:
                              Comment.fromMap(snapshot.data.docs[index].data()),
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
                } else {
                  return Text(
                    'No comments yet',
                  );
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
        // CommentWidget(),
      ],
    );
  }

  void _buildCommentGeneralDialog() async {
    await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add a Comment',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.clear,
                            color: Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 1.0,
                      color: Colors.grey[300],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Expanded(
                        child: EasyWebView(src: 'quill.html', onLoaded: () {})),
                    SizedBox(
                      height: 20.0,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                        color: PROJECT_GREEN,
                        onPressed: () async {
                          String commentStatement =
                              js.context.callMethod('readLocalStorage');
                          if (commentStatement.trim().isNotEmpty) {
                            var comment = Comment(
                              participantUID: widget.response.participantUID,
                              commentStatement: commentStatement,
                              commentTimestamp: Timestamp.now(),
                              commentType: 'moderatorComment',
                            );

                            await _researcherAndModeratorFirestoreService
                                .postModeratorComment(
                                    widget.studyUID,
                                    widget.response.participantUID,
                                    widget.topicUID,
                                    widget.questionUID,
                                    widget.response.responseUID,
                                    widget.response.questionNumber,
                                    widget.response.questionTitle,
                                    comment);

                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          'Comment',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
