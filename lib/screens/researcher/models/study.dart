import 'package:cloud_firestore/cloud_firestore.dart';

class Study {
  String studyUID;
  String studyName;

  String internalStudyLabel;
  String studyStatus;
  String activeParticipants;
  String totalResponses;
  String startDate;
  String endDate;
  Timestamp created;
  Timestamp lastSaveTime;

  String masterPassword;
  String commonInviteMessage;
  String specializedInviteMessage;
  String introPageMessage;
  String studyClosedMessage;

  List<Map<String, dynamic>> categories;
  List<Map<String, dynamic>> groups;
  List<Map<String, dynamic>> topics;
  List<Map<String, dynamic>> participants;
  List<Map<String, dynamic>> clients;
  List<Map<String, dynamic>> moderators;

  Study({
    this.studyUID,
    this.studyName,
    this.internalStudyLabel,
    this.studyStatus,
    this.activeParticipants,
    this.totalResponses,
    this.startDate,
    this.endDate,
    this.created,
    this.lastSaveTime,
    this.masterPassword,
    this.commonInviteMessage,
    this.specializedInviteMessage,
    this.introPageMessage,
    this.studyClosedMessage,
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
    basicDetailsMap['internalStudyLabel'] = study.internalStudyLabel;
    basicDetailsMap['studyStatus'] = study.studyStatus;
    basicDetailsMap['startDate'] = study.startDate;
    basicDetailsMap['endDate'] = study.endDate;
    basicDetailsMap['created'] = study.created;
    basicDetailsMap['lastSaveTime'] = study.lastSaveTime;
    basicDetailsMap['introPageMessage'] = study.introPageMessage;
    basicDetailsMap['studyClosedMessage'] = study.studyClosedMessage;
    basicDetailsMap['commonInviteMessage'] = study.commonInviteMessage;

    return basicDetailsMap;
  }

  Study.basicDetailsFromMap(Map<String, dynamic> study){
    studyUID = study['studyUID'];
    studyName = study['studyName'];
    internalStudyLabel = study['internalStudyLabel'];
    studyStatus = study['studyStatus'];
    startDate = study['startDate'];
    endDate = study['endDate'];
    created = study['created'];
    lastSaveTime = study['lastSaveTime'];
    introPageMessage = study['introPageMessage'];
    commonInviteMessage = study['commonInviteMessage'];
    studyClosedMessage = study['studyClosedMessage'];
  }

  // Map<String, dynamic> toMap(Study study) {
  //   var _study = <String, dynamic>{};
  //
  //   _study['studyUID'] = study.studyUID;
  //   _study['studyName'] = study.studyName;
  //   _study['internalStudyLabel'] = study.internalStudyLabel;
  //   _study['studyStatus'] = study.studyStatus;
  //   _study['activeParticipants'] = study.activeParticipants;
  //   _study['totalResponses'] = study.totalResponses;
  //   _study['startDate'] = study.beginDate;
  //   _study['endDate'] = study.endDate;
  //   _study['lastSaveTime'] = study.created;
  //   _study['masterPassword'] = study.masterPassword;
  //   _study['commonInviteMessage'] = study.commonInviteMessage;
  //   _study['specializedInviteMessage'] = study.specializedInviteMessage;
  //   _study['studyClosedMessage'] = study.studyClosedMessage;
  //   _study['categories'] = categories;
  //   _study['groups'] = groups;
  //   _study['topics'] = topics;
  //
  //   return _study;
  // }
  //
  // Study.fromMap(Map<String, dynamic> study) {
  //   studyUID = study['studyUID'];
  //   studyName = study['studyName'];
  //   internalStudyLabel = study['internalStudyLabel'];
  //   studyStatus = study['studyStatus'];
  //   activeParticipants = study['activeParticipants'];
  //   totalResponses = study['totalResponses'];
  //   beginDate = study['startDate'];
  //   endDate = study['endDate'];
  //   created = study['created'];
  //   masterPassword = study['masterPassword'];
  //   commonInviteMessage = study['commonInviteMessage'];
  //   specializedInviteMessage = study['specializedInviteMessage'];
  //   studyClosedMessage = study['studyClosedMessage'];
  //   categories = study['categories'];
  //   groups = study['groups'];
  //   topics = study['topics'];
  // }
  //
  // Map<String, dynamic> studyBasicDetails(Study study) {
  //   var studyBasicDetails = <String, dynamic>{};
  //
  //   studyBasicDetails['studyUID'] = study.studyUID;
  //   studyBasicDetails['studyName'] = study.studyName;
  //   studyBasicDetails['internalStudyLabel'] = study.internalStudyLabel;
  //   studyBasicDetails['studyStatus'] = study.studyStatus;
  //   studyBasicDetails['masterPassword'] = study.masterPassword;
  //   studyBasicDetails['created'] = study.created;
  //   studyBasicDetails['beginDate'] = study.beginDate;
  //   studyBasicDetails['endDate'] = study.endDate;
  //   studyBasicDetails['introPageMessage'] = study.introPageMessage;
  //   studyBasicDetails['commonInviteMessage'] = study.commonInviteMessage;
  //   studyBasicDetails['studyClosedMessage'] = study.studyClosedMessage;
  //
  //   return studyBasicDetails;
  // }
}