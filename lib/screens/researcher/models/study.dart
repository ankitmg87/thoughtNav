class Study {
  String studyUID;
  String studyName;

  String internalStudyLabel;
  String studyStatus;
  String activeParticipants;
  String totalResponses;
  String startDate;
  String endDate;

  bool isDraft;

  String masterPassword;
  String commonInviteMessage;
  String specializedInviteMessage;
  String introPageMessage;
  String studyClosedMessage;

  List<dynamic> categories;
  List<dynamic> groups;
  List<dynamic> topics;

  Study({
    this.studyUID,
    this.studyName,
    this.internalStudyLabel,
    this.studyStatus,
    this.activeParticipants,
    this.totalResponses,
    this.startDate,
    this.endDate,
    this.isDraft,
    this.masterPassword,
    this.commonInviteMessage,
    this.specializedInviteMessage,
    this.introPageMessage,
    this.studyClosedMessage,
    this.categories,
    this.groups,
    this.topics,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> study = Map<String, dynamic>();

    study['studyUID'] = this.studyUID ?? 'Null';
    study['studyName'] = this.studyName ?? 'Study Name';
    study['internalStudyLabel'] =
        this.internalStudyLabel ?? 'Internal Study Label';
    study['studyStatus'] = this.studyStatus ?? 'Study Status';
    study['activeParticipants'] = this.activeParticipants ?? '0';
    study['totalResponses'] = this.totalResponses ?? '0';
    study['startDate'] = this.startDate ?? 'Start date not set';
    study['endDate'] = this.endDate ?? 'End date not set';
    study['isDraft'] = this.isDraft ?? true;
    study['masterPassword'] = this.masterPassword ?? 'Password not set';
    study['commonInviteMessage'] = this.commonInviteMessage ?? 'Common invite message not set.';
    study['specializedInviteMessage'] = this.specializedInviteMessage ?? 'Specialized invite message not set.';
    study['studyClosedMessage'] = this.studyClosedMessage ?? 'Study Closed Message';
    study['categories'] = this.categories ?? ['Category 1', 'Category 2',];
    study['groups'] = this.groups ?? [];
    study['topics'] = this.topics ?? [];

    return study;
  }

  Study.fromMap(Map<String, dynamic> study) {
    this.studyUID = study['studyUID'] ?? 'Null';
    this.studyName = study['studyName'] ?? 'Study Name';
    this.internalStudyLabel =
        study['internalStudyLabel'] ?? 'Internal Study Label';
    this.studyStatus = study['studyStatus'] ?? 'Study Status';
    this.activeParticipants = study['activeParticipants'] ?? '0';
    this.totalResponses = study['totalResponses'] ?? '0';
    this.startDate = study['startDate'] ?? 'Start date not set';
    this.endDate = study['endDate'] ?? 'End date not set';
    this.isDraft = study['isDraft'] ?? true;
    this.masterPassword = study['masterPassword'] ?? 'Password not set';
    this.commonInviteMessage = study['commonInviteMessage'] ?? 'Common invite message not set.';
    this.specializedInviteMessage = study['specializedInviteMessage'] ?? 'Specialized invite message not set.';
    this.studyClosedMessage = study['studyClosedMessage'] ?? 'Study closed message not set';
    this.categories = study['categories'] ?? [];
    this.groups = study['groups'] ?? [];
    this.topics = study['topics'] ?? [];
  }
}
