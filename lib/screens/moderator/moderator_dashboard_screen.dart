// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/researcher/models/moderator.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/widgets/study_widget.dart';
import 'package:thoughtnav/services/firebase_auth_service.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

class ModeratorDashboardScreen extends StatefulWidget {
  @override
  _ModeratorDashboardScreenState createState() =>
      _ModeratorDashboardScreenState();
}

class _ModeratorDashboardScreenState extends State<ModeratorDashboardScreen> {
  final _researcherAndModeratorFirestoreService =
      ResearcherAndModeratorFirestoreService();

  final _firebaseAuthService = FirebaseAuthService();

  Moderator _moderator;

  Future<Moderator> _futureModerator;
  Future<List<Study>> _assignedStudies;

  Future<Moderator> _getFutureModerator(String moderatorUID) async {
    _moderator = await _researcherAndModeratorFirestoreService
        .getModerator(moderatorUID);

    return _moderator;
  }

  Future<List<Study>> _getAssignedStudies(List<dynamic> assignedStudies) async {
    var studies = await _researcherAndModeratorFirestoreService
        .getModeratorAssignedStudies(_moderator.assignedStudies);

    return studies;
  }

  @override
  void initState() {
    var getStorage = GetStorage();

    var moderatorUID = getStorage.read('moderatorUID');

    _futureModerator = _getFutureModerator(moderatorUID);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      backgroundColor: Colors.white,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leadingWidth: 140.0,
      leading: Center(
        child: Text(
          ' ThoughtNav',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
        ),
      ),
      title: Text(
        'Dashboard',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          height: kToolbarHeight,
          width: 1.0,
          color: Colors.grey[300],
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
              onTap: (){
                Navigator.of(context).popAndPushNamed(MODERATOR_PREFERENCES_SCREEN);
              },
              child: Text(
                'Preferences',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Container(
          height: kToolbarHeight,
          width: 1.0,
          color: Colors.grey[300],
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
              onTap: () async {
                await _firebaseAuthService.signOutUser();
                await Navigator.of(context).popAndPushNamed(LOGIN_SCREEN);
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: FutureBuilder<Moderator>(
        future: _futureModerator,
        builder: (BuildContext context, AsyncSnapshot<Moderator> moderator) {
          switch (moderator.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(
                child: Text('Loading...'),
              );
              break;
            case ConnectionState.done:
              if (moderator.hasData) {
                _assignedStudies =
                    _getAssignedStudies(moderator.data.assignedStudies);

                return FutureBuilder<List<Study>>(
                  future: _assignedStudies,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Study>> studies) {
                    switch (studies.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return Center(
                          child: Text(
                            'Loading...',
                          ),
                        );
                        break;
                      case ConnectionState.done:
                        if (studies.hasData) {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text(
                                  'All Studies',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Expanded(
                                child: ListView.separated(
                                  itemCount: studies.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return StudyWidget(
                                        study: studies.data[index]);
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      height: 20.0,
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Center(
                            child: Text(
                              'Something went wrong',
                            ),
                          );
                        }
                        break;
                      default:
                        return SizedBox();
                    }
                  },
                );
              } else {
                return Center(
                  child: Text(
                    'Something went wrong',
                  ),
                );
              }
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
    );
  }
}
