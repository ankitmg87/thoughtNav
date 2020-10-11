class ResearcherNotification {
  String avatarURL;
  String userAlias;
  String questionIndex;
  String questionTitle;
  String notificationTime;

  ResearcherNotification(
      {this.avatarURL,
      this.userAlias,
      this.questionIndex,
      this.questionTitle,
      this.notificationTime});

  ResearcherNotification.fromMap(Map<String, String> researcherNotification) {
    this.avatarURL = researcherNotification['avatarURL'];
    this.userAlias = researcherNotification['userAlias'];
    this.questionIndex = researcherNotification['questionIndex'];
    this.questionTitle = researcherNotification['questionTitle'];
    this.notificationTime = researcherNotification['notificationTime'];
  }
}
