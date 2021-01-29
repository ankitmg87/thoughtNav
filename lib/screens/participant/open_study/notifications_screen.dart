import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/participant/open_study/dashboard/dashboard_widgets/new_question_notification_widget.dart';
import 'package:thoughtnav/screens/researcher/models/notification.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/services/participant_firestore_service.dart';

import 'dashboard/dashboard_widgets/clap_notification_widget.dart';
import 'dashboard/dashboard_widgets/comment_notification_widget.dart';
import 'dashboard/dashboard_widgets/moderator_comment_notification_widget.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  final _participantFirestoreService = ParticipantFirestoreService();

  String _studyUID;
  String _participantUID;

  Future<Participant> _futureParticipant;
  Stream<QuerySnapshot> _notificationsStream;

  Future<Participant> _getParticipant(String studyUID, String participantUID) async {
    return _participantFirestoreService.getParticipant(
        studyUID, participantUID);
  }

  Stream<QuerySnapshot> _getNotificationsStream(String studyUID, String participantUID) {
    return _participantFirestoreService
        .getParticipantNotifications(studyUID, participantUID);
  }

  @override
  void initState() {
    var getStorage = GetStorage();

    _studyUID = getStorage.read('studyUID');
    _participantUID = getStorage.read('participantUID');

    _futureParticipant = _getParticipant(_studyUID, _participantUID);
    _notificationsStream = _getNotificationsStream(_studyUID, _participantUID);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN);
        return;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildPhoneAppBar(),
        body: buildPhoneBody(screenSize),
      ),
    );
  }

  Widget buildPhoneBody(Size screenSize) {
    return FutureBuilder<Participant>(
      future: _futureParticipant,
      builder: (BuildContext context, AsyncSnapshot<Participant> participant) {
        switch(participant.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: Text(
                'Loading...'
              ),
            );
            break;
          case ConnectionState.done:
            return StreamBuilder<QuerySnapshot>(
              stream: _notificationsStream,
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

                      return ListView.separated(
                        padding: EdgeInsets.all(20.0),
                        itemBuilder: (BuildContext context, int index) {
                          switch (notifications[index]['notificationType']) {
                            case 'clap':
                              var clapNotification = ClapNotification.fromMap(
                                  notifications[index].data());

                              return ClapNotificationWidget(
                                clapNotification: clapNotification,
                                participantDisplayName: participant.data.displayName,
                              );
                              break;

                            case 'comment':
                              var commentNotification = CommentNotification.fromMap(
                                  notifications[index].data());

                              return CommentNotificationWidget(
                                commentNotification: commentNotification,
                                participantDisplayName: participant.data.displayName,
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
                              var newQuestionNotification =
                              NewQuestionNotification.fromMap(notifications[index].data());

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
            break;
          default:
            return Center(
              child: Text(
                  'Loading...'
              ),
            );
        }
      },
    );
  }

  AppBar buildPhoneAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        'Notifications',
        style: TextStyle(
          color: Colors.black
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Color(0xFF555555),
        ),
        onPressed: () => Navigator.of(context).popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN),
      ),
    );
  }
}