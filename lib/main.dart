import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/confirm_display_profile_screen.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/reward_method_screen.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/select_avatar_screen.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/setup_complete_screen.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/study_details_screen.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/tips_screens/dashboard_tips_screen.dart';
import 'package:thoughtnav/screens/public/login/forgot_password_screen.dart';
import 'package:thoughtnav/screens/public/login/login_screen.dart';
import 'package:thoughtnav/screens/public/login/reset_password_screen.dart';
import 'package:thoughtnav/screens/public/tn_home_screen.dart';

import 'constants/routes/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThoughtNav',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: SCAFFOLD_BACKGROUND_COLOR,
        unselectedWidgetColor: Colors.white,
      ),
      initialRoute: TN_HOME_SCREEN_ROUTE,
      routes: {
        TN_HOME_SCREEN_ROUTE : (context) => TNHomeScreen(),
        LOGIN_SCREEN: (context) => LoginScreen(),
        FORGOT_PASSWORD_SCREEN: (context) => ForgotPasswordScreen(),
        RESET_PASSWORD_SCREEN: (context) => ResetPasswordScreen(),
        STUDY_DETAILS_SCREEN: (context) => StudyDetailsScreen(),
        SELECT_AVATAR_SCREEN: (context) => SelectAvatarScreen(),
        CONFIRM_DISPLAY_PROFILE_SCREEN: (context) => ConfirmDisplayProfileScreen(),
        REWARD_METHOD_SCREEN: (context) => RewardMethodScreen(),
        SETUP_COMPLETE_SCREEN: (context) => SetupCompleteScreen(),
        DASHBOARD_TIPS_SCREEN: (context) => DashboardTipsScreen(),
      },
    );
  }
}
