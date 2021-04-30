// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';

class ClientOnboardingScreen extends StatefulWidget {
  @override
  _ClientOnboardingScreenState createState() => _ClientOnboardingScreenState();
}

class _ClientOnboardingScreenState extends State<ClientOnboardingScreen> {


  Future<void> _future;

  @override
  void initState() {

    _future = Future.delayed(Duration(seconds: 1));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (screenSize.width > screenSize.height) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'ThoughtNav',
            style: TextStyle(
              color: Colors.black
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(
                  child: Text(
                    'Loading...'
                  ),
                );
                break;
              case ConnectionState.done:
                return Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: screenSize.width * 0.3),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'PREFERENCES',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Text(
                          'You can change your preferences later',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[500],
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        TextFormField(
                          initialValue: 'Email',
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          initialValue: 'Password',
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          initialValue: 'Password',
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          initialValue: 'Phone',
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            labelStyle: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        RaisedButton(
                          onPressed: (){
                            Navigator.of(context).popAndPushNamed(CLIENT_DASHBOARD_SCREEN);
                          },
                          elevation: 4.0,
                          color: PROJECT_GREEN,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0,),
                            child: Text(
                              'CONTINUE',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
                break;
              default:
                return Center(
                  child: Text(
                    'Something went wrong. Please contact administrator'
                  ),
                );
            }
          },
        ),
      );
    } else {
      return Material(
        child: Center(
          child: Text(
            'Please change orientation of the device',
          ),
        ),
      );
    }
  }
}
