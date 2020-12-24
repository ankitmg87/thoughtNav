import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoughtnav/models/avatar_and_display_name.dart';
import 'package:thoughtnav/screens/researcher/models/comment.dart';
import 'package:thoughtnav/screens/researcher/models/notification.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/response.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';

const String _STUDIES_COLLECTION = 'studies';
const String _TOPICS_COLLECTION = 'topics';
const String _QUESTIONS_COLLECTION = 'questions';
const String _NOTIFICATIONS_COLLECTION = 'notifications';
const String _AVATAR_AND_DISPLAY_NAMES_COLLECTION = 'avatarsAndDisplayNames';
const String _PARTICIPANTS_COLLECTION = 'participants';
const String _RESPONSES_COLLECTION = 'responses';
const String _COMMENTS_COLLECTION = 'comments';
const String _PARTICIPANT_NOTIFICATIONS_COLLECTION = 'participantNotifications';

const String _NOTIFICATION_TYPE_RESPONSE = 'response';
const String _NOTIFICATION_TYPE_COMMENT = 'comment';
const String _NOTIFICATION_TYPE_CLAP = 'clap';
const String _NOTIFICATION_TYPE_NEW_QUESTION = 'newQuestion';
const String _NOTIFICATION_TYPE_MODERATOR_COMMENT = 'moderatorComment';

class ParticipantFirestoreService {
  final _studiesReference =
      FirebaseFirestore.instance.collection(_STUDIES_COLLECTION);

  Future<Response> postResponse(String studyUID, String topicUID,
      String questionUID, Response response) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_RESPONSES_COLLECTION)
        .add(response.toMap())
        .then((responseDocumentReference) {
      response.responseUID = responseDocumentReference.id;
      responseDocumentReference.set(
        {
          'responseUID': response.responseUID,
        },
        SetOptions(merge: true),
      );
    });

    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .update(
      {
        'respondedBy': FieldValue.arrayUnion([response.participantUID])
      },
    );

    var responseNotification = ResponseNotification(
      avatarURL: response.avatarURL,
      questionNumber: response.questionNumber,
      questionTitle: response.questionTitle,
      questionUID: questionUID,
      topicUID: topicUID,
      responseUID: response.responseUID,
      notificationType: _NOTIFICATION_TYPE_RESPONSE,
      notificationTimestamp: response.responseTimestamp,
    );

    await addResponseNotification(
        studyUID, response.participantUID, responseNotification);

    return response;
  }

  Future<void> addResponseNotification(String studyUID, String participantUID,
      ResponseNotification responseNotification) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .doc(participantUID)
        .collection(_PARTICIPANT_NOTIFICATIONS_COLLECTION)
        .add(ResponseNotification().toMap(responseNotification))
        .then((responseNotificationDocumentReference) {
      var responseNotificationUID = responseNotificationDocumentReference.id;

      responseNotificationDocumentReference.set(
        {
          'notificationUID': responseNotificationUID,
        },
        SetOptions(merge: true),
      );
    });
  }

  Future<void> updateResponse(String studyUID, String topicUID,
      String questionUID, String participantUID, Response response) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_RESPONSES_COLLECTION)
        .doc(response.responseUID)
        .update({
      'responseStatement': response.responseStatement,
      'responseTimestamp': response.responseTimestamp,
    });

    await updateResponseNotification(
        studyUID, participantUID, questionUID, response.responseUID);
  }

  Future<void> updateResponseNotification(String studyUID,
      String participantUID, String questionUID, String responseUID) async {
    var responseNotification = await getResponseNotification(
        studyUID, participantUID, questionUID, responseUID);

    await _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .doc(participantUID)
        .collection(_PARTICIPANT_NOTIFICATIONS_COLLECTION)
        .doc(responseNotification.notificationUID)
        .update({
      'notificationTimestamp': Timestamp.now(),
    });
  }

  Future<ResponseNotification> getResponseNotification(String studyUID,
      String participantUID, String questionUID, String responseUID) async {
    ResponseNotification responseNotification;

    var responseNotificationsReferences = await _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .doc(participantUID)
        .collection(_PARTICIPANT_NOTIFICATIONS_COLLECTION)
        .where('responseUID', isEqualTo: responseUID)
        .where('questionUID', isEqualTo: questionUID)
        .where('notificationType', isEqualTo: _NOTIFICATION_TYPE_RESPONSE)
        .get();

    for (var responseNotificationDoc in responseNotificationsReferences.docs) {
      responseNotification =
          ResponseNotification.fromMap(responseNotificationDoc.data());
    }

    return responseNotification;
  }

  Future<Comment> postComment(
      String studyUID,
      String participantUID,
      String topicUID,
      String questionUID,
      String responseUID,
      String questionNumber,
      String questionTitle,
      Comment comment) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_RESPONSES_COLLECTION)
        .doc(responseUID)
        .collection(_COMMENTS_COLLECTION)
        .add(comment.toMap())
        .then((commentReference) {
      comment.commentUID = commentReference.id;
      commentReference.set(
        {
          'commentUID': comment.commentUID,
        },
        SetOptions(merge: true),
      );
    });

    var commentSnapshots = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_RESPONSES_COLLECTION)
        .doc(responseUID)
        .collection(_COMMENTS_COLLECTION)
        .get();

    var totalComments = commentSnapshots.docs.length;

    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_RESPONSES_COLLECTION)
        .doc(responseUID)
        .set(
      {
        'comments': totalComments,
      },
      SetOptions(merge: true),
    );

    var commentNotification = CommentNotification(
      avatarURL: comment.avatarURL,
      displayName: comment.displayName,
      notificationType: _NOTIFICATION_TYPE_COMMENT,
      questionNumber: questionNumber,
      questionTitle: questionTitle,
      participantUID: participantUID,
      questionUID: questionUID,
      topicUID: topicUID,
      responseUID: responseUID,
      commentUID: comment.commentUID,
      notificationTimestamp: comment.commentTimestamp,
    );

    await addCommentNotification(studyUID, participantUID, commentNotification);

    return comment;
  }

  Future<void> updateComment(String studyUID, String topicUID,
      String questionUID, String responseUID, Comment comment) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_RESPONSES_COLLECTION)
        .doc(responseUID)
        .collection(_COMMENTS_COLLECTION)
        .doc(comment.commentUID)
        .update({
      'commentStatement': comment.commentStatement,
    });
  }

  Future<void> addCommentNotification(String studyUID, String participantUID,
      CommentNotification commentNotification) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .doc(participantUID)
        .collection(_PARTICIPANT_NOTIFICATIONS_COLLECTION)
        .add(CommentNotification().toMap(commentNotification))
        .then((commentNotificationReference) {
      commentNotificationReference.update({
        'notificationUID': commentNotificationReference.id,
      });
    });
  }

  Future<Comment> getFirstComment(String studyUID, String topicUID,
      String questionUID, String responseUID) async {
    var comment;
    var commentsReference = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_RESPONSES_COLLECTION)
        .doc(responseUID)
        .collection(_COMMENTS_COLLECTION)
        .orderBy('commentTimestamp', descending: false)
        .limit(1)
        .get();

    if (commentsReference.docs.isNotEmpty) {
      for (var commentReference in commentsReference.docs) {
        comment = Comment.fromMap(commentReference.data());
      }
    }

    return comment;
  }

  Stream<QuerySnapshot> streamFirstComment(String studyUID, String topicUID,
      String questionUID, String responseUID) {
    return _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_RESPONSES_COLLECTION)
        .doc(responseUID)
        .collection(_COMMENTS_COLLECTION)
        .orderBy('commentTimestamp')
        .snapshots();
  }

  Future<Study> getParticipantStudy(String studyUID) async {
    var studySnapshot = await _studiesReference.doc(studyUID).get();

    var study = Study.basicDetailsFromMap(studySnapshot.data());

    return study;
  }

  Stream<QuerySnapshot> getParticipantNotifications(
      String studyUID, String participantUID) {
    var notificationsSnapshot = _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .doc(participantUID)
        .collection(_PARTICIPANT_NOTIFICATIONS_COLLECTION)
        .orderBy('notificationTimestamp', descending: true)
        .snapshots();

    return notificationsSnapshot;
  }

  Future<void> setAnsweredBy(String studyUID, String topicUID,
      String questionUID, String participantUID) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .update({
      'answeredBy': FieldValue.arrayUnion([participantUID]),
    });
  }

  Future<bool> checkWhetherAnswered(String studyUID, String topicUID,
      String questionUID, String participantUID) async {
    var questionDocumentSnapshot = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .get();

    var questionData = questionDocumentSnapshot.data();

    return questionData.containsValue(participantUID);
  }

  Future<List<Topic>> getParticipantTopics(
      String studyUID, String participantGroupUID) async {
    var topics = <Topic>[];

    var topicsReference = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .orderBy('topicNumber', descending: false)
        .get();

    for (var topicSnapshot in topicsReference.docs) {
      var topic = Topic.fromMap(topicSnapshot.data());
      var questions = await getParticipantQuestions(
          studyUID, topic.topicUID, participantGroupUID);
      topic.questions = questions;

      topics.add(topic);
    }

    return topics;
  }

  Future<List<Question>> getParticipantQuestions(
      String studyUID, String topicUID, String participantGroupUID) async {
    var questions = <Question>[];

    var questionsReference = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .orderBy('questionNumber', descending: false)
        .get();

    for (var questionSnapshot in questionsReference.docs) {
      var question = Question.fromMap(questionSnapshot.data());

      if (question.groups.contains(participantGroupUID)) {
        questions.add(question);
      }
    }

    return questions;
  }

  Stream getAvatarsAndDisplayNames(String studyUID) {
    return _studiesReference
        .doc(studyUID)
        .collection(_AVATAR_AND_DISPLAY_NAMES_COLLECTION)
        .snapshots();
  }

  Future<void> updateParticipantAvatarAndDisplayName(String studyUID,
      String participantUID, String displayName, String avatarURL) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .doc(participantUID)
        .update({
      'displayName': displayName,
      'profilePhotoURL': avatarURL,
    });
  }

  Future<void> updateAvatarAndDisplayNameStatus(
      String studyUID, String avatarAndDisplayNameID, bool selected) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_AVATAR_AND_DISPLAY_NAMES_COLLECTION)
        .doc(avatarAndDisplayNameID)
        .update({
      'selected': selected,
    });
  }

  Future<String> getResponseUID(String studyUID, String topicUID,
      String questionUID, String participantUID) async {
    var responseUID;

    var responseSnapshots = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_RESPONSES_COLLECTION)
        .where('participantUID', isEqualTo: participantUID)
        .limit(1)
        .get();

    for (var response in responseSnapshots.docs) {
      if (response.data()['participantUID'] == participantUID) {
        responseUID = response.data()['responseUID'];
        print('Response UID from Participant FS: $responseUID');
      }
    }

    return responseUID;
  }

  Future<void> incrementClap({
    String studyUID,
    String topicUID,
    String questionUID,
    Response response,
    Participant participant,
  }) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_RESPONSES_COLLECTION)
        .doc(response.responseUID)
        .update(
      {
        'claps': FieldValue.arrayUnion([participant.participantUID]),
      },
    );

    print(response.questionTitle);
    print(response.questionNumber);

    var clapNotification = ClapNotification(
      displayName: participant.displayName,
      avatarURL: participant.profilePhotoURL,
      questionNumber: response.questionNumber,
      questionTitle: response.questionTitle,
      topicUID: topicUID,
      questionUID: questionUID,
      responseUID: response.responseUID,
      notificationType: _NOTIFICATION_TYPE_CLAP,
      notificationTimestamp: Timestamp.now(),
    );

    await addClapNotification(
        studyUID, response.participantUID, clapNotification);
  }

  Future<void> addClapNotification(String studyUID, String participantUID,
      ClapNotification clapNotification) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .doc(participantUID)
        .collection(_PARTICIPANT_NOTIFICATIONS_COLLECTION)
        .add(ClapNotification().toMap(clapNotification));
  }

  Future<void> decrementClap(String studyUID, String topicUID,
      String questionUID, Response response, String participantUID) async {
    await removeClapNotification(studyUID, participantUID, response);

    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_RESPONSES_COLLECTION)
        .doc(response.responseUID)
        .update({
      'claps': FieldValue.arrayRemove([participantUID]),
    });

    await removeClapNotification(studyUID, response.participantUID, response);
  }

  Future<void> removeClapNotification(
      String studyUID, String participantUID, Response response) async {
    var clapQuerySnapshot = await _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .doc(participantUID)
        .collection(_PARTICIPANT_NOTIFICATIONS_COLLECTION)
        .where('notificationType', isEqualTo: _NOTIFICATION_TYPE_CLAP)
        .where('responseUID', isEqualTo: response.responseUID)
        .get();

    for (var clapReference in clapQuerySnapshot.docs) {
      await _studiesReference
          .doc(studyUID)
          .collection(_PARTICIPANTS_COLLECTION)
          .doc(response.participantUID)
          .collection(_PARTICIPANT_NOTIFICATIONS_COLLECTION)
          .doc(clapReference.id)
          .delete();
    }
  }
}
