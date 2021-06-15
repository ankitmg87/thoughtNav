// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';

import 'study_details_bottom_sheet.dart';

class DashboardTopContainer extends StatelessWidget {
  const DashboardTopContainer({
    Key key,
    this.scaffoldKey,
    this.studyName,
    this.nextTopicName,
    this.studyBeginDate,
    this.studyEndDate,
    this.rewardAmount,
    this.introMessage, this.answeredQuestions, this.totalQuestions, this.nextQuestionWidget,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final String studyName;
  final String nextTopicName;
  final String studyBeginDate;
  final String studyEndDate;
  final String rewardAmount;
  final String introMessage;
  final int answeredQuestions;
  final int totalQuestions;
  final Widget nextQuestionWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 30.0,
        top: 30.0,
        right: 30.0,
        bottom: 15.0,
      ),
      color: Color(0xFF092A66),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            studyName,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          GestureDetector(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Text(
                    'View Details',
                    style: TextStyle(
                      color: PROJECT_GREEN,
                    ),
                  ),
                  onTap: () => scaffoldKey.currentState.showBottomSheet(
                    (context) {
                      return StudyDetailsBottomSheet(
                        studyBeginDate: studyBeginDate,
                        studyEndDate: studyEndDate,
                        studyName: studyName,
                        rewardAmount: rewardAmount,
                        introMessage: introMessage,
                      );
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 16.0,
                  ),
                ),
                Icon(
                  CupertinoIcons.right_chevron,
                  color: PROJECT_GREEN,
                  size: 10.0,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            child: LinearProgressIndicator(
              backgroundColor:
              Colors.white.withOpacity(0.7),
              minHeight: 8.0,
              value: answeredQuestions / totalQuestions,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  answeredQuestions == 0
                      ? 'You have not answered any questions'
                      : answeredQuestions == 1
                      ? 'You have answered 1 question'
                      : 'You have answered $answeredQuestions questions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
              ),
              Expanded(
                child: nextQuestionWidget,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
