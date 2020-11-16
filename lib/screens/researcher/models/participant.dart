class Participant {
  String id;
  String participantUID;
  String alias;
  String userName;
  String userGroupName;
  String lastSeen;
  String email;
  String phone;
  String password;
  String age;
  String gender;
  int responses;
  int comments;
  String groupUID;
  String profilePhotoURL;
  int topicsCompleted;
  String currentTopic;
  String currentQuestion;

  bool isActive;
  bool isDeleted;
  bool isOnboarded;

  Participant({
    this.id,
    this.participantUID,
    this.alias,
    this.userName,
    this.userGroupName,
    this.lastSeen,
    this.email,
    this.phone,
    this.password,
    this.age,
    this.gender,
    this.responses,
    this.comments,
    this.isActive,
    this.isDeleted,
    this.isOnboarded,
    this.groupUID,
    this.profilePhotoURL,
    this.topicsCompleted,
    this.currentTopic,
    this.currentQuestion,
  });

  Map<String, dynamic> toMap() {
    var participant = <String, dynamic>{};

    participant['id'] = id;
    participant['participantUID'] = participantUID;
    participant['alias'] = alias;
    participant['userName'] = userName;
    participant['userGroupName'] = userGroupName;
    participant['lastSeen'] = lastSeen;
    participant['email'] = email;
    participant['phone'] = phone;
    participant['password'] = password;
    participant['age'] = age;
    participant['gender'] = gender;
    participant['responses'] = responses;
    participant['comments'] = comments;
    participant['isActive'] = isActive;
    participant['isDeleted'] = isDeleted;
    participant['groupUID'] = groupUID;
    participant['isOnboarded'] = isOnboarded;
    participant['profilePhotoURL'] = profilePhotoURL;
    participant['topicsCompleted'] = topicsCompleted;
    participant['currentTopic'] = currentTopic;
    participant['currentQuestion'] = currentQuestion;

    return participant;
  }

  Participant.fromMap(Map<String, dynamic> participant){
    id = participant['id'];
    participantUID = participant['participantUID'];
    alias = participant['alias'];
    userName = participant['userName'];
    userGroupName = participant['userGroupName'];
    lastSeen = participant['lastSeen'];
    email = participant['email'];
    phone = participant['phone'];
    password = participant['password'];
    age = participant['age'];
    gender = participant['gender'];
    responses = participant['responses'];
    comments = participant['comments'];
    isActive = participant['isActive'];
    isDeleted = participant['isDeleted'];
    isOnboarded = participant['isOnboarded'];
    groupUID = participant['groupUID'];
    profilePhotoURL = participant['profilePhotoURL'];
    currentTopic = participant['currentTopic'];
    currentQuestion = participant['currentQuestion'];
  }
}
