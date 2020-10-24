import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';

class StudyWidget extends StatelessWidget {
  final Study study;

  const StudyWidget({
    Key key,
    this.study,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        child: InkWell(
          onTap: ()  {
            if(study.isDraft){
              Navigator.pushNamed(context, DRAFT_STUDY_SCREEN, arguments: study);
            }
            else {
              Navigator.pushNamed(
                context,
                CLIENT_MODERATOR_STUDY_SCREEN,
                arguments: study,
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            study.studyName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            '(${study.isDraft ? 'Draft' : study.studyStatus})',
                            style: TextStyle(
                              color: PROJECT_GREEN,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '% ${study.activeParticipants}',
                            style: TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                              fontSize: 12.0,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: LinearPercentIndicator(
                              lineHeight: 30.0,
                              percent: 0.5,
                              padding: EdgeInsets.symmetric(horizontal: 0.0),
                              backgroundColor: Colors.black12,
                              linearGradient: LinearGradient(
                                colors: [
                                  Color(0xFF437FEF),
                                  PROJECT_NAVY_BLUE,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 140.0,
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 400.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Current Active',
                            style: TextStyle(
                                color: Color(0xFF437FEF),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${study.activeParticipants ?? 0}',
                            style: TextStyle(
                                color: Color(0xFF437FEF),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Responses',
                            style: TextStyle(
                                color: Color(0xFF437FEF),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${study.totalResponses ?? 0}',
                            style: TextStyle(
                                color: Color(0xFF437FEF),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Start Date',
                            style: TextStyle(
                                color: Color(0xFF437FEF),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${study.startDate}',
                            style: TextStyle(
                                color: Color(0xFF437FEF),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'End Date',
                            style: TextStyle(
                                color: Color(0xFF437FEF),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${study.endDate}',
                            style: TextStyle(
                                color: Color(0xFF437FEF),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
