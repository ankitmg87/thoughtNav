import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 40.0,
          ),
          Text(
            'Welcome to\nPower Wheelchair Study',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: TEXT_COLOR.withOpacity(0.9),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 50.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.15,
            ),
            child: Text(
              'The Purpose of this study is to get your honest feedback about your personal experiences with your power wheelchair.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TEXT_COLOR,
                fontSize: 14.0,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.15,
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'You\'re participating in the\n',
                style: TextStyle(
                  color: TEXT_COLOR.withOpacity(0.8),
                  height: 1.5,
                  fontSize: 14.0,
                ),
                children: [
                  TextSpan(
                    text: 'Power Wheelchair Study',
                    style: TextStyle(
                      color: TEXT_COLOR.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 32.0,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                height: 1.5,
                fontSize: 14.0,
              ),
              children: [
                TextSpan(
                  text: 'It begins ',
                  style: TextStyle(
                    color: TEXT_COLOR.withOpacity(0.8),
                  ),
                ),
                TextSpan(
                  text: 'Monday, May 6',
                  style: TextStyle(
                    color: TEXT_COLOR.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '\nand ends ',
                  style: TextStyle(
                    color: TEXT_COLOR.withOpacity(0.8),
                  ),
                ),
                TextSpan(
                  text: 'Friday, May 10.',
                  style: TextStyle(
                    color: TEXT_COLOR.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 32.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Monday',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TEXT_COLOR.withOpacity(0.6),
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Card(
                    child: Container(
                      width: 50.0,
                      padding: EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'May',
                            style: TextStyle(
                              color: TEXT_COLOR.withOpacity(0.8),
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '6',
                            style: TextStyle(
                              color: TEXT_COLOR.withOpacity(0.7),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 40.0,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Friday',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TEXT_COLOR.withOpacity(0.6),
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Card(
                    child: Container(
                      width: 50.0,
                      padding: EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'May',
                            style: TextStyle(
                              color: TEXT_COLOR.withOpacity(0.8),
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '10',
                            style: TextStyle(
                              color: TEXT_COLOR.withOpacity(0.7),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.4, vertical: 20.0),
            height: 1.0,
            color: TEXT_COLOR.withOpacity(0.6),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.3),
            alignment: Alignment.center,
            child: Text(
              'Login each day and post responses to the questions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                color: TEXT_COLOR.withOpacity(0.8),
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.25),
            child: Row(
              children: [
                Expanded(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    onPressed: () =>
                        Navigator.of(context).popAndPushNamed(DASHBOARD_SCREEN),
                    color: PROJECT_GREEN,
                    child: Text(
                      'LET\'S GET STARTED',
                      style: TextStyle(
                        color: Colors.white,
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
