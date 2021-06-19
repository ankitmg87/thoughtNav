// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines the widget that is used to show the locked topic which is
/// shown on the participant dashboard

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';

class LockedTaskWidget extends StatelessWidget {
  final Topic topic;

  const LockedTaskWidget({Key key, @required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatDate = DateFormat(DateFormat.ABBR_MONTH_DAY);
    var formatTime = DateFormat.jm();

    var date = formatDate.format(topic.topicDate.toDate());
    var time = formatTime.format(topic.topicDate.toDate());

    return InkWell(
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        showGeneralDialog(
          barrierDismissible: true,
          barrierLabel: 'Locked Question Dialog',
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'This topic will be unlocked after $date at $time',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          context: context,
        );
      },
      child: Container(
        color: Color(0xFFDFE2ED),
        margin: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 5.0,
        ),
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.topicName,
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  'Begins $date at $time ${DateTime.now().timeZoneName}',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
