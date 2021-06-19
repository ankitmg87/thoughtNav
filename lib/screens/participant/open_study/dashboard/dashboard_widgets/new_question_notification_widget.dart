// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This question is used to show notification to the participant when
/// moderator adds a new question in the middle of the study

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/researcher/models/notification.dart';

class NewQuestionNotificationWidget extends StatelessWidget {

  final NewQuestionNotification newQuestionNotification;

  const NewQuestionNotificationWidget({Key key, this.newQuestionNotification}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var formatDate = DateFormat(DateFormat.ABBR_MONTH_DAY);
    var formatTime = DateFormat.jm();

    var date = formatDate.format(newQuestionNotification.notificationTimestamp.toDate());
    var time = formatTime.format(newQuestionNotification.notificationTimestamp.toDate());

    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: (){
        Navigator.of(context).popAndPushNamed(PARTICIPANT_RESPONSES_SCREEN, arguments: {
          'topicUID' : newQuestionNotification.topicUID,
          'questionUID' : newQuestionNotification.questionUID,
        });
      },
      child: Row(
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
                        text: newQuestionNotification.topicName,
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
      ),
    );
  }
}
