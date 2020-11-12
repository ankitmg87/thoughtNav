import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoughtnav/models/user.dart';
import 'package:thoughtnav/screens/researcher/models/categories.dart';
import 'package:thoughtnav/screens/researcher/models/client.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/moderator.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
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

  Future<String> getMasterPassword(String studyUID) async {
    var studySnapshot = await _studiesReference.doc(studyUID).get();
    var masterPassword = studySnapshot.data()['masterPassword'];
    return masterPassword;
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

  Stream getQuestion(String studyUID, String topicUID, String questionUID) {
    return _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .snapshots();
  }

  Stream getResponses(String studyUID, String topicUID, String questionUID) {
    return _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_RESPONSES_COLLECTION)
        .orderBy('responseTimeStamp', descending: true)
        .snapshots();
  }

  Stream getComments(String studyUID, String topicUID, String questionUID,
      String responseUID) {
    return _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topicUID)
        .collection(_QUESTIONS_COLLECTION)
        .doc(questionUID)
        .collection(_RESPONSES_COLLECTION)
        .doc(responseUID)
        .collection(_COMMENTS_COLLECTION)
        .orderBy('commentTimeStamp', descending: true)
        .snapshots();
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
    var question = Question(questionIndex: index, questionType: 'Standard');

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

  Future<Participant> createParticipant(
      String studyUID, Participant participant) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_PARTICIPANTS_COLLECTION)
        .add(participant.toMap())
        .then((participantReference) {
      participant.participantUID = participantReference.id;
      participantReference.set(
        {
          'participantUID': participantReference.id,
        },
        SetOptions(
          merge: true,
        ),
      );
    });

    return participant;
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
