import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {

  final _firebaseFirestoreService = FirebaseFirestoreService();

  TabController _tabController;

  String _studyUID;

  @override
  void initState() {

    var getStorage = GetStorage();

    _studyUID = getStorage.read('studyUID');

    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    _getNotifications();
  }

  Stream _notificationsStream;

  void _getNotifications() {
    _notificationsStream =
        _firebaseFirestoreService.getNotifications(_studyUID);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

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
    return StreamBuilder(
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
            Icons.settings,
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
