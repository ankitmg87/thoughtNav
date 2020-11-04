import 'package:thoughtnav/screens/researcher/models/comment.dart';

class Response {
  String avatarURL;
  String alias;
  String userName;
  String timeElapsed;
  String date;
  String responseStatement;
  int claps;
  List<Map<String, dynamic>> comments;

  Response({
    this.avatarURL,
    this.alias,
    this.userName,
    this.timeElapsed,
    this.date,
    this.responseStatement,
    this.claps,
    this.comments,
  });

  Map<String, dynamic> toMap () {
    var response = <String, dynamic>{};

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
    avatarURL = response['avatarURL'];
    alias = response['alias'];
    userName = response['userName'];
    timeElapsed = response['timeElapsed'];
    date = response['responseStatement'];
    claps = response['claps'];
    comments = response['comments'];
  }


}
