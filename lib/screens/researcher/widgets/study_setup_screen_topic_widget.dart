import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reorderables/reorderables.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

import 'custom_text_editing_box.dart';
import 'study_setup_screen_question_widget.dart';

class StudySetupScreenTopicWidget extends StatefulWidget {
  final String studyUID;
  final Topic topic;
  final List<Group> groups;

  const StudySetupScreenTopicWidget({
    Key key,
    this.studyUID,
    this.topic,
    this.groups,
  }) : super(key: key);

  @override
  _StudySetupScreenTopicWidgetState createState() =>
      _StudySetupScreenTopicWidgetState();
}

class _StudySetupScreenTopicWidgetState
    extends State<StudySetupScreenTopicWidget> {
  final FirebaseFirestoreService _firebaseFirestoreService =
      FirebaseFirestoreService();

  final _researcherAndModeratorFirestoreService =
      ResearcherAndModeratorFirestoreService();

  List<Question> _questions;

  String _topicDate;

  final FocusNode _topicNameFocusNode = FocusNode();

  void _updateTopicDetails() async {
    await _firebaseFirestoreService.updateTopic(widget.studyUID, widget.topic);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      _questions.insert(newIndex, _questions.removeAt(oldIndex));
    });
  }

  @override
  void initState() {
    if (widget.topic.topicDate != null) {
      _topicDate = _formatTopicDate(widget.topic.topicDate);
    }
    super.initState();
    _topicNameFocusNode.addListener(() {
      if (!_topicNameFocusNode.hasFocus) {
        _updateTopicDetails();
      }
    });

    _questions = widget.topic.questions;

    _questions ??= <Question>[];
  }

  String _formatTopicDate(Timestamp timestamp) {
    var dateTime = timestamp.toDate();
    var formatter = DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY);
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 10.0,
        left: 10.0,
        bottom: 5.0,
      ),
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
              SizedBox(
                width: 60.0,
                child: TextFormField(
                  initialValue: widget.topic.topicNumber,
                  // focusNode: _questionNumberFocusNode,
                  onFieldSubmitted: (topicNumber) {
                    if (topicNumber != null || topicNumber.isNotEmpty) {
                      // _updateQuestionDetails();
                    }
                  },
                  onChanged: (topicNumber) {
                    // _questionNumber = topicNumber;
                    // widget.question.questionNumber = _questionNumber;
                  },
                  decoration: InputDecoration(
                    hintText: 'No.',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
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
                child: TextFormField(
                  initialValue: widget.topic.topicName,
                  focusNode: _topicNameFocusNode,
                  onChanged: (topicName) {
                    if (topicName != null || topicName.isNotEmpty) {
                      widget.topic.topicName = topicName;
                    }
                  },
                  onFieldSubmitted: (topicName) {
                    if (topicName != null || topicName.isNotEmpty) {
                      _updateTopicDetails();
                    }
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
                        initialDate: DateTime.now(),
                        lastDate: DateTime(2025),
                        context: context,
                      );
                      if (beginDate != null) {
                        var editedTime = beginDate.add(Duration(hours: 6));
                        widget.topic.topicDate = Timestamp.fromDate(editedTime);
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
              SizedBox(
                width: 20.0,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {},
                child: Icon(
                  Icons.clear,
                  color: Colors.red[700],
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          widget.topic.isActive
              ? ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.topic.questions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return StudySetupScreenQuestionWidget(
                      studyUID: widget.studyUID,
                      topicUID: widget.topic.topicUID,
                      question: widget.topic.questions[index],
                      groups: widget.groups,
                      deleteQuestion: () async {
                        await _firebaseFirestoreService.deleteQuestion(
                          widget.studyUID,
                          widget.topic.topicUID,
                          widget.topic.questions[index].questionUID,
                        );
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox();
                  },
                )
              : ReorderableWrap(
                  needsLongPressDraggable: false,
                  runSpacing: 10.0,
                  onReorder: _onReorder,
                  children: [
                    for (var _question in _questions)
                      StudySetupScreenQuestionWidget(
                        studyUID: widget.studyUID,
                        topicUID: widget.topic.topicUID,
                        question: _question,
                        groups: widget.groups,
                        deleteQuestion: () async {
                          await _firebaseFirestoreService.deleteQuestion(
                            widget.studyUID,
                            widget.topic.topicUID,
                            _question.questionUID,
                          );
                        },
                      ),
                  ],
                ),
          SizedBox(
            height: 10.0,
          ),

          widget.topic.isActive ?
              SizedBox() :
          Align(
            alignment: Alignment.centerRight,
            child: Row(
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
                        icon: Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red[700],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.close_outlined,
                              color: Colors.white,
                              size: 14.0,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                IconButton(
                  onPressed: () async {
                    var question = await _researcherAndModeratorFirestoreService
                        .createQuestion(widget.studyUID, _questions.length + 1,
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
          ),
        ],
      ),
    );
  }
}
