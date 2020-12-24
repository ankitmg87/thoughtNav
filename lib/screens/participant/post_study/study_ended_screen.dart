import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/constants/string_constants.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/services/participant_firestore_service.dart';

class StudyEndedScreen extends StatefulWidget {
  @override
  _StudyEndedScreenState createState() => _StudyEndedScreenState();
}

class _StudyEndedScreenState extends State<StudyEndedScreen> {
  final _participantFirestoreService = ParticipantFirestoreService();

  Study _study;

  String _studyUID;

  Future<void> _futureStudy;

  Future<void> _getStudy(String studyUID) async {
    _study = await _participantFirestoreService.getParticipantStudy(studyUID);
  }

  @override
  void initState() {
    var getStorage = GetStorage();

    _studyUID = getStorage.read('studyUID');

    _futureStudy = _getStudy(_studyUID);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          APP_NAME,
          style: TextStyle(
            color: TEXT_COLOR,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _futureStudy,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
              return SizedBox();
              break;
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(
                child: Text('Please wait...'),
              );
              break;
            case ConnectionState.done:
              return Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      height: 50.0,
                    ),
                    Text(
                      'Study Closed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: TEXT_COLOR.withOpacity(0.7),
                        fontSize: 24.0,
                      ),
                    ),
                    Text(
                      '${_study.studyName}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: TEXT_COLOR.withOpacity(0.8),
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: TEXT_COLOR.withOpacity(0.7),
                          fontSize: 16.0,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text: 'Began on ',
                          ),
                          TextSpan(
                            text: '${_study.startDate}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '\nEnded on ',
                          ),
                          TextSpan(
                            text: '${_study.endDate}.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Column(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         Text(
                    //           'Monday',
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //             color: TEXT_COLOR.withOpacity(0.6),
                    //             fontSize: 10.0,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //         Card(
                    //           child: Container(
                    //             width: 50.0,
                    //             padding: EdgeInsets.all(4.0),
                    //             child: Column(
                    //               mainAxisSize: MainAxisSize.min,
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: [
                    //                 Text(
                    //                   'May',
                    //                   style: TextStyle(
                    //                     color: TEXT_COLOR.withOpacity(0.8),
                    //                     fontSize: 10.0,
                    //                     fontWeight: FontWeight.bold,
                    //                   ),
                    //                 ),
                    //                 Text(
                    //                   '5',
                    //                   style: TextStyle(
                    //                     color: TEXT_COLOR.withOpacity(0.7),
                    //                     fontSize: 20.0,
                    //                     fontWeight: FontWeight.bold,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     SizedBox(
                    //       width: 20.0,
                    //     ),
                    //     Column(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         Text(
                    //           'Friday',
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //             color: TEXT_COLOR.withOpacity(0.6),
                    //             fontSize: 10.0,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //         Card(
                    //           child: Container(
                    //             width: 50.0,
                    //             padding: EdgeInsets.all(4.0),
                    //             child: Column(
                    //               mainAxisSize: MainAxisSize.min,
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: [
                    //                 Text(
                    //                   'May',
                    //                   style: TextStyle(
                    //                     color: TEXT_COLOR.withOpacity(0.8),
                    //                     fontSize: 10.0,
                    //                     fontWeight: FontWeight.bold,
                    //                   ),
                    //                 ),
                    //                 Text(
                    //                   '10',
                    //                   style: TextStyle(
                    //                     color: TEXT_COLOR.withOpacity(0.7),
                    //                     fontSize: 20.0,
                    //                     fontWeight: FontWeight.bold,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(
                    //       horizontal: screenSize.width * 0.4, vertical: 20.0),
                    //   height: 1.0,
                    //   color: TEXT_COLOR.withOpacity(0.6),
                    // ),
                    // SizedBox(
                    //   height: 30.0,
                    // ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.15),
                      child: Text(
                        'The ${_study.studyName} has concluded. Please contact the administrator if you think there is a mistake.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: TEXT_COLOR.withOpacity(0.7),
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                    screenSize.width < screenSize.height
                        ? Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width * 0.15),
                      child: Row(
                        children: [
                          Expanded(
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              color: PROJECT_GREEN,
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Contact Administrator',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    )
                        : Align(
                      child: Container(
                        width: 200.0,
                        child: FlatButton(
                          color: PROJECT_GREEN,
                          onPressed: () {
                            Navigator.of(context).popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN);
                          },
                          child: Text(
                            'Go Back To Dashboard',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
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
}
