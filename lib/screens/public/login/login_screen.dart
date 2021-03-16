import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/constants/string_constants.dart';
import 'package:thoughtnav/models/user.dart';
import 'package:thoughtnav/services/client_firestore_service.dart';
import 'package:thoughtnav/services/firebase_auth_service.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _invalidEmail = false;
  bool _invalidPassword = false;

  bool _rememberMe = false;

  bool _showPassword = true;

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final FirebaseFirestoreService _firebaseFirestoreService =
      FirebaseFirestoreService();

  final _clientFirestoreService = ClientFirestoreService();

  final _researcherModeratorFirestoreService = ResearcherAndModeratorFirestoreService();

  String _email;
  String _password;

  void unAwaited(Future<void> future) {}

  bool _checkEmail(String _email) {
    var emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);
    return emailValid;
  }

  void _loginAndRedirectUser(BuildContext _context) async {
    var dialogContext;
    User user;

    String userID;

    if (_email != null && _password != null) {
      if (_checkEmail(_email.trim()) && _password.trim().isNotEmpty) {
        unAwaited(
          showGeneralDialog(
            context: _context,
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
                      'Signing In...',
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

        userID = await _firebaseAuthService.signInUser(
            _email.trim(), _password.trim());

        if (userID == 'user-not-found') {
          print('User not Found');
          _invalidEmail = true;
          _invalidPassword = true;
          _formKey.currentState.validate();
          Navigator.of(dialogContext).pop();
        } else if (userID == 'wrong-password') {
          print('Invalid Password');
          if (_invalidEmail) {
            _invalidEmail = false;
          }
          _invalidPassword = true;
          _formKey.currentState.validate();
          Navigator.of(dialogContext).pop();
        } else {
          user = await _firebaseFirestoreService.getUser(userID);

          Navigator.of(dialogContext).pop();

          switch (user.userType) {
            case USER_TYPE_ROOT_USER:

              var getStorage = GetStorage();
              await getStorage.write('userType', 'root');

              await Navigator.of(context).pushNamedAndRemoveUntil(
                  RESEARCHER_MAIN_SCREEN, (route) => false);
              break;
            case USER_TYPE_CLIENT:
              var client = await _clientFirestoreService.getClient(
                  user.studyUID, userID);

              if (client.isOnboarded) {
                var getStorage = GetStorage();
                await getStorage.write('studyUID', user.studyUID);
                await getStorage.write('clientUID', client.clientUID);
                await getStorage.write('userType', 'client');

                await Navigator.of(context).pushNamedAndRemoveUntil(
                    CLIENT_DASHBOARD_SCREEN, (route) => false);
              } else {
                var getStorage = GetStorage();
                await getStorage.write('studyUID', user.studyUID);
                await getStorage.write('clientUID', client.clientUID);
                await getStorage.write('userType', 'client');

                await Navigator.of(context).pushNamedAndRemoveUntil(
                    CLIENT_DASHBOARD_SCREEN, (route) => false);
              }
              break;
            case USER_TYPE_MODERATOR:
              var getStorage = GetStorage();

              var moderator = await _researcherModeratorFirestoreService.getModerator(userID);

              await getStorage.write('moderatorUID', moderator.moderatorUID);
              await getStorage.write('userType', 'moderator');

              await Navigator.of(context).pushNamedAndRemoveUntil(
                  MODERATOR_DASHBOARD_SCREEN, (route) => false);
              break;

            case USER_TYPE_PARTICIPANT:
              var participant = await _firebaseFirestoreService.getParticipant(
                  user.studyUID, userID);
              var study = await _firebaseFirestoreService.getStudy(user.studyUID);
              if(study.studyStatus == 'Active' || study.studyStatus == 'Completed'){
                if(participant.isDeleted){
                  var getStorage = GetStorage();
                  await getStorage.write('studyUID', user.studyUID);
                  await getStorage.write('participantUID', user.userUID);
                  await Navigator.of(context).pushNamedAndRemoveUntil(STUDY_ENDED_SCREEN, (route) => false);
                }
                if (participant.isOnboarded) {
                  var getStorage = GetStorage();
                  await getStorage.write('studyUID', user.studyUID);
                  await getStorage.write('participantUID', user.userUID);
                  await Navigator.of(context).pushNamedAndRemoveUntil(
                      PARTICIPANT_DASHBOARD_SCREEN, (route) => false);
                  break;
                }
                if (!participant.isOnboarded) {
                  var getStorage = GetStorage();
                  await getStorage.write('studyUID', user.studyUID);
                  await getStorage.write('participantUID', user.userUID);
                  await Navigator.of(context).pushNamedAndRemoveUntil(
                      STUDY_DETAILS_SCREEN, (route) => false);
                  break;
                }
              }
              if(study.studyStatus == 'Closed' || study.studyStatus == 'Draft'){
                var getStorage = GetStorage();
                await getStorage.write('studyUID', user.studyUID);
                await Navigator.of(context).pushNamedAndRemoveUntil(STUDY_ENDED_SCREEN, (route) => false);
              }
              break;
          }
        }
      } else {
        _invalidEmail = true;
        _invalidPassword = true;
        _formKey.currentState.validate();
        Navigator.of(dialogContext).pop();
      }
    } else {
      _formKey.currentState.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < screenHeight) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: PROJECT_GREEN,
          title: Text(
            APP_NAME,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 30.0,
            ),
            constraints: BoxConstraints(
              maxWidth: 600.0,
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 600.0,
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: 600.0,
                          height: 250.0,
                        ),
                        Positioned(
                          left: 0.0,
                          bottom: 0.0,
                          child: Image.asset(
                            'images/login_screen_left.png',
                            width: 175.0,
                          ),
                        ),
                        Positioned(
                          bottom: 5.0,
                          right: 0.0,
                          child: Image.asset(
                            'images/login_screen_right.png',
                            width: 175.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  APP_NAME,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                Text(
                  'ThoughtNav is an online focus group platform.\nResearchers use ThoughtNav to get quality\ninsights from participants like you!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                GestureDetector(
                  child: Text(
                    'Learn More',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF00CC66),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: screenHeight * 0.05),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Email Id cannot be empty';
                                } else if (!_checkEmail(value) ||
                                    _invalidEmail) {
                                  return 'Please enter a valid email id';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                              ),
                              onChanged: (email) {
                                _email = email;
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'Password',
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            TextFormField(
                              validator: (passwordValue) {
                                if (passwordValue.isEmpty) {
                                  return 'Password cannot be empty';
                                } else if (_invalidPassword) {
                                  return 'Password is invalid';
                                } else {
                                  return null;
                                }
                              },
                              obscureText: _showPassword,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: Icon(
                                    _showPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 16.0,
                                    color: Colors.grey[700],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                              ),
                              onChanged: (password) {
                                _password = password;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Theme(
                            data: ThemeData(accentColor: PROJECT_NAVY_BLUE),
                            child: Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value;
                                });
                              },
                            ),
                          ),
                          Text(
                            'Remember Me',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(FORGOT_PASSWORD_SCREEN);
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          color: PROJECT_GREEN,
                          onPressed: () {
                            _loginAndRedirectUser(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'LOGIN',
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
                  height: 40.0,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: PROJECT_GREEN,
          title: Text(
            APP_NAME,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 336.0,
                          height: 198.0,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                child: Image(
                                  image: AssetImage(
                                    'images/login_screen_left.png',
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 21.0,
                                right: 50.0,
                                bottom: 19.0,
                                child: Image(
                                  image: AssetImage(
                                    'images/login_screen_right.png',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          APP_NAME,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TEXT_COLOR.withOpacity(0.6),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'ThoughtNav is an online focus group platform.'
                          '\nResearchers use ThoughtNav to get quality'
                          '\ninsights from participants like you!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        GestureDetector(
                          child: Text(
                            'Learn More',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF00CC66),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 30.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Text(
                                          'Email',
                                          style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Email Id cannot be empty';
                                          } else if (!_checkEmail(value) ||
                                              _invalidEmail) {
                                            return 'Please enter a valid email id';
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                        ),
                                        onChanged: (email) {
                                          _email = email;
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Text(
                                          'Password',
                                          style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        validator: (passwordValue) {
                                          if (passwordValue.isEmpty) {
                                            return 'Password cannot be empty';
                                          } else if (_invalidPassword) {
                                            return 'Password is invalid';
                                          } else {
                                            return null;
                                          }
                                        },
                                        obscureText: _showPassword,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            hoverColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            icon: Icon(
                                              _showPassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              size: 16.0,
                                              color: Colors.grey[700],
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _showPassword = !_showPassword;
                                              });
                                            },
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                        ),
                                        onChanged: (password) {
                                          _password = password;
                                        },
                                        onFieldSubmitted: (password) {
                                          _loginAndRedirectUser(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Theme(
                                      data: ThemeData(
                                          accentColor: PROJECT_NAVY_BLUE),
                                      child: Checkbox(
                                        value: _rememberMe,
                                        tristate: false,
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberMe = value;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4.0,
                                    ),
                                    Text(
                                      'Remember Me',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(FORGOT_PASSWORD_SCREEN);
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  color: PROJECT_GREEN,
                                  onPressed: () {
                                    _loginAndRedirectUser(context);
                                    // sendMail();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image(
                                          width: 20.0,
                                          image: AssetImage(
                                            'images/login_section_images/login_button_icon.png',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          'LOGIN',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
