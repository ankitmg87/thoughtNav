// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class StudySetup extends StatefulWidget {
  final String studyUID;
  final FirebaseFirestoreService firebaseFirestoreService;

  const StudySetup({Key key, this.studyUID, this.firebaseFirestoreService})
      : super(key: key);

  @override
  _StudySetupState createState() => _StudySetupState();
}

class _StudySetupState extends State<StudySetup> {
  Study _mStudy;

  Future<void> _studyDetails;
  Future<void> _groups;
  Future<void> _topicsAndQuestions;

  List<Group> _groupsList = [];
  List<Topic> _topicsList = [];

  Future<void> _getStudyDetails() async {
    _mStudy = await widget.firebaseFirestoreService.getStudy(widget.studyUID);
  }

  Future<void> _getGroups() async {
    _groupsList =
        await widget.firebaseFirestoreService.getGroups(widget.studyUID);
  }

  Future<void> _getTopicsAndQuestions() async {
    _topicsList =
        await widget.firebaseFirestoreService.getTopics(widget.studyUID);
  }

  @override
  void initState() {
    _studyDetails = _getStudyDetails();
    _groups = _getGroups();
    _topicsAndQuestions = _getTopicsAndQuestions();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'images/researcher_images/study_setup_images/setup_study_poster.png',),
                fit: BoxFit.cover,
              ),
            ),
            width: 300.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              width: 300.0,
              decoration: BoxDecoration(
                //color: PROJECT_GREEN
                gradient: LinearGradient(
                  colors: [
                    PROJECT_GREEN,
                    Color(0xFF008F47),
                    //Color(0xFF005229),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'STUDY INFO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'SELECT CATEGORY',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'CREATE GROUPS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'ADD QUESTIONS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _studySetupFutureBuilder(),
          ),
        ],
      ),
    );
  }

  FutureBuilder _studySetupFutureBuilder() {
    return FutureBuilder(
      future: _studyDetails,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text('No Internet Connection'),
            );
            break;
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: Text(
                'Loading...',
              ),
            );
            break;
          case ConnectionState.done:
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              children: [
                ListView(
                  shrinkWrap: true,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 5.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Text(
                          'STUDY INFO',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Study Name',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                enabled: false,
                                initialValue: _mStudy.studyName,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey[300],
                                      width: 0.5,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 40.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Internal Study Label',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                enabled: false,
                                initialValue: _mStudy.internalStudyLabel ??
                                    'Internal Study Label not set',
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey[300],
                                      width: 0.5,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Master Password',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                enabled: false,
                                initialValue: _mStudy.masterPassword,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey[300],
                                      width: 0.5,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 40.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Date',
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  border: Border.all(
                                    color: Colors.grey[400],
                                    width: 1.5,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      _mStudy.startDate,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 40.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'End Date',
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  border: Border.all(
                                    color: Colors.grey[400],
                                    width: 1.5,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      _mStudy.endDate,
                                      style: TextStyle(
                                        fontSize: 16.0,
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
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Intro Page Message',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                enabled: false,
                                initialValue: _mStudy.introPageMessage,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey[300],
                                      width: 0.5,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 40.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Study End Message',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                enabled: false,
                                initialValue: _mStudy.studyClosedMessage,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey[300],
                                      width: 0.5,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 5.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    child: Text(
                      'GROUPS',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                FutureBuilder(
                  future: _groups,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: _groupsList != null ? _groupsList.length : 0,
                      itemBuilder: (BuildContext context, int index) {
                        if (_groupsList != null) {
                          return _ActiveStudyGroupWidget(
                            index: _groupsList[index].groupIndex,
                            group: _groupsList[index],
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 30.0,
                        );
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 40.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 5.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    child: Text(
                      'TOPICS AND QUESTIONS',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                FutureBuilder(
                  future: _topicsAndQuestions,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: _topicsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _ActiveStudyTopicWidget(
                          topic: _topicsList[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 20.0,
                        );
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 40.0,
                ),
              ],
            );
            break;
          default:
            return SizedBox();
        }
      },
    );
  }
}

class _ActiveStudyGroupWidget extends StatelessWidget {
  final int index;
  final Group group;

  const _ActiveStudyGroupWidget({Key key, this.index, this.group})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$index.',
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: TextFormField(
            enabled: false,
            initialValue: group.groupName,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[300],
                  width: 0.5,
                  style: BorderStyle.solid,
                ),
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
            enabled: false,
            initialValue: group.internalGroupLabel ?? 'No internal group label',
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[300],
                  width: 0.5,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActiveStudyTopicWidget extends StatelessWidget {
  final Topic topic;

  const _ActiveStudyTopicWidget({Key key, this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        border: Border.all(
          color: Colors.grey[300],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topic.topicName,
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            topic.topicDate.toDate().toLocal().toString(),
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          ListView.separated(
            shrinkWrap: true,
            itemCount: topic.questions.length,
            itemBuilder: (BuildContext context, int index) {
              return _ActiveStudyQuestionWidget(
                question: topic.questions[index],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 20.0,
              );
            },
          )
        ],
      ),
    );
  }
}

class _ActiveStudyQuestionWidget extends StatelessWidget {
  final Question question;

  const _ActiveStudyQuestionWidget({Key key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: Colors.grey[300],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${question.questionNumber}.',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                question.questionTitle,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            question.questionStatement,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Question Type: ${question.questionType}',
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
