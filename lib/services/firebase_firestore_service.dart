import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/models/user.dart';
import 'package:thoughtnav/screens/researcher/models/categories.dart';
import 'package:thoughtnav/screens/researcher/models/client.dart';
import 'package:thoughtnav/screens/researcher/models/comment.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/moderator.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/response.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/services/firebase_auth_service.dart';

const String _USERS_COLLECTION = 'users';
const String _STUDIES_COLLECTION = 'studies';
const String _CATEGORIES_COLLECTION = 'categories';
const String _GROUPS_COLLECTION = 'groups';
const String _TOPICS_COLLECTION = 'topics';
const String _QUESTIONS_COLLECTION = 'questions';
const String _RESPONSES_COLLECTION = 'responses';
const String _COMMENTS_COLLECTION = 'comments';
const String _PARTICIPANTS_COLLECTION = 'participants';
const String _CLIENTS_COLLECTION = 'clients';
const String _MODERATORS_COLLECTION = 'moderators';
const String _NOTIFICATIONS_COLLECTION = 'notifications';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _studiesReference =
      FirebaseFirestore.instance.collection(_STUDIES_COLLECTION);
  final CollectionReference _usersReference =
      FirebaseFirestore.instance.collection(_USERS_COLLECTION);

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  Future saveStudy(String studyUID) async {}

  Future saveTopics(String studyUID) async {}

  Future saveParticipants(String studyUID) async {}

  /// Get section

  Future<User> getUser(String uid) async {
    User user;

    await _firestore
        .collection(_USERS_COLLECTION)
        .doc(uid)
        .get()
        .then((userData) {
      user = User.fromMap(userData.data());
      user.userUID = uid;
    });

    return user;
  }

  Future<List<Study>> getAllStudies(List<Study> allStudiesList) async {
    var studiesSnapshot =
        await _studiesReference.orderBy('created', descending: true).get();

    for (var snapshot in studiesSnapshot.docs) {
      var study = Study.basicDetailsFromMap(snapshot.data());
      allStudiesList.add(study);
    }

    return allStudiesList;
  }

  Future<Study> getStudy(String studyUID) async {
    var studySnapshot = await _studiesReference.doc(studyUID).get();

    var study = Study.basicDetailsFromMap(studySnapshot.data());

    return study;
  }

  Stream getStudyAsStream(String studyUID) {
    return _studiesReference.doc(studyUID).snapshots();
  }

  Stream getNotifications(String studyUID) {
    return _studiesReference
        .doc(studyUID)
        .collection(_NOTIFICATIONS_COLLECTION)
        .orderBy('notificationTimeStamp', descending: true)
        .snapshots();
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
      categories = Categories();
      await saveCategories(studyUID, categories);
    }

    return categories;
  }

  Future<List<Group>> getGroups(String studyUID) async {
    var groups = <Group>[];

    var groupsReference = await _studiesReference
        .doc(studyUID)
        .collection(_GROUPS_COLLECTION)
        .orderBy('groupIndex', descending: false)
        .get();

    if (groupsReference.size > 0) {
      for (var groupDoc in groupsReference.docs) {
        groups.add(Group.fromMap(groupDoc.data()));
      }
    }

    return groups;
  }

  Future<List<Topic>> getTopics(String studyUID) async {
    var topics = <Topic>[];

    var topicsReference = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .orderBy('topicIndex', descending: false)
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

  Future<List<Topic>> getParticipantTopics(String studyUID) async {
    var topics = <Topic>[];

    var topicsReference = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .orderBy('topicIndex', descending: false)
        .get();

    for (var topicSnapshot in topicsReference.docs) {
      var topic = Topic.fromMap(topicSnapshot.data());

      if(topic.isActive){
        var questions = await getQuestions(studyUID, topic);

        topic.questions = questions;

        topics.add(topic);
      }
    }
    return topics;
  }

  Future<String> getTopicName(String studyUID, String topicUID) async {
    var topicSnapshot = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .get();
    String topicName = topicSnapshot.data()['topicName'];
    return topicName;
  }

  Future<List<Question>> getQuestions(String studyUID, Topic topic) async {
    var questions = <Question>[];

    var questionsCollection = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topic.topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .orderBy('questionIndex', descending: false)
        .get();

    if (questionsCollection.size > 0) {
      for (var questionDocument in questionsCollection.docs) {
        var question = Question.fromMap(questionDocument.data());
        questions.add(question);
      }
    }

    return questions;
  }

  Future<Question> getQuestion(
      String studyUID, String topicUID, String questionUID) async {
    var questionSnapshot = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .get();

    var question = Question.fromMap(questionSnapshot.data());
    return question;
  }

  Future<String> getMasterPassword(String studyUID) async {
    var studySnapshot = await _studiesReference.doc(studyUID).get();
    var masterPassword = studySnapshot.data()['masterPassword'];
    return masterPassword;
  }

  Future<Participant> getParticipant(
      String studyUID, String participantUID) async {
    var participantSnapshot = await _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .doc(participantUID)
        .get();
    var participant = Participant.fromMap(participantSnapshot.data());
    return participant;
  }

  Future<List<Participant>> getParticipants(String studyUID) async {
    var participants = <Participant>[];

    var participantsCollection = await _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .orderBy(
          'email',
          descending: false,
        )
        .get();

    for (var participantDocument in participantsCollection.docs) {
      participants.add(Participant.fromMap(participantDocument.data()));
    }
    return participants;
  }

  Future<List<Client>> getClients(String studyUID) async {
    var clients = <Client>[];

    var clientsCollection = await _studiesReference
        .doc(studyUID)
        .collection(_CLIENTS_COLLECTION)
        .orderBy(
          'email',
          descending: false,
        )
        .get();

    for (var clientDocument in clientsCollection.docs) {
      clients.add(Client.fromMap(clientDocument.data()));
    }

    return clients;
  }

  Future<List<Moderator>> getModerators(String studyUID) async {
    var moderators = <Moderator>[];

    var moderatorsCollection = await _studiesReference
        .doc(studyUID)
        .collection(_MODERATORS_COLLECTION)
        .orderBy(
          'email',
          descending: false,
        )
        .get();

    for (var moderatorDocument in moderatorsCollection.docs) {
      moderators.add(Moderator.fromMap(moderatorDocument.data()));
    }

    return moderators;
  }

  Stream getQuestionAsStream(
      String studyUID, String topicUID, String questionUID) {
    return _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .snapshots();
  }

  Stream<QuerySnapshot> getResponsesAsStream(
      String studyUID, String topicUID, String questionUID) {
    print(studyUID);
    print(topicUID);
    print(questionUID);

    return _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_RESPONSES_COLLECTION)
        .snapshots();
  }

  Stream getCommentsAsStream(String studyUID, String topicUID,
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
        .orderBy('commentTimestamp', descending: true)
        .snapshots();
  }

  Future<Response> getParticipantResponse(String studyUID, String topicUID,
      String questionUID, String participantUID) async {
    var responseSnapshot = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_RESPONSES_COLLECTION)
        .where(
          'participantUID',
          isEqualTo: participantUID,
        )
        .limit(1)
        .get();

    Response response;

    for (var responseDocument in responseSnapshot.docs) {
      response = Response.fromMap(responseDocument.data());
      continue;
    }

    return response;
  }

  /// Create section

  Future<void> saveCategories(String studyUID, Categories categories) async {
    var categoriesMap = <String, dynamic>{};

    categoriesMap = Categories().toMap(categories);

    await _studiesReference
        .doc(studyUID)
        .collection('categories')
        .doc('categories')
        .set(categoriesMap, SetOptions(merge: true));
  }

  Future<Study> createStudy() async {
    final created = Timestamp.now();

    final study = Study(
      activeParticipants: 0,
      totalResponses: 0,
      studyName: 'Draft Study',
      internalStudyLabel: 'Internal Label',
      studyStatus: 'Draft',
      masterPassword: 'Password not set',
      startDate: 'Study begin date not set',
      endDate: 'Study end date not set',
      created: created,
      lastSaveTime: created,
      introPageMessage: null,
      commonInviteMessage: null,
      studyClosedMessage: null,
    );

    var studyMap = Study().basicDetailsToMap(study);

    await _studiesReference.add(studyMap).then((studyReference) async {
      var studyUID = studyReference.id;
      study.studyUID = studyUID;
      await _studiesReference.doc(studyUID).set(
        {
          'studyUID': studyUID,
        },
        SetOptions(merge: true),
      );
    });

    return study;
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
      topicIndex: index,
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
        questionIndex: index,
        questionType: 'Standard',
        totalComments: 0,
        totalResponses: 0);

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

  Future<User> createUser(User user) async {
    var userUID = await _firebaseAuthService.signUpUser(
        user.userEmail, user.userPassword);

    user.userUID = userUID;

    await _usersReference.doc(userUID).set(user.toMap());

    return user;
  }

  Future<void> createParticipant(
      String studyUID, Participant participant) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .doc(participant.participantUID)
        .set(participant.toMap());
  }

  Future<Client> createClient(String studyUID, Client client) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_CLIENTS_COLLECTION)
        .add(client.toMap())
        .then((clientReference) {
      client.uid = clientReference.id;
      clientReference.set(
        {
          'clientUID': clientReference.id,
        },
        SetOptions(
          merge: true,
        ),
      );
    });

    return client;
  }

  Future<Moderator> createModerator(
      String studyUID, Moderator moderator) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_MODERATORS_COLLECTION)
        .add(moderator.toMap())
        .then((moderatorReference) {
      moderator.uid = moderatorReference.id;
      moderatorReference.set(
        {
          'moderatorUID': moderatorReference.id,
        },
        SetOptions(
          merge: true,
        ),
      );
    });

    return moderator;
  }

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
        .collection(_NOTIFICATIONS_COLLECTION)
        .add({
      'notificationTimestamp': response.responseTimestamp,
      'participantAlias': response.userName,
      'participantAvatar': response.avatarURL,
      'questionNumber': response.questionNumber,
      'questionTitle': response.questionTitle,
    });

    await _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .doc(response.participantUID);

    return response;
  }

  Future<Comment> postComment(String studyUID, String topicUID,
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

    return comment;
  }

  /// Update section

  Future<void> updateStudyBasicDetail(
      String studyUID, String fieldName, String fieldValue) async {
    var lastSaveTime = Timestamp.now();

    await _studiesReference.doc(studyUID).set(
      {
        fieldName: fieldValue,
        'lastSaveTime': lastSaveTime,
      },
      SetOptions(merge: true),
    );
  }

  Future<void> updateStudyStatus(String studyUID, String studyStatus) async {
    var lastSaveTime = Timestamp.now();
    await _studiesReference.doc(studyUID).set(
      {
        'studyStatus': studyStatus,
        'lastSaveTime': lastSaveTime,
      },
      SetOptions(merge: true),
    );
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

  Future<void> updateTopic(String studyUID, Topic topic) async {
    var lastSaveTime = Timestamp.now();

    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topic.topicUID)
        .set(
      {
        'topicDate': topic.topicDate,
        'topicName': topic.topicName,
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

  Future<void> setTopicAsActive(String studyUID, String topicUID) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .set(
      {
        'isActive': true,
      },
      SetOptions(merge: true),
    );
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

  Future<void> updateParticipant(
      String studyUID, Participant participant) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .doc(participant.participantUID)
        .set(participant.toMap(), SetOptions(merge: true));
  }

  Future<void> updateParticipantDetails(String studyUID, String participantUID,
      String detailKey, dynamic detail) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .doc(participantUID)
        .set(
      {detailKey: detail},
      SetOptions(merge: true),
    );
  }

  Future<void> incrementClap(String studyUID, String topicUID,
      String questionUID, String responseUID, String participantUID) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_RESPONSES_COLLECTION)
        .doc(responseUID)
        .update(
      {
        'claps': FieldValue.arrayUnion([participantUID]),
      },
    );
  }

  Future<void> decrementClap(String studyUID, String topicUID,
      String questionUID, String responseUID, String participantUID) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_RESPONSES_COLLECTION)
        .doc(responseUID)
        .update({
      'claps': FieldValue.arrayRemove([participantUID]),
    });
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

  Future<void> addUserToGroup(
      String studyUID, String groupUID, String userUID) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_GROUPS_COLLECTION)
        .doc(groupUID)
        .update({'users': userUID});
  }

  /// Delete section

  Future deleteGroup(String studyUID, String groupUID) async {
    var lastSaveTime = Timestamp.now();

    await _studiesReference
        .doc(studyUID)
        .collection(_GROUPS_COLLECTION)
        .doc(groupUID)
        .delete();

    await _studiesReference.doc(studyUID).set(
      {
        'lastSaveTime': lastSaveTime,
      },
      SetOptions(merge: true),
    );
  }

  Future deleteTopic(String studyUID, String topicUID) async {
    var lastSaveTime = Timestamp.now();

    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .delete();

    await _studiesReference.doc(studyUID).set(
      {
        'lastSaveTime': lastSaveTime,
      },
      SetOptions(merge: true),
    );
  }

  Future deleteQuestion(
      String studyUID, String topicUID, String questionUID) async {
    var lastSaveTime = Timestamp.now();

    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .delete();

    await _studiesReference.doc(studyUID).set(
      {
        'lastSaveTime': lastSaveTime,
      },
      SetOptions(merge: true),
    );
  }
}
