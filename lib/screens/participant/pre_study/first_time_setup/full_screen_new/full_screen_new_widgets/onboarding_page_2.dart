// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';

class OnboardingPage2 extends StatefulWidget {
  final Participant participant;
  final TextEditingController phoneNumberController;

  OnboardingPage2({
    Key key,
    this.participant, this.phoneNumberController,
  }) : super(key: key);

  @override
  _OnboardingPage2State createState() => _OnboardingPage2State();
}

class _OnboardingPage2State extends State<OnboardingPage2> {

  final _confirmPasswordKey = GlobalKey<FormState>();

  final _phoneFormatter = MaskTextInputFormatter(mask: '(###) ###-####', filter: {'#' : RegExp(r'[0-9]')});

  int _selectedRadio = 0;

  void _setSelectedRadio(int value) {
    setState(() {
      _selectedRadio = value;
    });
  }

  String _password;
  String _confirmPassword;

  bool _showPassword = false;

  @override
  void initState() {
    if (widget.participant.gender == 'male') {
      _selectedRadio = 1;
    }
    if (widget.participant.gender == 'female') {
      _selectedRadio = 2;
    }
    if (widget.participant.gender == 'other') {
      _selectedRadio = 3;
    }

    _password = widget.participant.password;
    _confirmPassword = widget.participant.password;

    super.initState();
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
                  fontSize: 18.0),
            ),
            SizedBox(
              height: 40.0,
            ),
            Container(
              constraints: BoxConstraints(maxWidth: screenSize.width),
              child: TextFormField(
                initialValue: widget.participant.displayName,
                enabled: false,
                style: TextStyle(
                  fontSize: 14.0,
                ),
                decoration: InputDecoration(
                  labelText: 'Display Name',
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
                initialValue: widget.participant.userFirstName,
                enabled: false,
                style: TextStyle(
                  fontSize: 14.0,
                ),
                decoration: InputDecoration(
                  labelText: 'First Name',
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
                initialValue: widget.participant.userLastName,
                enabled: false,
                style: TextStyle(
                  fontSize: 14.0,
                ),
                decoration: InputDecoration(
                  labelText: 'Last Name',
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
                initialValue: _password,
                onChanged: (password) {
                  _password = password;
                  _confirmPasswordKey.currentState.validate();
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
              child: Form(
                key: _confirmPasswordKey,
                child: TextFormField(
                  validator: (confirmPassword){
                    if(_password != confirmPassword){
                      return 'Passwords do not match';
                    }
                    else {
                      widget.participant.password = _confirmPassword;
                      return null;
                    }
                  },
                  obscureText: !_showPassword,
                  initialValue: widget.participant.password,
                  onChanged: (confirmPassword) {
                    _confirmPassword = confirmPassword;
                    _confirmPasswordKey.currentState.validate();
                  },
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                        size: 16.0,
                        color: Colors.grey[700],
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(
                      fontSize: 14.0,
                    ),
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
                controller: widget.phoneNumberController,
                inputFormatters: [
                  _phoneFormatter
                ],
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Text('Not Selected'),
                    ],
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        constraints: BoxConstraints(maxWidth: 800.0),
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
                    fontSize: 18.0),
              ),
              SizedBox(
                height: 40.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          initialValue: widget.participant.displayName,
                          enabled: false,
                          // onChanged: (displayName) {
                          //   widget.participant.displayName = displayName;
                          // },
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Display Name',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          initialValue: _password,
                          onChanged: (password) {
                            _password = password;
                            _confirmPasswordKey.currentState.validate();
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
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
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
                                Text('Not Selected'),
                              ],
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 40.0,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: 400.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue:
                                  widget.participant.userFirstName,
                                  enabled: false,
                                  onChanged: (userName) {
                                    widget.participant.userFirstName = userName;
                                  },
                                  style: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'First Name',
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  initialValue: widget.participant.userLastName,
                                  enabled: false,
                                  onChanged: (userName) {
                                    widget.participant.userLastName = userName;
                                  },
                                  style: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Last Name',
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: 400.0),
                          child: Form(
                            key: _confirmPasswordKey,
                            child: TextFormField(
                              validator: (confirmPassword){
                                if(_password != confirmPassword){
                                  return 'Passwords do not match';
                                }
                                else {
                                  widget.participant.password = _confirmPassword;
                                  return null;
                                }
                              },
                              obscureText: !_showPassword,
                              initialValue: widget.participant.password,
                              onChanged: (confirmPassword) {
                                _confirmPassword = confirmPassword;
                                _confirmPasswordKey.currentState.validate();
                              },
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
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
                                labelText: 'Confirm Password',
                                labelStyle: TextStyle(
                                  fontSize: 14.0,
                                ),
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
                            controller: widget.phoneNumberController,
                            inputFormatters: [
                              _phoneFormatter
                            ],
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


