// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines the locked question tile which is displayed in
/// the end drawer to participants

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';

class LockedQuestionExpansionTileChild extends StatelessWidget {
  final Question question;

  const LockedQuestionExpansionTileChild({Key key, this.question})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatDate = DateFormat(DateFormat.ABBR_MONTH_DAY);
    var formatTime = DateFormat.jm();

    var date = formatDate.format(question.questionTimestamp.toDate());
    var time = formatTime.format(question.questionTimestamp.toDate());

    return InkWell(
      onTap: () {
        showGeneralDialog(
            barrierDismissible: true,
            barrierLabel: 'Question locked barrier',
            context: context,
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return Center(
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      Timestamp.now().millisecondsSinceEpoch <
                          question.questionTimestamp.millisecondsSinceEpoch
                          ? 'This question will unlock after $date at $time'
                          : 'All previous questions must be answered before this question can be answered',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              );
            });
      },
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      child: ListTile(
        title: Text(
          'Question Locked',
          style: TextStyle(
            fontSize: 12.0,
            color: Color(0xFF333333),
          ),
        ),
        trailing: Icon(
          Icons.lock,
          color: Color(0xFF333333).withOpacity(0.5),
          size: 16.0,
        ),
        contentPadding: EdgeInsets.only(
          left: 30.0,
          right: 16.0,
        ),
      ),
    );
  }
}