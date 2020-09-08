import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/constants/string_constants.dart';

import 'dashboard_widgets/active_task_widget.dart';
import 'dashboard_widgets/dashboard_top_container.dart';
import 'dashboard_widgets/drawer_tile.dart';
import 'dashboard_widgets/end_drawer_expansion_tile_child.dart';
import 'dashboard_widgets/locked_task_widget.dart';
import 'dashboard_widgets/end_drawer_expansion_tile.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _dashboardScaffoldKey =
      GlobalKey<ScaffoldState>();

  double value = 50.0;
  double initialWidth = 50.0;
  double finalWidth = 300.0;
  bool isExpanded = false;

  bool dropDownOpened = false;

  bool showDrawer = false;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    if (screenSize.width < screenSize.height)
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
              child: ListView(
                shrinkWrap: true,
                children: [
                  ActiveTaskWidget(),
                  LockedTaskWidget(),
                  LockedTaskWidget(),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      );
    else
      return Scaffold(
        appBar: buildDesktopAppBar(),
        body: buildDesktopBody(screenSize, context),
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
                            'Power Wheelchair Study',
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
                              width: screenSize.width * 0.6,
                              child: ListView(
                                children: [
                                  ActiveTaskWidget(),
                                  LockedTaskWidget(),
                                  LockedTaskWidget(),
                                  LockedTaskWidget(),
                                  LockedTaskWidget(),
                                ],
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
                                    child: ListView(
                                      children: [
                                        _DesktopNotificationWidget(),
                                        _DesktopNotificationWidget(),
                                        _DesktopNotificationWidget(),
                                        _DesktopNotificationWidget(),
                                        _DesktopNotificationWidget(),
                                        _DesktopNotificationWidget(),
                                        _DesktopNotificationWidget(),
                                      ],
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
                    child: showDrawer ? Text(
                      'Study Navigator',
                      maxLines: 1,
                      style: TextStyle(
                        color: TEXT_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ) : SizedBox(),
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
            showDrawer ?
            Expanded(
              child: ListView(
                children: [
                  EndDrawerExpansionTile(
                    title: 'Quick Intro',
                    children: [
                      EndDrawerExpansionTileChild(
                        label: 'Tell Us About You',
                        onTap: () => Navigator.of(context).pushNamed(TELL_US_YOUR_STORY_SCREEN),
                      )
                    ],
                  ),
                  EndDrawerExpansionTile(
                    title: 'Welcome to Day 1',
                    children: [
                      EndDrawerExpansionTileChild(
                        label: '1.1 Welcome to Day 1',
                        onTap: () {},
                      ),
                      EndDrawerExpansionTileChild(
                        label: '1.2 Getting to know you',
                        onTap: () {},
                      ),
                      EndDrawerExpansionTileChild(
                        label: '1.3 Describe your PWC',
                        onTap: () {},
                      ),
                      EndDrawerExpansionTileChild(
                        label: '1.4 Caregiver',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ) : SizedBox(),
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
            'Hello Sarah',
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
          child: Container(
            padding: EdgeInsets.all(6.0),
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: PROJECT_LIGHT_GREEN,
            ),
            child: Image(
              width: 20.0,
              image: AssetImage('images/avatars/batman.png'),
            ),
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
            child: ListView(
              shrinkWrap: true,
              children: [
                EndDrawerExpansionTile(
                  title: 'Quick Intro',
                  children: [
                    EndDrawerExpansionTileChild(
                      label: '0.1 Tell Us Your Story',
                      onTap: () => Navigator.of(context)
                          .pushNamed(TELL_US_YOUR_STORY_SCREEN),
                    ),
                  ],
                ),
                EndDrawerExpansionTile(
                  title: 'Welcome to Day One',
                  children: [
                    EndDrawerExpansionTileChild(
                      label: '1.1 Welcome to Day 1',
                      onTap: () => Navigator.of(context)
                          .pushNamed(QUESTIONS_FIRST_DAY_SCREEN),
                    ),
                  ],
                ),
              ],
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
  const _DesktopNotificationWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
      child: Row(
        children: [
          Text(
            '5:28 pm',
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
                'images/avatars/batman.png',
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
                      TextSpan(text: 'Spiderman responded to the question '),
                      TextSpan(
                        text: '1.2 Describe your Power Wheelchair.',
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
