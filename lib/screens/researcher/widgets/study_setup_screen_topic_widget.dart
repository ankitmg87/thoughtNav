import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

import 'custom_text_editing_box.dart';
import 'study_setup_screen_question_widget.dart';

class StudySetupScreenTopicWidget extends StatefulWidget {
  final Function onTap;
  final String studyUID;
  final Topic topic;

  const StudySetupScreenTopicWidget({
    Key key,
    this.onTap,
    this.studyUID,
    this.topic,
  }) : super(key: key);

  @override
  _StudySetupScreenTopicWidgetState createState() =>
      _StudySetupScreenTopicWidgetState();
}

class _StudySetupScreenTopicWidgetState
    extends State<StudySetupScreenTopicWidget> {
  final FirebaseFirestoreService _firebaseFirestoreService =
      FirebaseFirestoreService();

  Future<List<Question>> _futureQuestions;

  List<Question> _questions = [];

  String _topicDate;

  final FocusNode _topicNameFocusNode = FocusNode();

  void _getQuestions() async {
    _futureQuestions =
        _firebaseFirestoreService.getQuestions(widget.studyUID, widget.topic);
  }

  void _updateTopicDetails() async {
    await _firebaseFirestoreService.updateTopic(widget.studyUID, widget.topic);
  }

  @override
  void initState() {
    if(widget.topic.topicDate != null) {
      _topicDate = _formatTopicDate(widget.topic.topicDate);
    }
    super.initState();
    _topicNameFocusNode.addListener(() {
      if (!_topicNameFocusNode.hasFocus) {
        _updateTopicDetails();
      }
    });
    _getQuestions();
  }

  String _formatTopicDate(Timestamp timestamp) {
    var dateTime = timestamp.toDate();
    var formatter = DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY);
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300],
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: widget.topic.topicName,
                  focusNode: _topicNameFocusNode,
                  onChanged: (topicName) {
                    widget.topic.topicName = topicName;
                  },
                  onFieldSubmitted: (topicName){
                    widget.topic.topicName = topicName;
                    _updateTopicDetails();
                  },
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Topic Name',
                    hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: BorderSide(
                        color: Colors.grey[400],
                        width: 0.5,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 40.0,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    border: Border.all(
                      width: 0.75,
                      color: Colors.grey[300],
                    ),
                  ),
                  child: InkWell(
                    onTap: () async {
                      final beginDate = await showDatePicker(
                        firstDate: DateTime(2020),
                        initialDate: DateTime(2020),
                        lastDate: DateTime(2025),
                        context: context,
                      );
                      if (beginDate != null) {
                        widget.topic.topicDate = Timestamp.fromDate(beginDate);
                        _topicDate = _formatTopicDate(widget.topic.topicDate);
                        _updateTopicDetails();
                        setState(() {});
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 10.0,
                      ),
                      child: Text(
                        _topicDate ?? 'Select Date',
                        style: TextStyle(
                          color: _topicDate == null
                              ? Colors.grey[400]
                              : Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _questions.length > 1
                      ? IconButton(
                          onPressed: () async {
                            await _firebaseFirestoreService.deleteQuestion(
                                widget.studyUID,
                                widget.topic.topicUID,
                                _questions.last.questionUID);
                            setState(() {
                              _questions.removeLast();
                            });
                          },
                          icon: Icon(
                            Icons.clear_outlined,
                          ),
                          color: Colors.red[700],
                        )
                      : SizedBox(),
                  IconButton(
                    onPressed: () async {
                      var question =
                          await _firebaseFirestoreService.createQuestion(
                              widget.studyUID,
                              _questions.length + 1,
                              widget.topic.topicUID);
                      setState(() {
                        _questions.add(question);
                      });
                    },
                    icon: Icon(
                      Icons.add_circle_outlined,
                    ),
                    color: PROJECT_GREEN,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          FutureBuilder(
            future: _futureQuestions,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                _questions = snapshot.data;
                return ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 20.0,
                    );
                  },
                  itemCount: _questions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return StudySetupScreenQuestionWidget(
                      question: _questions[index],
                      hint: Text(
                        'Set a Question',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.grey[400],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
