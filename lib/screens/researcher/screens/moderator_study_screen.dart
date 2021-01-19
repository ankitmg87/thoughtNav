import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/researcher/screens/draft_study_sub_screens/draft_study_setup.dart';
import 'package:thoughtnav/screens/researcher/screens/sub_screens/study_dashboard.dart';
import 'package:thoughtnav/screens/researcher/screens/sub_screens/study_reports.dart';
import 'package:thoughtnav/screens/researcher/screens/sub_screens/study_setup.dart';
import 'package:thoughtnav/screens/researcher/screens/sub_screens/study_users.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class ModeratorStudyScreen extends StatefulWidget {
  @override
  _ModeratorStudyScreenState createState() => _ModeratorStudyScreenState();
}

class _ModeratorStudyScreenState extends State<ModeratorStudyScreen> {

  final _firebaseFirestoreService = FirebaseFirestoreService();

  String _userType;

  bool dashboardSelected = true;
  bool usersSelected = false;
  bool setupSelected = false;
  bool reportsSelected = false;

  Widget subScreen;

  Widget dashboardScreen;
  Widget usersScreen;
  Widget setupScreen;
  Widget reportsScreen;

  @override
  void initState() {

    final getStorage = GetStorage();

    var studyUID = getStorage.read('studyUID');
    _userType = getStorage.read('userType');

    dashboardScreen = StudyDashboard(studyUID: studyUID, firebaseFirestoreService: _firebaseFirestoreService,);
    usersScreen = StudyUsers(studyUID: studyUID, firebaseFirestoreService: _firebaseFirestoreService,);
    setupScreen = Expanded(child: DraftStudySetup(studyUID: studyUID,));
    reportsScreen = StudyReports(studyUID: studyUID,);

    subScreen = dashboardScreen;

    super.initState();
  }

  void setSubScreen(String label) {
    if (label == 'Studies') {
      if(_userType == 'moderator'){
        Navigator.of(context).popAndPushNamed(MODERATOR_DASHBOARD_SCREEN);
      }
      if(_userType == 'root'){
        Navigator.of(context).popAndPushNamed(RESEARCHER_MAIN_SCREEN);
      }
      return;
    }
    if (label == 'Dashboard') {
      dashboardSelected = true;
      usersSelected = false;
      setupSelected = false;
      reportsSelected = false;

      subScreen = dashboardScreen;
      setState(() {});
      return;
    }
    if (label == 'Users') {
      usersSelected = true;
      dashboardSelected = false;
      setupSelected = false;
      reportsSelected = false;

      subScreen = usersScreen;
      setState(() {});
      return;
    }
    if (label == 'Setup') {
      setupSelected = true;
      dashboardSelected = false;
      usersSelected = false;
      reportsSelected = false;

      subScreen = setupScreen;
      setState(() {});
      return;
    }
    if (label == 'Reports') {
      reportsSelected = true;
      dashboardSelected = false;
      usersSelected = false;
      setupSelected = false;

      subScreen = reportsScreen;
      setState(() {});
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final Study study = Study.fromMap(ModalRoute.of(context).settings.arguments);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    StudyScreenSecondaryAppBarWidget(
                      label: 'Studies',
                      onTap: () => setSubScreen('Studies'),
                      selected: false,
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    StudyScreenSecondaryAppBarWidget(
                            label: 'Dashboard',
                            selected: dashboardSelected,
                            onTap: () => setSubScreen('Dashboard'),
                          ),
                    SizedBox(
                            width: 16.0,
                          ),
                    StudyScreenSecondaryAppBarWidget(
                      label: 'Users',
                      selected: usersSelected,
                      onTap: () => setSubScreen('Users'),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    StudyScreenSecondaryAppBarWidget(
                      label: 'Setup',
                      selected: setupSelected,
                      onTap: () => setSubScreen('Setup'),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    StudyScreenSecondaryAppBarWidget(
                            label: 'Reports',
                            selected: reportsSelected,
                            onTap: () => setSubScreen('Reports'),
                          ),
                  ],
                ),
              ],
            ),
          ),
          subScreen,
        ],
      ),
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
        'Study Dashboard',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      // actions: [
      //   Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Center(
      //       child: Stack(
      //         children: [
      //           Container(
      //             child: Image(
      //               image: AssetImage('images/avatars/batman.png'),
      //             ),
      //             decoration: BoxDecoration(
      //               shape: BoxShape.circle,
      //             ),
      //           ),
      //           Positioned(
      //             bottom: 0,
      //             right: 0,
      //             child: Container(
      //               padding: EdgeInsets.all(2.0),
      //               decoration: BoxDecoration(
      //                 color: Colors.black,
      //                 shape: BoxShape.circle,
      //                 border: Border.all(
      //                   color: Colors.white,
      //                 ),
      //               ),
      //               child: Icon(
      //                 Icons.menu,
      //                 color: Colors.white,
      //                 size: 12.0,
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ],
    );
  }
}

class StudyScreenSecondaryAppBarWidget extends StatefulWidget {
  final String label;
  final bool selected;
  final Function onTap;

  const StudyScreenSecondaryAppBarWidget({
    Key key,
    @required this.label,
    @required this.selected,
    @required this.onTap,
  }) : super(key: key);

  @override
  _StudyScreenSecondaryAppBarWidgetState createState() =>
      _StudyScreenSecondaryAppBarWidgetState();
}

class _StudyScreenSecondaryAppBarWidgetState
    extends State<StudyScreenSecondaryAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        widget.label,
        style: TextStyle(
          color: widget.selected ? PROJECT_GREEN : Colors.black,
          fontWeight: FontWeight.w900,
          fontSize: 16.0,
        ),
      ),
      onTap: widget.onTap,
      hoverColor: Colors.white,
      splashColor: Colors.white,
      highlightColor: Colors.white,
    );
  }
}
