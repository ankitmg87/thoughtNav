import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/participant/open_study/common_widgets/common_app_bar.dart';
import 'package:thoughtnav/screens/participant/open_study/questions/questions_widgets/progress_row.dart';
import 'package:thoughtnav/screens/participant/open_study/questions/questions_widgets/question_and_description_container.dart';

class QuestionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CommonAppBar(),
      body: Column(
        children: [
          ProgressRow(
            totalQuestions: 6,
            currentQuestionNumber: 5,
            screenSize: screenSize,
            completedQuestions: 0,
          ),
          Expanded(
            child: ListView(
              children: [
                QuestionAndDescriptionContainer(
                  screenSize: screenSize,
                  // studyName: 'Power Wheelchair Study',
                  number: '1.1',
                  title: 'Getting to Know You',
                  // question:
                  //     'How many years have you been using any power wheelchair?',
                  description:
                      'Please tell us a little bit about your primary diagnosis and what that means in terms of what you are able to do independently vs. things you need assistance with.',
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.2),
            child: Row(
              children: [
                Expanded(
                  child: FlatButton(
                    color: PROJECT_GREEN,
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      // Navigator.of(context).pushNamed(DAY_COMPLETED_SCREEN);
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
