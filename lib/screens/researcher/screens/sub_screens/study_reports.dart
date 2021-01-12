import 'package:flutter/material.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

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

  Future<List<Topic>> _generateReport(String studyUID) async {
    var allTopicsQuestionsResponsesAndComments = await _researcherAndModeratorService
        .generateReport(studyUID);
    return allTopicsQuestionsResponsesAndComments;
  }

  @override
  void initState() {
    _futureGenerateReport = _generateReport(widget.studyUID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Topic>>(
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
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(
                  snapshot.data[index].topicName,
                );
              },

            );
            break;
          default:
            return SizedBox();
        }
      },
    );
  }
}
