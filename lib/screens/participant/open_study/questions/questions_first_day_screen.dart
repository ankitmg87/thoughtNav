import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/participant/open_study/common_widgets/common_app_bar.dart';

class QuestionsFirstDayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: PROJECT_NAVY_BLUE,
      appBar: CommonAppBar(),
      body: ListView(
        children: [
          Row(
            children: [
              Container(
                width: screenSize.width * 0.2,
                height: 10.0,
                color: PROJECT_GREEN,
              ),
              Container(
                width: screenSize.width * 0.8,
                height: 10.0,
                color: SCAFFOLD_BACKGROUND_COLOR,
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'Power Wheelchair Study',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              '1.1 Welcome to Day 1',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'Welcome to Day 1 of our online discussion.\nWe are very excited to have you join us!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'We’re going to be focusing our discussion on activities of daily living (ADLs). What we mean by that is:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
            child: Image(
              image: AssetImage(
                'images/study_illustration.png',
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
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pushNamed(QUESTION_SCREEN),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60.0,
          ),
        ],
      ),
    );
  }
}
