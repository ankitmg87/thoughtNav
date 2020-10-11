import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/widgets/participant_details_widget.dart';

class StudyUsers extends StatefulWidget {
  @override
  _StudyUsersState createState() => _StudyUsersState();
}

class _StudyUsersState extends State<StudyUsers> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 20.0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Card(
                      elevation: 4.0,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Participants',
                                  style: TextStyle(
                                    color: PROJECT_GREEN,
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  'Clients',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  'Moderators',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 200.0,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: TextField(
                                    cursorColor: PROJECT_NAVY_BLUE,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      hintText: 'Search',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Icon(
                                  Icons.edit_outlined,
                                  color: PROJECT_GREEN,
                                  size: 24.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          ParticipantDetailsWidget(),
                          ParticipantDetailsWidget(),
                          ParticipantDetailsWidget(),
                          ParticipantDetailsWidget(),
                          ParticipantDetailsWidget(),
                          ParticipantDetailsWidget(),
                          ParticipantDetailsWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.yellow[100],
                    width: screenSize.width * 0.3,
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


