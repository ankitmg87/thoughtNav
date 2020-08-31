import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/misc_constants.dart';

import 'custom_tab_bar.dart';
import 'progress_containers.dart';
import 'study_details_bottom_sheet.dart';

class DashboardTopContainer extends StatelessWidget {
  const DashboardTopContainer({
    Key key,
    this.scaffoldKey,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: COMMON_PADDING,
      color: Color(0xFF092A66),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Power Wheelchair Study',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          GestureDetector(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Text(
                    'View Details',
                    style: TextStyle(
                      color: PROJECT_GREEN,
                    ),
                  ),
                  onTap: () => scaffoldKey.currentState.showBottomSheet(
                    (context) {
                      return StudyDetailsBottomSheet();
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 16.0,
                  ),
                ),
                Icon(
                  CupertinoIcons.right_chevron,
                  color: PROJECT_GREEN,
                  size: 10.0,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              StartProgressContainer(),
              MiddleProgressContainer(),
              MiddleProgressContainer(),
              EndProgressContainer(),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'You have not completed any questions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
              GestureDetector(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Next: Quick Intro',
                      style: TextStyle(
                        color: PROJECT_GREEN,
                      ),
                    ),
                    Icon(
                      CupertinoIcons.right_chevron,
                      color: PROJECT_GREEN,
                      size: 10.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          CustomTabBar()
        ],
      ),
    );
  }
}

