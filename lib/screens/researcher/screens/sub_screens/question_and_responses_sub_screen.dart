import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/misc_constants.dart';
import 'package:thoughtnav/screens/researcher/widgets/reponse_widget.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class QuestionAndResponsesSubScreen extends StatefulWidget {
  const QuestionAndResponsesSubScreen({
    Key key,
    this.studyUID,
    this.topicUID,
    this.questionUID,
    this.firebaseFirestoreService,
  }) : super(key: key);

  final String studyUID;
  final String topicUID;
  final String questionUID;
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

  String topicUID;
  String _topicName;

  void _getTopicName() async {
    _topicName = await widget.firebaseFirestoreService.getTopicName(widget.studyUID, widget.topicUID);
  }

  Stream _getQuestionStream(String studyUID, String topicUID, String questionUID) {
    _getTopicName();
    return widget.firebaseFirestoreService
        .getQuestionAsStream(studyUID, topicUID, questionUID);
  }

  void _getResponsesStream() {
    _getResponses = widget.firebaseFirestoreService
        .getQuestionAsStream(widget.studyUID, widget.topicUID, widget.questionUID);
  }

  @override
  void initState() {

    topicUID = widget.topicUID;

    _getResponsesStream();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Column(
        children: [
          StreamBuilder(
            stream: _getQuestionStream(widget.studyUID, widget.topicUID, widget.questionUID),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.connectionState == ConnectionState.active){
                if(snapshot.hasData){
                  return _QuestionDisplayBar(
                    topicName: _topicName,
                    questionTitle: snapshot.data['questionTitle'],
                    questionStatement: snapshot.data['questionStatement'],
                    responses: snapshot.data['responses'],
                    comments: snapshot.data['comments'],
                  );
                }
                else {
                  return SizedBox();
                }
              }
              else {
                return SizedBox();
              }
            },
          ),
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
  final String topicName;
  final String questionTitle;
  final String questionStatement;
  final int responses;
  final int comments;

  const _QuestionDisplayBar(
      {Key key,
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
                  topicName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  questionTitle,
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
                  questionStatement,
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
                      '$responses',
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
                      '$comments',
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
