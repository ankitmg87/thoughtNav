import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/screens/draft_study_sub_screens/draft_study_setup.dart';
import 'package:thoughtnav/screens/researcher/screens/draft_study_sub_screens/draft_study_users.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class DraftStudyScreen extends StatefulWidget {
  @override
  _DraftStudyScreenState createState() => _DraftStudyScreenState();
}

class _DraftStudyScreenState extends State<DraftStudyScreen> {

  final _firebaseFirestoreService = FirebaseFirestoreService();

  String _studyUID = '';
  String _studyName = '';
  String _studyStatus = '';

  bool _setupSelected = true;
  bool _usersSelected = false;

  Widget _draftSubScreen = Container();
  Widget _draftStudySetup;
  Widget _draftStudyUsers;

  void _getStudyDetails() {
    final getStorage = GetStorage();
    _studyUID = getStorage.read('studyUID');
    _studyName = getStorage.read('studyName');
    _studyStatus = getStorage.read('studyStatus');
  }

  void _setStudyAsActive() async {
    await _firebaseFirestoreService.updateStudyStatus(_studyUID, 'Active').then((value){
      Navigator.of(context).pop();
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
                  Navigator.of(context).pop();
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
