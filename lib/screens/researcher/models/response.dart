import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoughtnav/screens/researcher/models/comment.dart';

class Response {
  String responseUID;
  String participantUID;
  String avatarURL;
  String participantDisplayName;
  String userName;
  String timeElapsed;
  String responseStatement;
  List<dynamic> claps;
  int comments;
  Timestamp responseTimestamp;
  List<Comment> commentStatements;
  String questionNumber;
  String questionTitle;

  Response({
    this.responseUID,
    this.participantUID,
    this.avatarURL,
    this.participantDisplayName,
    this.userName,
    this.timeElapsed,
    this.responseStatement,
    this.claps,
    this.comments,
    this.responseTimestamp,
    this.commentStatements,
    this.questionNumber,
    this.questionTitle,
  });

  Map<String, dynamic> toMap () {
    var response = <String, dynamic>{};

    response['responseUID'] = responseUID;
    response['participantUID'] = participantUID;
    response['avatarURL'] = avatarURL;
    response['alias'] = participantDisplayName;
    response['userName'] = userName;
    response['timeElapsed'] = timeElapsed;
    response['responseStatement'] = responseStatement;
    response['claps'] = claps;
    response['comments'] = comments;
    response['responseTimestamp'] = responseTimestamp;
    response['questionNumber'] = questionNumber;
    response['questionTitle'] = questionTitle;

    return response;
  }

  Response.fromMap(Map<String, dynamic> response){
    responseUID = response['responseUID'];
    participantUID = response['participantUID'];
    avatarURL = response['avatarURL'];
    participantDisplayName = response['alias'];
    userName = response['userName'];
    timeElapsed = response['timeElapsed'];
    responseStatement = response['responseStatement'];
    claps = response['claps'];
    comments = response['comments'];
    responseTimestamp = response['responseTimestamp'];
  }


}
