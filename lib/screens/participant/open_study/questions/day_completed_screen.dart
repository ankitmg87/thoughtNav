import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';

class DayCompletedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF11B262),
      body: ListView(
        children: [
          SizedBox(
            height: 20.0,
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
            height: 60.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.35),
            child: Image(
              image: AssetImage(
                'images/questions_icons/quick_intro_complete_icon.png',
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Text(
            'Day One Complete!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'You have completed all of\n',
              style: TextStyle(
                height: 1.5,
                color: Colors.white,
                fontSize: 14.0,
              ),
              children: [
                TextSpan(
                  text: 'Day One',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '\'s',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' questions.',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60.0,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                color: Colors.white,
              ),
              children: [
                TextSpan(
                  text: 'Day Two',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' is now available.',
                ),
              ]
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlineButton(
                  hoverColor: Color(0xFF1A4C88),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  borderSide: BorderSide(color: Colors.white, width: 5.0),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          'SET REMINDER',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                    onPressed: () {},
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
