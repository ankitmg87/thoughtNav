// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines the dialogue box that is shown when the participant wants
/// to view study details on a desktop

import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';

class StudyDetailsGeneralDialogWidget extends StatelessWidget {
  const StudyDetailsGeneralDialogWidget({
    Key key,
    @required Study study,
    @required Participant participant,
    @required this.context,
  })  : _study = study,
        _participant = participant,
        super(key: key);

  final Study _study;
  final Participant _participant;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding:
          EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 20.0),
          child: Text(
            'You\'re participating in the ${_study.studyName}.',
            style: TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 12.0,
          ),
          child: Row(
            children: [
              Image(
                width: 30.0,
                image: AssetImage(
                  'images/svg_icons/calender_icon.png',
                ),
              ),
              SizedBox(
                width: 40.0,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'This study begins ',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF333333),
                      ),
                    ),
                    TextSpan(
                      text: '${_study.startDate}\n',
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'and ends ',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF333333),
                      ),
                    ),
                    TextSpan(
                      text: '${_study.endDate}.',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Row(
            children: [
              Image(
                width: 30.0,
                image: AssetImage(
                  'images/svg_icons/dollar.png',
                ),
              ),
              SizedBox(
                width: 40.0,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                      'After you complete this study,\nyou\'ll be awarded a ',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF333333),
                      ),
                    ),
                    TextSpan(
                      text: '\$${_participant.rewardAmount} giftcard.',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.maxFinite,
          height: 0.5,
          color: Colors.grey[200],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Text(
            'About ${_study.studyName}',
            style: TextStyle(
              color: Color(0xFF7F7F7F),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'The purpose of this study is to receive your honest feedback about your personal experiences.',
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 12.0,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 12.0,
          ),
          child: Text(
            'Learn more about Focus Groups',
            style: TextStyle(
              color: PROJECT_GREEN,
              fontSize: 13.0,
            ),
          ),
        ),
        Container(
          width: double.maxFinite,
          height: 0.5,
          color: Colors.grey[200],
        ),
        Padding(
          padding:
          EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 6.0),
          child: Text(
            'Tips for completing this study',
            style: TextStyle(
              color: Color(0xFF7F7F7F),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 6.0,
            horizontal: 20.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Color(0xFF81D3F8),
                size: 14.0,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                'Login each day and respond to questions.',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 6.0,
            horizontal: 20.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Color(0xFF81D3F8),
                size: 14.0,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                'Comment on other posts. ',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 6.0,
            horizontal: 20.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Color(0xFF81D3F8),
                size: 14.0,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                'Set up your preferred reward method.',
                style: TextStyle(
                  color: PROJECT_GREEN,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.maxFinite,
          height: 0.5,
          color: Colors.grey[200],
        ),
        Padding(
          padding:
          EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 6.0),
          child: Text(
            'Be sure to remember...',
            style: TextStyle(
              color: Color(0xFF7F7F7F),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 6.0,
            horizontal: 20.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Color(0xFF81D3F8),
                size: 14.0,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                'All posts are anonymous. Your personal info is confidential.',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 6.0,
            horizontal: 20.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Color(0xFF81D3F8),
                size: 14.0,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                'Be open and honest with your answers.',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 6.0,
            horizontal: 20.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Color(0xFF81D3F8),
                size: 14.0,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                'Have fun!',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.maxFinite,
          height: 0.5,
          color: Colors.grey[200],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 40.0,
            horizontal: 20.0,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Contact Us ',
                  style: TextStyle(
                    color: PROJECT_GREEN,
                    fontSize: 13.0,
                  ),
                ),
                TextSpan(
                  text: 'for any additional questions or concerns',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 13.0,
                  ),
                ),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}