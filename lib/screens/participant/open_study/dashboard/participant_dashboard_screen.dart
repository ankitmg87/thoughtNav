import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/constants/string_constants.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/participant_firestore_service.dart';

import 'dashboard_widgets/active_task_widget.dart';
import 'dashboard_widgets/dashboard_top_container.dart';
import 'dashboard_widgets/drawer_tile.dart';
import 'dashboard_widgets/locked_task_widget.dart';
import 'dashboard_widgets/end_drawer_expansion_tile.dart';

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

  int _totalQuestions = 1;
  int _answeredQuestions = 0;

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
  List<Topic> _studyNavigatorTopics;
  List<Topic> _topics;

  Future<void> _futureStudy;
  Future<void> _futureStudyNavigatorTopics;
  Future<void> _futureTopics;

  Stream _notificationsStream;

  Future<void> _getFutureStudy() async {
    await _getFutureParticipant();
    _study = await _firebaseFireStoreService.getStudy(_studyUID);

    var getStorage = GetStorage();

    _futureTopics = _getFutureTopics(_participant.groupUID);

    await getStorage.write('studyName', _study.studyName);
  }

  Future<void> _getFutureParticipant() async {
    _participant = await _firebaseFireStoreService.getParticipant(
        _studyUID, _participantUID);
  }

  Future<void> _getStudyNavigatorFutureTopics() async {
    _studyNavigatorTopics = await _firebaseFireStoreService
        .getParticipantStudyNavigatorTopics(_studyUID);
  }

  Future<void> _getFutureTopics(String participantGroupUID) async {
    _topics = await _participantFirestoreService.getParticipantTopics(
        _studyUID, participantGroupUID);

    var totalQuestions = 0;
    var answeredQuestions = 0;

    for (var topic in _topics){
      totalQuestions += topic.questions.length;

      for(var question in topic.questions){
        if(question.respondedBy != null){
          if (question.respondedBy.contains(_participantUID)){
            answeredQuestions += 1;
          }
        }
      }

    }
    setState(() {
      _answeredQuestions = answeredQuestions;
      _totalQuestions = totalQuestions;
    });
  }

  void _getNotifications() {
    _notificationsStream =
        _firebaseFireStoreService.getNotifications(_studyUID);
  }

  @override
  void initState() {
    var getStorage = GetStorage();
    _studyUID = getStorage.read('studyUID');
    _participantUID = getStorage.read('participantUID');

    _futureStudy = _getFutureStudy();
    _futureStudyNavigatorTopics = _getStudyNavigatorFutureTopics();

    _getNotifications();

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
              appBar: buildPhoneAppBar(),
              drawer: buildPhoneDrawer(),
              endDrawer: buildPhoneEndDrawer(),
              body: Column(
                children: [
                  DashboardTopContainer(
                    scaffoldKey: _dashboardScaffoldKey,
                    studyName: _study.studyName,
                    studyBeginDate: _study.startDate,
                    studyEndDate: _study.endDate,
                    rewardAmount: _participant.rewardAmount,
                    introMessage: _study.introPageMessage,
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
                            return ListView.builder(
                              itemCount: _topics.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (_topics[index].isActive) {
                                  return ActiveTaskWidget(
                                    topic: _topics[index],
                                  );
                                } else {
                                  return LockedTaskWidget(
                                    topic: _topics[index],
                                  );
                                }
                              },
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
                  )
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
              buildCustomLeftDrawer(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        top: 20.0,
                        right: 20.0,
                        bottom: 16.0,
                      ),
                      color: PROJECT_NAVY_BLUE,
                      child: Column(
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
                            onTap: () {
                              _buildViewDetailsGeneralDialog();
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            width: screenSize.width * 0.5,
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.white.withOpacity(0.7),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'You have not completed any questions',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Next: Quick Intro',
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
                                      color: PROJECT_GREEN,
                                      size: 14.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                                      return ListView.separated(
                                        itemCount: _topics.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (_topics[index].isActive) {
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
                            child: _buildNotificationsStreamBuilder(
                                _notificationsStream),
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
              ? buildDropDownMenu(screenSize, context)
              : SizedBox(),
        ),
      ],
    );
  }

  StreamBuilder _buildNotificationsStreamBuilder(
      Stream getNotificationsStream) {
    return StreamBuilder(
      stream: getNotificationsStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
              var notifications = snapshot.data.documents;

              return Column(
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
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return _DesktopNotificationWidget(
                          timestamp: notifications[index]
                              ['notificationTimestamp'],
                          participantAvatar: notifications[index]
                              ['participantAvatar'],
                          participantDisplayName: notifications[index]
                                      ['participantDisplayName'] ==
                                  _participant.displayName
                              ? 'You'
                              : notifications[index]['participantDisplayName'],
                          questionNumber: notifications[index]
                              ['questionNumber'],
                          questionTitle: notifications[index]['questionTitle'],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 10.0,
                        );
                      },
                      itemCount: notifications.length,
                    ),
                  ),
                ],
              );
            } else {
              return SizedBox(
                child: Text('Loading...'),
              );
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

  Widget buildCustomLeftDrawer() {
    return Align(
      child: AnimatedContainer(
        curve: Curves.ease,
        height: double.maxFinite,
        width: value,
        color: Colors.white,
        duration: Duration(milliseconds: 200),
        onEnd: () {
          setState(() {
            if (isExpanded) {
              showDrawer = true;
            }
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: showDrawer
                        ? Text(
                            'Study Navigator',
                            maxLines: 1,
                            style: TextStyle(
                              color: TEXT_COLOR,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : SizedBox(),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    showDrawer ? Icons.close : Icons.menu,
                    color: PROJECT_GREEN,
                  ),
                  onPressed: () {
                    setState(() {
                      if (!isExpanded) {
                        value = finalWidth;
                        isExpanded = !isExpanded;
                      } else {
                        value = initialWidth;
                        isExpanded = !isExpanded;
                        showDrawer = false;
                      }
                    });
                  },
                ),
              ],
            ),
            showDrawer
                ? Expanded(
                    child: FutureBuilder(
                      future: _futureStudyNavigatorTopics,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            return Center(
                              child: Text('Loading Topics...'),
                            );
                            break;
                          case ConnectionState.done:
                            if (_studyNavigatorTopics != null) {
                              return ListView.builder(
                                itemCount: _studyNavigatorTopics.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return EndDrawerExpansionTile(
                                    title:
                                        _studyNavigatorTopics[index].topicName,
                                    questions:
                                        _studyNavigatorTopics[index].questions,
                                    participantUID: _participantUID,
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: Text('Some error occurred'),
                              );
                            }
                            break;
                          default:
                            return SizedBox();
                        }
                      },
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Container buildDropDownMenu(Size screenSize, BuildContext context) {
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
                    _DropdownMenuOptionsRow(
                      image1: 'images/dashboard_icons/dashboard.png',
                      image2: 'images/dashboard_icons/preferences.png',
                      label1: 'Dashboard',
                      label2: 'Preferences',
                      onTap2: () => Navigator.of(context)
                          .pushNamed(USER_PREFERENCES_SCREEN),
                    ),
                    _DropdownMenuOptionsRow(
                      image1: 'images/dashboard_icons/rewards.png',
                      image2: 'images/dashboard_icons/contact_us.png',
                      label1: 'Rewards',
                      label2: 'Contact Us',
                      onTap1: () => Navigator.of(context)
                          .pushNamed(POST_STUDY_REWARD_METHODS_SCREEN),
                      onTap2: () =>
                          Navigator.of(context).pushNamed(CONTACT_US_SCREEN),
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
                    Container(
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
      pageBuilder: (BuildContext _context,
          Animation<double> animation,
          Animation<double> secondaryAnimation) {

        return Center(
          child: Material(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context)
                    .size
                    .width *
                    0.7,
                maxHeight: MediaQuery.of(context)
                    .size
                    .height *
                    0.7,
              ),
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Study Details',
                    style: TextStyle(
                      color: Color(0xFFAAAAAA),
                    ),
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
                            builder: (BuildContext
                            builderContext) {

                              var textSpan = HTML.toTextSpan(
                                builderContext,
                                _study.introPageMessage,
                                // defaultTextStyle: TextStyle(color: Colors.grey[700]),
                                // overrideStyle: {
                                //   'p': TextStyle(fontSize: 14),
                                //   'a': TextStyle(wordSpacing: 2),
                                //   // specify any tag not just the supported ones,
                                //   // and apply TextStyles to them and/override them
                                // },
                              );


                              return SingleChildScrollView(
                                child: Material(
                                  child: Container(
                                    padding:
                                    EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                      vertical: 12.0,
                                    ),
                                    child: RichText(
                                      text: textSpan,
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
                          child: ListView(
                            children: [
                              Padding(
                                padding:
                                EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 5.0,
                                    bottom: 20.0),
                                child: Text(
                                  'You\'re participating in the ${_study.studyName}.',
                                  style: TextStyle(
                                    color: Color(
                                        0xFF333333),
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets
                                    .symmetric(
                                  horizontal: 24.0,
                                  vertical: 12.0,
                                ),
                                child: Row(
                                  children: [
                                    Image(
                                      width: 30.0,
                                      image:
                                      AssetImage(
                                        'images/svg_icons/calender_icon.png',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40.0,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                            'This study begins ',
                                            style:
                                            TextStyle(
                                              fontSize:
                                              14.0,
                                              color: Color(
                                                  0xFF333333),
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                            '${_study.startDate}\n',
                                            style: TextStyle(
                                                fontSize:
                                                14.0,
                                                color: Color(
                                                    0xFF333333),
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text:
                                            'and ends ',
                                            style:
                                            TextStyle(
                                              fontSize:
                                              14.0,
                                              color: Color(
                                                  0xFF333333),
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                            '${_study.endDate}.',
                                            style:
                                            TextStyle(
                                              fontSize:
                                              14.0,
                                              color: Color(
                                                  0xFF333333),
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets
                                    .symmetric(
                                    horizontal:
                                    24.0,
                                    vertical:
                                    12.0),
                                child: Row(
                                  children: [
                                    Image(
                                      width: 30.0,
                                      image:
                                      AssetImage(
                                        'images/svg_icons/gift_card.png',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40.0,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                            'After you complete this study,\nyou\'ll be awarded a ',
                                            style:
                                            TextStyle(
                                              fontSize:
                                              14.0,
                                              color: Color(
                                                  0xFF333333),
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                            '\$${_participant.rewardAmount} giftcard.',
                                            style:
                                            TextStyle(
                                              fontSize:
                                              14.0,
                                              color: Color(
                                                  0xFF333333),
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width:
                                double.maxFinite,
                                height: 0.5,
                                color:
                                Colors.grey[200],
                              ),
                              Padding(
                                padding: EdgeInsets
                                    .symmetric(
                                    horizontal:
                                    20.0,
                                    vertical:
                                    12.0),
                                child: Text(
                                  'About ${_study.studyName}',
                                  style: TextStyle(
                                    color: Color(
                                        0xFF7F7F7F),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets
                                    .symmetric(
                                    horizontal:
                                    20.0),
                                child: Text(
                                  'The purpose of this study is to receive your honest feedback about your personal experiences with your power wheelchair.',
                                  style: TextStyle(
                                    color: Color(
                                        0xFF333333),
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets
                                    .symmetric(
                                  horizontal: 20.0,
                                  vertical: 12.0,
                                ),
                                child: Text(
                                  'Learn more about Focus Groups',
                                  style: TextStyle(
                                    color:
                                    PROJECT_GREEN,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                              Container(
                                width:
                                double.maxFinite,
                                height: 0.5,
                                color:
                                Colors.grey[200],
                              ),
                              Padding(
                                padding:
                                EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 12.0,
                                    bottom: 6.0),
                                child: Text(
                                  'Tips for completing this study',
                                  style: TextStyle(
                                    color: Color(
                                        0xFF7F7F7F),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets
                                    .symmetric(
                                  vertical: 6.0,
                                  horizontal: 20.0,
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .center,
                                  children: [
                                    Icon(
                                      Icons
                                          .check_circle_outline,
                                      color: Color(
                                          0xFF81D3F8),
                                      size: 14.0,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      'Login each day and respond to questions.',
                                      style:
                                      TextStyle(
                                        color: Color(
                                            0xFF333333),
                                        fontSize:
                                        12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets
                                    .symmetric(
                                  vertical: 6.0,
                                  horizontal: 20.0,
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .center,
                                  children: [
                                    Icon(
                                      Icons
                                          .check_circle_outline,
                                      color: Color(
                                          0xFF81D3F8),
                                      size: 14.0,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      'Comment on other posts. ',
                                      style:
                                      TextStyle(
                                        color: Color(
                                            0xFF333333),
                                        fontSize:
                                        12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets
                                    .symmetric(
                                  vertical: 6.0,
                                  horizontal: 20.0,
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .center,
                                  children: [
                                    Icon(
                                      Icons
                                          .check_circle_outline,
                                      color: Color(
                                          0xFF81D3F8),
                                      size: 14.0,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      'Set up your preferred reward method.',
                                      style:
                                      TextStyle(
                                        color:
                                        PROJECT_GREEN,
                                        fontSize:
                                        12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width:
                                double.maxFinite,
                                height: 0.5,
                                color:
                                Colors.grey[200],
                              ),
                              Padding(
                                padding:
                                EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 12.0,
                                    bottom: 6.0),
                                child: Text(
                                  'Be sure to remember...',
                                  style: TextStyle(
                                    color: Color(
                                        0xFF7F7F7F),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets
                                    .symmetric(
                                  vertical: 6.0,
                                  horizontal: 20.0,
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .center,
                                  children: [
                                    Icon(
                                      Icons
                                          .check_circle_outline,
                                      color: Color(
                                          0xFF81D3F8),
                                      size: 14.0,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      'All posts are anonymous. Your personal info is confidential.',
                                      style:
                                      TextStyle(
                                        color: Color(
                                            0xFF333333),
                                        fontSize:
                                        12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets
                                    .symmetric(
                                  vertical: 6.0,
                                  horizontal: 20.0,
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .center,
                                  children: [
                                    Icon(
                                      Icons
                                          .check_circle_outline,
                                      color: Color(
                                          0xFF81D3F8),
                                      size: 14.0,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      'Be open and honest with your answers.',
                                      style:
                                      TextStyle(
                                        color: Color(
                                            0xFF333333),
                                        fontSize:
                                        12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets
                                    .symmetric(
                                  vertical: 6.0,
                                  horizontal: 20.0,
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .center,
                                  children: [
                                    Icon(
                                      Icons
                                          .check_circle_outline,
                                      color: Color(
                                          0xFF81D3F8),
                                      size: 14.0,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      'Have fun!',
                                      style:
                                      TextStyle(
                                        color: Color(
                                            0xFF333333),
                                        fontSize:
                                        12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width:
                                double.maxFinite,
                                height: 0.5,
                                color:
                                Colors.grey[200],
                              ),
                              Padding(
                                padding: EdgeInsets
                                    .symmetric(
                                  vertical: 40.0,
                                  horizontal: 20.0,
                                ),
                                child:
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(
                                        context)
                                        .pop();
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                            'Contact Us ',
                                            style:
                                            TextStyle(
                                              color:
                                              PROJECT_GREEN,
                                              fontSize:
                                              13.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                            'for any additional questions or concerns',
                                            style:
                                            TextStyle(
                                              color: Color(
                                                  0xFF333333),
                                              fontSize:
                                              13.0,
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
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
              //Navigator.of(context).pushNamed(PARTICIPANT_RESPONSES_SCREEN);
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

  Drawer buildPhoneEndDrawer() {
    return Drawer(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Color(0xFF333333),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  'Study Navigator',
                  style: TextStyle(
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.close,
                    color: Colors.transparent,
                  ),
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
            child: FutureBuilder(
              future: _futureStudyNavigatorTopics,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return Center(
                      child: Text('Loading Topics...'),
                    );
                    break;
                  case ConnectionState.done:
                    if (_studyNavigatorTopics != null) {
                      return ListView.builder(
                        itemCount: _studyNavigatorTopics.length,
                        itemBuilder: (BuildContext context, int index) {
                          return EndDrawerExpansionTile(
                            title: _studyNavigatorTopics[index].topicName,
                            questions: _studyNavigatorTopics[index].questions,

                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text('Some error occurred'),
                      );
                    }
                    break;
                  default:
                    return SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Drawer buildPhoneDrawer() {
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
                    _participant.userGroupName ?? 'Unassigned',
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
                ),
                DrawerTile(
                  image:
                      'images/dashboard_icons/notifications_outline_black.png',
                  title: 'Notifications',
                  onTap: () =>
                      Navigator.of(context).pushNamed(NOTIFICATIONS_SCREEN),
                ),
                DrawerTile(
                  image: 'images/dashboard_icons/rewards.png',
                  title: 'Rewards',
                  width: 22.5,
                  onTap: () => Navigator.of(context)
                      .pushNamed(POST_STUDY_REWARD_METHODS_SCREEN),
                ),
                DrawerTile(
                  image: 'images/dashboard_icons/contact_us.png',
                  title: 'Contact Us',
                  onTap: () =>
                      Navigator.of(context).pushNamed(CONTACT_US_SCREEN),
                ),
                DrawerTile(
                  image: 'images/dashboard_icons/preferences.png',
                  title: 'Preferences',
                  onTap: () =>
                      Navigator.of(context).pushNamed(USER_PREFERENCES_SCREEN),
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
                  onTap: () =>
                      Navigator.of(context).pushNamed(USER_DETAILS_SCREEN),
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
                    child: Text(
                      'Settings and Privacy',
                      style: TextStyle(
                        color: TEXT_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.only(left: 20.0, top: 10.0, bottom: 20.0),
                    child: Text(
                      'Help Center',
                      style: TextStyle(
                        color: TEXT_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                GestureDetector(
                  child: Container(
                    color: Color(0xFFF3F3F3),
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text(
                          'Log Out',
                          style: TextStyle(
                            color: TEXT_COLOR.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Icon(
                          Icons.exit_to_app,
                          color: Color(0xFF333333).withOpacity(0.7),
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

  AppBar buildPhoneAppBar() {
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
}

class _DesktopNotificationWidget extends StatelessWidget {
  final Timestamp timestamp;
  final String participantAvatar;
  final String participantDisplayName;
  final String questionNumber;
  final String questionTitle;

  const _DesktopNotificationWidget({
    Key key,
    //this.time,
    this.participantAvatar,
    this.participantDisplayName,
    this.questionNumber,
    this.questionTitle,
    this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var date =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);

    var dateFormat = DateFormat(DateFormat.HOUR_MINUTE);

    var time = dateFormat.format(date);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
      child: Row(
        children: [
          Text(
            '$time',
            style: TextStyle(
              color: TEXT_COLOR.withOpacity(0.6),
              fontSize: 13.0,
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          CachedNetworkImage(
            imageUrl: participantAvatar,
            imageBuilder: (context, imageProvider) {
              return Container(
                padding: EdgeInsets.all(8.0),
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
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  text: TextSpan(
                    style: TextStyle(
                        color: TEXT_COLOR.withOpacity(0.7), fontSize: 13.0),
                    children: [
                      TextSpan(
                          text:
                              '$participantDisplayName responded to the question '),
                      TextSpan(
                        text: '$questionNumber $questionTitle.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownMenuOptionsRow extends StatelessWidget {
  const _DropdownMenuOptionsRow({
    Key key,
    this.image1,
    this.image2,
    this.label1,
    this.label2,
    this.onTap1,
    this.onTap2,
  }) : super(key: key);

  final String image1;
  final String image2;
  final String label1;
  final String label2;
  final Function onTap1;
  final Function onTap2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap1,
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            width: 200.0,
            padding: EdgeInsets.only(
                left: 20.0, top: 10.0, bottom: 10.0, right: 20.0),
            child: Row(
              children: [
                Image(
                  width: 20.0,
                  image: AssetImage(
                    image1,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  label1,
                  style: TextStyle(
                    color: TEXT_COLOR,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap2 ?? () {},
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            width: 200.0,
            padding: EdgeInsets.only(
                left: 20.0, top: 10.0, bottom: 10.0, right: 20.0),
            child: Row(
              children: [
                image2 == null
                    ? SizedBox()
                    : Image(
                        width: 20.0,
                        image: AssetImage(
                          image2,
                        ),
                      ),
                SizedBox(
                  width: 10.0,
                ),
                label2 == null
                    ? SizedBox()
                    : Text(
                        label2,
                        style: TextStyle(
                          color: TEXT_COLOR,
                          fontSize: 14.0,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
