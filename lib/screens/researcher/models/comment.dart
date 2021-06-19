// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines the comment model

import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String commentUID;
  String avatarURL;
  String displayName;
  String participantName;
  String commentStatement;
  String participantUID;
  String commentType;
  Timestamp commentTimestamp;

  Comment({
    this.commentUID,
    this.avatarURL,
    this.displayName,
    this.participantName,
    this.commentStatement,
    this.participantUID,
    this.commentType,
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
    comment['commentType'] = commentType;
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
    commentType = comment['commentType'];
  }

}
