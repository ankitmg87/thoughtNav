import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/notification.dart';

class ResponseNotificationWidget extends StatelessWidget {

  final ResponseNotification responseNotification;

  const ResponseNotificationWidget({Key key, this.responseNotification}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var formatDate = DateFormat.yMd();
    var formatTime = DateFormat.jm();

    var date = formatDate.format(responseNotification.notificationTimestamp.toDate());
    var time = formatTime.format(responseNotification.notificationTimestamp.toDate());

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      text: 'You',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: TEXT_COLOR,
                      ),
                    ),
                    TextSpan(
                      text: ' responded to the question ',
                    ),
                    TextSpan(
                      text: responseNotification.questionNumber,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    TextSpan(
                      text: ' ${responseNotification.questionTitle}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ]
                ),
              ),
              SizedBox(
                height: 10.0,
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
        )
      ],
    );
  }
}
