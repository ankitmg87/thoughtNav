import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/constants/string_constants.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/services/firebase_auth_service.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class UserPreferencesScreen extends StatefulWidget {
  @override
  _UserPreferencesScreenState createState() => _UserPreferencesScreenState();
}

class _UserPreferencesScreenState extends State<UserPreferencesScreen> {
  final _firebaseFirestoreService = FirebaseFirestoreService();
  final _firebaseAuthService = FirebaseAuthService();

  final _passwordAndPhoneKey = GlobalKey<FormState>();

  final _phoneFormatter = MaskTextInputFormatter(
      mask: '(###) ###-####', filter: {'#': RegExp(r'[0-9]')});

  String _studyUID;
  String _participantUID;
  String _studyName;

  String _newPassword = '';
  String _previousPassword;
  String _newPhoneNumber = '';
  String _previousPhoneNumber;

  Participant _participant;

  Future<Participant> _getParticipant() async {
    _participant = await _firebaseFirestoreService.getParticipant(
        _studyUID, _participantUID);
    _newPassword = _participant.password;
    _previousPassword = _participant.password;
    _newPhoneNumber = _participant.phone;
    _previousPhoneNumber = _participant.phone;

    return _participant;
  }

  void _unAwaited(Future<void> future) {}

  Future<void> _updateParticipantDetails() async {
    var dialogContext;

    _unAwaited(
      showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          dialogContext = context;
          return Center(
            child: Material(
              borderRadius: BorderRadius.circular(4.0),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  'Please Wait',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    if (_newPassword != _previousPassword) {
      _participant.password = _newPassword;

      try {
        await _firebaseAuthService
            .changeUserPassword(_newPassword)
            .then((value) async {
          await _firebaseFirestoreService.updateParticipant(
              _studyUID, _participant);
        });
      } catch (e) {
        if (e.code == 'requires-recent-login') {
          await _firebaseAuthService.signInUser(
              _participant.email, _previousPassword);
          await _firebaseAuthService.changeUserPassword(_newPassword);
          await _firebaseFirestoreService.updateParticipant(
              _studyUID, _participant);
        }
      }
    }

    if (_newPhoneNumber != _previousPhoneNumber) {
      _participant.phone = _newPhoneNumber;

      await _firebaseFirestoreService.updateParticipant(
          _studyUID, _participant);
    }

    Navigator.of(dialogContext).pop();
  }

  @override
  void initState() {
    var getStorage = GetStorage();
    _studyUID = getStorage.read('studyUID');
    _participantUID = getStorage.read('participantUID');
    _studyName = getStorage.read('studyName');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (screenSize.height > screenSize.width) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN);
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
            ),
          ),
          title: Text(
            'Preferences',
            style: TextStyle(
              color: TEXT_COLOR,
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: _getParticipant(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return SizedBox();
                break;
              case ConnectionState.done:
                return ListView(
                  children: [
                    Align(
                      child: Container(
                        width: screenSize.height > screenSize.width
                            ? double.maxFinite
                            : screenSize.width * 0.5,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 20.0,
                        ),
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: snapshot.data.profilePhotoURL,
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  padding: EdgeInsets.all(6.0),
                                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: PROJECT_LIGHT_GREEN,
                                  ),
                                  child: Image(
                                    width: 20.0,
                                    image: imageProvider,
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${snapshot.data.userFirstName} ${snapshot.data.userLastName}',
                                  style: TextStyle(
                                    color: TEXT_COLOR,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Text(
                                  snapshot.data.displayName,
                                  style: TextStyle(
                                    color: TEXT_COLOR,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      child: Container(
                        color: Colors.white,
                        width: screenSize.height > screenSize.width
                            ? double.maxFinite
                            : screenSize.width * 0.5,
                        padding: EdgeInsets.only(
                          left: 30.0,
                          right: 30.0,
                          top: 30.0,
                          bottom: 50.0,
                        ),
                        child: Column(
                          children: [
                            _CustomRow(
                              label: 'Display Name',
                              value: snapshot.data.displayName,
                            ),
                            _CustomRow(
                              label: 'Email Address',
                              value: snapshot.data.email,
                            ),
                            _CustomRow(
                              label: 'Group',
                              value: snapshot.data.userGroupName,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: double.infinity,
                              color: Colors.grey[300],
                              height: 0.5,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            _CustomRow(
                              label: 'Full Name',
                              value:
                                  '${snapshot.data.userFirstName} ${snapshot.data.userLastName}',
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      'Password',
                                      style: TextStyle(
                                        color: TEXT_COLOR.withOpacity(0.6),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: snapshot.data.password,
                                    onChanged: (password) {
                                      _newPassword = password;
                                    },
                                    decoration: InputDecoration(
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        fillColor: Colors.grey[100]),
                                    style: TextStyle(
                                      color: TEXT_COLOR,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      'Phone',
                                      style: TextStyle(
                                        color: TEXT_COLOR.withOpacity(0.6),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      _phoneFormatter,
                                    ],
                                    initialValue: snapshot.data.phone,
                                    onChanged: (phoneNumber) {
                                      _newPhoneNumber = phoneNumber;
                                    },
                                    decoration: InputDecoration(
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        fillColor: Colors.grey[100]),
                                    style: TextStyle(
                                      color: TEXT_COLOR,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            FlatButton(
                              color: PROJECT_GREEN,
                              child: Text(
                                'SAVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                if (_newPassword.trim().isEmpty) {
                                  await showGeneralDialog(
                                    context: context,
                                    barrierLabel: 'Empty Password',
                                    barrierDismissible: true,
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) {
                                      return Center(
                                        child: Material(
                                          child: Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Text(
                                              'Password cannot be empty',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else if (_newPassword.trim().length < 6) {
                                  showGeneralDialog(
                                    context: context,
                                    barrierLabel: 'Incomplete Password',
                                    barrierDismissible: true,
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) {
                                      return Center(
                                        child: Material(
                                          child: Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Text(
                                              'Password cannot have less than 6 charcters',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else if (_newPhoneNumber.trim().isEmpty) {
                                  await showGeneralDialog(
                                    context: context,
                                    barrierLabel: 'Empty Phone',
                                    barrierDismissible: true,
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) {
                                      return Center(
                                        child: Material(
                                          child: Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Text(
                                              'Phone cannot be empty',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  if (_newPhoneNumber != _previousPhoneNumber ||
                                      _newPassword != _previousPassword) {
                                    await _updateParticipantDetails();
                                  }
                                  await Navigator.of(context).popAndPushNamed(
                                      PARTICIPANT_DASHBOARD_SCREEN);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
                break;
              default:
                return SizedBox();
            }
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: Center(
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN);
              },
              child: Text(
                APP_NAME,
                style: TextStyle(
                  color: TEXT_COLOR,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ),
          leadingWidth: 120.0,
          title: Text(
            _studyName,
            style: TextStyle(
              color: TEXT_COLOR,
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: _getParticipant(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return SizedBox();
                break;
              case ConnectionState.done:
                return ListView(
                  children: [
                    Align(
                      child: Container(
                        width: screenSize.height > screenSize.width
                            ? double.maxFinite
                            : screenSize.width * 0.5,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 20.0,
                        ),
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: snapshot.data.profilePhotoURL,
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  padding: EdgeInsets.all(6.0),
                                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: PROJECT_LIGHT_GREEN,
                                  ),
                                  child: Image(
                                    width: 20.0,
                                    image: imageProvider,
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${snapshot.data.userFirstName} ${snapshot.data.userLastName}',
                                  style: TextStyle(
                                    color: TEXT_COLOR,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Text(
                                  snapshot.data.displayName,
                                  style: TextStyle(
                                    color: TEXT_COLOR,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      child: Container(
                        color: Colors.white,
                        width: screenSize.height > screenSize.width
                            ? double.maxFinite
                            : screenSize.width * 0.5,
                        padding: EdgeInsets.only(
                          left: 30.0,
                          right: 30.0,
                          top: 30.0,
                          bottom: 50.0,
                        ),
                        child: Column(
                          children: [
                            _CustomRow(
                              label: 'Display Name',
                              value: snapshot.data.displayName,
                            ),
                            _CustomRow(
                              label: 'Email Address',
                              value: snapshot.data.email,
                            ),
                            _CustomRow(
                              label: 'Group',
                              value: snapshot.data.userGroupName,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: double.infinity,
                              color: Colors.grey[300],
                              height: 0.5,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            _CustomRow(
                              label: 'Full Name',
                              value:
                                  '${snapshot.data.userFirstName} ${snapshot.data.userLastName}',
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      'Password',
                                      style: TextStyle(
                                        color: TEXT_COLOR.withOpacity(0.6),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: snapshot.data.password,
                                    onChanged: (password) {
                                      _newPassword = password;
                                    },
                                    decoration: InputDecoration(
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        fillColor: Colors.grey[100]),
                                    style: TextStyle(
                                      color: TEXT_COLOR,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      'Phone',
                                      style: TextStyle(
                                        color: TEXT_COLOR.withOpacity(0.6),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      _phoneFormatter,
                                    ],
                                    initialValue: snapshot.data.phone,
                                    onChanged: (phoneNumber) {
                                      _newPhoneNumber = phoneNumber;
                                    },
                                    decoration: InputDecoration(
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        fillColor: Colors.grey[100]),
                                    style: TextStyle(
                                      color: TEXT_COLOR,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            FlatButton(
                              color: PROJECT_GREEN,
                              child: Text(
                                'SAVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                if (_newPassword.trim().isEmpty) {
                                  await showGeneralDialog(
                                    context: context,
                                    barrierLabel: 'Empty Password',
                                    barrierDismissible: true,
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) {
                                      return Center(
                                        child: Material(
                                          child: Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Text(
                                              'Password cannot be empty',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else if (_newPassword.trim().length < 6) {
                                  showGeneralDialog(
                                    context: context,
                                    barrierLabel: 'Incomplete Password',
                                    barrierDismissible: true,
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) {
                                      return Center(
                                        child: Material(
                                          child: Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Text(
                                              'Password cannot have less than 6 charcters',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else if (_newPhoneNumber.trim().isEmpty) {
                                  await showGeneralDialog(
                                    context: context,
                                    barrierLabel: 'Empty Phone',
                                    barrierDismissible: true,
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) {
                                      return Center(
                                        child: Material(
                                          child: Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Text(
                                              'Phone cannot be empty',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  if (_newPhoneNumber != _previousPhoneNumber ||
                                      _newPassword != _previousPassword) {
                                    await _updateParticipantDetails();
                                  }
                                  await Navigator.of(context).popAndPushNamed(
                                      PARTICIPANT_DASHBOARD_SCREEN);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
}

class _CustomRow extends StatelessWidget {
  final String label;
  final String value;

  const _CustomRow({
    Key key,
    this.label,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(12.0),
            child: Text(
              label,
              style: TextStyle(
                color: TEXT_COLOR.withOpacity(0.6),
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                color: TEXT_COLOR,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
