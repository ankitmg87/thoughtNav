import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/full_screen_new_widgets/custom_avatar_radio_widget.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/full_screen_new_widgets/custom_information_container.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/services/firebase_auth_service.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _firebaseFirestoreService = FirebaseFirestoreService();
  final _firebaseAuthService = FirebaseAuthService();

  int _onboardingPageNumber = 1;

  PageController _pageController;

  String _studyUID;
  String _participantUID;

  Participant _participant;

  Future<Participant> _futureParticipant;

  Future<Participant> _getParticipant() async {
    var getStorage = GetStorage();
    _studyUID = getStorage.read('studyUID');
    _participantUID = getStorage.read('participantUID');
    _participant = await _firebaseFirestoreService.getParticipant(
        _studyUID, _participantUID);
    return _participant;
  }

  Future<void> _updatePasswordAndSaveParticipantDetails() async {

    await _firebaseAuthService.changeUserPassword(_participant.password);

    _participant.isOnboarded = true;
    _participant.isActive = true;
    _participant.isDeleted = false;
    await _firebaseFirestoreService.updateParticipant(
        _studyUID, _participant);
  }

  @override
  void initState() {
    _futureParticipant = _getParticipant();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.9,
    );
    super.initState();
  }

  Widget _buildDesktopBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              _OnboardingPage1(
                participant: _participant,
              ),
              _OnboardingPage2(
                participant: _participant,
              ),
            ],
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
                  _onboardingPageNumber++;
                  _pageController.jumpToPage(2);
                });
                break;
              case 2:
                await _updatePasswordAndSaveParticipantDetails();
                await Navigator.of(context).pushNamedAndRemoveUntil(
                    SETUP_COMPLETE_SCREEN, (route) => false);
                break;
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
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
          child: PageView(
            controller: _pageController,
            children: [
              _OnboardingPage1(
                participant: _participant,
              ),
              _OnboardingPage2(
                participant: _participant,
              ),
            ],
          ),
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
                    _onboardingPageNumber++;
                    _pageController.jumpToPage(2);
                  });
                  break;
                case 2:
                  await _updatePasswordAndSaveParticipantDetails();
                  await Navigator.of(context).pushNamedAndRemoveUntil(
                      DASHBOARD_SCREEN, (route) => false);
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
      ],
    );
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
            if (_onboardingPageNumber > 1) {
              setState(() {
                _onboardingPageNumber--;
                _pageController.jumpToPage(0);
              });
            }
          },
        ),
        title: Text(
          'Step $_onboardingPageNumber of 2',
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
              return screenHeight > screenWidth
                  ? _buildPhoneBody()
                  : _buildDesktopBody();
              break;
            default:
              return SizedBox();
          }
        },
      ),
    );
  }
}

class _OnboardingPage1 extends StatefulWidget {
  final Participant participant;

  const _OnboardingPage1({Key key, this.participant}) : super(key: key);

  @override
  _OnboardingPage1State createState() => _OnboardingPage1State();
}

class _OnboardingPage1State extends State<_OnboardingPage1> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    if (screenSize.height > screenSize.width) {
      return ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: 20.0),
          CustomInformationContainer(
            title: 'Select Your Display Profile',
            subtitle1:
                'Your display profile contains the avatar and username you will be using during the study.',
            subtitle2:
                'You cannot change your selection after your account has been created.',
          ),
          SizedBox(
            width: 40.0,
          ),
          CustomAvatarRadioWidget(
            participant: widget.participant,
          ),
          SizedBox(
            width: 40.0,
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomInformationContainer(
            title: 'Select Your Display Profile',
            subtitle1:
                'Your display profile contains the avatar and username you will be using during the study.',
            subtitle2:
                'You cannot change your selection after your account has been created.',
            width: 400.0,
          ),
          SizedBox(
            width: 40.0,
          ),
          Container(
            width: 2.0,
            color: Colors.grey[300],
            height: 300.0,
          ),
          SizedBox(
            width: 40.0,
          ),
          CustomAvatarRadioWidget(
            participant: widget.participant,
          ),
        ],
      );
    }
  }
}

class _OnboardingPage2 extends StatefulWidget {
  final Participant participant;

  const _OnboardingPage2({Key key, this.participant}) : super(key: key);

  @override
  __OnboardingPage2State createState() => __OnboardingPage2State();
}

class __OnboardingPage2State extends State<_OnboardingPage2> {
  int _selectedRadio = 0;

  void _setSelectedRadio(int value) {
    setState(() {
      _selectedRadio = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    if (screenSize.height > screenSize.width) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        constraints: BoxConstraints(
          maxWidth: screenSize.width,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Your Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18.0
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Container(
              constraints: BoxConstraints(maxWidth: screenSize.width),
              child: TextFormField(
                onChanged: (alias) {
                  widget.participant.alias = alias;
                },
                style: TextStyle(
                  fontSize: 14.0,
                ),
                decoration: InputDecoration(
                  labelText: 'Alias',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              constraints: BoxConstraints(maxWidth: screenSize.width),
              child: TextFormField(
                onChanged: (userName) {
                  widget.participant.userName = userName;
                },
                style: TextStyle(
                  fontSize: 14.0,
                ),
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              constraints: BoxConstraints(maxWidth: screenSize.width),
              child: TextFormField(
                onChanged: (password) {
                  widget.participant.password = password;
                },
                style: TextStyle(
                  fontSize: 14.0,
                ),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              constraints: BoxConstraints(maxWidth: screenSize.width),
              child: TextFormField(
                obscureText: true,
                onChanged: (confirmPassword) {
                  widget.participant.password = confirmPassword;
                },
                style: TextStyle(
                  fontSize: 14.0,
                ),
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              constraints: BoxConstraints(maxWidth: screenSize.width),
              child: TextFormField(
                onChanged: (phone) {
                  widget.participant.phone = phone;
                },
                style: TextStyle(
                  fontSize: 14.0,
                ),
                decoration: InputDecoration(
                  labelText: 'Phone',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              constraints: BoxConstraints(maxWidth: screenSize.width),
              child: Row(
                children: [
                  Text(
                    'Gender: ',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Theme(
                        data: ThemeData(
                          disabledColor: Colors.grey[400],
                          accentColor: PROJECT_NAVY_BLUE,
                        ),
                        child: Radio(
                          value: 1,
                          groupValue: _selectedRadio,
                          onChanged: (value) {
                            _setSelectedRadio(value);
                            widget.participant.gender = 'male';
                          },
                        ),
                      ),
                      Text('Male'),
                    ],
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Theme(
                        data: ThemeData(
                          disabledColor: Colors.grey[400],
                          accentColor: PROJECT_NAVY_BLUE,
                        ),
                        child: Radio(
                          value: 2,
                          groupValue: _selectedRadio,
                          onChanged: (value) {
                            _setSelectedRadio(value);
                            widget.participant.gender = 'female';
                          },
                        ),
                      ),
                      Text('Female'),
                    ],
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Theme(
                        data: ThemeData(
                          disabledColor: Colors.grey[400],
                          accentColor: PROJECT_NAVY_BLUE,
                        ),
                        child: Radio(
                          value: 3,
                          groupValue: _selectedRadio,
                          onChanged: (value) {
                            _setSelectedRadio(value);
                            widget.participant.gender = 'other';
                          },
                        ),
                      ),
                      Text('Other'),
                    ],
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: TextFormField(
                      onChanged: (age) {
                        widget.participant.age = age;
                      },
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Age',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(20.0),
        constraints: BoxConstraints(maxWidth: 700.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Your Details',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: 400.0),
                        child: TextFormField(
                          onChanged: (alias) {
                            widget.participant.alias = alias;
                          },
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Alias',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 400.0),
                        child: TextFormField(
                          onChanged: (password) {
                            widget.participant.password = password;
                          },
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 400.0),
                        child: Row(
                          children: [
                            Text(
                              'Gender: ',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Theme(
                                  data: ThemeData(
                                    disabledColor: Colors.grey[400],
                                    accentColor: PROJECT_NAVY_BLUE,
                                  ),
                                  child: Radio(
                                    value: 1,
                                    groupValue: _selectedRadio,
                                    onChanged: (value) {
                                      _setSelectedRadio(value);
                                      widget.participant.gender = 'male';
                                    },
                                  ),
                                ),
                                Text('Male'),
                              ],
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Theme(
                                  data: ThemeData(
                                    disabledColor: Colors.grey[400],
                                    accentColor: PROJECT_NAVY_BLUE,
                                  ),
                                  child: Radio(
                                    value: 2,
                                    groupValue: _selectedRadio,
                                    onChanged: (value) {
                                      _setSelectedRadio(value);
                                      widget.participant.gender = 'female';
                                    },
                                  ),
                                ),
                                Text('Female'),
                              ],
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Theme(
                                  data: ThemeData(
                                    disabledColor: Colors.grey[400],
                                    accentColor: PROJECT_NAVY_BLUE,
                                  ),
                                  child: Radio(
                                    value: 3,
                                    groupValue: _selectedRadio,
                                    onChanged: (value) {
                                      _setSelectedRadio(value);
                                      widget.participant.gender = 'other';
                                    },
                                  ),
                                ),
                                Text('Other'),
                              ],
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: TextFormField(
                                onChanged: (age) {
                                  widget.participant.age = age;
                                },
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Age',
                                  labelStyle: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 40.0,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: 400.0),
                        child: TextFormField(
                          onChanged: (userName) {
                            widget.participant.userName = userName;
                          },
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 400.0),
                        child: TextFormField(
                          obscureText: true,
                          onChanged: (confirmPassword) {
                            widget.participant.password = confirmPassword;
                          },
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 400.0),
                        child: TextFormField(
                          onChanged: (phone) {
                            widget.participant.phone = phone;
                          },
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
