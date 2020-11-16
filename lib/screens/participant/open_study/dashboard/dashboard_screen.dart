import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/constants/string_constants.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

import 'dashboard_widgets/active_task_widget.dart';
import 'dashboard_widgets/dashboard_top_container.dart';
import 'dashboard_widgets/drawer_tile.dart';
import 'dashboard_widgets/locked_task_widget.dart';
import 'dashboard_widgets/end_drawer_expansion_tile.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _dashboardScaffoldKey =
      GlobalKey<ScaffoldState>();

  final _firebaseFireStoreService = FirebaseFirestoreService();

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
  List<Topic> _topics;

  Future<void> _futureStudy;
  Future<void> _futureTopics;

  Stream _notificationsStream;

  Future<void> _getFutureStudy() async {
    await _getFutureParticipant();
    _study = await _firebaseFireStoreService.getStudy(_studyUID);
  }

  Future<void> _getFutureParticipant() async {
    _participant = await _firebaseFireStoreService.getParticipant(
        _studyUID, _participantUID);
  }

  Future<void> _getFutureTopics() async {
    _topics = await _firebaseFireStoreService.getTopics(_studyUID);
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
    _futureTopics = _getFutureTopics();

    _getNotifications();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    if (screenSize.width < screenSize.height) {
      return Scaffold(
        key: _dashboardScaffoldKey,
        appBar: buildPhoneAppBar(),
        drawer: buildPhoneDrawer(),
        endDrawer: buildPhoneEndDrawer(),
        body: Column(
          children: [
            DashboardTopContainer(
              scaffoldKey: _dashboardScaffoldKey,
            ),
            Expanded(
              child: FutureBuilder(
                future: _futureTopics,
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
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
    } else {
      return _buildDesktopDashboardFutureBuilder();
    }
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
                appBar: buildDesktopAppBar(),
                body: buildDesktopBody(screenSize, context));
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

  Stack buildDesktopBody(Size screenSize, BuildContext context) {
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
                          Row(
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
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            width: screenSize.width * 0.5,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    color: Colors.white.withOpacity(0.6),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 0.5),
                                    height: 10.0,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    color: Colors.white.withOpacity(0.6),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 0.5),
                                    height: 10.0,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    color: Colors.white.withOpacity(0.6),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 0.5),
                                    height: 10.0,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    color: Colors.white.withOpacity(0.6),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 0.5),
                                    height: 10.0,
                                  ),
                                ),
                              ],
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
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 20.0,
                                horizontal: 10.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Study Activity',
                                    style: TextStyle(
                                        color: TEXT_COLOR.withOpacity(0.7),
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 20.0, bottom: 20.0),
                                    height: 1.0,
                                    color: TEXT_COLOR.withOpacity(0.2),
                                  ),
                                  Expanded(
                                    child: StreamBuilder(
                                      stream: _notificationsStream,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
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
                                              var notifications =
                                                  snapshot.data.documents;

                                              return ListView.separated(
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return _DesktopNotificationWidget(
                                                    time: notifications[index]
                                                        ['time'],
                                                    participantAvatar:
                                                        notifications[index][
                                                            'participantAvatar'],
                                                    participantAlias:
                                                        notifications[index][
                                                            'participantAlias'],
                                                    questionNumber:
                                                        notifications[index]
                                                            ['questionNumber'],
                                                    questionTitle:
                                                        notifications[index]
                                                            ['questionTitle'],
                                                  );
                                                },
                                                separatorBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return SizedBox(
                                                    height: 10.0,
                                                  );
                                                },
                                                itemCount: notifications.length,
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
                                    ),
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
                      future: _futureTopics,
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
                            if (_topics != null) {
                              return ListView.builder(
                                itemCount: _topics.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return EndDrawerExpansionTile(
                                    title: _topics[index].topicName,
                                    questions: _topics[index].questions,
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
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: PROJECT_LIGHT_GREEN,
                            ),
                            child: Center(
                              child: Image(
                                width: 30.0,
                                image: AssetImage('images/avatars/batman.png'),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sarah Baker',
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
                                '@batman-0416',
                                style: TextStyle(
                                  color: TEXT_COLOR.withOpacity(0.7),
                                  fontSize: 13.0,
                                ),
                              ),
                              SizedBox(
                                height: 6.0,
                              ),
                              Text(
                                'Group 2 - PWC User',
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
                      image2: 'images/dashboard_icons/dashboard.png',
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

  AppBar buildDesktopAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        APP_NAME,
        style: TextStyle(
          color: TEXT_COLOR,
        ),
      ),
      actions: [
        Center(
          child: Text(
            'Hello ${_participant.userName}',
            style: TextStyle(
              color: TEXT_COLOR.withOpacity(0.7),
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              dropDownOpened = !dropDownOpened;
            });
          },
          child: CachedNetworkImage(
            imageUrl: _participant.profilePhotoURL,
            imageBuilder: (context, imageProvider){
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
              Navigator.of(context).pushNamed(PARTICIPANT_RESPONSES_SCREEN);
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
              future: _futureTopics,
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
                    if (_topics != null) {
                      return ListView.builder(
                        itemCount: _topics.length,
                        itemBuilder: (BuildContext context, int index) {
                          return EndDrawerExpansionTile(
                            title: _topics[index].topicName,
                            questions: _topics[index].questions,
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
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Color(0xFFB6ECC7),
                  child: Image(
                    width: 40.0,
                    image: AssetImage(
                      'images/avatars/batman.png',
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sarah Baker',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '@batman_789',
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Color(0xFF666666),
                    ),
                  ),
                  Text(
                    'Group 2 - Smartphone users',
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Continue Study - Question 1.2',
                  style: TextStyle(
                    color: PROJECT_GREEN,
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Icon(
                  Icons.arrow_forward,
                  color: PROJECT_GREEN,
                  size: 12.0,
                ),
              ],
            ),
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
                  image: 'images/dashboard_icons/dashboard.png',
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
        child: Container(
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Color(0xFFB6ECC7),
            shape: BoxShape.circle,
          ),
          child: Image(
            image: AssetImage('images/avatars/batman.png'),
          ),
        ),
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
  final String time;
  final String participantAvatar;
  final String participantAlias;
  final String questionNumber;
  final String questionTitle;

  const _DesktopNotificationWidget({
    Key key,
    this.time,
    this.participantAvatar,
    this.participantAlias,
    this.questionNumber,
    this.questionTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
      child: Row(
        children: [
          Text(
            time,
            style: TextStyle(
              color: TEXT_COLOR.withOpacity(0.6),
              fontSize: 13.0,
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: PROJECT_LIGHT_GREEN,
            ),
            child: Image(
              width: 20.0,
              image: AssetImage(
                participantAvatar,
              ),
            ),
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  text: TextSpan(
                    style: TextStyle(
                        color: TEXT_COLOR.withOpacity(0.7), fontSize: 13.0),
                    children: [
                      TextSpan(
                          text: '$participantAlias responded to the question '),
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
