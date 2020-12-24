import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String commentUID;
  String avatarURL;
  String displayName;
  String participantName;
  String commentStatement;
  String participantUID;
  Timestamp commentTimestamp;

  Comment({
    this.commentUID,
    this.avatarURL,
    this.displayName,
    this.participantName,
    this.commentStatement,
    this.participantUID,
    this.commentTimestamp,
  });

  Map<String, dynamic> toMap () {
    var comment = <String, dynamic>{};

    comment['commentUID'] = commentUID;
    comment['avatarURL'] = avatarURL;
    comment['displayName'] = displayName;
    comment['participantName'] = participantName;
    comment['commentStatement'] = commentStatement;
    comment['participantUID'] = participantUID;
    comment['commentTimestamp'] = commentTimestamp;

    return comment;
  }

  Comment.fromMap(Map<String, dynamic> comment){
    commentUID = comment['commentUID'];
    avatarURL = comment['avatarURL'];
    displayName = comment['displayName'];
    participantName = comment['participantName'];
    commentStatement = comment['commentStatement'];
    commentTimestamp = comment['commentTimestamp'];
    participantUID = comment['participantUID'];
  }

}
