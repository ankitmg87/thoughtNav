// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines the study dashboard screen.
/// This screen is shown to the moderators when a study is active, completed or closed.
/// Moderators are able to view basic details of the study on this screen

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/researcher/models/insight.dart';
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

  Future<Study> _futureStudy;

  Future<List<Topic>> _futureTopics;

  Stream<QuerySnapshot> _insightsStream;

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

  void _viewResponses(String topicUID, String questionUID) {
    Navigator.of(context)
        .pushNamed(CLIENT_MODERATOR_RESPONSES_SCREEN, arguments: {
      'questionUID': questionUID,
      'topicUID': topicUID,
    });
  }

  @override
  void initState() {
    _futureStudy = _getFutureStudy(widget.studyUID);

    super.initState();

    _insightsStream = _getInsightNotificationsStream(widget.studyUID);

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
                                      color: Colors.grey[700],
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    height: 1.0,
                                    color: Colors.grey[300],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Expanded(
                                    child:
                                    _buildInsightNotificationsStreamBuilder(
                                        _insightsStream),
                                  ),
                                  // Divider(),
                                  // Expanded(
                                  //   child: StreamBuilder<QuerySnapshot>(
                                  //     stream: _insightNotificationsStream,
                                  //     builder: (BuildContext context,
                                  //         AsyncSnapshot<QuerySnapshot>
                                  //             snapshot) {
                                  //       switch (snapshot.connectionState) {
                                  //         case ConnectionState.none:
                                  //           if (snapshot.hasError) {
                                  //             print(snapshot.error);
                                  //           }
                                  //           return SizedBox();
                                  //           break;
                                  //         case ConnectionState.waiting:
                                  //         case ConnectionState.active:
                                  //           if (snapshot.hasData) {
                                  //             var insightNotifications =
                                  //                 snapshot.data.docs;
                                  //             if (insightNotifications
                                  //                 .isNotEmpty) {
                                  //               return ListView.separated(
                                  //                 itemCount:
                                  //                     insightNotifications
                                  //                         .length,
                                  //                 itemBuilder:
                                  //                     (BuildContext context,
                                  //                         int index) {
                                  //                   return Text(
                                  //                       '${insightNotifications[index].data()['moderatorName']}');
                                  //                 },
                                  //                 separatorBuilder:
                                  //                     (BuildContext context,
                                  //                         int index) {
                                  //                   return SizedBox(
                                  //                     height: 10.0,
                                  //                   );
                                  //                 },
                                  //               );
                                  //             }
                                  //             else {
                                  //               return Center(
                                  //                 child: Text(
                                  //                   'No insights yet.'
                                  //                 ),
                                  //               );
                                  //             }
                                  //           } else {
                                  //             return SizedBox(
                                  //               child: Text('Loading...'),
                                  //             );
                                  //           }
                                  //           break;
                                  //         case ConnectionState.done:
                                  //           if (snapshot.hasError) {
                                  //             print(snapshot.error);
                                  //           }
                                  //           return SizedBox();
                                  //           break;
                                  //         default:
                                  //           if (snapshot.hasError) {
                                  //             print(snapshot.error);
                                  //           }
                                  //           return SizedBox();
                                  //       }
                                  //     },
                                  //   ),
                                  // ),
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

  StreamBuilder<QuerySnapshot> _buildInsightNotificationsStreamBuilder(
      Stream<QuerySnapshot> insightNotificationsStream) {
    return StreamBuilder(
      stream: insightNotificationsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Text('Loading...'),
            );
            break;
          case ConnectionState.active:
            if (snapshot.hasData) {
              if (snapshot.data.docs.isNotEmpty) {
                var insights = <Insight>[];

                for (var insightSnapshot in snapshot.data.docs) {
                  var insight = Insight.fromMap(insightSnapshot.data());
                  insights.add(insight);
                }

                return ListView.separated(
                  itemCount: insights.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: (){
                        _viewResponses(insights[index].topicUID, insights[index].questionUID);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            insights[index].avatarURL != null && insights[index].avatarURL != 'null'
                                ? CachedNetworkImage(
                              imageUrl: insights[index].avatarURL,
                              imageBuilder: (context, provider) {
                                return Container(
                                  width: 30.0,
                                  height: 30.0,
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: PROJECT_LIGHT_GREEN,
                                  ),
                                  child: Image(
                                    image: provider,
                                  ),
                                );
                              },
                            )
                                : Container(
                              width: 30.0,
                              height: 30.0,
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: PROJECT_LIGHT_GREEN,
                              ),
                              child: Image(
                                image: AssetImage(
                                  'images/researcher_images/researcher_dashboard/participant_icon.png',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: insights[index].name ?? 'Mike Courtney',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' gained a new insight in ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${insights[index].questionNumber} ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${insights[index].questionTitle}.',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox();
                  },
                );
              } else {
                return Center(
                  child: Text('No insights yet'),
                );
              }
            } else {
              return SizedBox();
            }
            break;
          case ConnectionState.done:
            return Center(
              child: Text(
                'Something went wrong',
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
