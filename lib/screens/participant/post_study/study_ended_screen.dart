import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/string_constants.dart';

class StudyEndedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          APP_NAME,
          style: TextStyle(
            color: TEXT_COLOR,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 50.0,
          ),
          Text(
            'Study Closed',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TEXT_COLOR.withOpacity(0.7),
              fontSize: 24.0,
            ),
          ),
          Text(
            'Power Wheelchair Study',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TEXT_COLOR.withOpacity(0.8),
              fontSize: 14.0,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                color: TEXT_COLOR.withOpacity(0.7),
                fontSize: 16.0,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: 'Began on ',
                ),
                TextSpan(
                  text: 'Monday, May 6',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '\nEnded on ',
                ),
                TextSpan(
                  text: 'Friday, May 10.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50.0,
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
                            '5',
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
                width: 20.0,
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
          SizedBox(
            height: 30.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.15),
            child: Text(
              'The Power Wheelchair Study has concluded. Please contact the administrator if you think there is a mistake.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TEXT_COLOR.withOpacity(0.7),
                fontSize: 16.0,
              ),
            ),
          ),
          SizedBox(
            height: 60.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.15),
            child: Row(
              children: [
                Expanded(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    color: PROJECT_GREEN,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Contact Administrator',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: (){},
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
