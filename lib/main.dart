import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/participant/open_study/dashboard/dashboard_screen.dart';
import 'package:thoughtnav/screens/participant/open_study/dashboard/welcome_screen.dart';
import 'package:thoughtnav/screens/participant/open_study/notifications_screen.dart';
import 'package:thoughtnav/screens/participant/open_study/questions/quick_intro_tutorial/quick_intro_complete_screen.dart';
import 'package:thoughtnav/screens/participant/open_study/questions/quick_intro_tutorial/tell_us_your_story_screen.dart';
import 'package:thoughtnav/screens/participant/open_study/set_account/contact_us_screen.dart';
import 'package:thoughtnav/screens/participant/open_study/set_account/user_details.dart';
import 'package:thoughtnav/screens/participant/open_study/set_account/user_peferences_screen.dart';
import 'package:thoughtnav/screens/participant/post_study/post_study_reward_methods_screen.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: SCAFFOLD_BACKGROUND_COLOR,
        unselectedWidgetColor: Colors.white,
      ),
      initialRoute: WELCOME_SCREEN,
      routes: {
        // Public Section

        TN_HOME_SCREEN_ROUTE: (context) => TNHomeScreen(),
        LOGIN_SCREEN: (context) => LoginScreen(),
        FORGOT_PASSWORD_SCREEN: (context) => ForgotPasswordScreen(),
        RESET_PASSWORD_SCREEN: (context) => ResetPasswordScreen(),
        STUDY_DETAILS_SCREEN: (context) => StudyDetailsScreen(),
        SELECT_AVATAR_SCREEN: (context) => SelectAvatarScreen(),
        CONFIRM_DISPLAY_PROFILE_SCREEN: (context) =>
            ConfirmDisplayProfileScreen(),
        REWARD_METHOD_SCREEN: (context) => RewardMethodScreen(),
        SETUP_COMPLETE_SCREEN: (context) => SetupCompleteScreen(),
        DASHBOARD_TIPS_SCREEN: (context) => DashboardTipsScreen(),

        //Participants Section

        WELCOME_SCREEN: (context) => WelcomeScreen(),
        DASHBOARD_SCREEN: (context) => DashboardScreen(),
        NOTIFICATIONS_SCREEN: (context) => NotificationsScreen(),
        POST_STUDY_REWARD_METHODS_SCREEN: (context) => PostStudyRewardMethodsScreen(),
        CONTACT_US_SCREEN: (context) => ContactUsScreen(),
        USER_PREFERENCES_SCREEN: (context) => UserPreferencesScreen(),
        USER_DETAILS_SCREEN: (context) => UserDetailsScreen(),

        //Study Navigator Section

        TELL_US_YOUR_STORY_SCREEN: (context) => TellUsYouStoryScreen(),
        QUICK_INTRO_COMPLETE_SCREEN: (context) => QuickIntroCompleteScreen(),
      },
    );
  }
}
