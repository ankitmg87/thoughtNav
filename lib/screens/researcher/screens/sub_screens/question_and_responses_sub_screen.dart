import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/misc_constants.dart';
import 'package:thoughtnav/screens/researcher/widgets/reponse_widget.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class QuestionAndResponsesSubScreen extends StatefulWidget {
  const QuestionAndResponsesSubScreen({
    Key key,
    @required this.screenSize,
    this.studyUID,
    this.topicUID,
    this.questionUID,
    this.studyName,
    this.topicName,
    this.firebaseFirestoreService, this.internalStudyLabel,
  }) : super(key: key);

  final Size screenSize;
  final String studyUID;
  final String topicUID;
  final String questionUID;
  final String studyName;
  final String internalStudyLabel;
  final String topicName;
  final FirebaseFirestoreService firebaseFirestoreService;

  @override
  _QuestionAndResponsesSubScreenState createState() =>
      _QuestionAndResponsesSubScreenState();
}

class _QuestionAndResponsesSubScreenState
    extends State<QuestionAndResponsesSubScreen> {
  Stream _getQuestion;
  Stream _getResponses;
  Stream _getComments;

  void _getQuestionStream() {
    _getQuestion = widget.firebaseFirestoreService
        .getQuestion(widget.studyUID, widget.questionUID, widget.topicUID);
  }

  void _getResponsesStream() {
    _getResponses = widget.firebaseFirestoreService
        .getQuestion(widget.studyUID, widget.topicUID, widget.questionUID);
  }

  // void _getCommentsStream(){
  //   _getComments = widget.firebaseFirestoreService.get
  // }

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Column(
        children: [
          _QuestionDisplayBar(),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 20.0,
              ),
              child: ListView(
                children: [
                  ResponseWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionDisplayBar extends StatelessWidget {
  final String studyName;
  final String internalStudyLabel;
  final String topicName;
  final String questionTitle;
  final String questionStatement;
  final int responses;
  final int comments;

  const _QuestionDisplayBar(
      {Key key,
      this.studyName,
      this.internalStudyLabel,
      this.topicName,
      this.questionTitle,
      this.questionStatement,
      this.responses,
      this.comments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 30.0,
      ),
      color: Colors.grey[100],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: screenSize.width * 0.55,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Study Name (Internal study label)',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  'Welcome to "Topic name"',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Question title',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  TEMPORARY_QUESTION,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          Container(
            width: 250.0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Responses',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '0',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comments',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '0',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
