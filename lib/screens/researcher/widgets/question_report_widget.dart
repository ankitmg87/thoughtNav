// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/response.dart';
import 'package:thoughtnav/screens/researcher/widgets/response_report_widget.dart';

class QuestionReportWidget extends StatelessWidget {
  final List<Group> groups;
  final Question question;
  final List<dynamic> listForCSV;

  const QuestionReportWidget({Key key, this.question, this.groups, this.listForCSV})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    groups.sort((a, b) => a.groupIndex.compareTo(b.groupIndex));

    return Container(
      margin: EdgeInsets.only(left: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${question.questionNumber}. ${question.questionTitle}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          HtmlWidget(question.questionStatement),
          SizedBox(
            height: 20.0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(groups.length, (groupIndex) {
              var responsesFromThisGroup = <Response>[];

              var responsesInThisQuestion = question.responses;

              for (var response in responsesInThisQuestion) {
                if (response.participantGroupUID ==
                    groups[groupIndex].groupUID) {
                  responsesFromThisGroup.add(response);
                }
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${groups[groupIndex].groupIndex}. ${groups[groupIndex].groupName}',
                    style: TextStyle(
                      color: PROJECT_GREEN,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),

                  responsesFromThisGroup.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: responsesFromThisGroup.length,
                          itemBuilder:
                              (BuildContext context, int responseIndex) {
                            return ResponseReportWidget(
                              response: responsesFromThisGroup[responseIndex],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 10.0,
                            );
                          },
                        )
                      : Text(
                          'No responses from this group yet',
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  SizedBox(height: 20.0,)
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
