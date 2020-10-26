import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/screens/researcher/widgets/custom_text_editing_box.dart';
import 'package:thoughtnav/screens/researcher/widgets/study_setup_screen_category_check_box.dart';
import 'package:thoughtnav/screens/researcher/widgets/study_setup_screen_custom_input_field.dart';
import 'package:thoughtnav/screens/researcher/widgets/study_setup_screen_topic_widget.dart';

/// Study object is passed here via navigator

class DraftStudySetup extends StatefulWidget {
  final Study study;

  const DraftStudySetup({Key key, this.study}) : super(key: key);

  @override
  _DraftStudySetupState createState() => _DraftStudySetupState();
}

class _DraftStudySetupState extends State<DraftStudySetup> {
  final formKey = GlobalKey<FormState>();

  final ScrollController _controller = ScrollController();

  int numberOfGroups = 1;
  int numberOfTopics = 1;

  final TextStyle headingTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );

  final TextStyle compulsoryFieldIndicatorTextStyle = TextStyle(
    color: Colors.red[700],
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );

  Study mStudy;

  String mStudyName;
  String mInternalStudyLabel;
  String mMasterPassword;
  String mBeginDate;
  String mEndDate;
  String mCommonInviteMessage;
  String mIntroPageMessage;
  String mStudyClosedMessage;

  List<String> mCategories;

  List<Group> mGroups;
  List<Topic> mTopics;

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

  void initializeFields() {
    mStudy = widget.study;

    mStudyName = mStudy.studyName;
    mInternalStudyLabel = mStudy.internalStudyLabel;
    mMasterPassword = mStudy.masterPassword;
    mBeginDate = mStudy.beginDate ?? '';
    mEndDate = mStudy.endDate;
    mCommonInviteMessage = mStudy.commonInviteMessage;
    mIntroPageMessage = mStudy.introPageMessage;
    mStudyClosedMessage = mStudy.studyClosedMessage;

    mCategories = mStudy.categories;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'images/researcher_images/study_setup_images/setup_study_poster.png'),
              fit: BoxFit.cover,
            ),
          ),
          width: 300.0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            width: 300.0,
            decoration: BoxDecoration(
              //color: PROJECT_GREEN
              gradient: LinearGradient(
                colors: [
                  PROJECT_GREEN,
                  Color(0xFF008F47),
                  //Color(0xFF005229),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'STUDY INFO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'SELECT CATEGORY',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'CREATE GROUPS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'ADD QUESTIONS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Form(
                    child: ListView(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.only(bottom: 5.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                            ),
                            child: Text(
                              'STUDY INFO',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            StudySetupScreenCustomTextField(
                              child: RichText(
                                text: TextSpan(
                                  text: 'STUDY NAME',
                                  style: headingTextStyle,
                                  children: [
                                    TextSpan(
                                      text: ' *',
                                      style: compulsoryFieldIndicatorTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              textFormField: TextFormField(
                                onChanged: (studyName) {
                                  mStudyName = studyName;
                                },
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[400],
                                      width: 0.5,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            StudySetupScreenCustomTextField(
                              child: RichText(
                                text: TextSpan(
                                  text: 'INTERNAL STUDY LABEL',
                                  style: headingTextStyle,
                                  children: [
                                    TextSpan(
                                      text: ' *',
                                      style: compulsoryFieldIndicatorTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              textFormField: TextFormField(
                                onChanged: (internalStudyLabel) {
                                  mInternalStudyLabel = internalStudyLabel;
                                },
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[400],
                                      width: 0.5,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Row(
                          children: [
                            StudySetupScreenCustomTextField(
                              child: RichText(
                                text: TextSpan(
                                  text: 'MASTER PASSWORD',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' *',
                                      style: compulsoryFieldIndicatorTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              textFormField: TextFormField(
                                onChanged: (masterPassword) {
                                  mMasterPassword = masterPassword;
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[400],
                                      width: 0.5,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            StudySetupScreenCustomInputField(
                              onTap: () async {
                                final beginDate = await showDatePicker(
                                  firstDate: DateTime(2020),
                                  initialDate: DateTime(2020),
                                  lastDate: DateTime(2025),
                                  context: context,
                                );
                                var formatter =
                                    DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY);
                                mBeginDate = formatter.format(beginDate);
                                print(mBeginDate);
                              },
                              heading: 'BEGIN DATE',
                              subtitle: Text(
                                mBeginDate ?? 'Select a date',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: widget.study.beginDate == null
                                      ? Colors.grey[400]
                                      : Colors.grey[700],
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              headingTextStyle: headingTextStyle,
                              compulsoryFieldIndicatorTextStyle:
                                  compulsoryFieldIndicatorTextStyle,
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            StudySetupScreenCustomInputField(
                              onTap: () async {
                                final endDate = await showDatePicker(
                                  firstDate: DateTime(2020),
                                  initialDate: DateTime(2020),
                                  lastDate: DateTime(2025),
                                  context: context,
                                );
                                var formatter =
                                    DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY);
                                mEndDate = formatter.format(endDate);
                                print(mEndDate);
                              },
                              heading: 'END DATE',
                              subtitle: Text(
                                'Select a date',
                                textAlign: TextAlign.start,
                                // TODO -> Set a bool here, if date is selected then textStyle will be different
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              headingTextStyle: headingTextStyle,
                              compulsoryFieldIndicatorTextStyle:
                                  compulsoryFieldIndicatorTextStyle,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Row(
                          children: [
                            StudySetupScreenCustomInputField(
                              onTap: () async {
                                await showGeneralDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    barrierLabel:
                                        MaterialLocalizations.of(context)
                                            .modalBarrierDismissLabel,
                                    barrierColor: Colors.black45,
                                    transitionDuration:
                                        const Duration(milliseconds: 200),
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) {
                                      return CustomTextEditingBox();
                                    });
                              },
                              heading: 'INTRO PAGE MESSAGE',
                              subtitle: Text(
                                'Enter an intro page message',
                                textAlign: TextAlign.start,
                                // TODO -> Set a bool here, if date is selected then textStyle will be different
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              headingTextStyle: headingTextStyle,
                              compulsoryFieldIndicatorTextStyle:
                                  compulsoryFieldIndicatorTextStyle,
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            StudySetupScreenCustomInputField(
                              onTap: () async {
                                await showGeneralDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    barrierLabel:
                                        MaterialLocalizations.of(context)
                                            .modalBarrierDismissLabel,
                                    barrierColor: Colors.black45,
                                    transitionDuration:
                                        const Duration(milliseconds: 200),
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) {
                                      return CustomTextEditingBox();
                                    });
                              },
                              heading: 'STUDY END MESSAGE',
                              subtitle: Text(
                                'Enter a study end message',
                                textAlign: TextAlign.start,
                                // TODO -> Set a bool here, if date is selected then textStyle will be different
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              headingTextStyle: headingTextStyle,
                              compulsoryFieldIndicatorTextStyle:
                                  compulsoryFieldIndicatorTextStyle,
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            StudySetupScreenCustomInputField(
                              onTap: () async {
                                await showGeneralDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    barrierLabel:
                                        MaterialLocalizations.of(context)
                                            .modalBarrierDismissLabel,
                                    barrierColor: Colors.black45,
                                    transitionDuration:
                                        const Duration(milliseconds: 200),
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) {
                                      return CustomTextEditingBox();
                                    });
                              },
                              heading: 'COMMON INVITE MESSAGE',
                              subtitle: Text(
                                'Enter a common invite message',
                                textAlign: TextAlign.start,
                                // TODO -> Set a bool here, if date is selected then textStyle will be different
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              headingTextStyle: headingTextStyle,
                              compulsoryFieldIndicatorTextStyle:
                                  compulsoryFieldIndicatorTextStyle,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.only(bottom: 5.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                            ),
                            child: Text(
                              'SELECT CATEGORY',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            StudySetupScreenCategoryCheckBox(
                              categoryName: 'Lifestyle',
                              categorySelected: false,
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            StudySetupScreenCategoryCheckBox(
                              categoryName: 'Health',
                              categorySelected: false,
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            StudySetupScreenCategoryCheckBox(
                              categoryName: 'Auto',
                              categorySelected: false,
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            StudySetupScreenCategoryCheckBox(
                              categoryName: 'Fashion',
                              categorySelected: false,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          children: [
                            StudySetupScreenCategoryCheckBox(
                              categoryName: 'Advertising',
                              categorySelected: false,
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            StudySetupScreenCategoryCheckBox(
                              categoryName: 'Product',
                              categorySelected: false,
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            StudySetupScreenCategoryCheckBox(
                              categoryName: 'Futures',
                              categorySelected: false,
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            StudySetupScreenCategoryCheckBox(
                              categoryName: 'Others',
                              categorySelected: false,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 5.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                ),
                                child: Text(
                                  'CREATE GROUPS',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                numberOfGroups > 1
                                    ? IconButton(
                                        onPressed: () =>
                                            _reduceNumberOfGroups(),
                                        icon: Icon(Icons.close_outlined),
                                        color: Colors.red[700],
                                      )
                                    : SizedBox(),
                                IconButton(
                                  onPressed: () => _addNumberOfGroups(),
                                  icon: Icon(Icons.add),
                                  color: PROJECT_GREEN,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: numberOfGroups,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: 'Enter Group Name',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          borderSide: BorderSide(
                                            color: Colors.grey[300],
                                            width: 0.5,
                                          ),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  width: 40.0,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: 'Enter Internal Group Label',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          borderSide: BorderSide(
                                            color: Colors.grey[300],
                                            width: 0.5,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 30.0,
                            );
                          },
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 5.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                ),
                                child: Text(
                                  'ADD QUESTIONS',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                numberOfTopics > 1
                                    ? IconButton(
                                        onPressed: () =>
                                            _reduceNumberOfTopics(),
                                        icon: Icon(Icons.close_outlined),
                                        color: Colors.red[700],
                                      )
                                    : SizedBox(),
                                IconButton(
                                  onPressed: () => _addNumberOfTopics(),
                                  icon: Icon(Icons.add),
                                  color: PROJECT_GREEN,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: numberOfTopics,
                          itemBuilder: (BuildContext context, int index) {
                            return StudySetupScreenTopicWidget(
                              onTap: () async {
                                final beginDate = await showDatePicker(
                                  firstDate: DateTime(2020),
                                  initialDate: DateTime(2020),
                                  lastDate: DateTime(2025),
                                  context: context,
                                );
                                var formatter =
                                DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY);
                                mBeginDate = formatter.format(beginDate);
                                print(mBeginDate);
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 30.0,
                            );
                          },
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Container(
                          height: 0.75,
                          color: Colors.grey[400],
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            color: PROJECT_GREEN,
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.save_alt,
                                    color: Colors.white,
                                    size: 16.0,
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  Text(
                                    'SAVE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _addNumberOfGroups() {
    setState(() {
      numberOfGroups++;
    });
  }

  void _reduceNumberOfGroups() {
    if (numberOfGroups > 1) {
      setState(() {
        numberOfGroups--;
      });
    }
  }

  void _addNumberOfTopics() {
    setState(() {
      numberOfTopics++;
    });
  }

  void _reduceNumberOfTopics() {
    if (numberOfTopics > 1) {
      setState(() {
        numberOfTopics--;
      });
    }
  }
}

class StudySetupScreenCustomTextField extends StatelessWidget {
  final Widget child;
  final TextFormField textFormField;

  const StudySetupScreenCustomTextField(
      {Key key, @required this.child, this.textFormField})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
          SizedBox(
            height: 10.0,
          ),
          textFormField,
        ],
      ),
    );
  }
}
