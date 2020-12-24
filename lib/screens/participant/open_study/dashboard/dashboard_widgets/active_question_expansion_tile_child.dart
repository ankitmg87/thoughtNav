import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';

class ActiveQuestionExpansionTileChild extends StatelessWidget {
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

class LockedQuestionExpansionTileChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showGeneralDialog(
            barrierDismissible: true,
            barrierLabel: 'Enter Gender',
            context: context,
            pageBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return Center(
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'All previous questions must be answered before this question can be answered',
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
