// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines the report response model

class ReportResponse {
  String participantDisplayName;
  String dateAndTime;
  String responseStatement;
  String participantAvatarURL;
  String mediaURL;
  String mediaType;
  String claps;
  String comments;
  ReportResponse({
    this.participantDisplayName,
    this.dateAndTime,
    this.responseStatement,
    this.participantAvatarURL,
    this.mediaURL,
    this.mediaType,
    this.claps,
    this.comments,
  });
  Map toMap(ReportResponse reportResponse){
    var reportResponseMap = <String, dynamic>{};
    reportResponseMap['participantDisplayName'] = reportResponse.participantDisplayName;
    reportResponseMap['dateAndTime'] = reportResponse.dateAndTime;
    reportResponseMap['responseStatement'] = reportResponse.responseStatement;
    reportResponseMap['participantAvatarURL'] = reportResponse.participantAvatarURL;
    reportResponseMap['mediaURL'] = reportResponse.mediaURL;
    reportResponseMap['mediaType'] = reportResponse.mediaType;
    reportResponseMap['likes'] = reportResponse.claps;
    reportResponseMap['comments'] = reportResponse.comments;
    return reportResponseMap;
  }
}