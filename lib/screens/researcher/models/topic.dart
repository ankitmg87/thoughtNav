import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';

class Topic {
  String topicUID;
  String topicName;
  Timestamp topicDate;
  int topicIndex;
  List<Question> questions;
  bool isActive;

  Topic({
    this.topicUID,
    this.topicName,
    this.topicDate,
    this.topicIndex,
    this.questions,
    this.isActive,
  });

  Map<String, dynamic> toMap() {
    var topic = <String, dynamic>{};

    topic['topicUID'] = topicUID;
    topic['topicName'] = topicName;
    topic['topicDate'] = topicDate;
    topic['topicIndex'] = topicIndex;
    topic['isActive'] = isActive;

    return topic;
  }

  Topic.fromMap(Map<String, dynamic> topic){
    topicUID = topic['topicUID'];
    topicName = topic['topicName'];
    topicDate = topic['topicDate'];
    topicIndex = topic['topicIndex'];
    isActive = topic['isActive'];
  }

}
