import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';

class ProgressRow extends StatelessWidget {
  final int totalQuestions;
  final int currentQuestionNumber;
  final int completedQuestions;
  final Size screenSize;

  const ProgressRow({Key key,
    this.totalQuestions,
    this.currentQuestionNumber,
    this.completedQuestions, this.screenSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: totalQuestions,
        itemBuilder: (context, index) {
          if (index < currentQuestionNumber - 1) {
            return _ProgressedContainer(
              screenSize: screenSize,
              totalQuestions: totalQuestions,
            );
          }
          else if (index == currentQuestionNumber - 1) {
            return _ProgressingContainer(
              screenSize: screenSize,
              totalQuestions: totalQuestions,
            );
          }
          else return _UnProgressedContainer(
            screenSize: screenSize,
            totalQuestions: totalQuestions,
          );
        },
      ),
    );
  }
}

class _ProgressedContainer extends StatelessWidget {
  final Size screenSize;
  final int totalQuestions;

  const _ProgressedContainer({Key key, this.screenSize, this.totalQuestions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.5),
      color: PROJECT_GREEN,
      width: screenSize.width * (1 / totalQuestions),
      height: 10.0,
    );
  }
}

class _ProgressingContainer extends StatelessWidget {
  final Size screenSize;
  final int totalQuestions;

  const _ProgressingContainer({Key key, this.screenSize, this.totalQuestions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.5),
      width: screenSize.width * (1 / totalQuestions),
      height: 10.0,
      color: PROJECT_GREEN.withOpacity(0.2),
    );
  }
}

class _UnProgressedContainer extends StatelessWidget {
  final Size screenSize;
  final int totalQuestions;

  const _UnProgressedContainer({Key key, this.screenSize, this.totalQuestions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.5),
      width: screenSize.width * (1 / totalQuestions),
      height: 10.0,
      color: SCAFFOLD_BACKGROUND_COLOR,
    );
  }
}
