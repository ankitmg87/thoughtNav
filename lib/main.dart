// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/client/client_dashboard_screen.dart';
import 'package:thoughtnav/screens/client/client_onboarding_screen.dart';
import 'package:thoughtnav/screens/client/client_preferences_screen.dart';
import 'package:thoughtnav/screens/client/client_responses_screen.dart';
import 'package:thoughtnav/screens/moderator/moderator_dashboard_screen.dart';
import 'package:thoughtnav/screens/moderator/moderator_preferences_screen.dart';
import 'package:thoughtnav/screens/participant/open_study/dashboard/participant_dashboard_screen.dart';
import 'package:thoughtnav/screens/participant/open_study/notifications_screen.dart';
import 'package:thoughtnav/screens/participant/open_study/questions/participant_responses_screen.dart';
import 'package:thoughtnav/screens/participant/open_study/questions/quick_intro_tutorial/quick_intro_complete_screen.dart';
import 'package:thoughtnav/screens/participant/open_study/set_account/contact_us_screen.dart';
import 'package:thoughtnav/screens/participant/open_study/set_account/user_preferences_screen.dart';
import 'package:thoughtnav/screens/participant/post_study/post_study_reward_methods_screen.dart';
import 'package:thoughtnav/screens/participant/post_study/study_ended_screen.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/onboarding_screen.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/setup_complete_screen.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/study_details_screen.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/tips_screens/dashboard_tips_screen.dart';
import 'package:thoughtnav/screens/public/login/forgot_password_screen.dart';
import 'package:thoughtnav/screens/public/login/login_screen.dart';
import 'package:thoughtnav/screens/public/tn_home_screen.dart';
import 'package:thoughtnav/screens/researcher/researcher_main_screen.dart';
import 'package:thoughtnav/screens/researcher/screens/draft_study_screen.dart';
import 'package:thoughtnav/screens/researcher/screens/responses_screen.dart';
import 'package:thoughtnav/screens/researcher/screens/moderator_study_screen.dart';

import 'constants/routes/routes.dart';


void main() async {
  await GetStorage.init();
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
        fontFamily: 'Sofia',
      ),
      initialRoute: TN_HOME_SCREEN_ROUTE,
      routes: {
        // Public Section
        TN_HOME_SCREEN_ROUTE: (context) => TNHomeScreen(),
        LOGIN_SCREEN: (context) => LoginScreen(),
        FORGOT_PASSWORD_SCREEN: (context) => ForgotPasswordScreen(),
        STUDY_DETAILS_SCREEN: (context) => StudyDetailsScreen(),
        ONBOARDING_SCREEN: (context) => OnboardingScreen(),
        SETUP_COMPLETE_SCREEN: (context) => SetupCompleteScreen(),
        DASHBOARD_TIPS_SCREEN: (context) => DashboardTipsScreen(),

        //Participants Section
        PARTICIPANT_DASHBOARD_SCREEN: (context) => ParticipantDashboardScreen(),
        NOTIFICATIONS_SCREEN: (context) => NotificationsScreen(),
        POST_STUDY_REWARD_METHODS_SCREEN: (context) =>
            PostStudyRewardMethodsScreen(),
        CONTACT_US_SCREEN: (context) => ContactUsScreen(),
        USER_PREFERENCES_SCREEN: (context) => UserPreferencesScreen(),

        //Study Navigator Section
        PARTICIPANT_RESPONSES_SCREEN: (context) => ParticipantResponseScreen(),
        TOPIC_COMPLETE_SCREEN: (context) => TopicCompleteScreen(),

        //Study End
        STUDY_ENDED_SCREEN: (context) => StudyEndedScreen(),

        //Researcher Section
        RESEARCHER_MAIN_SCREEN: (context) => ResearcherMainScreen(),

        //Client and Moderator Study Dashboard
        MODERATOR_STUDY_SCREEN: (context) => ModeratorStudyScreen(),
        MODERATOR_DASHBOARD_SCREEN: (context) => ModeratorDashboardScreen(),
        MODERATOR_PREFERENCES_SCREEN: (context) => ModeratorPreferencesScreen(),

        //Client and Moderator Responses Screen
        CLIENT_MODERATOR_RESPONSES_SCREEN: (context) => ResponsesScreen(),

        //Draft Study Screen
        DRAFT_STUDY_SCREEN: (context) => DraftStudyScreen(),

        // Client screens
        CLIENT_ONBOARDING_SCREEN: (context) => ClientOnboardingScreen(),
        CLIENT_DASHBOARD_SCREEN: (context) => ClientDashboardScreen(),
        CLIENT_PREFERENCES_SCREEN: (context) => ClientPreferencesScreen(),
        CLIENT_RESPONSES_SCREEN: (context) => ClientResponsesScreen(),
      },
    );
  }
}
