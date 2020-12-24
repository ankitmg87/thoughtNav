import 'package:cloud_firestore/cloud_firestore.dart';

class ResponseNotification {
  String notificationUID;
  String avatarURL;
  String questionNumber;
  String questionTitle;
  String questionUID;
  String topicUID;
  String responseUID;
  String notificationType;
  Timestamp notificationTimestamp;

  ResponseNotification({
    this.notificationUID,
    this.avatarURL,
    this.questionNumber,
    this.questionTitle,
    this.questionUID,
    this.topicUID,
    this.responseUID,
    this.notificationType,
    this.notificationTimestamp,
  });

  ResponseNotification.fromMap(Map<String, dynamic> responseNotificationMap) {
    notificationUID = responseNotificationMap['notificationUID'];
    avatarURL = responseNotificationMap['avatarURL'];
    questionNumber = responseNotificationMap['questionNumber'];
    questionTitle = responseNotificationMap['questionTitle'];
    questionUID = responseNotificationMap['questionUID'];
    topicUID = responseNotificationMap['topicUID'];
    responseUID = responseNotificationMap['responseUID'];
    notificationType = responseNotificationMap['notificationType'];
    notificationTimestamp = responseNotificationMap['notificationTimestamp'];
  }

  Map<String, dynamic> toMap(ResponseNotification responseNotification) {
    var responseNotificationMap = <String, dynamic>{};

    responseNotificationMap['notificationUID'] =
        responseNotification.notificationUID;
    responseNotificationMap['avatarURL'] = responseNotification.avatarURL;
    responseNotificationMap['questionNumber'] =
        responseNotification.questionNumber;
    responseNotificationMap['questionTitle'] =
        responseNotification.questionTitle;
    responseNotificationMap['questionUID'] = responseNotification.questionUID;
    responseNotificationMap['topicUID'] = responseNotification.topicUID;
    responseNotificationMap['responseUID'] = responseNotification.responseUID;
    responseNotificationMap['notificationType'] =
        responseNotification.notificationType;
    responseNotificationMap['notificationTimestamp'] =
        responseNotification.notificationTimestamp;

    return responseNotificationMap;
  }
}

class CommentNotification {
  String notificationUID;
  String avatarURL;
  String displayName;
  String notificationType;
  String questionNumber;
  String questionTitle;
  String participantUID;
  String questionUID;
  String topicUID;
  String responseUID;
  String commentUID;
  Timestamp notificationTimestamp;

  CommentNotification({
    this.notificationUID,
    this.avatarURL,
    this.displayName,
    this.notificationType,
    this.questionNumber,
    this.questionTitle,
    this.participantUID,
    this.questionUID,
    this.topicUID,
    this.responseUID,
    this.commentUID,
    this.notificationTimestamp,
  });

  CommentNotification.fromMap(Map<String, dynamic> commentNotificationMap) {
    notificationUID = commentNotificationMap['notificationUID'];
    avatarURL = commentNotificationMap['avatarURL'];
    displayName = commentNotificationMap['displayName'];
    notificationType = commentNotificationMap['notificationType'];
    questionNumber = commentNotificationMap['questionNumber'];
    questionTitle = commentNotificationMap['questionTitle'];
    participantUID = commentNotificationMap['participantUID'];
    questionUID = commentNotificationMap['questionUID'];
    topicUID = commentNotificationMap['topicUID'];
    responseUID = commentNotificationMap['responseUID'];
    commentUID = commentNotificationMap['commentUID'];
    notificationTimestamp = commentNotificationMap['notificationTimestamp'];
  }

  Map<String, dynamic> toMap(CommentNotification commentNotification) {
    var commentNotificationMap = <String, dynamic>{};

    commentNotificationMap['notificationUID'] =
        commentNotification.notificationUID;
    commentNotificationMap['avatarURL'] = commentNotification.avatarURL;
    commentNotificationMap['displayName'] = commentNotification.displayName;
    commentNotificationMap['notificationType'] =
        commentNotification.notificationType;
    commentNotificationMap['questionNumber'] =
        commentNotification.questionNumber;
    commentNotificationMap['questionTitle'] = commentNotification.questionTitle;
    commentNotificationMap['participantUID'] =
        commentNotification.participantUID;
    commentNotificationMap['questionUID'] = commentNotification.questionUID;
    commentNotificationMap['topicUID'] = commentNotification.topicUID;
    commentNotificationMap['responseUID'] = commentNotification.responseUID;
    commentNotificationMap['commentUID'] = commentNotification.commentUID;
    commentNotificationMap['notificationTimestamp'] =
        commentNotification.notificationTimestamp;

    return commentNotificationMap;
  }
}

class ModeratorCommentNotification {
  String moderatorAvatarURL;
  String moderatorFirstName;
  String moderatorCommentStatement;
  String notificationType;
  String questionNumber;
  String questionTitle;
  String topicUID;
  String questionUID;
  String responseUID;
  String commentUID;
  Timestamp notificationTimestamp;

  ModeratorCommentNotification({
    this.moderatorAvatarURL,
    this.moderatorFirstName,
    this.moderatorCommentStatement,
    this.notificationType,
    this.questionNumber,
    this.questionTitle,
    this.topicUID,
    this.questionUID,
    this.responseUID,
    this.commentUID,
    this.notificationTimestamp,
  });

  ModeratorCommentNotification.fromMap(
      Map<String, dynamic> moderatorCommentNotificationMap) {
    moderatorAvatarURL = moderatorCommentNotificationMap['moderatorAvatarURL'];
    moderatorFirstName = moderatorCommentNotificationMap['moderatorFirstName'];
    moderatorCommentStatement =
        moderatorCommentNotificationMap['moderatorCommentStatement'];
    notificationType = moderatorCommentNotificationMap['notificationType'];
    questionNumber = moderatorCommentNotificationMap['questionNumber'];
    questionTitle = moderatorCommentNotificationMap['questionTitle'];
    topicUID = moderatorCommentNotificationMap['topicUID'];
    questionUID = moderatorCommentNotificationMap['questionUID'];
    responseUID = moderatorCommentNotificationMap['responseUID'];
    commentUID = moderatorCommentNotificationMap['commentUID'];
    notificationTimestamp =
        moderatorCommentNotificationMap['notificationTimestamp'];
  }

  Map<String, dynamic> toMap(
      ModeratorCommentNotification moderatorCommentNotification) {
    var moderatorCommentNotificationMap = <String, dynamic>{};

    moderatorCommentNotificationMap['moderatorAvatarURL'] =
        moderatorCommentNotification.moderatorAvatarURL;
    moderatorCommentNotificationMap['moderatorFirstName'] =
        moderatorCommentNotification.moderatorFirstName;
    moderatorCommentNotificationMap['moderatorCommentStatement'] =
        moderatorCommentNotification.moderatorCommentStatement;
    moderatorCommentNotificationMap['notificationType'] =
        moderatorCommentNotification.notificationType;
    moderatorCommentNotificationMap['questionNumber'] =
        moderatorCommentNotification.questionNumber;
    moderatorCommentNotificationMap['questionTitle'] =
        moderatorCommentNotification.questionTitle;
    moderatorCommentNotificationMap['topicUID'] =
        moderatorCommentNotification.topicUID;
    moderatorCommentNotificationMap['questionUID'] =
        moderatorCommentNotification.questionUID;
    moderatorCommentNotificationMap['responseUID'] =
        moderatorCommentNotification.responseUID;
    moderatorCommentNotificationMap['commentUID'] =
        moderatorCommentNotification.commentUID;
    moderatorCommentNotificationMap['notificationTimestamp'] =
        moderatorCommentNotification.notificationTimestamp;

    return moderatorCommentNotificationMap;
  }
}

class NewQuestionNotification {
  String questionNumber;
  String questionTitle;
  String topicTitle;
  String notificationType;
  String topicUID;
  String questionUID;
  Timestamp notificationTimestamp;

  NewQuestionNotification({
    this.questionNumber,
    this.questionTitle,
    this.topicTitle,
    this.notificationType,
    this.topicUID,
    this.questionUID,
    this.notificationTimestamp,
  });

  NewQuestionNotification.fromMap(
      Map<String, dynamic> newQuestionNotificationMap) {
    questionNumber = newQuestionNotificationMap['questionNumber'];
    questionTitle = newQuestionNotificationMap['questionTitle'];
    topicTitle = newQuestionNotificationMap['topicTitle'];
    notificationType = newQuestionNotificationMap['notificationType'];
    topicUID = newQuestionNotificationMap['topicUID'];
    questionUID = newQuestionNotificationMap['questionUID'];
    notificationTimestamp = newQuestionNotificationMap['notificationTimestamp'];
  }

  Map<String, dynamic> toMap(NewQuestionNotification newQuestionNotification) {
    var newQuestionNotificationMap = <String, dynamic>{};

    newQuestionNotificationMap['questionNumber'] =
        newQuestionNotification.questionNumber;
    newQuestionNotificationMap['questionTitle'] =
        newQuestionNotification.questionTitle;
    newQuestionNotificationMap['topicTitle'] =
        newQuestionNotification.topicTitle;
    newQuestionNotificationMap['notificationType'] =
        newQuestionNotification.notificationType;
    newQuestionNotificationMap['topicUID'] = newQuestionNotification.topicUID;
    newQuestionNotificationMap['questionUID'] =
        newQuestionNotification.questionUID;
    newQuestionNotificationMap['notificationTimestamp'] =
        newQuestionNotification.notificationTimestamp;

    return newQuestionNotificationMap;
  }
}

class ClapNotification {
  String displayName;
  String avatarURL;
  String questionNumber;
  String questionTitle;
  String questionUID;
  String topicUID;
  String responseUID;
  String notificationType;
  Timestamp notificationTimestamp;

  ClapNotification({
    this.displayName,
    this.avatarURL,
    this.questionNumber,
    this.questionTitle,
    this.questionUID,
    this.topicUID,
    this.responseUID,
    this.notificationType,
    this.notificationTimestamp,
  });

  ClapNotification.fromMap(Map<String, dynamic> clapNotificationMap) {
    displayName = clapNotificationMap['displayName'];
    avatarURL = clapNotificationMap['avatarURL'];
    questionNumber = clapNotificationMap['questionNumber'];
    questionTitle = clapNotificationMap['questionTitle'];
    questionUID = clapNotificationMap['questionUID'];
    topicUID = clapNotificationMap['topicUID'];
    responseUID = clapNotificationMap['responseUID'];
    notificationType = clapNotificationMap['notificationType'];
    notificationTimestamp = clapNotificationMap['notificationTimestamp'];
  }

  Map<String, dynamic> toMap(ClapNotification clapNotification) {
    var clapNotificationMap = <String, dynamic>{};

    clapNotificationMap['displayName'] = clapNotification.displayName;
    clapNotificationMap['avatarURL'] = clapNotification.avatarURL;
    clapNotificationMap['questionNumber'] = clapNotification.questionNumber;
    clapNotificationMap['questionTitle'] = clapNotification.questionTitle;
    clapNotificationMap['questionUID'] = clapNotification.questionUID;
    clapNotificationMap['topicUID'] = clapNotification.topicUID;
    clapNotificationMap['responseUID'] = clapNotification.responseUID;
    clapNotificationMap['notificationType'] = clapNotification.notificationType;
    clapNotificationMap['notificationTimestamp'] =
        clapNotification.notificationTimestamp;

    return clapNotificationMap;
  }
}
