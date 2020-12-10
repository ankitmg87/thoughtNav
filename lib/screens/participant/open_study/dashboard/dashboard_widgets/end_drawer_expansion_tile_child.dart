import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';

class EndDrawerExpansionTileChild extends StatelessWidget {
  final String label;
  final Function onTap;
  final Question question;
  final String participantUID;

  const EndDrawerExpansionTileChild({
    Key key,
    this.label,
    this.onTap,
    this.question,
    this.participantUID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        '${question.questionNumber} ${question.questionTitle}',
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: 12.0,
        ),
      ),
      trailing: Icon(
        question.respondedBy == null
            ? Icons.arrow_forward
            : question.respondedBy.contains(participantUID)
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
