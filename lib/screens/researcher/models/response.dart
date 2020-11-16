import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoughtnav/screens/researcher/models/comment.dart';

class Response {
  String responseUID;
  String participantUID;
  String avatarURL;
  String alias;
  String userName;
  String timeElapsed;
  String date;
  String responseStatement;
  int claps;
  int comments;
  Timestamp responseTimestamp;
  List<Comment> commentStatements;

  Response({
    this.responseUID,
    this.participantUID,
    this.avatarURL,
    this.alias,
    this.userName,
    this.timeElapsed,
    this.date,
    this.responseStatement,
    this.claps,
    this.comments,
    this.responseTimestamp,
    this.commentStatements,
  });

  Map<String, dynamic> toMap () {
    var response = <String, dynamic>{};

    response['responseUID'] = responseUID;
    response['participantUID'] = participantUID;
    response['avatarURL'] = avatarURL;
    response['alias'] = alias;
    response['userName'] = userName;
    response['timeElapsed'] = timeElapsed;
    response['date'] = date;
    response['responseStatement'] = responseStatement;
    response['claps'] = claps;
    response['comments'] = comments;
    response['responseTimestamp'] = responseTimestamp;

    return response;
  }

  Response.fromMap(Map<String, dynamic> response){
    responseUID = response['responseUID'];
    participantUID = response['participantUID'];
    avatarURL = response['avatarURL'];
    alias = response['alias'];
    userName = response['userName'];
    timeElapsed = response['timeElapsed'];
    date = response['date'];
    responseStatement = response['responseStatement'];
    claps = response['claps'];
    comments = response['comments'];
    responseTimestamp = response['responseTimestamp'];
  }


}
