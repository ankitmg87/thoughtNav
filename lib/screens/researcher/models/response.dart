import 'package:thoughtnav/screens/researcher/models/comment.dart';

class Response {
  String responseUID;
  String avatarURL;
  String alias;
  String userName;
  String timeElapsed;
  String date;
  String responseStatement;
  int claps;
  int comments;
  List<Comment> commentStatements;

  Response({
    this.responseUID,
    this.avatarURL,
    this.alias,
    this.userName,
    this.timeElapsed,
    this.date,
    this.responseStatement,
    this.claps,
    this.comments,
    this.commentStatements,
  });

  Map<String, dynamic> toMap () {
    var response = <String, dynamic>{};

    response['responseUID'] = responseUID;
    response['avatarURL'] = avatarURL;
    response['alias'] = alias;
    response['userName'] = userName;
    response['timeElapsed'] = timeElapsed;
    response['date'] = date;
    response['responseStatement'] = responseStatement;
    response['claps'] = claps;
    response['comments'] = comments;

    return response;
  }

  Response.fromMap(Map<String, dynamic> response){
    responseUID = response['responseUID'];
    avatarURL = response['avatarURL'];
    alias = response['alias'];
    userName = response['userName'];
    timeElapsed = response['timeElapsed'];
    date = response['responseStatement'];
    claps = response['claps'];
    comments = response['comments'];
  }


}
