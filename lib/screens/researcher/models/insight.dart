import 'package:cloud_firestore/cloud_firestore.dart';

class Insight {
  String moderatorAvatarURL;
  String moderatorName;
  String insightStatement;
  String questionNumber;
  String questionTitle;
  String topicUID;
  String questionUID;
  Timestamp insightTimestamp;

  Insight({
    this.moderatorAvatarURL,
    this.moderatorName,
    this.insightStatement,
    this.questionNumber,
    this.questionTitle,
    this.topicUID,
    this.questionUID,
    this.insightTimestamp,
  });

  Map<String, dynamic> toMap(Insight insight) {
    var insightMap = <String, dynamic>{};

    insightMap['moderatorAvatarURL'] = moderatorAvatarURL;
    insightMap['moderatorName'] = moderatorName;
    insightMap['insightStatement'] = insightStatement;
    insightMap['questionNumber'] = questionNumber;
    insightMap['questionTitle'] = questionTitle;
    insightMap['topicUID'] = topicUID;
    insightMap['questionUID'] = questionUID;
    insightMap['insightTimestamp'] = insightTimestamp;

    return insightMap;
  }

  Insight.fromMap(Map<String, dynamic> insightMap){
    moderatorAvatarURL = insightMap['moderatorAvatarURL'];
    moderatorName = insightMap['moderatorName'];
    insightStatement = insightMap['insightStatement'];
    questionNumber = insightMap['questionNumber'];
    questionTitle = insightMap['questionTitle'];
    topicUID = insightMap['topicUID'];
    questionUID = insightMap['questionUID'];
    insightTimestamp = insightMap['insightTimestamp'];
  }

}
