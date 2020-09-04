import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';

class QuestionAndDescriptionContainer extends StatelessWidget {
  const QuestionAndDescriptionContainer({
    Key key,
    @required this.screenSize,
    this.number,
    this.title,
    this.question,
    this.description, this.studyName,
  }) : super(key: key);

  final Size screenSize;
  final String studyName;
  final String number;
  final String title;
  final String question;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: screenSize.width * 0.1,
          child: Transform.rotate(
            angle: 0.785398,
            child: Container(
              width: 40.0,
              height: 40.0,
              color: PROJECT_NAVY_BLUE,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            left: 30.0,
            right: 30.0,
            bottom: 30.0,
            top: 20.0,
          ),
          width: screenSize.width,
          color: PROJECT_NAVY_BLUE,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                studyName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                '$number. $title',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 25.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
