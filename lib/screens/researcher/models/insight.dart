// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

import 'package:cloud_firestore/cloud_firestore.dart';

class Insight {
  String avatarURL;
  String name;
  String insightStatement;
  String questionNumber;
  String questionTitle;
  String topicUID;
  String questionUID;
  Timestamp insightTimestamp;

  Insight({
    this.avatarURL,
    this.name,
    this.insightStatement,
    this.questionNumber,
    this.questionTitle,
    this.topicUID,
    this.questionUID,
    this.insightTimestamp,
  });

  Map<String, dynamic> toMap() {
    var insightMap = <String, dynamic>{};

    insightMap['avatarURL'] = avatarURL;
    insightMap['name'] = name;
    insightMap['insightStatement'] = insightStatement;
    insightMap['questionNumber'] = questionNumber;
    insightMap['questionTitle'] = questionTitle;
    insightMap['topicUID'] = topicUID;
    insightMap['questionUID'] = questionUID;
    insightMap['insightTimestamp'] = insightTimestamp;

    return insightMap;
  }

  Insight.fromMap(Map<String, dynamic> insightMap){
    avatarURL = insightMap['avatarURL'];
    name = insightMap['name'];
    insightStatement = insightMap['insightStatement'];
    questionNumber = insightMap['questionNumber'];
    questionTitle = insightMap['questionTitle'];
    topicUID = insightMap['topicUID'];
    questionUID = insightMap['questionUID'];
    insightTimestamp = insightMap['insightTimestamp'];
  }

}
