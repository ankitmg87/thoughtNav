import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/screens/researcher/widgets/topic_report_widget.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {

  final _researcherAndModeratorService =
  ResearcherAndModeratorFirestoreService();

  Future<List<Topic>> _futureGenerateReport;

  Study _study;
  List<Group> _groups;
  List<Topic> _topics;

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

  @override
  void initState() {

    var studyUID = GetStorage().read('studyUID');

    _futureGenerateReport = _generateReport(studyUID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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

              return SingleChildScrollView(
                child: Column(
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
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(topics.length, (index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TopicReportWidget(
                              topic: topics[index],
                              groups: _groups,
                            ),
                            SizedBox(
                              height: 10.0,
                            )
                          ],
                        );
                      }).toList(),
                    ),
                    // ListView.separated(
                    //   shrinkWrap: true,
                    //   physics: NeverScrollableScrollPhysics(),
                    //   itemCount: topics.length,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     return TopicReportWidget(
                    //       topic: topics[index],
                    //       groups: _groups,
                    //     );
                    //   },
                    //   separatorBuilder: (BuildContext context, int index) {
                    //     return SizedBox(
                    //       height: 10.0,
                    //     );
                    //   },
                    // ),
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



}
