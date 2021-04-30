import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class StudyDetailsScreen extends StatefulWidget {
  @override
  _StudyDetailsScreenState createState() => _StudyDetailsScreenState();
}

class _StudyDetailsScreenState extends State<StudyDetailsScreen> {
  final _firebaseFirestoreService = FirebaseFirestoreService();

  final _getStorage = GetStorage();

  Study _study;

  String _studyUID;

  Future<Study> _futureStudyInstance;

  Future<Study> _getFutureStudy(String studyUID) async {
    _study = await _firebaseFirestoreService.getStudy(studyUID);
    return _study;
  }

  @override
  void initState() {
    _studyUID = _getStorage.read('studyUID');
    _futureStudyInstance = _getFutureStudy(_studyUID);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600.0),
          child: FutureBuilder(
            future: _futureStudyInstance,
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              switch(snapshot.connectionState){
                case ConnectionState.none:
                  return Center(
                    child: Text(
                      'No Internet Connection'
                    ),
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
                    children: [
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Text(
                        'Welcome to\n${_study.studyName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Text(
                        'Thank you for joining our study',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Text(
                        'Your participation is important',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 20.0,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.05, horizontal: 40.0),
                        color: Color(0xFFDFE2ED),
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _DetailsRow(
                              icon: 'images/svg_icons/calender_icon.png',
                              detail: 'This study runs ${_study.startDate} through ${_study.endDate}.',
                            ),
                            SizedBox(
                              height: 36.0,
                            ),
                            _DetailsRow(
                              icon: 'images/svg_icons/checkbox_icon.png',
                              detail: 'Login each day and post responses to the questions.',
                            ),
                            SizedBox(
                              height: 36.0,
                            ),
                            _DetailsRow(
                              icon: 'images/svg_icons/message_icon.png',
                              detail: 'All posts are anonymous. Your personal info is confidential.',
                            ),
                            SizedBox(
                              height: 36.0,
                            ),
                            _DetailsRow(
                              icon: 'images/svg_icons/dollar.png',
                              detail: 'After you complete this study, you\'ll be awarded a giftcard.',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                color: PROJECT_GREEN,
                                onPressed: (){
                                  Navigator.of(context).pushNamedAndRemoveUntil(ONBOARDING_SCREEN, (route) => false);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    'Let\'s Get Started',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                    ],
                  );
                  break;
                default:
                  return Center(
                    child: Text(
                      'Something went wrong',
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _DetailsRow extends StatelessWidget {
  final String icon;
  final String detail;

  const _DetailsRow({
    Key key,
    this.icon,
    this.detail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(icon),
        SizedBox(
          width: 24.0,
        ),
        Expanded(
          child: Text(
            detail,
            style: TextStyle(
              color: Color(0xFF0B0B0B),
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}
