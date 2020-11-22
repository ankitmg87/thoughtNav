import 'package:thoughtnav/screens/researcher/models/response.dart';

class Question{
  int questionIndex;
  String questionUID;
  String questionNumber;
  String questionTitle;
  String questionStatement;
  String questionType;
  List<Response> responses;
  int totalResponses;
  int totalComments;
  List groups;

  Question({
    this.questionIndex,
    this.questionUID,
    this.questionNumber,
    this.questionTitle,
    this.questionStatement,
    this.questionType,
    this.responses,
    this.totalResponses,
    this.totalComments,
    this.groups
  });

  Map<String, dynamic> toMap () {
    var question = <String, dynamic>{};

    question['questionIndex'] = questionIndex;
    question['questionUID'] = questionUID;
    question['questionNumber'] = questionNumber;
    question['questionTitle'] = questionTitle;
    question['questionStatement'] = questionStatement;
    question['questionType'] = questionType;
    question['totalResponses'] = totalResponses;
    question['totalComments'] = totalComments;
    question['groups'] = groups;

    return question;
  }

  Question.fromMap(Map<String, dynamic> question){

    questionIndex = question['questionIndex'];
    questionUID = question['questionUID'];
    questionNumber = question['questionNumber'];
    questionTitle = question['questionTitle'];
    questionStatement = question['questionStatement'];
    questionType = question['questionType'];
    totalResponses = question['totalResponses'];
    totalComments = question['totalComments'];
    groups = question['groups'];
  }

}