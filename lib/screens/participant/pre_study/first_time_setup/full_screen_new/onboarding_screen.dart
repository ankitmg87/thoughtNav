import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/full_screen_new_widgets/onboarding_page_1.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/services/firebase_auth_service.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/participant_firestore_service.dart';

import 'full_screen_new_widgets/onboarding_page_2.dart';
import 'full_screen_new_widgets/onboarding_page_3.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _firebaseFirestoreService = FirebaseFirestoreService();
  final _firebaseAuthService = FirebaseAuthService();

  final _participantFirestoreService = ParticipantFirestoreService();

  final _phoneNumberController = TextEditingController();

  int _onboardingPageNumber = 1;

  String _studyUID;
  String _participantUID;

  String _previousPassword;
  String _newPassword;

  Participant _participant;

  Future<Participant> _futureParticipant;

  Widget _selectedPage;

  Widget _onboardingPage1;

  Future<Participant> _getParticipant() async {
    var getStorage = GetStorage();
    _studyUID = getStorage.read('studyUID');
    _participantUID = getStorage.read('participantUID');
    _participant = await _firebaseFirestoreService.getParticipant(
        _studyUID, _participantUID);

    _previousPassword = _participant.password;

    _onboardingPage1 = OnboardingPage1(
      participant: _participant,
      participantFirestoreService: _participantFirestoreService,
    );

    _selectedPage = _onboardingPage1;

    return _participant;
  }

  void unAwaited(Future<void> future) {}

  Future<void> _updatePasswordAndSaveParticipantDetails() async {
    var dialogContext;

    _newPassword = _participant.password;

    unAwaited(
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
      try {
        await _firebaseAuthService
            .changeUserPassword(_newPassword)
            .then((value) async {
          await _firebaseFirestoreService.updateAvatarAndDisplayNameStatus(
              _studyUID, _participant.profilePhotoURL);

          _participant.isOnboarded = true;
          _participant.isActive = true;
          _participant.isDeleted = false;

          await _firebaseFirestoreService.updateParticipant(
              _studyUID, _participant);
        });
      } catch (e) {
        if (e.code == 'requires-recent-login') {
          await _firebaseAuthService.signInUser(
              _participant.email, _previousPassword);
          await _firebaseAuthService.changeUserPassword(_newPassword);

          await _firebaseFirestoreService.updateAvatarAndDisplayNameStatus(
              _studyUID, _participant.profilePhotoURL);

          _participant.isOnboarded = true;
          _participant.isActive = true;
          _participant.isDeleted = false;

          await _firebaseFirestoreService.updateParticipant(
              _studyUID, _participant);
        }
      }
    } else {
      await _firebaseFirestoreService.updateAvatarAndDisplayNameStatus(
          _studyUID, _participant.profilePhotoURL);

      _participant.isOnboarded = true;
      _participant.isActive = true;
      _participant.isDeleted = false;

      await _firebaseFirestoreService.updateParticipant(
          _studyUID, _participant);
    }

    Navigator.of(dialogContext).pop();
  }

  @override
  void initState() {
    _futureParticipant = _getParticipant();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF333333),
          ),
          onPressed: () {
            switch (_onboardingPageNumber) {
              case 1:
                break;
              case 2:
                setState(() {
                  _onboardingPageNumber = 1;
                  _selectedPage = _onboardingPage1;
                });
                break;
              case 3:
                setState(() {
                  _onboardingPageNumber = 2;
                  _selectedPage = OnboardingPage2(
                    participant: _participant,
                    phoneNumberController: _phoneNumberController,
                  );
                });
            }
          },
        ),
        title: Text(
          'Step $_onboardingPageNumber of 3',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _futureParticipant,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(
                child: Text('Loading...'),
              );
              break;
            case ConnectionState.done:
              if (screenHeight > screenWidth) {
                return _buildPhoneBody();
              } else {
                return _buildDesktopBody();
              }
              break;
            default:
              return SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildDesktopBody() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: _selectedPage,
          ),
        ),
        SizedBox(
          height: 40.0,
        ),
        FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          color: PROJECT_GREEN,
          onPressed: () async {
            switch (_onboardingPageNumber) {
              case 1:
                setState(() {
                  _onboardingPageNumber = 2;
                  _selectedPage = OnboardingPage2(
                    participant: _participant,
                    phoneNumberController: _phoneNumberController,
                  );
                });
                break;
              case 2:
                if (_phoneNumberController.value.text.trim().isEmpty) {
                  await showGeneralDialog(
                      barrierDismissible: true,
                      barrierLabel: 'Enter Phone number',
                      context: context,
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return Center(
                          child: Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                'Please enter phone number',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }
                else if (_participant.gender == null){
                  await showGeneralDialog(
                      barrierDismissible: true,
                      barrierLabel: 'Enter Gender',
                      context: context,
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return Center(
                          child: Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                'Please enter gender',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }
                else {
                  setState(() {
                    _onboardingPageNumber = 3;
                    _selectedPage = OnboardingPage3(
                      participant: _participant,
                    );
                  });
                }
                break;
              case 3:
                await _updatePasswordAndSaveParticipantDetails();
                await Navigator.of(context).pushNamedAndRemoveUntil(
                    SETUP_COMPLETE_SCREEN, (route) => false);
                break;
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 60.0,
              vertical: 10.0,
            ),
            child: Text(
              _onboardingPageNumber > 2 ? 'LET\'S GET STARTED' : 'CONTINUE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 40.0,
        ),
      ],
    );
  }

  Widget _buildPhoneBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: _selectedPage,
        ),
        SizedBox(
          height: 40.0,
        ),
        Center(
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            color: PROJECT_GREEN,
            onPressed: () async {
              switch (_onboardingPageNumber) {
                case 1:
                  setState(() {
                    _onboardingPageNumber = 2;
                    _selectedPage = OnboardingPage2(
                      participant: _participant,
                    );
                  });
                  break;
                case 2:
                  setState(() {
                    _onboardingPageNumber = 3;
                    _selectedPage = OnboardingPage3(
                      participant: _participant,
                    );
                  });
                  break;
                case 3:
                  await _updatePasswordAndSaveParticipantDetails();
                  await Navigator.of(context).pushNamedAndRemoveUntil(
                      SETUP_COMPLETE_SCREEN, (route) => false);
                  break;
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 16.0),
              child: Text(
                _onboardingPageNumber > 1 ? 'LET\'S GET STARTED' : 'CONTINUE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}
