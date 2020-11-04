import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';

class Topic {
  String topicUID;
  String topicName;
  Timestamp topicDate;
  int topicIndex;
  List<Question> questions;

  Topic({
    this.topicUID,
    this.topicName,
    this.topicDate,
    this.topicIndex,
    this.questions
  });

  Map<String, dynamic> toMap() {
    var topic = <String, dynamic>{};

    topic['topicUID'] = topicUID;
    topic['topicName'] = topicName;
    topic['topicDate'] = topicDate;
    topic['topicIndex'] = topicIndex;

    return topic;
  }

  Topic.fromMap(Map<String, dynamic> topic){
    topicUID = topic['topicUID'];
    topicName = topic['topicName'];
    topicDate = topic['topicDate'];
    topicIndex = topic['topicIndex'];
  }

}
