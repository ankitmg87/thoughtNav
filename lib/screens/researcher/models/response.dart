// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines the response model

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoughtnav/screens/researcher/models/comment.dart';

class Response {
  String responseUID;
  String participantUID;
  String participantGroupUID;
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
  bool hasMedia;
  bool questionHasMedia;
  String mediaType;
  String mediaURL;
  dynamic media;
  bool participantDeleted;

  Response({
    this.responseUID,
    this.participantUID,
    this.participantGroupUID,
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
    this.hasMedia,
    this.questionHasMedia,
    this.mediaType,
    this.mediaURL,
    this.media,
    this.participantDeleted,
  });

  Map<String, dynamic> toMap() {
    var response = <String, dynamic>{};

    response['responseUID'] = responseUID;
    response['participantUID'] = participantUID;
    response['participantGroupUID'] = participantGroupUID;
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
    response['hasMedia'] = hasMedia;
    response['questionHasMedia'] = questionHasMedia;
    response['mediaType'] = mediaType;
    response['mediaURL'] = mediaURL;
    response['participantDeleted'] = participantDeleted;

    return response;
  }

  Response.fromMap(Map<String, dynamic> response) {
    responseUID = response['responseUID'];
    participantUID = response['participantUID'];
    participantGroupUID = response['participantGroupUID'];
    avatarURL = response['avatarURL'];
    participantDisplayName = response['alias'];
    userName = response['userName'];
    timeElapsed = response['timeElapsed'];
    responseStatement = response['responseStatement'];
    claps = response['claps'];
    comments = response['comments'];
    responseTimestamp = response['responseTimestamp'];
    questionNumber = response['questionNumber'];
    questionTitle = response['questionTitle'];
    hasMedia = response['hasMedia'];
    questionHasMedia = response['questionHasMedia'];
    mediaType = response['mediaType'];
    mediaURL = response['mediaURL'];
    participantDeleted = response['participantDeleted'];
  }
}
