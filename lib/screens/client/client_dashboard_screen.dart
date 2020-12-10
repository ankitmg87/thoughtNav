import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/participant/open_study/dashboard/dashboard_widgets/active_task_widget.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/services/client_firestore_service.dart';

class ClientDashboardScreen extends StatefulWidget {
  @override
  _ClientDashboardScreenState createState() => _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends State<ClientDashboardScreen> {
  final _clientFirestoreService = ClientFirestoreService();

  Study _study;

  List<Topic> _topics;

  Future<void> _futureStudy;
  Future<void> _futureTopics;

  Stream _notificationsStream;

  Future<void> _getFutureTopics(String studyUID) async {
    _topics = await _clientFirestoreService.getClientTopics(studyUID);
  }

  Future<void> _getFutureStudy(String studyUID) async {
    _study = await _clientFirestoreService.getClientStudy(studyUID);
  }

  Stream _getNotificationsStream(String studyUID) {
    return _clientFirestoreService.getClientNotifications(studyUID);
  }

  @override
  void initState() {
    _futureStudy = _getFutureStudy('kdmkid1WWQ3frXIZk51f');
    _futureTopics = _getFutureTopics('kdmkid1WWQ3frXIZk51f');
    _notificationsStream = _getNotificationsStream('kdmkid1WWQ3frXIZk51f');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (screenSize.width >= screenSize.height) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'ThoughtNav',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(
                CupertinoIcons.wrench_fill,
                color: Colors.black,
                size: 18.0,
              ),
              onPressed: (){
                Navigator.of(context).pushNamed(CLIENT_PREFERENCES_SCREEN);
              },
            ),
          ],
        ),
        body: _bodyFutureBuilder(_futureStudy),
      );
    } else {
      return Material(
        child: Center(
          child: Text(
            'Please change orientation of the device',
          ),
        ),
      );
    }
  }

  FutureBuilder _bodyFutureBuilder(Future<void> getFutureStudy) {
    return FutureBuilder(
      future: getFutureStudy,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: Text('Loading Study...'),
            );
            break;
          case ConnectionState.done:
            return Column(
              children: [
                _StudyDetailsBar(
                  studyName: 'Power Wheelchair Study',
                  studyStatus: 'Active',
                  activeParticipants: 0,
                  currentActiveParticipants: 0,
                  totalResponses: 0,
                  startDate: '20/11/2020',
                  endDate: '30/11/2020',
                ),
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: _buildTopicsFutureBuilder(_futureTopics),
                      ),
                      SizedBox(
                        width: 40.0,
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.4,
                          minWidth: MediaQuery.of(context).size.width * 0.4,
                        ),
                        child: _buildNotificationsStreamBuilder(
                            _notificationsStream),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                    ],
                  ),
                ),
              ],
            );
            break;
          default:
            return Center(
              child: Text(
                'Something went wrong. Please contact the administrator',
              ),
            );
        }
      },
    );
  }

  FutureBuilder _buildTopicsFutureBuilder(Future<void> getTopicsFuture) {
    return FutureBuilder(
      future: getTopicsFuture,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: Text(
                'Loading Topics...',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
            );
            break;
          case ConnectionState.done:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Topics',
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
                    itemCount: _topics.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _TopicWidget(topic: _topics[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 20.0,
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            );
            break;
          default:
            return Center(
              child: Text(
                  'Something went wrong. Please contact the administrator'),
            );
        }
      },
    );
  }

  StreamBuilder _buildNotificationsStreamBuilder(
      Stream getNotificationsStream) {
    return StreamBuilder(
      stream: getNotificationsStream,
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
                      itemBuilder:
                          (BuildContext context, int index) {
                        return _DesktopNotificationWidget(
                          //time: notifications[index]['time'],
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
            return _StudyDetailsBar();
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

class _TopicWidget extends StatefulWidget {
  final Topic topic;

  const _TopicWidget({Key key, this.topic}) : super(key: key);

  @override
  __TopicWidgetState createState() => __TopicWidgetState();
}

class __TopicWidgetState extends State<_TopicWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: Card(
        elevation: 4.0,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 30.0,
                horizontal: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.topic.topicName,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FlatButton(
                    color: PROJECT_GREEN,
                    onPressed: () {

                      Navigator.of(context).pushNamed(CLIENT_MODERATOR_RESPONSES_SCREEN);

                      // Navigator.of(context).pushNamed(
                      //   PARTICIPANT_RESPONSES_SCREEN,
                      //   arguments: {
                      //     'topicUID': widget.topic.topicUID,
                      //     'questionUID':
                      //     widget.topic.questions.first.questionUID,
                      //   },
                      // );
                    },
                    child: Text(
                      'View Responses',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Color(0xFFDFE2ED).withOpacity(0.2),
              child: ExpansionTile(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.list,
                      size: 14.0,
                      color: Colors.grey[400],
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      '${widget.topic.questions.length}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                trailing: _isExpanded
                    ? Text(
                        'Hide Details',
                        style: TextStyle(
                          color: Color(0xFFC6C5CC),
                          fontSize: 10.0,
                        ),
                      )
                    : Text(
                        'Show Details',
                        style: TextStyle(
                          color: Color(0xFFC6C5CC),
                          fontSize: 10.0,
                        ),
                      ),
                onExpansionChanged: (value) {
                  setState(() {
                    _isExpanded = value;
                  });
                },
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 20.0, bottom: 15.0),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Questions',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                            ),
                            Text(
                              'In Progress',
                              style: TextStyle(
                                color: Color(0xFFAAAAAA),
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 1.0,
                          color: Colors.grey,
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: widget.topic.questions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${widget.topic.questions[index].questionNumber} ${widget.topic.questions[index].questionTitle}',
                                  style: TextStyle(
                                    color: PROJECT_GREEN,
                                    fontSize: 12.0,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward,
                                    color: PROJECT_GREEN,
                                  ),
                                  onPressed: () {
                                    // Navigator.of(context).pushNamed(
                                    //   PARTICIPANT_RESPONSES_SCREEN,
                                    //   arguments: {
                                    //     'topicUID': widget.topic.topicUID,
                                    //     'questionUID': widget
                                    //         .topic.questions[index].questionUID,
                                    //   },
                                    // );
                                  },
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 10.0,
                            );
                          },
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
    );
  }
}

// class _DesktopNotificationWidget extends StatelessWidget {
//   final Timestamp notificationTimestamp;
//   final String avatarURL;
//   final String displayName;
//   final String questionTitle;
//   final String topicName;
//   final String questionNumber;
//
//   // final String time;
//   // final String participantAvatar;
//   // final String participantAlias;
//   // final String questionNumber;
//   // final String questionTitle;
//
//   const _DesktopNotificationWidget({
//     Key key,
//     this.notificationTimestamp,
//     this.avatarURL,
//     this.displayName,
//     this.questionTitle,
//     this.topicName,
//     this.questionNumber,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
//       child: Row(
//         children: [
//           Text(
//             '5:30 pm',
//             style: TextStyle(
//               color: TEXT_COLOR.withOpacity(0.6),
//               fontSize: 13.0,
//             ),
//           ),
//           SizedBox(
//             width: 5.0,
//           ),
//           CachedNetworkImage(
//             imageUrl: avatarURL,
//             imageBuilder: (context, imageProvider) {
//               return Container(
//                 padding: EdgeInsets.all(6.0),
//                 margin: EdgeInsets.symmetric(horizontal: 8.0),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: PROJECT_LIGHT_GREEN,
//                 ),
//                 child: Image(
//                   width: 20.0,
//                   image: imageProvider,
//                 ),
//               );
//             },
//           ),
//           SizedBox(
//             width: 8.0,
//           ),
//           Expanded(
//             child: Column(
//               children: [
//                 RichText(
//                   textAlign: TextAlign.start,
//                   maxLines: 2,
//                   text: TextSpan(
//                     style: TextStyle(
//                         color: TEXT_COLOR.withOpacity(0.7), fontSize: 13.0),
//                     children: [
//                       TextSpan(
//                           text: '$displayName responded to the question '),
//                       TextSpan(
//                         text: '$questionNumber $questionTitle.',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
            '5:40 pm',
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
            imageBuilder: (context, imageProvider){
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
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