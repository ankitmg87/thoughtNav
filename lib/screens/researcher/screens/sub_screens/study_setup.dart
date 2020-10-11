import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';

class StudySetup extends StatefulWidget {
  @override
  _StudySetupState createState() => _StudySetupState();
}

class _StudySetupState extends State<StudySetup> {

  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            color: PROJECT_LIGHT_GREEN,
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            width: 300.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Study Info',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Select Category',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Create Groups',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Add Questions',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: Scrollbar(
              controller: _controller,
              isAlwaysShown: true,
              thickness: 15.0,
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.only(
                    top: 20.0,
                    left: 30.0,
                    right: 30.0,
                  ),
                  constraints: BoxConstraints(
                    maxWidth: 700.0,
                  ),
                  child: ListView(
                    controller: _controller,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'STUDY INFO',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            color: PROJECT_GREEN,
                            onPressed: () {},
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.save_alt,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              cursorColor: PROJECT_NAVY_BLUE,
                              decoration: InputDecoration(
                                hintText: 'Study Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              cursorColor: PROJECT_NAVY_BLUE,
                              decoration: InputDecoration(
                                hintText: 'Internal Study Label',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              cursorColor: PROJECT_NAVY_BLUE,
                              decoration: InputDecoration(
                                hintText: 'Master Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      final date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime(2000),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2025),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                                      child: Text(
                                        'Begin Date',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20.0,),
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      final date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime(2000),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2025),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                                      child: Text(
                                        'End Date',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              cursorColor: PROJECT_NAVY_BLUE,
                              minLines: 5,
                              maxLines: 20,
                              decoration: InputDecoration(
                                hintText: 'Invite Message',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              cursorColor: PROJECT_NAVY_BLUE,
                              minLines: 5,
                              maxLines: 20,
                              decoration: InputDecoration(
                                hintText: 'Intro-Page Message',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              cursorColor: PROJECT_NAVY_BLUE,
                              minLines: 5,
                              maxLines: 20,
                              decoration: InputDecoration(
                                hintText: 'Study Closed Message',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'SELECT CATEGORY',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'CREATE GROUPS',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'ADD QUESTIONS',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
