import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class SetupCompleteScreen extends StatefulWidget {
  @override
  _SetupCompleteScreenState createState() => _SetupCompleteScreenState();
}

class _SetupCompleteScreenState extends State<SetupCompleteScreen> {
  final _firebaseFirestoreService = FirebaseFirestoreService();

  String _participantAvatarURL;
  String _participantDisplayName;
  String _studyName;

  String _studyUID;
  String _participantUID;

  Future<void> _future;

  Future<void> _getFuture() async {
    await _getStudy(_studyUID);
    await _getParticipant(_studyUID, _participantUID);
  }

  Future<void> _getStudy(String studyUID) async {
    var study = await _firebaseFirestoreService.getStudy(studyUID);
    _studyName = study.studyName;
  }

  Future<void> _getParticipant(String studyUID, String participantUID) async {
    var participant = await _firebaseFirestoreService.getParticipant(
        studyUID, participantUID);
    _participantAvatarURL = participant.profilePhotoURL;
    _participantDisplayName = participant.displayName;
  }

  @override
  void initState() {
    var getStorage = GetStorage();

    _studyUID = getStorage.read('studyUID');
    _participantUID = getStorage.read('participantUID');

    _future = _getFuture();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: PROJECT_GREEN,
      body: FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(
                child: Text(
                  'Please wait...',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
              break;
            case ConnectionState.done:
              return Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 600.0),
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CachedNetworkImage(
                        imageUrl: _participantAvatarURL,
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            width: 100.0,
                            height: 100.0,
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image(
                              image: imageProvider,
                            ),
                          );
                        },
                        placeholder: (context, String imageName) {
                          return Container(
                            width: 100.0,
                            height: 100.0,
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Theme(
                              data: ThemeData(
                                accentColor: PROJECT_NAVY_BLUE,
                              ),
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                              ),
                            ),
                          );
                        },
                      ),
                      Text(
                        _participantDisplayName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Text(
                        _studyName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Text(
                        'Account Setup Complete',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Text(
                        'This study is open',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Text(
                        'Get started on your first question of the day!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.1,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: BorderSide(
                                    color: Color(0xFF00DD66),
                                    width: 4.0,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(DASHBOARD_TIPS_SCREEN);
                                },
                                color: Color(0xFF00DD66),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'Answer Questions',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: 20.0,
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 40.0),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: OutlineButton(
                      //           borderSide: BorderSide(
                      //             color: Colors.white,
                      //             width: 6.0,
                      //             style: BorderStyle.solid,
                      //           ),
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(6.0),
                      //           ),
                      //           onPressed: () {
                      //             Navigator.of(context).pushNamedAndRemoveUntil(
                      //                 PARTICIPANT_DASHBOARD_SCREEN, (route) => false);
                      //           },
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(16.0),
                      //             child: Text(
                      //               'Continue to Dashboard',
                      //               style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.bold,
                      //                 fontSize: 20.0,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
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
