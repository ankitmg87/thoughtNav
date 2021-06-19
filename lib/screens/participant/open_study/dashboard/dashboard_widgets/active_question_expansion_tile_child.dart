// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines the Active question expansion tile which is displayed in
/// the end drawer to participants

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';

class ActiveQuestionExpansionTileChild extends StatefulWidget {
  final Function onTap;
  final Question question;
  final String participantUID;

  const ActiveQuestionExpansionTileChild({
    Key key,
    this.onTap,
    this.question,
    this.participantUID,
  }) : super(key: key);

  @override
  _ActiveQuestionExpansionTileChildState createState() => _ActiveQuestionExpansionTileChildState();
}

class _ActiveQuestionExpansionTileChildState extends State<ActiveQuestionExpansionTileChild> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap,
      title: Text(
        '${widget.question.questionNumber} ${widget.question.questionTitle}',
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: 12.0,
        ),
      ),
      trailing: Icon(
        widget.question.respondedBy == null
            ? Icons.arrow_forward
            : widget.question.respondedBy.contains(widget.participantUID)
                ? Icons.check_circle_outline_rounded
                : Icons.arrow_forward,
        color: PROJECT_GREEN,
        size: 16.0,
      ),
      contentPadding: EdgeInsets.only(
        left: 30.0,
        right: 16.0,
      ),
    );
  }
}


