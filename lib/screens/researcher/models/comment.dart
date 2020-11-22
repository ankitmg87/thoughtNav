import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String commentUID;
  String avatarURL;
  String alias;
  String userName;
  String timeElapsed;
  String date;
  String commentStatement;
  String userUID;
  Timestamp commentTimestamp;

  Comment({
    this.commentUID,
    this.avatarURL,
    this.alias,
    this.userName,
    this.timeElapsed,
    this.date,
    this.commentStatement,
    this.userUID,
    this.commentTimestamp,
  });

  Map<String, dynamic> toMap () {
    var comment = <String, dynamic>{};

    comment['commentUID'] = commentUID;
    comment['avatarURL'] = avatarURL;
    comment['alias'] = alias;
    comment['userName'] = userName;
    comment['timeElapsed'] = timeElapsed;
    comment['date'] = date;
    comment['commentStatement'] = commentStatement;
    comment['userUID'] = userUID;
    comment['commentTimestamp'] = commentTimestamp;

    return comment;
  }

  Comment.fromMap(Map<String, dynamic> comment){
    commentUID = comment['commentUID'];
    avatarURL = comment['avatarURL'];
    alias = comment['alias'];
    userName = comment['userName'];
    timeElapsed = comment['timeElapsed'];
    date = comment['date'];
    commentStatement = comment['commentStatement'];
    commentTimestamp = comment['commentTimestamp'];
    userUID = comment['userUID'];
  }

}
