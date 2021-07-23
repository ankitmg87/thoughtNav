// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines the forgot password screen which is shown to all users
/// Users can reset their password from this screen

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/string_constants.dart';
import 'package:thoughtnav/services/firebase_auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final _formKey = GlobalKey<FormState>();

  bool _invalidEmail = false;

  final _firebaseAuthService = FirebaseAuthService();

  String _invalidEmailMessage = '';

  String _email;

  bool _checkEmail(String _email) {
    var emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);
    return emailValid;
  }

  void _resetPassword(String email) async {

    if(email == null){
      _invalidEmailMessage = 'Email Id cannot be empty';
      _invalidEmail = true;
      _formKey.currentState.validate();
      return;
    }

    if(email.isEmpty){
      _invalidEmailMessage = 'Email Id cannot be empty';
      _invalidEmail = true;
      _formKey.currentState.validate();
      return;
    }

    if(_checkEmail(email.trim())){
      var status = await _firebaseAuthService.resetPassword(email);
      if(status == null){
        Navigator.pop(context);
      }
      else{
        _invalidEmailMessage = status;
        _invalidEmail = true;
        _formKey.currentState.validate();
      }
    }
    else{
      _invalidEmailMessage = 'Please enter a valid email id';
      _invalidEmail = true;
      _formKey.currentState.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: screenWidth < screenHeight
          ? Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    CupertinoIcons.back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                automaticallyImplyLeading: false,
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
                elevation: 0,
              ),
              body: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 600.0,
                  ),
                  child: ListView(
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
                        height: screenHeight * 0.1,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'Enter your valid email id',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            onChanged: (email) {
                              if (email.trim().isNotEmpty) {
                                _email = email;
                              }
                            },
                            validator: (value) {
                              return _invalidEmailMessage;
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
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlineButton(
                                borderSide: BorderSide(
                                  color: Color(0xFF50D2C3),
                                  width: 6.0,
                                  style: BorderStyle.solid,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                onPressed: () {
                                  _resetPassword(_email);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'CONFIRM',
                                    style: TextStyle(
                                      color: Color(0xFF50D2C3),
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
                  ),
                ),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    CupertinoIcons.back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                automaticallyImplyLeading: false,
                elevation: 0.0,
                backgroundColor: PROJECT_GREEN,
                title: Text(
                  APP_NAME,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(40.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Forgot Your Password?',
                                  style: TextStyle(
                                    color: TEXT_COLOR.withOpacity(0.6),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  'Enter your valid email id',
                                  style: TextStyle(
                                    color: TEXT_COLOR.withOpacity(0.7),
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    onChanged: (email) {
                                      if (email.trim().isNotEmpty) {
                                        _email = email;
                                      }
                                    },
                                    validator: (value) {
                                      return _invalidEmailMessage;
                                    },
                                    keyboardType: TextInputType.emailAddress,
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
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                OutlineButton(
                                  onPressed: () async {
                                    _resetPassword(_email);
                                  },
                                  borderSide: BorderSide(
                                      color: Color(0xFF50D2C3), width: 2.0),
                                  color: Color(0xFF50D2C3),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'CONFIRM',
                                      style: TextStyle(
                                        color: TEXT_COLOR,
                                      ),
                                    ),
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
    );
  }
}
