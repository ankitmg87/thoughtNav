// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines the report topic model

class ReportTopic {
  String topicName;
  String topicNumber;
  List<Map<String, dynamic>> reportQuestions;
  ReportTopic({
    this.topicName,
    this.topicNumber,
    this.reportQuestions,
  });
  Map toMap(ReportTopic reportTopic){
    var reportTopicMap = <String, dynamic>{};
    reportTopicMap['topicName'] = reportTopic.topicName;
    reportTopicMap['topicNumber'] = reportTopic.topicNumber;
    reportTopicMap['reportQuestions'] = reportTopic.reportQuestions;
    return reportTopicMap;
  }
}