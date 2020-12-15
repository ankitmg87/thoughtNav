import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoughtnav/models/avatar_and_display_name.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';

const String _STUDIES_COLLECTION = 'studies';
const String _TOPICS_COLLECTION = 'topics';
const String _QUESTIONS_COLLECTION = 'questions';
const String _NOTIFICATIONS_COLLECTION = 'notifications';
const String _AVATAR_AND_DISPLAY_NAMES_COLLECTION = 'avatarsAndDisplayNames';

class ParticipantFirestoreService {
  final _studiesReference =
      FirebaseFirestore.instance.collection(_STUDIES_COLLECTION);

  Stream<QuerySnapshot> getParticipantNotifications(String studyUID) {
    var notificationsSnapshot = _studiesReference
        .doc(studyUID)
        .collection(_NOTIFICATIONS_COLLECTION)
        .orderBy('notificationTimestamp', descending: true)
        .snapshots();
  }

  Future<List<AvatarAndDisplayName>> getAvatarsAndDisplayNames(
      String studyUID) async {
    var avatarAndDisplayNameList = <AvatarAndDisplayName>[];

    var avatarAndDisplayNameQuerySnapshot = await _studiesReference
        .doc(studyUID)
        .collection(_AVATAR_AND_DISPLAY_NAMES_COLLECTION)
        .where(
          'selected',
          isEqualTo: false,
        )
        .get();

    for (var avatarAndDisplayNameDocumentSnapshot
        in avatarAndDisplayNameQuerySnapshot.docs) {
      var avatarAndDisplayName = AvatarAndDisplayName.fromMap(
          avatarAndDisplayNameDocumentSnapshot.data());
      avatarAndDisplayNameList.add(avatarAndDisplayName);
    }

    return avatarAndDisplayNameList;
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
}
