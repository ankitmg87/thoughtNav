import 'package:cloud_firestore/cloud_firestore.dart';

class Study {
  String studyUID;
  String studyName;

  bool archived;

  String internalStudyLabel;
  String studyStatus;
  int activeParticipants;
  int totalResponses;
  int totalComments;
  int totalParticipants;
  int totalInsights;
  String startDate;
  String endDate;
  Timestamp created;
  Timestamp lastSaveTime;

  String masterPassword;
  String commonInviteMessage;
  String specializedInviteMessage;
  String introPageMessage;
  String studyClosedMessage;
  String studyTimeZone;
  String rewardAmount;

  List<Map<String, dynamic>> categories;
  List<Map<String, dynamic>> groups;
  List<Map<String, dynamic>> topics;
  List<Map<String, dynamic>> participants;
  List<Map<String, dynamic>> clients;
  List<Map<String, dynamic>> moderators;

  Study({
    this.studyUID,
    this.studyName,
    this.archived,
    this.internalStudyLabel,
    this.studyStatus,
    this.activeParticipants,
    this.totalResponses,
    this.totalComments,
    this.totalParticipants,
    this.totalInsights,
    this.startDate,
    this.endDate,
    this.created,
    this.lastSaveTime,
    this.masterPassword,
    this.commonInviteMessage,
    this.specializedInviteMessage,
    this.introPageMessage,
    this.studyClosedMessage,
    this.studyTimeZone,
    this.rewardAmount,
    this.categories,
    this.groups,
    this.topics,
    this.participants,
    this.clients,
    this.moderators,
  });

  Map basicDetailsToMap(Study study){
    var basicDetailsMap = <String, dynamic>{};

    basicDetailsMap['studyUID'] = study.studyUID;
    basicDetailsMap['studyName'] = study.studyName;
    basicDetailsMap['archived'] = study.archived;
    basicDetailsMap['internalStudyLabel'] = study.internalStudyLabel;
    basicDetailsMap['masterPassword'] = study.masterPassword;
    basicDetailsMap['studyStatus'] = study.studyStatus;
    basicDetailsMap['startDate'] = study.startDate;
    basicDetailsMap['endDate'] = study.endDate;
    basicDetailsMap['created'] = study.created;
    basicDetailsMap['lastSaveTime'] = study.lastSaveTime;
    basicDetailsMap['introPageMessage'] = study.introPageMessage;
    basicDetailsMap['studyClosedMessage'] = study.studyClosedMessage;
    basicDetailsMap['commonInviteMessage'] = study.commonInviteMessage;
    basicDetailsMap['studyTimeZone'] = study.studyTimeZone;
    basicDetailsMap['activeParticipants'] = study.activeParticipants;
    basicDetailsMap['totalResponses'] = study.totalResponses;
    basicDetailsMap['totalComments'] = study.totalComments;
    basicDetailsMap['totalParticipants'] = study.totalParticipants;
    basicDetailsMap['totalInsights'] = study.totalInsights;

    return basicDetailsMap;
  }

  Study.basicDetailsFromMap(Map<String, dynamic> study){
    studyUID = study['studyUID'];
    studyName = study['studyName'];
    archived = study['archived'];
    internalStudyLabel = study['internalStudyLabel'];
    masterPassword = study['masterPassword'];
    studyStatus = study['studyStatus'];
    startDate = study['startDate'];
    endDate = study['endDate'];
    created = study['created'];
    lastSaveTime = study['lastSaveTime'];
    introPageMessage = study['introPageMessage'];
    commonInviteMessage = study['commonInviteMessage'];
    studyClosedMessage = study['studyClosedMessage'];
    studyTimeZone = study['studyTimeZone'];
    activeParticipants = study['activeParticipants'];
    totalResponses = study['totalResponses'];
    totalComments = study['totalComments'];
    totalParticipants = study['totalParticipants'];
    totalInsights = study['totalInsights'];
  }
}