class Study {
  String studyUID;
  String studyName;
  String internalStudyLabel;
  String studyStatus;
  String activeParticipants;
  String totalResponses;
  String startDate;
  String endDate;

  Study(
      {this.studyUID,
      this.studyName,
      this.internalStudyLabel,
      this.studyStatus,
      this.activeParticipants,
      this.totalResponses,
      this.startDate,
      this.endDate});

  Map<String, String> toMap() {
    Map<String, String> study = Map<String, String>();

    study['studyUID'] = this.studyUID ?? 'Null';
    study['studyName'] = this.studyName ?? 'Study Name';
    study['internalStudyLabel'] =
        this.internalStudyLabel ?? 'Internal Study Label';
    study['studyStatus'] = this.studyStatus ?? 'Study Status';
    study['activeParticipants'] = this.activeParticipants ?? '0';
    study['totalResponses'] = this.totalResponses ?? '0';
    study['startDate'] = this.startDate ?? 'Start date not set';
    study['endDate'] = this.endDate ?? 'End date not set';

    return study;
  }

  Study.fromMap(Map<String, String> study) {
    this.studyUID = study['studyUID'] ?? 'Null';
    this.studyName = study['studyName'] ?? 'Study Name';
    this.internalStudyLabel =
        study['internalStudyLabel'] ?? 'Internal Study Label';
    this.studyStatus = study['studyStatus'] ?? 'Study Status';
    this.activeParticipants = study['activeParticipants'] ?? '0';
    this.totalResponses = study['totalResponses'] ?? '0';
    this.startDate = study['startDate'] ?? 'Start date not set';
    this.endDate = study['endDate'] ?? 'End date not set';
  }
}
