// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/screens/researcher/widgets/question_tile.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class TopicWidget extends StatefulWidget {
  final String studyUID;
  final Topic topic;
  final FirebaseFirestoreService firebaseFirestoreService;

  const TopicWidget(
      {Key key, this.topic, this.firebaseFirestoreService, this.studyUID})
      : super(key: key);

  @override
  _TopicWidgetState createState() => _TopicWidgetState();
}

class _TopicWidgetState extends State<TopicWidget> {
  bool isExpanded = false;

  String date = '';

  @override
  void initState() {
    super.initState();

    var dateFromTimeStamp = widget.topic.topicDate.toDate();
    var formatter = DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY);
    date = formatter.format(dateFromTimeStamp);
  }

  void _setTopicAsActive() async {
    if (widget.topic.topicDate.millisecondsSinceEpoch <= Timestamp.now().millisecondsSinceEpoch) {
      setState(() {
        widget.topic.topicDate = Timestamp.now();
      });
      await widget.firebaseFirestoreService
          .updateTopic(widget.studyUID, widget.topic);
    }
  }

  void _viewResponses() {
    print(widget.topic.topicDate.millisecondsSinceEpoch <=
        Timestamp.now().millisecondsSinceEpoch);
    if (widget.topic.topicDate.millisecondsSinceEpoch <=
        Timestamp.now().millisecondsSinceEpoch) {
      Navigator.of(context)
          .pushNamed(CLIENT_MODERATOR_RESPONSES_SCREEN, arguments: {
        'questionUID': widget.topic.questions.first.questionUID,
        'topicUID': widget.topic.topicUID,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.topic.topicName,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        color: Color(0xFF7F7F7F),
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                FlatButton(
                  color: PROJECT_GREEN,
                  onPressed: () {
                    if (widget.topic.topicDate.millisecondsSinceEpoch <= Timestamp.now().millisecondsSinceEpoch) {
                      _viewResponses();
                    } else {
                      _setTopicAsActive();
                    }
                  },
                  child: Text(
                    widget.topic.topicDate.millisecondsSinceEpoch <=
                        Timestamp.now().millisecondsSinceEpoch
                        ? 'View Responses'
                        : 'Set Active',
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
              title: SizedBox(),
              trailing: isExpanded
                  ? Text(
                      'Hide Details',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.0,
                      ),
                    )
                  : Text(
                      'Show Details',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.0,
                      ),
                    ),
              onExpansionChanged: (value) {
                setState(() {
                  isExpanded = value;
                });
              },
              children: [
                Container(
                  padding: EdgeInsets.all(20.0),
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Questions',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 20.0,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.topic.questions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return QuestionTile(
                            topicUID: widget.topic.topicUID,
                            question: widget.topic.questions[index],
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
    );
  }
}
