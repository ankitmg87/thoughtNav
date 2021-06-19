// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines the widget which is shown on the reports screen for
/// showing comments

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/comment.dart';

class CommentReportWidget extends StatelessWidget {
  final Comment comment;
  final List<dynamic> listForCSV;

  const CommentReportWidget({Key key, this.comment, this.listForCSV})
      : super(key: key);

  String _calculateDateAndTime(Timestamp commentTimestamp) {
    var dateFormat = DateFormat(DateFormat.ABBR_MONTH_DAY);
    var timeFormat = DateFormat.jm();

    var date = dateFormat.format(commentTimestamp.toDate());
    var time = timeFormat.format(commentTimestamp.toDate());

    return '$date at $time';
  }

  String _calculateTimeDifference() {
    var timeNow = DateTime.now();
    var difference = timeNow.difference(DateTime.fromMillisecondsSinceEpoch(
        comment.commentTimestamp.millisecondsSinceEpoch));

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
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.only(left: 20.0),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF27A6B6), width: 2.0),
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: comment.avatarURL ?? 'images/researcher_images/researcher_dashboard/participant_icon.png',
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
                                text: '${comment.displayName ?? 'Mike the Moderator'} - ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: comment.participantName ?? 'Mike Courtney',
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
                          _calculateDateAndTime(comment.commentTimestamp),
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
              color: Colors.grey[50],
            ),
            child: Row(
              children: [
                Expanded(
                  child: HtmlWidget(comment.commentStatement),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
