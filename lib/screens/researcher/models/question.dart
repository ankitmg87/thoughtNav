import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoughtnav/screens/researcher/models/response.dart';

class Question{
  String questionUID;
  String questionNumber;
  String questionTitle;
  String questionStatement;
  String questionType;
  String previousQuestionUID;
  Timestamp questionTimestamp;
  List<Response> responses;
  int totalResponses;
  int totalComments;
  List<dynamic> groups;
  List<dynamic> respondedBy;
  bool hasMedia;

  Question({
    this.questionUID,
    this.questionNumber,
    this.questionTitle,
    this.questionStatement,
    this.questionType,
    this.questionTimestamp,
    this.responses,
    this.totalResponses,
    this.totalComments,
    this.groups,
    this.respondedBy,
    this.hasMedia,
  });

  Map<String, dynamic> toMap () {
    var question = <String, dynamic>{};

    question['questionUID'] = questionUID;
    question['questionNumber'] = questionNumber;
    question['questionTitle'] = questionTitle;
    question['questionStatement'] = questionStatement;
    question['questionType'] = questionType;
    question['questionTimestamp'] = questionTimestamp;
    question['totalResponses'] = totalResponses;
    question['totalComments'] = totalComments;
    question['groups'] = groups;
    question['hasMedia'] = hasMedia;

    return question;
  }

  Question.fromMap(Map<String, dynamic> question){

    questionUID = question['questionUID'];
    questionNumber = question['questionNumber'];
    questionTitle = question['questionTitle'];
    questionStatement = question['questionStatement'];
    questionType = question['questionType'];
    questionTimestamp = question['questionTimestamp'];
    totalResponses = question['totalResponses'];
    totalComments = question['totalComments'];
    groups = question['groups'];
    hasMedia = question['hasMedia'];
    respondedBy = question['respondedBy'];
  }

}