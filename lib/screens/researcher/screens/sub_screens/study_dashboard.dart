import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/screens/researcher/widgets/topic_widget.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class StudyDashboard extends StatefulWidget {
  final String studyUID;
  final FirebaseFirestoreService firebaseFirestoreService;

  const StudyDashboard(
      {Key key,
      @required this.studyUID,
      @required this.firebaseFirestoreService})
      : super(key: key);

  @override
  _StudyDashboardState createState() => _StudyDashboardState();
}

class _StudyDashboardState extends State<StudyDashboard> {
  Study study;

  Stream _studyStream;
  Stream _notificationsStream;

  Future<List<Topic>> _futureTopics;

  void _getStudyAsStream() {
    _studyStream =
        widget.firebaseFirestoreService.getStudyAsStream(widget.studyUID);
  }

  void _getNotifications() {
    _notificationsStream =
        widget.firebaseFirestoreService.getNotifications(widget.studyUID);
  }

  void _getTopics() {
    _futureTopics = widget.firebaseFirestoreService.getTopics(widget.studyUID);
  }

  @override
  void initState() {
    super.initState();
    _getStudyAsStream();
    _getNotifications();
    _getTopics();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Expanded(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder(
              stream: _studyStream,
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
                      return _StudyDetailsBar(
                        studyName: snapshot.data['studyName'],
                        studyStatus: snapshot.data['studyStatus'],
                        activeParticipants: snapshot.data['activeParticipants'],
                        totalResponses: snapshot.data['totalResponses'],
                        startDate: snapshot.data['startDate'],
                        endDate: snapshot.data['endDate'],
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
                    return _StudyDetailsBar();
                    break;
                  default:
                    return SizedBox();
                }
              },
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                    left: 30.0, right: 30.0, top: 20.0, bottom: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: FutureBuilder(
                        future: _futureTopics,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Topic>> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return SizedBox();
                              break;
                            case ConnectionState.waiting:
                              return SizedBox();
                              break;
                            case ConnectionState.active:
                              return SizedBox();
                              break;
                            case ConnectionState.done:
                              if (snapshot.hasData) {
                                return ListView.separated(
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return TopicWidget(
                                      studyUID: widget.studyUID,
                                      topic: snapshot.data[index],
                                      firebaseFirestoreService: widget.firebaseFirestoreService,
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      height: 20.0,
                                    );
                                  },
                                );
                              } else {
                                return SizedBox();
                              }
                              break;
                            default:
                              return SizedBox();
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    Container(
                      height: double.maxFinite,
                      width: screenSize.width * 0.35,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Study Activity',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(),
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
                                            (BuildContext context, int index) {
                                          return _DesktopNotificationWidget(
                                            time: notifications[index]['time'],
                                            participantAvatar:
                                                notifications[index]
                                                    ['participantAvatar'],
                                            participantAlias:
                                                notifications[index]
                                                    ['participantAlias'],
                                            questionNumber: notifications[index]
                                                ['questionNumber'],
                                            questionTitle: notifications[index]
                                                ['questionTitle'],
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
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
                                    return _StudyDetailsBar();
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
                  ],
                ),
              ),
            ),
          ],
        ),
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

class _StudyDetailsBar extends StatelessWidget {
  final String studyName;
  final String studyStatus;
  final int activeParticipants;
  final int currentActiveParticipants;
  final int totalResponses;
  final String startDate;
  final String endDate;

  const _StudyDetailsBar(
      {Key key,
      this.studyName,
      this.studyStatus,
      this.activeParticipants,
      this.currentActiveParticipants,
      this.totalResponses,
      this.startDate,
      this.endDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var percentInt = activeParticipants;
    var percentDouble = percentInt / 100;

    return Container(
      padding: EdgeInsets.all(20.0),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      studyName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      '($studyStatus)',
                      style: TextStyle(
                        color: PROJECT_GREEN,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$activeParticipants% Active participants',
                      style: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontSize: 12.0,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: LinearPercentIndicator(
                        lineHeight: 30.0,
                        percent: percentDouble,
                        padding: EdgeInsets.symmetric(horizontal: 0.0),
                        backgroundColor: Colors.grey[300],
                        progressColor: Color(0xFF437FEF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 140.0,
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 400.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current Active',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '0',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Responses',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$totalResponses',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Start Date',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      startDate,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'End Date',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      endDate,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
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
}
