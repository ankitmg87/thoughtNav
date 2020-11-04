import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/screens/researcher/widgets/category_widget.dart';
import 'package:thoughtnav/screens/researcher/widgets/dynamic_group_and_question_addition_widget.dart';
import 'package:thoughtnav/screens/researcher/widgets/group_widget.dart';

class StudySetup extends StatefulWidget {
  final FirebaseFirestore firestore;

  const StudySetup({Key key, this.firestore}) : super(key: key);

  @override
  _StudySetupState createState() => _StudySetupState();
}

class _StudySetupState extends State<StudySetup> {
  ScrollController _controller = ScrollController();

  TextEditingController _studyNameController = TextEditingController();
  TextEditingController _internalStudyLabelController = TextEditingController();
  TextEditingController _masterPasswordController = TextEditingController();
  TextEditingController _commonInviteMessageController =
      TextEditingController();
  TextEditingController _introPageMessageController = TextEditingController();
  TextEditingController _studyClosedMessageController = TextEditingController();

  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _internalGroupLabelController = TextEditingController();

  TextEditingController _topicNameController = TextEditingController();
  TextEditingController _questionNameController = TextEditingController();
  TextEditingController _questionController = TextEditingController();

  String _beginDate = 'Begin Date';
  String _endDate = 'End Date';

  List<Group> _groups = [];
  List<Topic> _topics = [];

  // Future addStudy() async {
  //   CollectionReference reference = widget.firestore.collection('studies');
  //   Study study = Study(
  //     studyName: 'Study 4',
  //     isDraft: true,
  //   );
  //   await reference
  //       .add(study.toMap())
  //       .then((value) => print(value.id))
  //       .catchError((onError) => print('Some error occurred | $onError'));
  // }

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
                      Align(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          color: PROJECT_GREEN,
                          onPressed: (){},
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
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Card(
                              elevation: 4.0,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'STUDY INFO',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      height: 1.0,
                                      color: Colors.grey[300],
                                    ),
                                    SizedBox(
                                      height: 16.0,
                                    ),
                                    TextFormField(
                                      controller: _studyNameController,
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return 'Please enter a study name';
                                        else
                                          return null;
                                      },
                                      cursorColor: PROJECT_NAVY_BLUE,
                                      decoration: InputDecoration(
                                        hintText: 'Study Name',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextFormField(
                                      controller: _internalStudyLabelController,
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return 'Please enter a internal study label';
                                        else
                                          return null;
                                      },
                                      cursorColor: PROJECT_NAVY_BLUE,
                                      decoration: InputDecoration(
                                        hintText: 'Internal Study Label',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextFormField(
                                      controller: _masterPasswordController,
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return 'Please enter a master password';
                                        else
                                          return null;
                                      },
                                      cursorColor: PROJECT_NAVY_BLUE,
                                      decoration: InputDecoration(
                                        hintText: 'Master Password',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
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
                                                initialDate: DateTime(2020),
                                                firstDate: DateTime(2020),
                                                lastDate: DateTime(2030),
                                              );
                                              setState(() {
                                                _beginDate = date.toString();
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0,
                                                  vertical: 15.0),
                                              child: Text(
                                                _beginDate,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              final date = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime(2020),
                                                firstDate: DateTime(2020),
                                                lastDate: DateTime(2030),
                                              );
                                              setState(() {
                                                _endDate = date.toString();
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0,
                                                  vertical: 15.0),
                                              child: Text(
                                                _endDate,
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
                                      controller:
                                          _commonInviteMessageController,
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return 'Please set a common invite message';
                                        else
                                          return null;
                                      },
                                      cursorColor: PROJECT_NAVY_BLUE,
                                      minLines: 5,
                                      maxLines: 20,
                                      decoration: InputDecoration(
                                        hintText: 'Invite Message',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextFormField(
                                      controller: _introPageMessageController,
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return 'Please set an introduction page message';
                                        else
                                          return null;
                                      },
                                      cursorColor: PROJECT_NAVY_BLUE,
                                      minLines: 5,
                                      maxLines: 20,
                                      decoration: InputDecoration(
                                        hintText: 'Intro-Page Message',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextFormField(
                                      controller: _studyClosedMessageController,
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return 'Please set a study closed message';
                                        else
                                          return null;
                                      },
                                      cursorColor: PROJECT_NAVY_BLUE,
                                      minLines: 5,
                                      maxLines: 20,
                                      decoration: InputDecoration(
                                        hintText: 'Study Closed Message',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Card(
                              elevation: 4.0,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
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
                                      height: 10.0,
                                    ),
                                    Container(
                                      height: 1.0,
                                      color: Colors.grey[300],
                                    ),
                                    SizedBox(
                                      height: 16.0,
                                    ),
                                    GridView(
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 16.0,
                                        childAspectRatio: 1920 / 1080,
                                        mainAxisSpacing: 16.0,
                                      ),
                                      children: [
                                        CategoryWidget(
                                          imagePath:
                                              'images/study_categories/lifestyle_category_thoughtnav.png',
                                          categoryTitle: 'Lifestyle',
                                        ),
                                        CategoryWidget(
                                          imagePath:
                                              'images/study_categories/health_category_thoughtnav.png',
                                          categoryTitle: 'Health',
                                        ),
                                        CategoryWidget(
                                          imagePath:
                                              'images/study_categories/auto_category_thoughtnav.png',
                                          categoryTitle: 'Auto',
                                        ),
                                        CategoryWidget(
                                          imagePath:
                                              'images/study_categories/fashion_category_thoughtnav.png',
                                          categoryTitle: 'Fashion',
                                        ),
                                        CategoryWidget(
                                          imagePath:
                                              'images/study_categories/advertising_category_thoughtnav.png',
                                          categoryTitle: 'Advertising',
                                        ),
                                        CategoryWidget(
                                          imagePath:
                                              'images/study_categories/product_tests_category_thoughtnav.png',
                                          categoryTitle: 'Product Tests',
                                        ),
                                        CategoryWidget(
                                          imagePath:
                                              'images/study_categories/futures_category_thoughtnav.png',
                                          categoryTitle: 'Futures',
                                        ),
                                        CategoryWidget(
                                          imagePath:
                                              'images/study_categories/other_category_thoughtnav.png',
                                          categoryTitle: 'Other',
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
                            DynamicGroupAndQuestionAdditionWidget(
                              title: 'CREATE GROUPS',
                              child: GroupWidget(
                                //groups: _groups,
                              ),
                              separatorWidget: SizedBox(
                                height: 16.0,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            // DynamicGroupAndQuestionAdditionWidget(
                            //   title: 'ADD QUESTIONS',
                            //   child: AddQuestionWidget(
                            //     topics: _topics,
                            //   ),
                            // ),
                            SizedBox(
                              height: 20.0,
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
