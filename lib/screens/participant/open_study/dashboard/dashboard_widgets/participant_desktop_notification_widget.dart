import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';

class ParticipantDesktopNotificationWidget extends StatelessWidget {
  final Timestamp timestamp;
  final String participantAvatar;
  final String participantDisplayName;
  final String questionNumber;
  final String questionTitle;

  const ParticipantDesktopNotificationWidget({
    Key key,
    //this.time,
    this.participantAvatar,
    this.participantDisplayName,
    this.questionNumber,
    this.questionTitle,
    this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var date =
    DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);

    var dateFormat = DateFormat(DateFormat.HOUR_MINUTE);

    var time = dateFormat.format(date);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
      child: Row(
        children: [
          Text(
            '$time',
            style: TextStyle(
              color: TEXT_COLOR.withOpacity(0.6),
              fontSize: 13.0,
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          CachedNetworkImage(
            imageUrl: participantAvatar,
            placeholder: (context, placeholderString){
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                width: 28.0,
                height: 28.0,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white.withOpacity(0.7),
                ),
              );
            },
            imageBuilder: (context, imageProvider) {
              return Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PROJECT_LIGHT_GREEN,
                ),
                child: Image(
                  width: 20.0,
                  height: 20.0,
                  image: imageProvider,
                ),
              );
            },
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  text: TextSpan(
                    style: TextStyle(
                        color: TEXT_COLOR.withOpacity(0.7), fontSize: 13.0),
                    children: [
                      TextSpan(
                          text:
                          '$participantDisplayName responded to the question '),
                      TextSpan(
                        text: '$questionNumber $questionTitle.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}