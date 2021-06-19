// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// this file defines the question widget that is shown to moderators in their
/// study navigator

import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';

class QuestionTile extends StatelessWidget {

  final Question question;
  final String topicUID;

  const QuestionTile({
    Key key, this.question, this.topicUID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: InkWell(
        onTap: (){
          Navigator.of(context)
              .pushNamed(CLIENT_MODERATOR_RESPONSES_SCREEN, arguments: {
            'questionUID': question.questionUID,
            'topicUID': topicUID,
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${question.questionNumber} ${question.questionTitle}',
              style: TextStyle(
                color: PROJECT_GREEN,
                fontSize: 14.0,
              ),
            ),
            Icon(
              Icons.arrow_forward,
              color: PROJECT_GREEN,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
