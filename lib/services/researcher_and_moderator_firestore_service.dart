import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoughtnav/screens/researcher/models/categories.dart';
import 'package:thoughtnav/screens/researcher/models/client.dart';
import 'package:thoughtnav/screens/researcher/models/comment.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/insight.dart';
import 'package:thoughtnav/screens/researcher/models/moderator.dart';
import 'package:thoughtnav/screens/researcher/models/notification.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/response.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';

import 'package:http/http.dart' as http;

const String _STUDIES_COLLECTION = 'studies';
const String _CATEGORIES_COLLECTION = 'categories';
const String _GROUPS_COLLECTION = 'groups';
const String _TOPICS_COLLECTION = 'topics';
const String _QUESTIONS_COLLECTION = 'questions';
const String _RESPONSES_COLLECTION = 'responses';
const String _INSIGHTS_COLLECTION = 'insights';
const String _INSIGHT_NOTIFICATIONS_COLLECTION = 'insightNotifications';
const String _COMMENTS_COLLECTION = 'comments';
const String _PARTICIPANTS_COLLECTION = 'participants';
const String _CLIENTS_COLLECTION = 'clients';
const String _MODERATORS_COLLECTION = 'moderators';
const String _PARTICIPANT_NOTIFICATIONS_COLLECTION = 'participantNotifications';
const String _GROUP_NOTIFICATIONS_COLLECTION = 'groupNotifications';

class ResearcherAndModeratorFirestoreService {
  final _studiesReference =
      FirebaseFirestore.instance.collection(_STUDIES_COLLECTION);

  final _moderatorsReference =
      FirebaseFirestore.instance.collection(_MODERATORS_COLLECTION);

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

  Future<Question> createQuestion(String studyUID, String topicUID,
      Timestamp topicTimestamp, bool isProbe) async {
    var question = Question(
      questionType: 'Standard',
      questionTimestamp: topicTimestamp,
      totalComments: 0,
      totalResponses: 0,
      questionNumber: '',
      groups: [],
      groupIndexes: [],
      allowImage: false,
      allowVideo: false,
      isProbe: isProbe,
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
        'allowImage': question.allowImage,
        'allowVideo': question.allowVideo,
        'groupIndexes': question.groupIndexes,
        'groups': question.groups,
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

  Future<void> updateQuestionGroup(String studyUID, Topic topic,
      String questionUID, List groups, bool isProbe) async {
    var lastSaveTime = Timestamp.now();

    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topic.topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .update({
      'groups': groups,
    });

    await _studiesReference.doc(studyUID).set(
      {
        'lastSaveTime': lastSaveTime,
      },
      SetOptions(merge: true),
    );

    if (isProbe) {
      var newQuestionNotification = NewQuestionNotification(
        topicName: topic.topicName,
        notificationType: 'newQuestionNotification',
        topicUID: topic.topicUID,
        questionUID: questionUID,
        notificationTimestamp: Timestamp.now(),
      );

      await addNewQuestionNotification(
          studyUID, groups, newQuestionNotification);
    }
  }

  /// GET SECTION

  Future<List<Study>> getAllStudies() async {
    var allStudiesList = <Study>[];

    var studiesSnapshot =
        await _studiesReference.orderBy('created', descending: true).get();

    for (var snapshot in studiesSnapshot.docs) {
      var study = Study.basicDetailsFromMap(snapshot.data());
      allStudiesList.add(study);
    }

    return allStudiesList;
  }

  Stream<QuerySnapshot> getActiveParticipantsInStudy(String studyUID) {
    return _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .where('isActive', isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllParticipantsInStudy(String studyUID) {
    return _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .snapshots();
  }

  Future<List<Topic>> getTopics(String studyUID) async {
    var topics = <Topic>[];

    var topicsReference = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .orderBy('topicNumber', descending: false)
        .get();

    if (topicsReference.size > 0) {
      for (var topicSnapshot in topicsReference.docs) {
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

  Future<void> addModeratorCommentNotification(
      String studyUID,
      String participantUID,
      ModeratorCommentNotification moderatorCommentNotification) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .doc(participantUID)
        .collection(_PARTICIPANT_NOTIFICATIONS_COLLECTION)
        .add(
            ModeratorCommentNotification().toMap(moderatorCommentNotification));
  }

  Future<void> addNewQuestionNotification(String studyUID, List groupUIDs,
      NewQuestionNotification newQuestionNotification) async {
    for (var groupUID in groupUIDs) {
      var participantsOfGroupSnapshot = await _studiesReference
          .doc(studyUID)
          .collection(_PARTICIPANTS_COLLECTION)
          .where('groupUID', isEqualTo: groupUID)
          .get();

      for (var participantSnapshot in participantsOfGroupSnapshot.docs) {
        await participantSnapshot.reference
            .collection(_PARTICIPANT_NOTIFICATIONS_COLLECTION)
            .add(newQuestionNotification.toMap());
      }
    }
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

  Future<void> updateGroup(String studyUID, Group group) async {
    var lastSaveTime = Timestamp.now();

    await _studiesReference
        .doc(studyUID)
        .collection(_GROUPS_COLLECTION)
        .doc(group.groupUID)
        .set(
      {
        'groupName': group.groupName,
        'internalGroupLabel': group.internalGroupLabel,
        'groupRewardAmount': group.groupRewardAmount,
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

  Future<void> createParticipant(
      String studyUID, Participant participant) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .doc(participant.participantUID)
        .set(participant.toMap());
  }

  Future<void> createClient(String studyUID, Client client) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_CLIENTS_COLLECTION)
        .doc(client.clientUID)
        .set(client.toMap());
  }

  Future<void> createModerator(Moderator moderator) async {
    await _moderatorsReference
        .doc(moderator.moderatorUID)
        .set(moderator.toMap());
  }

  Stream<QuerySnapshot> getParticipantsAsStream(String studyUID) {
    return _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .orderBy('userGroupName')
        .snapshots();
  }

  Stream<QuerySnapshot> getClientsAsStream(String studyUID) {
    return _studiesReference
        .doc(studyUID)
        .collection(_CLIENTS_COLLECTION)
        .orderBy('email')
        .snapshots();
  }

  Stream<QuerySnapshot> getModeratorsAsStream() {
    return _moderatorsReference.orderBy('email').snapshots();
  }

  Future<List<Participant>> getParticipants(String studyUID) async {
    var participants = <Participant>[];

    var participantsSnapshot = await _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .orderBy('userGroupName')
        .get();

    for (var participantSnapshot in participantsSnapshot.docs) {
      participants.add(Participant.fromMap(participantSnapshot.data()));
    }

    return participants;
  }

  Future<void> updateParticipantDetails(
      String studyUID, Participant participant) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .doc(participant.participantUID)
        .update(participant.toMap());
  }

  Future<List<Group>> getGroups(String studyUID) async {
    var groups = <Group>[];

    var groupsSnapshot = await _studiesReference
        .doc(studyUID)
        .collection(_GROUPS_COLLECTION)
        .orderBy('groupName')
        .get();

    for (var groupSnapshot in groupsSnapshot.docs) {
      groups.add(Group.fromMap(groupSnapshot.data()));
    }

    return groups;
  }

  Stream<DocumentSnapshot> getQuestionAsStream(
      String studyUID, String topicUID, String questionUID) {
    return _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .snapshots();
  }

  Future<Topic> getTopic(String studyUID, String topicUID) async {
    var topicSnapshot = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .get();
    var topic = Topic.fromMap(topicSnapshot.data());
    return topic;
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

  Stream<DocumentSnapshot> streamQuestion(
      String studyUID, String topicUID, String questionUID) {
    return _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .snapshots();
  }

  Stream<QuerySnapshot> streamResponses(
      String studyUID, String topicUID, String questionUID) {
    return _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_RESPONSES_COLLECTION)
        .orderBy('responseTimestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> streamComments(String studyUID, String topicUID,
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
        .orderBy('commentTimestamp', descending: false)
        .snapshots();
  }

  Future<List<Topic>> generateReport(String studyUID) async {
    var topics = <Topic>[];

    var topicsSnapshot = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .orderBy('topicNumber')
        .get();

    for (var topicSnapshot in topicsSnapshot.docs) {
      topics.add(Topic.fromMap(topicSnapshot.data()));
      print('Here');
    }

    for (var topic in topics) {
      var questionsSnapshot = await _studiesReference
          .doc(studyUID)
          .collection(_TOPICS_COLLECTION)
          .doc(topic.topicUID)
          .collection(_QUESTIONS_COLLECTION)
          .orderBy('questionNumber')
          .get();

      for (var questionSnapshot in questionsSnapshot.docs) {
        topic.questions.add(Question.fromMap(questionSnapshot.data()));
        print('Here 2');
      }

      for (var question in topic.questions) {
        var responsesSnapshot = await _studiesReference
            .doc(studyUID)
            .collection(_TOPICS_COLLECTION)
            .doc(topic.topicUID)
            .collection(_QUESTIONS_COLLECTION)
            .doc(question.questionUID)
            .collection(_RESPONSES_COLLECTION)
            .orderBy('responseTimestamp')
            .get();

        for (var responseSnapshot in responsesSnapshot.docs) {
          question.responses.add(Response.fromMap(responseSnapshot.data()));
          print('Here 3');
        }

        for (var response in question.responses) {
          var commentsSnapshot = await _studiesReference
              .doc(studyUID)
              .collection(_TOPICS_COLLECTION)
              .doc(topic.topicUID)
              .collection(_QUESTIONS_COLLECTION)
              .doc(question.questionUID)
              .collection(_RESPONSES_COLLECTION)
              .doc(response.responseUID)
              .collection(_COMMENTS_COLLECTION)
              .orderBy('commentTimestamp')
              .get();

          for (var commentSnapshot in commentsSnapshot.docs) {
            response.commentStatements
                .add(Comment.fromMap(commentSnapshot.data()));
            print('Here 4');
          }
        }
      }
    }

    return topics;
  }

  Future<void> saveIntroductionMessage(
      String studyUID, String introductionMessage) async {
    await _studiesReference.doc(studyUID).update({
      'introPageMessage': introductionMessage,
    });
  }

  Future<Categories> getCategories(String studyUID) async {
    var categories;

    var categoriesReference = await _studiesReference
        .doc(studyUID)
        .collection(_CATEGORIES_COLLECTION)
        .get();

    if (categoriesReference.docs.isNotEmpty) {
      var categoryDoc = categoriesReference.docs[0];
      categories = Categories.fromMap(categoryDoc.data());
    } else {
      categories = Categories(
        customCategories: [],
      );
      await saveCategories(studyUID, categories);
    }

    return categories;
  }

  Future<void> saveCategories(String studyUID, Categories categories) async {
    var categoriesMap = <String, dynamic>{};

    categoriesMap = Categories().toMap(categories);

    await _studiesReference
        .doc(studyUID)
        .collection('categories')
        .doc('categories')
        .set(categoriesMap, SetOptions(merge: true));
  }

  Future<void> postModeratorComment(
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
        .then((commentDocumentReference) async {
      comment.commentUID = commentDocumentReference.id;
      await commentDocumentReference.update({
        'commentUID': commentDocumentReference.id,
      });
    });

    var moderatorCommentNotification = ModeratorCommentNotification(
      moderatorCommentStatement: comment.commentStatement,
      questionNumber: questionNumber,
      questionTitle: questionTitle,
      questionUID: questionUID,
      topicUID: topicUID,
      responseUID: responseUID,
      notificationType: 'moderatorCommentNotification',
      notificationTimestamp: comment.commentTimestamp,
    );

    await postModeratorCommentNotification(
        studyUID,
        participantUID,
        topicUID,
        questionUID,
        responseUID,
        comment.commentUID,
        moderatorCommentNotification);
  }

  Future<void> postModeratorCommentNotification(
      String studyUID,
      String participantUID,
      String topicUID,
      String questionUID,
      String responseUID,
      String commentUID,
      ModeratorCommentNotification moderatorCommentNotification) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .doc(participantUID)
        .collection(_PARTICIPANT_NOTIFICATIONS_COLLECTION)
        .add(
          moderatorCommentNotification.toMap(moderatorCommentNotification),
        );
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
        .add(insight.toMap(insight));

    await postInsightNotification(studyUID, insight);
  }

  Future<void> postInsightNotification(String studyUID, Insight insight) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_INSIGHT_NOTIFICATIONS_COLLECTION)
        .add(insight.toMap(insight));
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

  Stream<QuerySnapshot> streamInsightNotifications(String studyUID) {
    return _studiesReference
        .doc(studyUID)
        .collection(_INSIGHT_NOTIFICATIONS_COLLECTION)
        .orderBy('insightTimestamp')
        .snapshots();
  }

  Stream<QuerySnapshot> streamQuestions(String studyUID, String topicUID) {
    return _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .orderBy('questionNumber')
        .snapshots();
  }

  Future<void> deleteTopic(String studyUID, String topicUID) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .delete();
  }

  Future<void> deleteQuestion(
      String studyUID, String topicUID, String questionUID) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .delete();
  }

  Future<Moderator> getModerator(String userID) async {
    var moderatorSnapshot = await _moderatorsReference.doc(userID).get();

    var moderator = Moderator.fromMap(moderatorSnapshot.data());

    return moderator;
  }

  Future<List<Study>> getModeratorAssignedStudies(
      List<dynamic> assignedStudies) async {
    var studies = <Study>[];

    for (var assignedStudy in assignedStudies) {
      var studySnapshot = await _studiesReference.doc(assignedStudy).get();

      var study = Study.basicDetailsFromMap(studySnapshot.data());

      studies.add(study);
    }

    return studies;
  }

  Future<void> updateModerator(Moderator moderator) async {
    await _moderatorsReference
        .doc(moderator.moderatorUID)
        .update(moderator.toMap());
  }

  Future<void> updateStudyStatus(String studyUID, String studyStatus) async {
    await _studiesReference.doc(studyUID).update({
      'studyStatus': studyStatus,
    });
  }

}
