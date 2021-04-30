// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/response.dart';
import 'package:thoughtnav/screens/researcher/widgets/comment_report_widget.dart';
import 'package:video_player/video_player.dart';

class ResponseReportWidget extends StatefulWidget {
  final Response response;
  final List<dynamic> listForCSV;

  const ResponseReportWidget({Key key, this.response, this.listForCSV}) : super(key: key);

  @override
  _ResponseReportWidgetState createState() => _ResponseReportWidgetState();
}

class _ResponseReportWidgetState extends State<ResponseReportWidget>
    with AutomaticKeepAliveClientMixin {
  ChewieController _chewieController;
  VideoPlayerController _videoPlayerController;

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
    return Container(
      margin: EdgeInsets.only(left: 20.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Row(
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
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[50]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SelectableText(
                    widget.response.responseStatement ?? '',
                    showCursor: true,
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
                            imageBuilder: (imageContext, imageProvider) {
                              return Container(
                                padding: EdgeInsets.all(10.0),
                                constraints: BoxConstraints(
                                  maxWidth: 300.0,
                                  maxHeight: 200.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image(
                                    image: imageProvider,
                                  ),
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
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Chewie(controller: _chewieController),
                          )
                    : SizedBox(),
              ],
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                image: AssetImage('images/questions_icons/clap_icon.png'),
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
          widget.response.commentStatements.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1.0,
                            color: Colors.grey[300],
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'Comments',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.response.commentStatements.length,
                      itemBuilder: (BuildContext context, int commentIndex) {
                        return CommentReportWidget(
                          comment: widget.response.commentStatements[commentIndex],
                        );
                      }, separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 10.0,
                        );
                    },
                    ),
                    SizedBox(height: 10.0,),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
