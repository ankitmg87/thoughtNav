// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/report_question.dart';
import 'package:thoughtnav/screens/researcher/models/report_response.dart';
import 'package:thoughtnav/screens/researcher/models/report_study.dart';
import 'package:thoughtnav/screens/researcher/models/report_topic.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/screens/researcher/widgets/topic_report_widget.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

import 'dart:html' as html;
import 'dart:js' as js;

class StudyReports extends StatefulWidget {
  final String studyUID;

  const StudyReports({Key key, this.studyUID}) : super(key: key);

  @override
  _StudyReportsState createState() => _StudyReportsState();
}

class _StudyReportsState extends State<StudyReports> {
  final _researcherAndModeratorService =
  ResearcherAndModeratorFirestoreService();
  Future<List<Topic>> _futureGenerateReport;
  Study _study;
  List<Group> _groups;
  List<Topic> _topics;
  String _response;
  Future<Study> _getFutureStudy(String studyUID) async {
    var study = await _researcherAndModeratorService.getStudy(studyUID);
    return study;
  }
  Future<List<Topic>> _generateReport(String studyUID) async {
    _study = await _getFutureStudy(studyUID);
    _groups = await _researcherAndModeratorService.getGroups(studyUID);
    _topics = await _researcherAndModeratorService.generateReport(studyUID);
    return _topics;
  }
  Future<String> _createPDF() async {
    var reportStudy = ReportStudy(
      studyName: _study.studyName,
      internalStudyLabel: _study.internalStudyLabel,
      studyStatus: _study.studyStatus,
      beginDate: _study.startDate,
      endDate: _study.endDate,
      activeParticipants: '${_study.activeParticipants}',
      totalParticipants: '${_study.totalParticipants}',
      totalResponses: '${_study.totalResponses}',
      totalComments: '${_study.totalComments}',
      reportTopics: [],
    );
    for (var topic in _topics) {
      var reportTopic = ReportTopic(
        topicName: topic.topicName,
        topicNumber: topic.topicNumber,
        reportQuestions: [],
      );
      for (var question in topic.questions) {
        var reportQuestion = ReportQuestion(
          questionNumber: question.questionNumber,
          questionTitle: question.questionTitle,
          questionStatement: question.questionStatement,
          reportResponses: [],
        );
        for (var response in question.responses) {
          var reportResponse = ReportResponse(
              participantDisplayName: response.participantDisplayName,
              participantAvatarURL: response.avatarURL,
              dateAndTime: _calculateDateAndTime(response.responseTimestamp),
              responseStatement: response.responseStatement ?? '',
              mediaURL: response.mediaURL ?? '',
              mediaType: response.mediaType ?? '',
              claps: '${response.claps.length}',
              comments: '${response.comments}');
          reportQuestion.reportResponses
              .add(reportResponse.toMap(reportResponse));
        }
        reportTopic.reportQuestions.add(reportQuestion.toMap(reportQuestion));
      }
      reportStudy.reportTopics.add(reportTopic.toMap(reportTopic));
    }
    var response =
    await _researcherAndModeratorService.sendDataForPdfGeneration(
        'api/',
        reportStudy.toMap(reportStudy));
    var decodedResponse = jsonDecode(response.body);
    _response = decodedResponse['message'];
    return _response;
  }
  void _downloadPDF(String url) {
    var anchorElement = html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();
  }
  String _calculateDateAndTime(Timestamp responseTimestamp) {
    var dateFormat = DateFormat(DateFormat.ABBR_MONTH_DAY);
    var timeFormat = DateFormat.jm();
    var date = dateFormat.format(responseTimestamp.toDate());
    var time = timeFormat.format(responseTimestamp.toDate());
    return '$date at $time';
  }
  @override
  void initState() {
    _futureGenerateReport = _generateReport(widget.studyUID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Topic>>(
        future: _futureGenerateReport,
        builder: (BuildContext context, AsyncSnapshot<List<Topic>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(
                child: Text('Loading...'),
              );
              break;
            case ConnectionState.done:
              var topics = snapshot.data;
              return Scrollbar(
                thickness: 10.0,
                isAlwaysShown: true,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton(
                            elevation: 2.0,
                            color: PROJECT_LIGHT_GREEN,
                            onPressed: () {
                              _getCSV(topics);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Export as .csv',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          RaisedButton(
                            elevation: 2.0,
                            color: PROJECT_LIGHT_GREEN,
                            onPressed: () async {
                              var downloadLink = await _createPDF();
                              _downloadPDF(downloadLink);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Export as .pdf',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Card(
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _study.studyName,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    height: 1.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                        color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _detailRow('Internal Study Label',
                                                '${_study.internalStudyLabel ?? 'No Internal Study Label'}'),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            _detailRow('Study Status',
                                                '${_study.studyStatus}'),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            _detailRow('Begin Date',
                                                '${_study.startDate}'),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            _detailRow('End Date',
                                                '${_study.endDate}'),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 300.0,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _detailRow('Active Participants',
                                                '${_study.activeParticipants}'),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            _detailRow('Total Participants',
                                                '${_study.totalParticipants}'),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            _detailRow('Total Responses',
                                                '${_study.totalResponses}'),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            _detailRow('Total Comments',
                                                '${_study.totalComments}'),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: topics.length,
                          itemBuilder: (BuildContext context, int index) {
                            return TopicReportWidget(
                              topic: topics[index],
                              groups: _groups,
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
                  ],
                ),
              );
              break;
            default:
              return SizedBox();
          }
        },
      ),
    );
  }

  Row _detailRow(String label, String detail) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
        Text(
          detail,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }

  void _getCSV(List<Topic> topics) async {

    var topicRows = <List<dynamic>>[];

    topicRows.add([
      'Topic',
      'Question Type',
      'Question Title',
      'Group',
      'Display Name',
      'Response',
      'Attached Media',
      'Active Date',
    ]);

    for(var topic in topics){
      for (var question in topic.questions){
        for (var response in question.responses){
          var topicRow = <dynamic>[];
          topicRow.add('${topic.topicNumber} ${topic.topicName}');

          topicRow.add(question.questionType);
          topicRow.add('${question.questionNumber} ${question.questionTitle}');
          topicRow.add(question.groupIndexes);

          topicRow.add(response.participantDisplayName);
          topicRow.add(response.responseStatement);
          topicRow.add(response.mediaURL ?? '');
          topicRow.add(topic.topicDate.toDate());

          topicRows.add(topicRow);
        }
      }
    }
    var csv = ListToCsvConverter().convert(topicRows);

    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes]);

    js.context.callMethod('webSaveAs', [blob, '${_study.studyName}.csv']);
  }
}

