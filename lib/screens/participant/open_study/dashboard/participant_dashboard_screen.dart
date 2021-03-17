import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/constants/string_constants.dart';
import 'package:thoughtnav/screens/participant/open_study/dashboard/dashboard_widgets/clap_notification_widget.dart';
import 'package:thoughtnav/screens/participant/open_study/dashboard/dashboard_widgets/comment_notification_widget.dart';
import 'package:thoughtnav/screens/participant/open_study/dashboard/dashboard_widgets/desktop_study_navigator.dart';
import 'package:thoughtnav/screens/participant/open_study/dashboard/dashboard_widgets/moderator_comment_notification_widget.dart';
import 'package:thoughtnav/screens/researcher/models/notification.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/services/firebase_auth_service.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/participant_firestore_service.dart';

import 'dashboard_widgets/active_task_widget.dart';
import 'dashboard_widgets/dashboard_top_container.dart';
import 'dashboard_widgets/desktop_dropdown_menu_options_row.dart';
import 'dashboard_widgets/drawer_tile.dart';
import 'dashboard_widgets/locked_task_widget.dart';
import 'dashboard_widgets/end_drawer_expansion_tile.dart';
import 'dashboard_widgets/new_question_notification_widget.dart';
import 'dashboard_widgets/study_details_general_dialog_widget.dart';

class ParticipantDashboardScreen extends StatefulWidget {
  @override
  _ParticipantDashboardScreenState createState() =>
      _ParticipantDashboardScreenState();
}

class _ParticipantDashboardScreenState
    extends State<ParticipantDashboardScreen> {
  final GlobalKey<ScaffoldState> _dashboardScaffoldKey =
      GlobalKey<ScaffoldState>();

  final _firebaseFireStoreService = FirebaseFirestoreService();

  final _participantFirestoreService = ParticipantFirestoreService();

  final _firebaseAuthService = FirebaseAuthService();

  int _totalQuestions = 1;
  int _answeredQuestions = 0;

  Question _nextQuestion;
  Topic _nextTopic;
  String _questionStatus;

  double value = 50.0;
  double initialWidth = 50.0;
  double finalWidth = 300.0;
  bool isExpanded = false;

  bool dropDownOpened = false;

  bool showDrawer = false;

  Size screenSize;

  String _studyUID;
  String _participantUID;

  Study _study;
  Participant _participant;
  List<Topic> _studyNavigatorTopics = <Topic>[];
  List<Topic> _topics;

  Future<void> _futureStudy;

  Future<void> _futureTopics;

  Stream<QuerySnapshot> _notificationsStream;

  Future<void> _getFutureStudy() async {
    await _getFutureParticipant();
    _study = await _firebaseFireStoreService.getStudy(_studyUID);

    _getNotificationsStream();

    var getStorage = GetStorage();

    _futureTopics = _getFutureTopics(_participant.groupUID);

    await getStorage.write('studyName', _study.studyName);
    await getStorage.write('participantGroupUID', _participant.groupUID);
  }

  Future<void> _getFutureParticipant() async {
    _participant = await _firebaseFireStoreService.getParticipant(
        _studyUID, _participantUID);
  }

  Future<void> _getFutureTopics(String participantGroupUID) async {
    _topics = await _participantFirestoreService.getParticipantTopics(
        _studyUID, participantGroupUID);
    var totalQuestions = 0;
    var answeredQuestions = 0;
    for (var topic in _topics) {
      totalQuestions += topic.questions.length;
      for (var question in topic.questions) {
        if (question.respondedBy != null) {
          if (question.respondedBy.contains(_participantUID)) {
            answeredQuestions += 1;
          }
        }
      }
    }
    setState(() {
      _studyNavigatorTopics = _topics;
      _answeredQuestions = answeredQuestions;
      _totalQuestions = totalQuestions;
    });
  }

  void _getNotificationsStream() {
    _notificationsStream = _participantFirestoreService
        .getParticipantNotifications(_studyUID, _participantUID);
  }

  @override
  void initState() {
    var getStorage = GetStorage();
    _studyUID = getStorage.read('studyUID');
    _participantUID = getStorage.read('participantUID');

    _futureStudy = _getFutureStudy();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    if (screenSize.width < screenSize.height) {
      return _buildPhoneDashboardFutureBuilder();
    } else {
      return _buildDesktopDashboardFutureBuilder();
    }
  }

  FutureBuilder _buildPhoneDashboardFutureBuilder() {
    return FutureBuilder(
      future: _futureStudy,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Material(
              child: Center(
                child: Text('Loading Study'),
              ),
            );
            break;
          case ConnectionState.done:
            return Scaffold(
              key: _dashboardScaffoldKey,
              appBar: _buildPhoneAppBar(),
              drawer: _buildPhoneDrawer(),
              endDrawer: _buildPhoneEndDrawer(),
              body: Column(
                children: [
                  DashboardTopContainer(
                    scaffoldKey: _dashboardScaffoldKey,
                    studyName: _study.studyName,
                    studyBeginDate: _study.startDate,
                    studyEndDate: _study.endDate,
                    rewardAmount: _participant.rewardAmount,
                    introMessage: _study.introPageMessage,
                    answeredQuestions: _answeredQuestions,
                    totalQuestions: _totalQuestions,
                    nextQuestionWidget: InkWell(
                      onTap: _answeredQuestions == _totalQuestions
                          ? null
                          : () {
                        for (var topic in _topics) {
                          var topicIndex = _topics
                              .indexWhere((element) => element == topic);
                          if (_nextQuestion == null ||
                              _nextTopic == null) {
                            if (topicIndex + 1 <= _topics.length - 1) {
                              if (_topics[topicIndex + 1]
                                  .topicDate
                                  .millisecondsSinceEpoch >
                                  Timestamp.now()
                                      .millisecondsSinceEpoch) {
                                _questionStatus = 'questionLocked';
                              } else {
                                for (var question
                                in _topics[topicIndex + 1]
                                    .questions) {
                                  if (_nextQuestion == null ||
                                      _nextTopic == null) {
                                    if (question.questionTimestamp
                                        .millisecondsSinceEpoch >
                                        Timestamp.now()
                                            .millisecondsSinceEpoch) {
                                      _questionStatus = 'questionLocked';
                                    } else {
                                      if (question.respondedBy == null) {
                                        _questionStatus =
                                        'questionUnlocked';
                                        _nextTopic =
                                        _topics[topicIndex + 1];
                                        _nextQuestion = question;
                                      } else {
                                        if (!question.respondedBy
                                            .contains(_participantUID)) {
                                          _questionStatus =
                                          'questionUnlocked';
                                          _nextTopic =
                                          _topics[topicIndex + 1];
                                          _nextQuestion = question;
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                        if (_questionStatus == 'questionLocked') {
                          showGeneralDialog(
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation) {
                              return Center(
                                child: Material(
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.5,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Question is still locked',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                            Alignment.centerRight,
                                            child: FlatButton(
                                              color: PROJECT_NAVY_BLUE,
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(),
                                              child: Padding(
                                                padding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 10.0,
                                                ),
                                                child: Text(
                                                  'OKAY',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            context: context,
                          );
                        }
                        if (_questionStatus == 'questionUnlocked') {
                          Navigator.of(context).popAndPushNamed(
                            PARTICIPANT_RESPONSES_SCREEN,
                            arguments: {
                              'topicUID': _nextTopic.topicUID,
                              'questionUID': _nextQuestion.questionUID,
                            },
                          );
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              _answeredQuestions == _totalQuestions
                                  ? 'All Questions Answered'
                                  : 'Next Question',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: _answeredQuestions == _totalQuestions ? PROJECT_NAVY_BLUE : PROJECT_GREEN,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Icon(
                            CupertinoIcons.right_chevron,
                            color: PROJECT_GREEN,
                            size: 14.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: _futureTopics,
                      builder:
                          (BuildContext context, AsyncSnapshot<void> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            return Center(
                              child: Text('Loading Topics...'),
                            );
                            break;
                          case ConnectionState.done:
                            return Scrollbar(
                              child: ListView(
                                padding: EdgeInsets.only(right: 20.0),
                                children: [
                                  _answeredQuestions == _totalQuestions &&
                                      _study.studyStatus == 'Completed'
                                      ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Card(
                                      elevation: 4.0,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                          color: PROJECT_LIGHT_GREEN,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Hurray!!'
                                                      '\n'
                                                      ' You have answered $_answeredQuestions/$_totalQuestions questions!'
                                                      '\n'
                                                      'Payments will be sent within 5 working days after study is closed.',
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                    color:
                                                    Colors.grey[700],
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                      : SizedBox(),
                                  SizedBox(
                                    height: _answeredQuestions ==
                                        _totalQuestions &&
                                        _study.studyStatus == 'Completed'
                                        ? 10.0
                                        : 0,
                                  ),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: _topics.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (_topics[index]
                                          .topicDate
                                          .millisecondsSinceEpoch <=
                                          Timestamp.now()
                                              .millisecondsSinceEpoch) {
                                        return ActiveTaskWidget(
                                          topic: _topics[index],
                                          participantUID: _participantUID,
                                        );
                                      } else {
                                        return LockedTaskWidget(
                                            topic: _topics[index]);
                                      }
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        height: 10.0,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                            break;
                          default:
                            return SizedBox();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            );
            break;
          default:
            return SizedBox();
        }
      },
    );
  }

  Drawer _buildPhoneEndDrawer() {
    return Drawer(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Color(0xFF333333),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                'Study Navigator',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.close,
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 1.0,
            color: Color(0xFFE5E5E5),
            margin: EdgeInsets.only(
              top: 5.0,
            ),
          ),
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              thickness: 10.0,
              child: ListView.builder(
                padding: EdgeInsets.only(right: 20.0),
                itemCount: _studyNavigatorTopics.length,
                itemBuilder: (BuildContext context, int index) {
                  if (_studyNavigatorTopics[index]
                      .topicDate
                      .millisecondsSinceEpoch <=
                      Timestamp.now().millisecondsSinceEpoch) {
                    return EndDrawerExpansionTile(
                      title: _studyNavigatorTopics[index].topicName,
                      questions: _studyNavigatorTopics[index].questions,
                      participantUID: _participantUID,
                      topicUID: _studyNavigatorTopics[index].topicUID,
                    );
                  } else {
                    return ListTile(
                      onTap: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: 'Topic Locked',
                          pageBuilder:
                              (BuildContext studyNavigatorLockedTopicContext,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return Center(
                              child: Material(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'This topic is still locked',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      title: Text(
                        'Topic Locked',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          ),
        ],
      ),
    );
  }

  Drawer _buildPhoneDrawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                  imageUrl: _participant.profilePhotoURL ?? '',
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      padding: EdgeInsets.all(6.0),
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: PROJECT_LIGHT_GREEN,
                      ),
                      child: Image(
                        width: 20.0,
                        image: imageProvider,
                      ),
                    );
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_participant.userFirstName} ${_participant.userLastName}',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _participant.displayName,
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Color(0xFF666666),
                    ),
                  ),
                  Text(
                    _participant.userGroupName,
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              Column(
                children: [
                  IconButton(
                    alignment: Alignment.topCenter,
                    icon: Icon(
                      CupertinoIcons.clear_thick,
                      color: Color(0xFF333333),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
          Container(
            height: 1.0,
            color: Color(0xFFE5E5E5),
            width: double.infinity,
          ),
          Container(
            height: 1.0,
            color: Color(0xFFE5E5E5),
            width: double.infinity,
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                DrawerTile(
                  image: 'images/dashboard_icons/dashboard.png',
                  title: 'Dashboard',
                  onTap: () => Navigator.of(context).pop(),
                ),
                DrawerTile(
                  image:
                      'images/dashboard_icons/notifications_outline_black.png',
                  title: 'Notifications',
                  onTap: () => Navigator.of(context)
                      .popAndPushNamed(NOTIFICATIONS_SCREEN),
                ),
                DrawerTile(
                  image: 'images/dashboard_icons/rewards.png',
                  title: 'Rewards',
                  width: 22.5,
                  onTap: () => Navigator.of(context)
                      .popAndPushNamed(POST_STUDY_REWARD_METHODS_SCREEN),
                ),
                DrawerTile(
                  image: 'images/dashboard_icons/contact_us.png',
                  title: 'Contact Us',
                  onTap: () =>
                      Navigator.of(context).popAndPushNamed(CONTACT_US_SCREEN),
                ),
                DrawerTile(
                  image: 'images/dashboard_icons/preferences.png',
                  title: 'Preferences',
                  onTap: () => Navigator.of(context)
                      .popAndPushNamed(USER_PREFERENCES_SCREEN),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  height: 1.0,
                  color: Color(0xFFE5E5E5),
                  width: double.infinity,
                ),
                InkWell(
                  onTap: () async {
                    await _firebaseAuthService.signOutUser();
                    await Navigator.of(context).popAndPushNamed(LOGIN_SCREEN);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    width: 400.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(4.0),
                        ),
                        color: Colors.black12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Log Out',
                          style: TextStyle(
                            color: TEXT_COLOR.withOpacity(0.5),
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Icon(
                          Icons.exit_to_app,
                          color: TEXT_COLOR.withOpacity(0.5),
                          size: 15.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildPhoneAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        'ThoughtNav',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      leading: GestureDetector(
        onTap: () => _dashboardScaffoldKey.currentState.openDrawer(),
        child: _participant.profilePhotoURL != null
            ? CachedNetworkImage(
                imageUrl: _participant.profilePhotoURL ?? '',
                // placeholder: (context, placeholderText){
                //   return SizedBox();
                // },
                imageBuilder: (context, imageProvider) {
                  return Container(
                    padding: EdgeInsets.all(6.0),
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: PROJECT_LIGHT_GREEN,
                    ),
                    child: Image(
                      width: 20.0,
                      image: imageProvider ?? '',
                    ),
                  );
                },
              )
            : SizedBox(),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.menu,
            color: PROJECT_GREEN,
          ),
          onPressed: () => _dashboardScaffoldKey.currentState.openEndDrawer(),
        ),
      ],
    );
  }

  FutureBuilder _buildDesktopDashboardFutureBuilder() {
    return FutureBuilder(
      future: _futureStudy,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Material(
              child: Center(
                child: Text('No Internet Connection'),
              ),
            );
            break;
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Material(
              child: Center(
                child: Text('Loading Study...'),
              ),
            );
            break;
          case ConnectionState.done:
            return Scaffold(
                appBar: _buildDesktopAppBar(),
                body: _buildDesktopBody(screenSize, context));
            break;
          default:
            return Material(
              child: Center(
                child: Text(
                  'Something went wrong!',
                ),
              ),
            );
        }
      },
    );
  }

  Stack _buildDesktopBody(Size screenSize, BuildContext context) {
    return Stack(
      children: [
        Container(
          width: screenSize.width,
          height: double.maxFinite,
          child: Row(
            children: [
              DesktopStudyNavigator(
                participantUID: _participantUID,
                topics: _studyNavigatorTopics,
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        top: 20.0,
                        right: 20.0,
                        bottom: 16.0,
                      ),
                      color: PROJECT_NAVY_BLUE,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _study.studyName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              InkWell(
                                onTap: () {
                                  _buildViewDetailsGeneralDialog();
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'View Details',
                                      style: TextStyle(
                                        color: PROJECT_GREEN,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6.0,
                                    ),
                                    Icon(
                                      CupertinoIcons.right_chevron,
                                      color: PROJECT_GREEN,
                                      size: 14.0,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                width: screenSize.width * 0.5,
                                child: LinearProgressIndicator(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.7),
                                  minHeight: 8.0,
                                  value: _answeredQuestions / _totalQuestions,
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                width: screenSize.width * 0.5,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _answeredQuestions == 0
                                          ? 'You have not answered any questions'
                                          : _answeredQuestions == 1
                                              ? 'You have answered 1 question'
                                              : 'You have answered $_answeredQuestions questions',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: _answeredQuestions ==
                                          _totalQuestions
                                          ? null
                                          : () {
                                        print('Tapped');
                                        for (var topic in _topics) {
                                          var topicIndex = _topics
                                              .indexWhere((element) =>
                                          element == topic);
                                          if (_nextQuestion == null ||
                                              _nextTopic == null) {
                                            if (topicIndex + 1 <=
                                                _topics.length - 1) {
                                              if (_topics[topicIndex + 1]
                                                  .topicDate
                                                  .millisecondsSinceEpoch >
                                                  Timestamp.now()
                                                      .millisecondsSinceEpoch) {
                                                _questionStatus =
                                                'questionLocked';
                                              } else {
                                                for (var question
                                                in _topics[
                                                topicIndex +
                                                    1]
                                                    .questions) {
                                                  if (_nextQuestion ==
                                                      null ||
                                                      _nextTopic ==
                                                          null) {
                                                    if (question
                                                        .questionTimestamp
                                                        .millisecondsSinceEpoch >
                                                        Timestamp.now()
                                                            .millisecondsSinceEpoch) {
                                                      _questionStatus =
                                                      'questionLocked';
                                                    } else {
                                                      if (question
                                                          .respondedBy ==
                                                          null) {
                                                        _questionStatus =
                                                        'questionUnlocked';
                                                        _nextTopic =
                                                        _topics[
                                                        topicIndex +
                                                            1];
                                                        _nextQuestion =
                                                            question;
                                                      } else {
                                                        if (!question
                                                            .respondedBy
                                                            .contains(
                                                            _participantUID)) {
                                                          _questionStatus =
                                                          'questionUnlocked';
                                                          _nextTopic =
                                                          _topics[
                                                          topicIndex +
                                                              1];
                                                          _nextQuestion =
                                                              question;
                                                        }
                                                      }
                                                    }
                                                  }
                                                }
                                              }
                                            }
                                          }
                                        }
                                        if (_questionStatus ==
                                            'questionLocked') {
                                          showGeneralDialog(
                                            pageBuilder: (BuildContext
                                            context,
                                                Animation<double>
                                                animation,
                                                Animation<double>
                                                secondaryAnimation) {
                                              return Center(
                                                child: Material(
                                                  child: Container(
                                                    constraints:
                                                    BoxConstraints(
                                                      maxWidth: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.5,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                      EdgeInsets.all(
                                                          20.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                        MainAxisSize
                                                            .min,
                                                        children: [
                                                          Text(
                                                            'Question is still locked',
                                                            style:
                                                            TextStyle(
                                                              color: Colors
                                                                  .black,
                                                              fontSize:
                                                              18.0,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment:
                                                            Alignment
                                                                .centerRight,
                                                            child:
                                                            FlatButton(
                                                              color:
                                                              PROJECT_NAVY_BLUE,
                                                              onPressed: () =>
                                                                  Navigator.of(context)
                                                                      .pop(),
                                                              child:
                                                              Padding(
                                                                padding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                  horizontal:
                                                                  20.0,
                                                                  vertical:
                                                                  10.0,
                                                                ),
                                                                child:
                                                                Text(
                                                                  'OKAY',
                                                                  style:
                                                                  TextStyle(
                                                                    color:
                                                                    Colors.white,
                                                                    fontSize:
                                                                    14.0,
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            context: context,
                                          );
                                        }
                                        if (_questionStatus ==
                                            'questionUnlocked') {
                                          Navigator.of(context)
                                              .popAndPushNamed(
                                            PARTICIPANT_RESPONSES_SCREEN,
                                            arguments: {
                                              'topicUID':
                                              _nextTopic.topicUID,
                                              'questionUID': _nextQuestion
                                                  .questionUID,
                                            },
                                          );
                                        }
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            _answeredQuestions ==
                                                _totalQuestions
                                                ? 'All Questions Answered'
                                                : 'Next Question',
                                            style: TextStyle(
                                              color: PROJECT_GREEN,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4.0,
                                          ),
                                          Icon(
                                            CupertinoIcons.right_chevron,
                                            color: _answeredQuestions ==
                                                _totalQuestions
                                                ? PROJECT_NAVY_BLUE
                                                : PROJECT_GREEN,
                                            size: 14.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Align(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              width: screenSize.width * 0.6,
                              child: FutureBuilder(
                                future: _futureTopics,
                                builder: (BuildContext context,
                                    AsyncSnapshot<void> snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                      return Center(
                                        child: Text('Loading Topics...'),
                                      );
                                      break;
                                    case ConnectionState.done:
                                      return ListView(
                                        children: [
                                          _answeredQuestions ==
                                                      _totalQuestions &&
                                                  _study.studyStatus ==
                                                      'Completed'
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  child: Card(
                                                    elevation: 4.0,
                                                    color: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        color:
                                                            PROJECT_LIGHT_GREEN,
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            20.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Hurray!!'
                                                              '\n'
                                                              ' You have answered $_answeredQuestions/$_totalQuestions questions!'
                                                              '\n'
                                                              'Payments will be sent within 5 working days after study is closed.',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey[700],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                          SizedBox(
                                            height: _answeredQuestions ==
                                                        _totalQuestions &&
                                                    _study.studyStatus ==
                                                        'Completed'
                                                ? 10.0
                                                : 0,
                                          ),
                                          ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: _topics.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return _buildStudyTopic(index);
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return SizedBox(
                                                height: 10.0,
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                      break;
                                    default:
                                      return SizedBox();
                                  }
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  'Study Activity',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  height: 0.5,
                                  color: Colors.grey[300],
                                  width: double.maxFinite,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                _buildNotificationsStreamBuilder(
                                    _notificationsStream),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              dropDownOpened = !dropDownOpened;
            });
          },
          child: dropDownOpened
              ? _buildDropDownMenu(screenSize, context)
              : SizedBox(),
        ),
      ],
    );
  }

  Widget _buildStudyTopic(int index) {
    if (index == 0 &&
        _topics[index].topicDate.millisecondsSinceEpoch <=
            Timestamp.now().millisecondsSinceEpoch) {
      return ActiveTaskWidget(
        topic: _topics[index],
        participantUID: _participantUID,
      );
    } else {
      if (_topics[index - 1].questions.last.isProbe) {
        if (_topics[index].topicDate.millisecondsSinceEpoch <=
            Timestamp.now().millisecondsSinceEpoch) {
          return ActiveTaskWidget(
            topic: _topics[index],
            participantUID: _participantUID,
          );
        } else {
          return LockedTaskWidget(topic: _topics[index]);
        }
      } else {
        if (_topics[index - 1].questions.last.respondedBy != null) {
          if (_topics[index - 1]
              .questions
              .last
              .respondedBy
              .contains(_participantUID) &&
              _topics[index].topicDate.millisecondsSinceEpoch <=
                  Timestamp.now().millisecondsSinceEpoch) {
            return ActiveTaskWidget(
              topic: _topics[index],
              participantUID: _participantUID,
            );
          } else {
            return LockedTaskWidget(topic: _topics[index]);
          }
        } else {
          return LockedTaskWidget(topic: _topics[index]);
        }
      }
    }
  }

  StreamBuilder _buildNotificationsStreamBuilder(
      Stream<QuerySnapshot> getNotificationsStream) {
    return StreamBuilder<QuerySnapshot>(
      stream: getNotificationsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            return SizedBox();
            break;
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              var notifications = snapshot.data.docs;

              return Expanded(
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    switch (notifications[index]['notificationType']) {
                      case 'clap':
                        var clapNotification = ClapNotification.fromMap(
                            notifications[index].data());

                        return ClapNotificationWidget(
                          clapNotification: clapNotification,
                          participantDisplayName: _participant.displayName,
                        );
                        break;

                      case 'comment':
                        var commentNotification = CommentNotification.fromMap(
                            notifications[index].data());

                        return CommentNotificationWidget(
                          commentNotification: commentNotification,
                          participantDisplayName: _participant.displayName,
                        );
                        break;

                      case 'moderatorComment':
                        var moderatorCommentNotification =
                            ModeratorCommentNotification.fromMap(
                                notifications[index].data());

                        return ModeratorCommentNotificationWidget(
                          moderatorCommentNotification:
                              moderatorCommentNotification,
                        );
                        break;

                      case 'newQuestionNotification':
                        var newQuestionNotification = NewQuestionNotification.fromMap(notifications[index].data());

                        return NewQuestionNotificationWidget(
                          newQuestionNotification: newQuestionNotification,
                        );
                        break;
                      default:
                        return SizedBox();
                    }
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                      height: 1.0,
                      width: double.maxFinite,
                      color: Colors.grey[300],
                    );
                  },
                  itemCount: notifications.length,
                ),
              );
            } else {
              return SizedBox();
            }
            break;
          case ConnectionState.done:
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            return SizedBox();
            break;
          default:
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            return SizedBox();
        }
      },
    );
  }

  Container _buildDropDownMenu(Size screenSize, BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: Colors.black38.withOpacity(0.5),
      child: Stack(
        children: [
          Container(
            width: screenSize.width,
            height: screenSize.height,
          ),
          Positioned(
            top: 5.0,
            right: 160,
            child: Card(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CachedNetworkImage(
                            imageUrl: _participant.profilePhotoURL,
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: PROJECT_LIGHT_GREEN,
                                ),
                                child: Center(
                                  child: Image(
                                    width: 30.0,
                                    image: imageProvider,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_participant.userFirstName} ${_participant.userLastName}',
                                style: TextStyle(
                                  color: TEXT_COLOR,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 6.0,
                              ),
                              Text(
                                _participant.displayName,
                                style: TextStyle(
                                  color: TEXT_COLOR.withOpacity(0.7),
                                  fontSize: 13.0,
                                ),
                              ),
                              SizedBox(
                                height: 6.0,
                              ),
                              Text(
                                _participant.userGroupName,
                                style: TextStyle(
                                  color: TEXT_COLOR.withOpacity(0.7),
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 0.5,
                      width: 400,
                      color: TEXT_COLOR.withOpacity(0.5),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Continue Study',
                            style: TextStyle(
                              color: PROJECT_GREEN,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: PROJECT_GREEN,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 0.5,
                      width: 400,
                      color: TEXT_COLOR.withOpacity(0.5),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    DesktopDropdownMenuOptionsRow(
                      image1: 'images/dashboard_icons/dashboard.png',
                      image2: 'images/dashboard_icons/preferences.png',
                      label1: 'Dashboard',
                      label2: 'Preferences',
                      onTap2: () => Navigator.of(context)
                          .popAndPushNamed(USER_PREFERENCES_SCREEN),
                    ),
                    DesktopDropdownMenuOptionsRow(
                      image1: 'images/dashboard_icons/rewards.png',
                      image2: 'images/dashboard_icons/contact_us.png',
                      label1: 'Rewards',
                      label2: 'Contact Us',
                      onTap1: () {
                        Navigator.of(context)
                            .popAndPushNamed(POST_STUDY_REWARD_METHODS_SCREEN);
                      },
                      onTap2: () => Navigator.of(context)
                          .popAndPushNamed(CONTACT_US_SCREEN),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Container(
                      height: 0.5,
                      width: 400,
                      color: TEXT_COLOR.withOpacity(0.5),
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                    Container(
                      height: 0.5,
                      width: 400,
                      color: TEXT_COLOR.withOpacity(0.5),
                    ),
                    InkWell(
                      onTap: () async {
                        await _firebaseAuthService.signOutUser();
                        await Navigator.of(context)
                            .popAndPushNamed(LOGIN_SCREEN);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        width: 400.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(4.0),
                            ),
                            color: Colors.black12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Log Out',
                              style: TextStyle(
                                color: TEXT_COLOR.withOpacity(0.5),
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Icon(
                              Icons.exit_to_app,
                              color: TEXT_COLOR.withOpacity(0.5),
                              size: 15.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Object> _buildViewDetailsGeneralDialog() {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Study Details',
      pageBuilder: (BuildContext _context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: Material(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      Text(
                        'Study Details',
                        style: TextStyle(
                          color: Color(0xFFAAAAAA),
                        ),
                      ),
                      InkWell(
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Icon(
                          Icons.clear,
                          color: Colors.red[700],
                          size: 16.0,
                        ),
                        onTap: () {
                          Navigator.of(_context).pop();
                        },
                      ),
                    ],
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 1.0,
                    margin: EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Builder(
                            builder: (BuildContext builderContext) {
                              // var textSpan = HTML.toTextSpan(
                              //   builderContext,
                              //   _study.introPageMessage,
                              // );

                              return SingleChildScrollView(
                                child: Material(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                      vertical: 12.0,
                                    ),
                                    child: HtmlWidget(
                                      _study.introPageMessage,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          height: double.maxFinite,
                          width: 1.0,
                          color: Colors.grey[300],
                        ),
                        Expanded(
                          child: StudyDetailsGeneralDialogWidget(
                            study: _study,
                            participant: _participant,
                            context: context,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _buildDesktopAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Center(
        child: Text(
          APP_NAME,
          style: TextStyle(
            color: TEXT_COLOR,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ),
      leadingWidth: 120.0,
      title: Text(
        _study.studyName,
        style: TextStyle(
          color: TEXT_COLOR,
        ),
      ),
      centerTitle: true,
      actions: [
        Center(
          child: Text(
            'Hello ${_participant.userFirstName} ${_participant.userLastName}',
            style: TextStyle(
              color: TEXT_COLOR.withOpacity(0.7),
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        InkWell(
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            setState(() {
              dropDownOpened = !dropDownOpened;
            });
          },
          child: CachedNetworkImage(
            imageUrl: _participant.profilePhotoURL,
            imageBuilder: (context, imageProvider) {
              return Container(
                padding: EdgeInsets.all(6.0),
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PROJECT_LIGHT_GREEN,
                ),
                child: Image(
                  width: 20.0,
                  image: imageProvider,
                ),
              );
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12.0),
          height: double.infinity,
          width: 0.5,
          color: TEXT_COLOR.withOpacity(0.6),
        ),
        Center(
          child: InkWell(
            onTap: () {
              if (_questionStatus == 'questionLocked') {
                showGeneralDialog(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return Center(
                      child: Material(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.5,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Question is still locked',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: FlatButton(
                                    color: PROJECT_NAVY_BLUE,
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical: 10.0,
                                      ),
                                      child: Text(
                                        'OKAY',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  context: context,
                );
              }
              if (_questionStatus == 'questionUnlocked') {
                Navigator.of(context).pushNamed(
                  PARTICIPANT_RESPONSES_SCREEN,
                  arguments: {
                    'topicUID': _nextTopic.topicUID,
                    'questionUID': _nextQuestion.questionUID,
                  },
                );
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Continue Study',
                  style: TextStyle(
                    color: PROJECT_GREEN,
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(
                  width: 4.0,
                ),
                Icon(
                  Icons.arrow_forward,
                  color: PROJECT_GREEN,
                  size: 12.0,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
      ],
    );
  }
}
