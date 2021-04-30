// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

class ReportStudy {
  String studyName;
  String internalStudyLabel;
  String studyStatus;
  String beginDate;
  String endDate;
  String activeParticipants;
  String totalParticipants;
  String totalResponses;
  String totalComments;
  List<Map<String, dynamic>> reportTopics;
  ReportStudy({
    this.studyName,
    this.internalStudyLabel,
    this.studyStatus,
    this.beginDate,
    this.endDate,
    this.activeParticipants,
    this.totalParticipants,
    this.totalResponses,
    this.totalComments,
    this.reportTopics,
  });
  Map toMap(ReportStudy reportStudy){
    var reportStudyMap = <String, dynamic>{};
    reportStudyMap['studyName'] = reportStudy.studyName;
    reportStudyMap['internalStudyLabel'] = reportStudy.internalStudyLabel;
    reportStudyMap['studyStatus'] = reportStudy.studyStatus;
    reportStudyMap['beginDate'] = reportStudy.beginDate;
    reportStudyMap['endDate'] = reportStudy.endDate;
    reportStudyMap['activeParticipants'] = reportStudy.activeParticipants;
    reportStudyMap['totalParticipants'] = reportStudy.totalParticipants;
    reportStudyMap['totalResponses'] = reportStudy.totalResponses;
    reportStudyMap['totalComments'] = reportStudy.totalComments;
    reportStudyMap['reportTopics'] = reportStudy.reportTopics;
    return reportStudyMap;
  }
}