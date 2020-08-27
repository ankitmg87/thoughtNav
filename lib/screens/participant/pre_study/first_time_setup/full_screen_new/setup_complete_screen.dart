import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/full_screen_new_widgets/custom_flat_button.dart';

class SetupCompleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      backgroundColor: PROJECT_GREEN,
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 600.0
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundColor: Color(0xFFB6ECC7),
                child: Image.asset('images/avatars/batman.png',
                  width: 50,),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Text(
                'Power Wheelchair Study',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Text(
                'Account Setup Complete',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Text(
                'This study is open',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Text(
                'Get started on your first question of the day!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            side: BorderSide(
                              color: Color(0xFF00DD66),
                              width: 4.0,
                            )),
                        onPressed: () {},
                        color: Color(0xFF00DD66),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Answer Questions',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlineButton(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 6.0,
                          style: BorderStyle.solid,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            ),
                        onPressed: () => Navigator.of(context)
                            .pushNamed(DASHBOARD_TIPS_SCREEN),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Continue to Dashboard',
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
            ],
          ),
        ),
      ),
    );
  }
}
