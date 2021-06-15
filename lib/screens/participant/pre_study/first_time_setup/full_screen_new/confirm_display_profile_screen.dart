// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/full_screen_new_widgets/custom_information_container.dart';

class ConfirmDisplayProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF333333),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Step 2 of 3',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 600.0,
          ),
          child: ListView(
            children: [
              CustomInformationContainer(
                title: 'Confirm Display Profile',
                subtitle1:
                    'This is an example of how you will respond to questions when you participate in the study.',
                subtitle2:
                    'Post a sample response to continue, or change your display profile.',
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your response',
                      style: TextStyle(
                        color: Color(0xFF7F7F7F),
                        fontSize: 14.0,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          color: Color(0xFF7F7F7F),
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          'Will be visible to everyone',
                          style: TextStyle(
                            color: Color(0xFF7F7F7F),
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10.0,
                        top: 10.0,
                        right: 10.0,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xFFB6ECC7),
                            child: Center(
                              child: Image.asset('images/avatars/batman.png',
                              width: 30,),),
                            radius: 24.0,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            'Batman (Me)',
                            style: TextStyle(
                              color: Color(0xFF7F7F7F),
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: TextField(
                          minLines: 6,
                          maxLines: 7,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Write your response',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Transform.rotate(
                            angle: 2.35619,
                            child: Icon(
                              Icons.attach_file,
                              color: PROJECT_GREEN,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            'Add an attachment',
                            style: TextStyle(
                              color: Color(0xFF7F7F7F),
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: PROJECT_GREEN,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12.0),
                                bottomRight: Radius.circular(12.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Post',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  'Change Display Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: PROJECT_GREEN,
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              // CustomFlatButton(
              //   label: 'Continue',
              //   routeName: REWARD_METHOD_SCREEN,
              // ),
              SizedBox(
                height: 40.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
