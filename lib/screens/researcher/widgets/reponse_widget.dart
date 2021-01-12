import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/misc_constants.dart';
import 'package:thoughtnav/screens/researcher/models/comment.dart';
import 'package:thoughtnav/screens/researcher/models/response.dart';
import 'package:thoughtnav/screens/researcher/widgets/comment_widget.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';
import 'package:video_player/video_player.dart';

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

class _ResponseWidgetState extends State<ResponseWidget> {
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
                            child: Text(
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
                          comment: Comment.fromMap(snapshot.data.docs[index].data()),
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
}
