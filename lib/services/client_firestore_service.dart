import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoughtnav/screens/researcher/models/client.dart';
import 'package:thoughtnav/screens/researcher/models/notification.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';

const String _STUDIES_COLLECTION = 'studies';
const String _TOPICS_COLLECTION = 'topics';
const String _QUESTIONS_COLLECTION = 'questions';
const String _NOTIFICATIONS_COLLECTION = 'notifications';
const String _CLIENTS_COLLECTION = 'clients';

class ClientFirestoreService {
  final _studiesReference =
      FirebaseFirestore.instance.collection(_STUDIES_COLLECTION);

  Future<Client> getClient(String studyUID, String userID) async {
    var clientSnapshot = await _studiesReference
        .doc(studyUID)
        .collection(_CLIENTS_COLLECTION)
        .doc(userID)
        .get();

    var client = Client.fromMap(clientSnapshot.data());

    return client;
  }

  Future<Study> getClientStudy(String studyUID) async {
    var studySnapshot = await _studiesReference.doc(studyUID).get();

    var study = Study.basicDetailsFromMap(studySnapshot.data());

    return study;
  }

  Future<List<Topic>> getClientTopics(String studyUID) async {
    var topics = <Topic>[];

    var topicsCollectionSnapshot = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .orderBy('topicIndex')
        .get();

    for (var topicSnapshot in topicsCollectionSnapshot.docs) {
      var topic = Topic.fromMap(topicSnapshot.data());

      topic.questions = await getClientQuestions(studyUID, topic.topicUID);

      topics.add(topic);
    }

    return topics;
  }

  Future<List<Question>> getClientQuestions(
      String studyUID, String topicUID) async {
    var questions = <Question>[];

    var questionsCollectionSnapshot = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .orderBy('questionIndex')
        .get();

    for (var questionSnapshot in questionsCollectionSnapshot.docs) {
      var question = Question.fromMap(questionSnapshot.data());

      questions.add(question);
    }

    return questions;
  }

  Stream<QuerySnapshot> getClientNotifications(String studyUID) {
    var notificationsSnapshot = _studiesReference
        .doc(studyUID)
        .collection(_NOTIFICATIONS_COLLECTION)
        .orderBy('notificationTimestamp')
        .snapshots();

    return notificationsSnapshot;
  }
}
