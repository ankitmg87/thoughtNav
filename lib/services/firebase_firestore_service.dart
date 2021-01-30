import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoughtnav/models/avatar_and_display_name.dart';
import 'package:thoughtnav/models/user.dart';
import 'package:thoughtnav/screens/researcher/models/client.dart';
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
const String _AVATAR_AND_DISPLAY_NAMES_COLLECTION = 'avatarsAndDisplayNames';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _studiesReference =
      FirebaseFirestore.instance.collection(_STUDIES_COLLECTION);
  final CollectionReference _usersReference =
      FirebaseFirestore.instance.collection(_USERS_COLLECTION);

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

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

  Future<Study> getStudy(String studyUID) async {
    var studySnapshot = await _studiesReference.doc(studyUID).get();

    var study = Study.basicDetailsFromMap(studySnapshot.data());

    return study;
  }

  Stream getStudyAsStream(String studyUID) {
    return _studiesReference.doc(studyUID).snapshots();
  }

  Stream getNotifications(String studyUID, String participantGroupUID) {
    return _studiesReference
        .doc(studyUID)
        .collection(_NOTIFICATIONS_COLLECTION)
        .orderBy('notificationTimestamp', descending: true)
        .snapshots();
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

  Future<List<Topic>> getParticipantStudyNavigatorTopics(
    String studyUID,
  ) async {
    var topics = <Topic>[];

    var topicsReference = await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .orderBy('topicNumber', descending: false)
        .get();

    for (var topicSnapshot in topicsReference.docs) {
      var topic = Topic.fromMap(topicSnapshot.data());

      if (topic.isActive) {
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

      var questions = await getQuestions(studyUID, topic);

      topic.questions = questions;

      topics.add(topic);
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
        .orderBy('commentTimestamp', descending: false)
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

  /// Create section

  Future<User> createUser(User user) async {
    var userUID = await _firebaseAuthService.signUpUser(
        user.userEmail, user.userPassword);

    user.userUID = userUID;

    await _usersReference.doc(userUID).set(user.toMap());

    return user;
  }

  Future<Client> createClient(String studyUID, Client client) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_CLIENTS_COLLECTION)
        .doc(client.clientUID)
        .set(client.toMap());

    return client;
  }

  Future<Moderator> createModerator(
      String studyUID, Moderator moderator) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_MODERATORS_COLLECTION)
        .doc(moderator.moderatorUID)
        .set(moderator.toMap());

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



  Future<void> updateTopic(String studyUID, Topic topic) async {
    var lastSaveTime = Timestamp.now();

    await _studiesReference
        .doc(studyUID)
        .collection(_TOPICS_COLLECTION)
        .doc(topic.topicUID)
        .set(
      {
        'topicNumber': topic.topicNumber,
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

  Future<void> addUserToGroup(
      String studyUID, String groupUID, String userUID) async {
    await _studiesReference
        .doc(studyUID)
        .collection(_GROUPS_COLLECTION)
        .doc(groupUID)
        .update({'users': userUID});
  }

  Future<void> updateAvatarAndDisplayNameStatus(
      String studyUID, String avatarURL) async {
    var avatarAndDisplayNameQuerySnapshot = await _studiesReference
        .doc(studyUID)
        .collection(_AVATAR_AND_DISPLAY_NAMES_COLLECTION)
        .where('avatarURL', isEqualTo: avatarURL)
        .limit(1)
        .get();

    for (var avatarAndDisplayNameDocumentSnapshot
        in avatarAndDisplayNameQuerySnapshot.docs) {
      await _studiesReference
          .doc(studyUID)
          .collection(_AVATAR_AND_DISPLAY_NAMES_COLLECTION)
          .doc(avatarAndDisplayNameDocumentSnapshot.id)
          .update({
        'selected': true,
      });
    }
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
