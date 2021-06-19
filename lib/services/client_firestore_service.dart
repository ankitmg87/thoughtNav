// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file carries various methods for communicating with Firestore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoughtnav/screens/researcher/models/client.dart';
import 'package:thoughtnav/screens/researcher/models/insight.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';

const String _STUDIES_COLLECTION = 'studies';
const String _TOPICS_COLLECTION = 'topics';
const String _QUESTIONS_COLLECTION = 'questions';
const String _CLIENTS_COLLECTION = 'clients';
const String _INSIGHTS_COLLECTION = 'insights';
const String _INSIGHT_NOTIFICATIONS_COLLECTION = 'insightNotifications';

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
        .orderBy('topicNumber')
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
        .orderBy('questionNumber')
        .get();

    for (var questionSnapshot in questionsCollectionSnapshot.docs) {
      var question = Question.fromMap(questionSnapshot.data());

      questions.add(question);
    }

    return questions;
  }

  Future<Question> getQuestion(
      String studyUID, String topicUID, String questionUID) async {
    var questionDocumentSnapshot = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .get();

    var question = Question.fromMap(questionDocumentSnapshot.data());
    return question;
  }

  Future<void> postInsight(String studyUID, String topicUID, String questionUID,
      Insight insight) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_INSIGHTS_COLLECTION)
        .add(insight.toMap());

    await postInsightNotification(studyUID, insight);

    var totalInsights = await getStudyDetail(studyUID, 'totalInsights');

    await updateStudyDetail(studyUID, 'totalInsights', totalInsights + 1);
  }

  Future<void> postInsightNotification(String studyUID, Insight insight) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_INSIGHT_NOTIFICATIONS_COLLECTION)
        .add(insight.toMap());
  }

  Future<dynamic> getStudyDetail(String studyUID, String key) async {
    var studySnapshot = await _studiesReference.doc(studyUID).get();
    var detail = studySnapshot.data()[key];
    return detail;
  }

  Future<void> updateStudyDetail(String studyUID, String key, int value) async {
    await _studiesReference.doc(studyUID).update({
      key: value,
    });
  }

  Stream<QuerySnapshot> getClientInsightNotifications(String studyUID) {
    var notificationsSnapshot = _studiesReference
        .doc(studyUID)
        .collection(_INSIGHT_NOTIFICATIONS_COLLECTION)
        .orderBy('insightTimestamp')
        .snapshots();

    return notificationsSnapshot;
  }

  Stream<QuerySnapshot> streamInsights(
      String studyUID, String topicUID, String questionUID) {
    return _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_INSIGHTS_COLLECTION)
        .orderBy('insightTimestamp')
        .snapshots();
  }

  Future<void> updateClient(String studyUID, Client client) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_CLIENTS_COLLECTION)
        .doc(client.clientUID)
        .update(client.toMap());
  }
}
