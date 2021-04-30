// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/models/user.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/screens/researcher/screens/draft_study_sub_screens/draft_study_setup.dart';
import 'package:thoughtnav/screens/researcher/screens/draft_study_sub_screens/draft_study_users.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

class DraftStudyScreen extends StatefulWidget {
  @override
  _DraftStudyScreenState createState() => _DraftStudyScreenState();
}

class _DraftStudyScreenState extends State<DraftStudyScreen> {

  final _firebaseFirestoreService = FirebaseFirestoreService();

  final _researcherAndModeratorFirestoreService = ResearcherAndModeratorFirestoreService();

  String _userType = '';

  String _studyUID = '';
  String _studyName = '';
  String _studyStatus = '';

  bool _setupSelected = true;
  bool _usersSelected = false;

  Widget _draftSubScreen = Container();
  Widget _draftStudySetup;
  Widget _draftStudyUsers;

  void _unAwaited(Future future){}

  // Future<List<Group>> _getGroups() async {
  //   var groups = await _researcherAndModeratorFirestoreService.getGroups(_studyUID);
  //   return groups;
  // }
  //
  // Future<String> _getMasterPassword() async {
  //   var masterPassword = await _researcherAndModeratorFirestoreService.getMasterPassword(_studyUID);
  //   return masterPassword;
  // }

  Future<void> _addParticipantToFirebase(
      String studyUID, Participant participant, String masterPassword) async {
    var user = User(
      userEmail: participant.email,
      userPassword: masterPassword,
      userType: 'participant',
      studyUID: studyUID,
    );

    var createdUser = await _firebaseFirestoreService.createUser(user);

    if(createdUser != null){
      participant.participantUID = createdUser.userUID;
      participant.isActive = false;
      participant.isOnboarded = false;
      participant.isDeleted = false;
      participant.password = masterPassword;
      participant.responses = 0;
      participant.comments = 0;

      await _researcherAndModeratorFirestoreService.createParticipant(
          studyUID, participant);
    }
  }

  void _getStudyDetails() {
    final getStorage = GetStorage();
    _studyUID = getStorage.read('studyUID');
    _studyName = getStorage.read('studyName');
    _studyStatus = getStorage.read('studyStatus');
    _userType = getStorage.read('userType');
  }

  void _setStudyAsActive() async {
    //var dialogContext;

    // _unAwaited(
    //   showGeneralDialog(
    //     context: context,
    //     pageBuilder: (BuildContext context, Animation<double> animation,
    //         Animation<double> secondaryAnimation) {
    //       dialogContext = context;
    //       return Center(
    //         child: Material(
    //           borderRadius: BorderRadius.circular(4.0),
    //           color: Colors.white,
    //           child: Container(
    //             padding: EdgeInsets.all(16.0),
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(4.0),
    //             ),
    //             child: Text(
    //               'Please Wait...',
    //               style: TextStyle(
    //                 color: Colors.grey[700],
    //                 fontWeight: FontWeight.bold,
    //                 fontSize: 16.0,
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
    //
    // var groups = await _getGroups();
    // var masterPassword = await _getMasterPassword();
    //
    // var studyName = _studyName.replaceAll(RegExp(r'[^\w\s]+'), '');
    //
    // for (var group in groups){
    //   var rawEmailString =
    //       'participant.' + studyName + '.' + group.groupName + '@thoughtnav.com';
    //   var lowerCaseRawEmail = rawEmailString.toLowerCase();
    //   var sanitizedEmail = lowerCaseRawEmail.replaceAll(' ', '');
    //
    //   await _addParticipantToFirebase(_studyUID, Participant(
    //     userFirstName: 'Participant',
    //     userLastName: '${group.groupIndex}',
    //     email: sanitizedEmail,
    //     password: masterPassword,
    //     userGroupName: group.groupName,
    //     rewardAmount: group.groupRewardAmount,
    //     groupUID: group.groupUID,
    //
    //   ), masterPassword);
    // }
    //
    // Navigator.of(dialogContext).pop();

    await _firebaseFirestoreService.updateStudyStatus(_studyUID, 'Active').then((value){
      if(_userType == 'root'){
        Navigator.of(context).popAndPushNamed(RESEARCHER_MAIN_SCREEN);
      }
      if(_userType == 'moderator'){
        Navigator.of(context).popAndPushNamed(MODERATOR_DASHBOARD_SCREEN);
      }
    });
  }

  @override
  void initState() {
    _getStudyDetails();

    _draftStudySetup = DraftStudySetup(
      studyUID: _studyUID,
    );
    _draftStudyUsers = DraftStudyUsers(
      studyUID: _studyUID,
    );

    _draftSubScreen = _draftStudySetup;

    super.initState();
  }

  void setSubScreen(String label) {
    if (label == 'Setup') {
      _setupSelected = true;
      _usersSelected = false;

      _draftSubScreen = _draftStudySetup;

      setState(() {});

      return;
    }
    if (label == 'Users') {
      _setupSelected = false;
      _usersSelected = true;

      _draftSubScreen = _draftStudyUsers;

      setState(() {});

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leadingWidth: 140.0,
      leading: Center(
        child: Text(
          'ThoughtNav',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
        ),
      ),
      title: Text(
        _studyName,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[300],
              ),
            ),
          ),
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: [
              _DraftStudySecondaryAppBarWidget(
                label: 'Studies',
                onTap: () {
                  if(_userType == 'root'){
                    Navigator.of(context).popAndPushNamed(RESEARCHER_MAIN_SCREEN);
                  }
                  if(_userType == 'moderator'){
                    Navigator.of(context).popAndPushNamed(MODERATOR_DASHBOARD_SCREEN);
                  }
                },
                selected: false,
              ),
              SizedBox(
                width: 16.0,
              ),
              _DraftStudySecondaryAppBarWidget(
                label: 'Setup',
                onTap: () => setSubScreen('Setup'),
                selected: _setupSelected,
              ),
              SizedBox(
                width: 16.0,
              ),
              _DraftStudySecondaryAppBarWidget(
                label: 'Users',
                onTap: () => setSubScreen('Users'),
                selected: _usersSelected,
              ),
            ],
          ),
        ),
        Expanded(
          child: _draftSubScreen,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                width: 0.5,
                color: Colors.grey[400],
              )
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RaisedButton(
                onPressed: () => _setStudyAsActive(),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                color: Colors.grey[200],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.checkmark_alt_circle,
                      color: PROJECT_GREEN,
                      size: 14.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'Set as Active',
                      style: TextStyle(
                        color: PROJECT_GREEN,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DraftStudySecondaryAppBarWidget extends StatefulWidget {
  final String label;
  final bool selected;
  final Function onTap;

  const _DraftStudySecondaryAppBarWidget(
      {Key key, this.label, this.selected, this.onTap})
      : super(key: key);

  @override
  __DraftStudySecondaryAppBarWidgetState createState() =>
      __DraftStudySecondaryAppBarWidgetState();
}

class __DraftStudySecondaryAppBarWidgetState
    extends State<_DraftStudySecondaryAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      hoverColor: Colors.white,
      splashColor: Colors.white,
      highlightColor: Colors.white,
      child: Text(
        widget.label,
        style: TextStyle(
          color: widget.selected ? PROJECT_GREEN : Colors.black,
          fontWeight: FontWeight.w900,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
