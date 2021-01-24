import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/screens/researcher/widgets/topic_report_widget.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


class StudyReports extends StatefulWidget {
  final String studyUID;

  const StudyReports({Key key, this.studyUID}) : super(key: key);

  @override
  _StudyReportsState createState() => _StudyReportsState();
}

class _StudyReportsState extends State<StudyReports> {

  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();

  final _researcherAndModeratorService =
      ResearcherAndModeratorFirestoreService();

  final pdf = pw.Document();

  Future<List<Topic>> _futureGenerateReport;

  Study _study;
  List<Group> _groups;

  List<dynamic> _listForCSV;

  Future<Study> _getFutureStudy(String studyUID) async {
    var study = await _researcherAndModeratorService.getStudy(studyUID);
    return study;
  }

  Future<List<Topic>> _generateReport(String studyUID) async {
    _study = await _getFutureStudy(studyUID);
    _groups = await _researcherAndModeratorService.getGroups(studyUID);
    var allTopicsQuestionsResponsesAndComments =
        await _researcherAndModeratorService.generateReport(studyUID);

    return allTopicsQuestionsResponsesAndComments;
  }
  
  void _createPDF(){

    Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      final doc = pw.Document();

      final image = await wrapWidget(doc.document, key: _printKey, pixelRatio: 2.0);
      
      doc.addPage(pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Image(pw.ImageProxy(image));
        }
      ));

      return doc.save();

    });

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

              return ListView(
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
                          onPressed: () {},
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
                          onPressed: () {

                            
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
                    key: _printKey,
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
                                      borderRadius: BorderRadius.circular(10.0),
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
                                          _detailRow(
                                              'Begin Date', '${_study.startDate}'),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          _detailRow(
                                              'End Date', '${_study.endDate}'),
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
}
