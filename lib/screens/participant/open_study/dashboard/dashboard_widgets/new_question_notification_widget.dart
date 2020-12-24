import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/notification.dart';

class NewQuestionNotificationWidget extends StatelessWidget {

  final NewQuestionNotification newQuestionNotification;

  const NewQuestionNotificationWidget({Key key, this.newQuestionNotification}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var formatDate = DateFormat.yMd();
    var formatTime = DateFormat.jm();

    var date = formatDate.format(newQuestionNotification.notificationTimestamp.toDate());
    var time = formatTime.format(newQuestionNotification.notificationTimestamp.toDate());

    return Row(
      children: [
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
                      text: 'A new question has been added in the topic ',
                    ),
                    TextSpan(
                      text: newQuestionNotification.topicTitle,
                    ),
                  ],
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
