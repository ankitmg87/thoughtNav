import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/moderator.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';

import 'package:http/http.dart' as http;

const String _STUDIES_COLLECTION = 'studies';
const String _MODERATORS_COLLECTION = 'moderators';
const String _GROUPS_COLLECTION = 'groups';
const String _TOPICS_COLLECTION = 'topics';
const String _QUESTIONS_COLLECTION = 'questions';

class ModeratorFirestoreService {
  final _studiesReference =
      FirebaseFirestore.instance.collection(_STUDIES_COLLECTION);

  Future<Moderator> getModerator(String studyUID, String userID) async {
    var moderatorSnapshot = await _studiesReference
        .doc(studyUID)
        .collection(_MODERATORS_COLLECTION)
        .doc(userID)
        .get();

    var moderator = Moderator.fromMap(moderatorSnapshot.data());

    return moderator;
  }

  Future<Study> getStudy(String studyUID) async {
    var studySnapshot = await _studiesReference.doc(studyUID).get();

    var study = Study.basicDetailsFromMap(studySnapshot.data());

    return study;
  }

  Future<void> updateTimeZone(String studyUID, Study study) async {
    await _studiesReference.doc(studyUID).update({
      'studyTimeZone': study.studyTimeZone,
    });
  }

  Future<Group> createGroup(String studyUID, int index) async {
    var group = Group(
      groupIndex: index,
    );

    var groupMap = group.toMap();
    await _studiesReference
        .doc(studyUID)
        .collection(_GROUPS_COLLECTION)
        .add(groupMap)
        .then((groupReference) {
      group.groupUID = groupReference.id;
      groupReference.set(
        {
          'groupUID': groupReference.id,
        },
        SetOptions(merge: true),
      );
    });

    return group;
  }

  Future<Topic> createTopic(String studyUID, int index) async {
    var topic = Topic(
      topicNumber: '$index',
      isActive: false,
    );

    var topicMap = topic.toMap();

    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .add(topicMap)
        .then((topicReference) {
      topic.topicUID = topicReference.id;
      topicReference.set(
        {
          'topicUID': topicReference.id,
        },
        SetOptions(merge: true),
      );
    });

    return topic;
  }

  Future<Question> createQuestion(
      String studyUID, int index, String topicUID) async {
    var question = Question(
      questionType: 'Standard',
      totalComments: 0,
      totalResponses: 0,
      questionNumber: '$index'
    );

    var questionMap = question.toMap();

    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .add(questionMap)
        .then((questionReference) {
      question.questionUID = questionReference.id;
      questionReference.set(
        {
          'questionUID': questionReference.id,
        },
        SetOptions(
          merge: true,
        ),
      );
    });

    return question;
  }

  Future<void> updateQuestion(
      String studyUID, String topicUID, Question question) async {
    var lastSaveTime = Timestamp.now();

    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(question.questionUID)
        .set(
      {
        'questionNumber': question.questionNumber,
        'questionStatement': question.questionStatement,
        'questionTitle': question.questionTitle,
        'questionType': question.questionType,
        'questionTimestamp': question.questionTimestamp,
      },
      SetOptions(merge: true),
    );

    await _studiesReference.doc(studyUID).set(
      {
        'lastSaveTime': lastSaveTime,
      },
      SetOptions(merge: true),
    );
  }

  Future<void> addAssignedGroup(String studyUID, String topicUID,
      String questionUID, String groupUID) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .update({
      'groups': FieldValue.arrayUnion([groupUID])
    });
  }

  Future<void> removeAssignedGroup(
      String studyUID, String topicUID, questionUID, String groupUID) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .update({
      'groups': FieldValue.arrayRemove([groupUID])
    });
  }

  /// GET SECTION

  Future<List<Topic>> getTopics(String studyUID) async {
    var topics = <Topic>[];

    var topicsReference = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .orderBy('topicIndex', descending: false)
        .get();

    if(topicsReference.size > 0){

      for(var topicSnapshot in topicsReference.docs){
        var topic = Topic.fromMap(topicSnapshot.data());

        var questions = await getQuestions(studyUID, topic);

        topic.questions = questions;

        topics.add(topic);
      }
    }

    return topics;
  }

  Future<List<Question>> getQuestions(String studyUID, Topic topic) async {
    var questions = <Question>[];

    var questionsCollection = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topic.topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .orderBy('questionNumber', descending: false)
        .get();

    if (questionsCollection.size > 0) {
      for (var questionDocument in questionsCollection.docs) {
        var question = Question.fromMap(questionDocument.data());
        questions.add(question);
      }
    }

    return questions;
  }


  Future<http.Response> sendEmail() async {

    var url = 'http://koodo.m-staging.in/Koodo/flutter/send-email';

    var response = await http.post(url, body: {
      'email': 'aaomazelene@example.com',
      'message': 'Hello mhan parat sonali',
      'name': 'Kay milnare naav kalun',
      'subject': 'Kashala pahije subject',
    });

    print(response.body.toString());
    print(response.statusCode);

    return response;
  }

}
