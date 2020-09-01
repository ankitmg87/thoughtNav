import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (size.width < size.height)
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
            margin: EdgeInsets.only(top: 5.0,),
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
                      onTap: () => Navigator.of(context).pushNamed(TELL_US_YOUR_STORY_SCREEN),
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
                  image: 'images/dashboard_icons/notifications_outline_black.png',
                  title: 'Notifications',
                  onTap: () => Navigator.of(context).pushNamed(NOTIFICATIONS_SCREEN),
                ),
                DrawerTile(
                  image: 'images/dashboard_icons/rewards.png',
                  title: 'Rewards',
                  width: 22.5,
                  onTap: () => Navigator.of(context).pushNamed(POST_STUDY_REWARD_METHODS_SCREEN),
                ),
                DrawerTile(
                  image: 'images/dashboard_icons/contact_us.png',
                  title: 'Contact Us',
                  onTap: () => Navigator.of(context).pushNamed(CONTACT_US_SCREEN),
                ),
                DrawerTile(
                  image: 'images/dashboard_icons/preferences.png',
                  title: 'Preferences',
                  onTap: () => Navigator.of(context).pushNamed(USER_PREFERENCES_SCREEN),
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
                  onTap: () => Navigator.of(context).pushNamed(USER_DETAILS_SCREEN),
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
                    child: Text(
                      'Settings and Privacy',
                      style: TextStyle(color: TEXT_COLOR, fontWeight: FontWeight.bold,),
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
                      style: TextStyle(color: TEXT_COLOR, fontWeight: FontWeight.bold,),
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
                          Icons.logout,
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

  AppBar buildDesktopAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        'Desktop',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      leading: Container(
        decoration: BoxDecoration(
          color: Color(0xFFB6ECC7),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}


