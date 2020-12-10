import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  String avatarURL;
  String displayName;
  Timestamp notificationTimestamp;
  String notificationType;
  String questionName;
  String topicName;
  String questionNumber;
  // String participantUID;

  Notification({
    this.avatarURL,
    this.displayName,
    this.notificationTimestamp,
    this.notificationType,
    this.questionName,
    this.topicName,
    this.questionNumber
    // this.participantUID,
  });

  Map<String, dynamic> toMap() {
    var notificationMap = <String, dynamic>{};

    notificationMap['avatarURL'] = avatarURL;
    notificationMap['displayName'] = displayName;
    notificationMap['notificationTimestamp'] = notificationTimestamp;
    notificationMap['notificationType'] = notificationType;
    notificationMap['questionName'] = questionName;
    notificationMap['topicName'] = topicName;
    notificationMap['questionNumber'] = questionNumber;
    // notificationMap['participantUID'] = participantUID;

    return notificationMap;
  }

  Notification.fromMap(Map<String, dynamic> notificationMap){
    avatarURL = notificationMap['avatarURL'];
    displayName = notificationMap['displayName'];
    notificationTimestamp = notificationMap['notificationTimestamp'];
    notificationType = notificationMap['notificationType'];
    questionName = notificationMap['questionName'];
    topicName = notificationMap['topicName'];
    questionNumber = notificationMap['questionNumber'];
    // participantUID = notificationMap['participantUID'];
  }

}
