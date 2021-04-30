// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

import 'package:flutter/material.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/screens/researcher/widgets/question_report_widget.dart';

class TopicReportWidget extends StatelessWidget {
  final Topic topic;
  final List<Group> groups;
  final List<dynamic> listForCSV;

  const TopicReportWidget({Key key, this.topic, this.groups, this.listForCSV})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        elevation: 2.0,
        color: Colors.lightBlue[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${topic.topicNumber}. ${topic.topicName}',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(topic.questions.length, (questionIndex) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      QuestionReportWidget(
                        question: topic.questions[questionIndex],
                        groups: groups,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
