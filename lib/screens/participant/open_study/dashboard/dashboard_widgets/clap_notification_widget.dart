import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/researcher/models/notification.dart';

const Color _CLAP_NOTIFICATION_WIDGET_BACKGROUND_COLOR = Color(0xFF30BCED);

class ClapNotificationWidget extends StatelessWidget {
  final ClapNotification clapNotification;
  final String participantDisplayName;

  const ClapNotificationWidget(
      {Key key, this.clapNotification, this.participantDisplayName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatDate = DateFormat(DateFormat.ABBR_MONTH_DAY);
    var formatTime = DateFormat.jm();

    var date =
        formatDate.format(clapNotification.notificationTimestamp.toDate());
    var time =
        formatTime.format(clapNotification.notificationTimestamp.toDate());

    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context)
            .popAndPushNamed(PARTICIPANT_RESPONSES_SCREEN, arguments: {
          'topicUID': clapNotification.topicUID,
          'questionUID': clapNotification.questionUID,
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: clapNotification.avatarURL,
            imageBuilder: (context, imageProvider) {
              return Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _CLAP_NOTIFICATION_WIDGET_BACKGROUND_COLOR
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: TEXT_COLOR,
                      fontSize: 14.0,
                    ),
                    children: [
                      TextSpan(
                        text: participantDisplayName ==
                                clapNotification.displayName
                            ? 'You'
                            : clapNotification.displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' appreciated your response for the question ',
                      ),
                      TextSpan(
                        text: clapNotification.questionNumber,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      TextSpan(
                        text: ' ${clapNotification.questionTitle}',
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
                    fontSize: 13.0,
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
