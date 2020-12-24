import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/notification.dart';

const Color _MODERATOR_COMMENT_NOTIFICATION_AVATAR_BACKGROUND_COLOR =
    Color(0xFFAB87FF);

class ModeratorCommentNotificationWidget extends StatelessWidget {
  final ModeratorCommentNotification moderatorCommentNotification;

  const ModeratorCommentNotificationWidget(
      {Key key, this.moderatorCommentNotification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    var formatDate = DateFormat.yMd();
    var formatTime = DateFormat.jm();

    var date = formatDate.format(moderatorCommentNotification.notificationTimestamp.toDate());
    var time = formatTime.format(moderatorCommentNotification.notificationTimestamp.toDate());

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedNetworkImage(
          imageUrl: moderatorCommentNotification.moderatorAvatarURL,
          imageBuilder: (context, imageProvider) {
            return Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _MODERATOR_COMMENT_NOTIFICATION_AVATAR_BACKGROUND_COLOR
                    .withOpacity(0.3),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: TEXT_COLOR,
                  ),
                  children: [
                    TextSpan(
                      text: moderatorCommentNotification.moderatorFirstName,
                    ),
                    TextSpan(
                      text: ' (the moderator)',
                    ),
                    TextSpan(
                      text: ' commented on your response for the question',
                    ),
                    TextSpan(
                      text:
                          ' ${moderatorCommentNotification.questionNumber} ${moderatorCommentNotification.questionTitle}',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0,),
              Text(
                moderatorCommentNotification.moderatorCommentStatement,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                ),
              ),
              SizedBox(height: 10.0,),
              Text(
                '$date at $time',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
