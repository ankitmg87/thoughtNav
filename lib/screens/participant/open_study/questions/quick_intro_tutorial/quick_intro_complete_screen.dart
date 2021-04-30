// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';

class TopicCompleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF11B262),
      body: ListView(
        children: [
          SizedBox(
            height: screenSize.height * 0.1,
          ),
          Text(
            'Power Wheelchair Study',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
          SizedBox(
            height: screenSize.height * 0.1,
          ),
          Image(
            height: screenSize.height * 0.2,
            image: AssetImage(
              'images/questions_icons/quick_intro_complete_icon.png',
            ),
          ),
          SizedBox(
            height: screenSize.height * 0.1,
          ),
          Text(
            'Quick Intro Complete',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: screenSize.height * 0.1,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'You have completed all of\n',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                height: 1.5,
              ),
              children: [
                TextSpan(
                    text: 'Quick Intro\'s',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    )),
                TextSpan(
                    text: ' questions.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    )),
              ],
            ),
          ),
          // SizedBox(
          //   height: screenSize.height * 0.1,
          // ),
          // RichText(
          //   textAlign: TextAlign.center,
          //   text: TextSpan(
          //     style: TextStyle(
          //       height: 1.5,
          //     ),
          //     children: [
          //       TextSpan(
          //         text: 'Day One',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 14.0,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       TextSpan(
          //           text: ' is now available.\n',
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 14.0,
          //           )),
          //       TextSpan(
          //           text: 'Go to your Dashboard and get started.',
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 14.0,
          //           )),
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: screenSize.height * 0.01,
          // ),
          SizedBox(
            height: screenSize.height * 0.05,
          ),
          Padding(
            padding: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 40.0),
            child: Row(
              children: [
                Expanded(
                  child: FlatButton(
                    hoverColor: Color(0xFF1A4C88),
                    color: PROJECT_GREEN,
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(PARTICIPANT_DASHBOARD_SCREEN, (route) => false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Continue to Dashboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
