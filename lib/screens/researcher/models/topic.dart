// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';

class Topic {
  String topicUID;
  String topicNumber;
  String topicName;
  Timestamp topicDate;
  List<Question> questions;

  Topic({
    this.topicUID,
    this.topicNumber,
    this.topicName,
    this.topicDate,
    this.questions,
  });

  Map<String, dynamic> toMap() {
    var topic = <String, dynamic>{};

    topic['topicUID'] = topicUID;
    topic['topicNumber'] = topicNumber;
    topic['topicName'] = topicName;
    topic['topicDate'] = topicDate;

    return topic;
  }

  Topic.fromMap(Map<String, dynamic> topic){
    topicUID = topic['topicUID'];
    topicNumber = topic['topicNumber'];
    topicName = topic['topicName'];
    topicDate = topic['topicDate'];
  }

}
