import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/screens/researcher/widgets/topic_widget.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

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
  final _researcherAndModeratorFirestoreService =
      ResearcherAndModeratorFirestoreService();

  Study _study;

  Stream<QuerySnapshot> _insightNotificationsStream;

  Stream<QuerySnapshot> _activeParticipantsStream;
  Stream<QuerySnapshot> _allParticipantsStream;

  Future<Study> _futureStudy;

  Future<List<Topic>> _futureTopics;

  Stream<QuerySnapshot> _getInsightNotificationsStream(String studyUID) {
    return _researcherAndModeratorFirestoreService
        .streamInsightNotifications(studyUID);
  }

  void _getTopics() {
    _futureTopics =
        _researcherAndModeratorFirestoreService.getTopics(widget.studyUID);
  }

  Future<Study> _getFutureStudy(String studyUID) async {
    _study = await _researcherAndModeratorFirestoreService.getStudy(studyUID);
    return _study;
  }

  @override
  void initState() {
    _futureStudy = _getFutureStudy(widget.studyUID);

    super.initState();

    _insightNotificationsStream =
        _getInsightNotificationsStream(widget.studyUID);

    _getTopics();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return FutureBuilder<Study>(
      future: _futureStudy,
      builder: (BuildContext context, AsyncSnapshot<Study> snapshot) {
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
            return Expanded(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StudyDetailsBar(
                      studyName: _study.studyName,
                      studyStatus: _study.studyStatus,
                      studyUID: _study.studyUID,
                      startDate: _study.startDate,
                      endDate: _study.endDate,
                      totalResponses: _study.totalResponses,
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
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return TopicWidget(
                                              studyUID: widget.studyUID,
                                              topic: snapshot.data[index],
                                              firebaseFirestoreService: widget
                                                  .firebaseFirestoreService,
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
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
                                    'Insights',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Divider(),
                                  Expanded(
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: _insightNotificationsStream,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
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
                                              var insightNotifications =
                                                  snapshot.data.docs;
                                              if (insightNotifications
                                                  .isNotEmpty) {
                                                return ListView.separated(
                                                  itemCount:
                                                      insightNotifications
                                                          .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Text(
                                                        '${insightNotifications[index].data()['moderatorName']}');
                                                  },
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return SizedBox(
                                                      height: 10.0,
                                                    );
                                                  },
                                                );
                                              }
                                              else {
                                                return Center(
                                                  child: Text(
                                                    'No insights yet.'
                                                  ),
                                                );
                                              }
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
            break;
          default:
            return SizedBox();
        }
      },
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

class _StudyDetailsBar extends StatefulWidget {
  final String studyUID;
  final String studyName;
  final String studyStatus;
  final int totalResponses;
  final String startDate;
  final String endDate;

  const _StudyDetailsBar({
    Key key,
    this.studyName,
    this.studyStatus,
    this.totalResponses,
    this.startDate,
    this.endDate,
    this.studyUID,
  }) : super(key: key);

  @override
  __StudyDetailsBarState createState() => __StudyDetailsBarState();
}

class __StudyDetailsBarState extends State<_StudyDetailsBar> {
  final _researcherAndModeratorFirestoreService =
      ResearcherAndModeratorFirestoreService();

  int _activeParticipants = 0;
  int _allParticipants = 1;

  Stream<QuerySnapshot> _activeParticipantsStream;
  Stream<QuerySnapshot> _allParticipantsStream;

  Stream<QuerySnapshot> _getActiveParticipantsAsStream(String studyUID) {
    return _researcherAndModeratorFirestoreService
        .getActiveParticipantsInStudy(studyUID);
  }

  Stream<QuerySnapshot> _getAllParticipantsAsStream(String studyUID) {
    return _researcherAndModeratorFirestoreService
        .getAllParticipantsInStudy(studyUID);
  }

  @override
  void initState() {
    _activeParticipantsStream = _getActiveParticipantsAsStream(widget.studyUID);
    _allParticipantsStream = _getAllParticipantsAsStream(widget.studyUID);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      widget.studyName,
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
                      '(${widget.studyStatus})',
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
                StreamBuilder<QuerySnapshot>(
                  stream: _allParticipantsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> allParticipantsSnapshot) {
                    switch (allParticipantsSnapshot.connectionState) {
                      case ConnectionState.none:
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '0 % active participants',
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
                                percent: _activeParticipants / _allParticipants,
                                padding: EdgeInsets.symmetric(horizontal: 0.0),
                                backgroundColor: Colors.black12,
                                progressColor: Color(0xFF437FEF),
                              ),
                            ),
                          ],
                        );
                        break;
                      case ConnectionState.waiting:
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '0 % active participants',
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
                                percent: _activeParticipants / _allParticipants,
                                padding: EdgeInsets.symmetric(horizontal: 0.0),
                                backgroundColor: Colors.black12,
                                progressColor: Color(0xFF437FEF),
                              ),
                            ),
                          ],
                        );
                        break;
                      case ConnectionState.active:
                        if (allParticipantsSnapshot.hasData) {
                          if (allParticipantsSnapshot.data.docs.isNotEmpty) {
                            _allParticipants =
                                allParticipantsSnapshot.data.docs.length;
                            return StreamBuilder<QuerySnapshot>(
                              stream: _activeParticipantsStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot>
                                      activeParticipantsSnapshot) {
                                switch (activeParticipantsSnapshot
                                    .connectionState) {
                                  case ConnectionState.none:
                                    return SizedBox();
                                    break;
                                  case ConnectionState.waiting:
                                    return SizedBox();
                                    break;
                                  case ConnectionState.active:
                                    if (activeParticipantsSnapshot.hasData) {
                                      if (activeParticipantsSnapshot
                                          .data.docs.isNotEmpty) {
                                        _activeParticipants =
                                            activeParticipantsSnapshot
                                                .data.docs.length;
                                        var percent = (_activeParticipants /
                                                _allParticipants) *
                                            100;
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${percent.ceil()} % active participants',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              child: LinearPercentIndicator(
                                                lineHeight: 30.0,
                                                percent: _activeParticipants /
                                                    _allParticipants,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 0.0),
                                                backgroundColor: Colors.black12,
                                                progressColor:
                                                    Color(0xFF437FEF),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '0 % active participants',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              child: LinearPercentIndicator(
                                                lineHeight: 30.0,
                                                percent: _activeParticipants /
                                                    _allParticipants,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 0.0),
                                                backgroundColor: Colors.black12,
                                                progressColor:
                                                    Color(0xFF437FEF),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    } else {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'No % active participants',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: LinearPercentIndicator(
                                              lineHeight: 30.0,
                                              percent: _activeParticipants /
                                                  _allParticipants,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 0.0),
                                              backgroundColor: Colors.black12,
                                              progressColor: Color(0xFF437FEF),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    break;
                                  case ConnectionState.done:
                                    return SizedBox();
                                    break;
                                  default:
                                    return SizedBox();
                                }
                              },
                            );
                          } else {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '0 % active participants',
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
                                    percent:
                                        _activeParticipants / _allParticipants,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 0.0),
                                    backgroundColor: Colors.black12,
                                    progressColor: Color(0xFF437FEF),
                                  ),
                                ),
                              ],
                            );
                          }
                        } else {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '0 % active participants',
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
                                  percent:
                                      _activeParticipants / _allParticipants,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                  backgroundColor: Colors.black12,
                                  progressColor: Color(0xFF437FEF),
                                ),
                              ),
                            ],
                          );
                        }
                        break;
                      case ConnectionState.done:
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '0 % active participants',
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
                                percent: _activeParticipants / _allParticipants,
                                padding: EdgeInsets.symmetric(horizontal: 0.0),
                                backgroundColor: Colors.black12,
                                progressColor: Color(0xFF437FEF),
                              ),
                            ),
                          ],
                        );
                        break;
                      default:
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '0 % active participants',
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
                                percent: _activeParticipants / _allParticipants,
                                padding: EdgeInsets.symmetric(horizontal: 0.0),
                                backgroundColor: Colors.black12,
                                progressColor: Color(0xFF437FEF),
                              ),
                            ),
                          ],
                        );
                    }
                  },
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
                      'Total Responses',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.totalResponses}',
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
                      widget.startDate,
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
                      widget.endDate,
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
