import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

class StudyWidget extends StatefulWidget {
  final Study study;

  const StudyWidget({
    Key key,
    this.study,
  }) : super(key: key);

  @override
  _StudyWidgetState createState() => _StudyWidgetState();
}

class _StudyWidgetState extends State<StudyWidget> {
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
    _activeParticipantsStream =
        _getActiveParticipantsAsStream(widget.study.studyUID);
    _allParticipantsStream = _getAllParticipantsAsStream(widget.study.studyUID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var percentInt = widget.study.activeParticipants;
    // var percentDouble = percentInt / 100;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        child: InkWell(
          onTap: () {
            final getStorage = GetStorage();

            if (widget.study.studyStatus == 'Draft') {
              getStorage.write('studyUID', widget.study.studyUID);
              getStorage.write('studyName', widget.study.studyName);
              getStorage.write('studyStatus', widget.study.studyStatus);
              Navigator.pushNamed(context, DRAFT_STUDY_SCREEN);
            } else {
              getStorage.write('studyUID', widget.study.studyUID);
              getStorage.write('studyName', widget.study.studyName);
              getStorage.write('studyStatus', widget.study.studyStatus);
              getStorage.write(
                  'internalStudyLabel', widget.study.internalStudyLabel);
              Navigator.pushNamed(
                context,
                MODERATOR_STUDY_SCREEN,
                arguments: widget.study.studyUID,
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.all(20.0),
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
                            widget.study.studyName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            '(${widget.study.studyStatus})',
                            style: TextStyle(
                              color: PROJECT_GREEN,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: _allParticipantsStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot>
                                allParticipantsSnapshot) {
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
                                if (allParticipantsSnapshot
                                        .data.docs.isNotEmpty) {
                                  _allParticipants = allParticipantsSnapshot
                                      .data.docs.length;
                                  return StreamBuilder<QuerySnapshot>(
                                    stream: _activeParticipantsStream,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> activeParticipantsSnapshot) {
                                      switch(activeParticipantsSnapshot.connectionState){
                                        case ConnectionState.none:
                                          return SizedBox();
                                          break;
                                        case ConnectionState.waiting:
                                          return SizedBox();
                                          break;
                                        case ConnectionState.active:
                                          if(activeParticipantsSnapshot.hasData){
                                            if(activeParticipantsSnapshot.data.docs.isNotEmpty){
                                              _activeParticipants = activeParticipantsSnapshot.data.docs.length;
                                              var percent = (_activeParticipants / _allParticipants) * 100;
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                            else {
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
                                          }
                                          else {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                          percent: _activeParticipants / _allParticipants,
                                          padding: EdgeInsets.symmetric(horizontal: 0.0),
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
                                        percent: _activeParticipants / _allParticipants,
                                        padding: EdgeInsets.symmetric(horizontal: 0.0),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Row(
                      //   mainAxisSize: MainAxisSize.max,
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       'Current Active',
                      //       style: TextStyle(
                      //           color: Color(0xFF437FEF),
                      //           fontWeight: FontWeight.bold),
                      //     ),
                      //     Text(
                      //       '${widget.study.activeParticipants ?? 0}',
                      //       style: TextStyle(
                      //           color: Color(0xFF437FEF),
                      //           fontWeight: FontWeight.bold),
                      //     )
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 16.0,
                      // ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Responses',
                            style: TextStyle(
                                color: Color(0xFF437FEF),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.study.totalResponses ?? 0}',
                            style: TextStyle(
                                color: Color(0xFF437FEF),
                                fontWeight: FontWeight.bold),
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
                                color: Color(0xFF437FEF),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.study.startDate}',
                            style: TextStyle(
                                color: Color(0xFF437FEF),
                                fontWeight: FontWeight.bold),
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
                                color: Color(0xFF437FEF),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.study.endDate}',
                            style: TextStyle(
                                color: Color(0xFF437FEF),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
