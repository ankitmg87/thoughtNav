import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/researcher/models/notification.dart';

const Color _COMMENT_NOTIFICATION_AVATAR_BACKGROUND_COLOR = Color(0xFFF9B9B7);

class CommentNotificationWidget extends StatelessWidget {
  final CommentNotification commentNotification;
  final String participantDisplayName;

  const CommentNotificationWidget(
      {Key key, this.commentNotification, this.participantDisplayName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatDate = DateFormat(DateFormat.ABBR_MONTH_DAY);
    var formatTime = DateFormat.jm();

    var date =
        formatDate.format(commentNotification.notificationTimestamp.toDate());
    var time =
        formatTime.format(commentNotification.notificationTimestamp.toDate());

    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context)
            .popAndPushNamed(PARTICIPANT_RESPONSES_SCREEN, arguments: {
          'topicUID': commentNotification.topicUID,
          'questionUID': commentNotification.questionUID,
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: commentNotification.avatarURL,
            imageBuilder: (context, imageProvider) {
              return Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _COMMENT_NOTIFICATION_AVATAR_BACKGROUND_COLOR,
                ),
                child: Image(
                  image: imageProvider,
                  width: 24.0,
                  height: 24.0,
                ),
              );
            },
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: TEXT_COLOR,
                    ),
                    children: [
                      TextSpan(
                        text: participantDisplayName ==
                                commentNotification.displayName
                            ? 'You'
                            : commentNotification.displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' commented on your response for the question ',
                      ),
                      TextSpan(
                        text: commentNotification.questionNumber,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      TextSpan(
                        text: ' ${commentNotification.questionTitle}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  '$date at $time',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: TEXT_COLOR.withOpacity(0.7),
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
