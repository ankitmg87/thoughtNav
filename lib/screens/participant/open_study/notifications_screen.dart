import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildPhoneAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildPhoneBody(screenSize),
          buildPhoneBody(screenSize),
        ],
      ),
    );
  }

  Widget buildPhoneBody(Size screenSize) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Card(
            elevation: 6.0,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          backgroundImage:
                              AssetImage('images/avatars/batman.png'),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Tim Johnson posted a new follow up question',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            AutoSizeText(
                              'Hey Batman, I thought your comment was really interesting. It got me thinking about a Hey Batman, I thought your comment was really interesting. It got me thinking about a Hey Batman, I thought your comment was really interesting. It got me thinking about a',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              minFontSize: 12.0,
                              maxFontSize: 12.0,
                              maxLines: 2,
                              overflowReplacement: GestureDetector(
                                onTap: () => print('See more'),
                                child: Container(
                                  width: 20.0,
                                  height: 20.0,
                                  color: Colors.black,
                                  child: Text(
                                    'see more',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: screenSize.height * 0.2,
                    color: Colors.grey[200],
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: PROJECT_GREEN,
                        ),
                        child: Text(
                          '?',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  AppBar buildPhoneAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Color(0xFF555555),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings_outlined,
            color: PROJECT_GREEN,
          ),
          onPressed: () {},
        )
      ],
      bottom: TabBar(
        controller: _tabController,
        labelColor: Colors.black,
        tabs: [
          Tab(
            text: 'Activity',
          ),
          Tab(
            text: 'Announcements',
          ),
        ],
      ),
    );
  }
}
