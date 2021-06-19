// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines the widget that is shown to moderators which enables them
/// to view expansion tile shown in the study navigator

import 'package:flutter/material.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';

class StudyNavigatorExpansionTile extends StatefulWidget {
  final Topic topic;
  final Function onQuestionTap;

  const StudyNavigatorExpansionTile({Key key, this.topic, this.onQuestionTap})
      : super(key: key);

  @override
  _StudyNavigatorExpansionTileState createState() =>
      _StudyNavigatorExpansionTileState();
}

class _StudyNavigatorExpansionTileState
    extends State<StudyNavigatorExpansionTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.topic.topicName,
        style: TextStyle(
          color: Colors.grey[700],
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
        ),
      ),
      children: [
        SizedBox(
          height: 10.0,
        ),
        ListView.separated(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 10.0,
          ),
          shrinkWrap: true,
          itemCount: widget.topic.questions.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {},
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                children: [
                  Text(
                    '${widget.topic.questions[index].questionNumber}  ${widget.topic.questions[index].questionTitle}',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  )
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 20.0);
          },
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}