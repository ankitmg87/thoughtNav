import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/categories.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/screens/researcher/widgets/custom_text_editing_box.dart';
import 'package:thoughtnav/screens/researcher/widgets/study_setup_screen_category_check_box.dart';
import 'package:thoughtnav/screens/researcher/widgets/study_setup_screen_custom_input_field.dart';
import 'package:thoughtnav/screens/researcher/widgets/study_setup_screen_topic_widget.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

// TODO -> Put futureBuilder in groups
// TODO -> Put futureBuilder in topics

class DraftStudySetup extends StatefulWidget {
  final String studyUID;

  const DraftStudySetup({Key key, this.studyUID}) : super(key: key);

  @override
  _DraftStudySetupState createState() => _DraftStudySetupState();
}

class _DraftStudySetupState extends State<DraftStudySetup> {
  Future<void> _futureDraftStudy;
  Future<void> _futureGroups;
  Future<void> _futureTopics;

  final FirebaseFirestoreService _firebaseFirestoreService =
      FirebaseFirestoreService();

  final formKey = GlobalKey<FormState>();

  final ScrollController _controller = ScrollController();

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

  Categories _categories = Categories();

  List<Group> _groups = [];
  List<Topic> _topics = [];

  final FocusNode _studyNameFocusNode = FocusNode();
  final FocusNode _internalStudyLabelFocusNode = FocusNode();
  final FocusNode _masterPasswordFocusNode = FocusNode();

  @override
  void initState() {
    _getCategories();
    _initializeFocusNodes();
    _futureDraftStudy = _getStudyDetails();
    _futureGroups = _getGroups();
    _futureTopics = _getTopics();

    super.initState();
  }

  void _initializeFocusNodes() {
    _studyNameFocusNode.addListener(() {
      if (!_studyNameFocusNode.hasFocus) {
        _updateStudyName();
      }
    });
    _internalStudyLabelFocusNode.addListener(() {
      if (!_internalStudyLabelFocusNode.hasFocus) {
        _updateInternalStudyLabel();
      }
    });
    _masterPasswordFocusNode.addListener(() {
      if (!_masterPasswordFocusNode.hasFocus) {
        _updateMasterPassword();
      }
    });
  }

  void _updateStudyDetail(String studyUID, String fieldKey, fieldValue) async {
    await _firebaseFirestoreService.updateStudyBasicDetail(
        studyUID, fieldKey, fieldValue);
  }

  void _updateStudyName() {
    _updateStudyDetail(widget.studyUID, 'studyName', mStudy.studyName);
  }

  void _updateInternalStudyLabel() {
    _updateStudyDetail(
        widget.studyUID, 'internalStudyLabel', mStudy.internalStudyLabel);
  }

  void _updateMasterPassword() {
    _updateStudyDetail(
        widget.studyUID, 'masterPassword', mStudy.masterPassword);
  }

  Future<void> _getStudyDetails() async {
    mStudy = await _firebaseFirestoreService.getStudy(widget.studyUID);
  }

  void _getCategories() async {
    _categories =
        await _firebaseFirestoreService.getCategories(widget.studyUID);

    _categories ??= Categories(
        lifestyle: false,
        health: false,
        auto: false,
        fashion: false,
        advertising: false,
        product: false,
        futures: false);
  }

  Future<void> _getGroups() async {
    _groups = await _firebaseFirestoreService.getGroups(widget.studyUID);

    _groups ??= <Group>[];
  }

  Future<void> _getTopics() async {
    _topics = await _firebaseFirestoreService.getTopics(widget.studyUID);

    _topics ??= <Topic>[];
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
          child: FutureBuilder(
            future: _futureDraftStudy,
            builder:
                (BuildContext context, AsyncSnapshot<dynamic> studySnapshot) {
              if (studySnapshot.connectionState == ConnectionState.none) {
                return Center(
                  child: Text(
                    'Please check your connection and try again',
                  ),
                );
              } else if (studySnapshot.connectionState ==
                      ConnectionState.waiting ||
                  studySnapshot.connectionState == ConnectionState.active) {
                return Center(
                  child: Text('Loading...'),
                );
              } else {
                return Column(
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
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 1.0),
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
                                  DraftScreenCustomTextField(
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'STUDY NAME',
                                        style: headingTextStyle,
                                        children: [
                                          TextSpan(
                                            text: ' *',
                                            style:
                                                compulsoryFieldIndicatorTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    textFormField: TextFormField(
                                      focusNode: _studyNameFocusNode,
                                      initialValue: mStudy.studyName,
                                      onChanged: (studyName) {
                                        mStudy.studyName = studyName;
                                      },
                                      onFieldSubmitted: (studyName) {
                                        _firebaseFirestoreService
                                            .updateStudyBasicDetail(
                                                widget.studyUID,
                                                'studyName',
                                                mStudy.studyName);
                                      },
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          borderSide: BorderSide(
                                            color: Colors.grey[400],
                                            width: 0.5,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40.0,
                                  ),
                                  DraftScreenCustomTextField(
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'INTERNAL STUDY LABEL',
                                        style: headingTextStyle,
                                        children: [
                                          TextSpan(
                                            text: ' *',
                                            style:
                                                compulsoryFieldIndicatorTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    textFormField: TextFormField(
                                      focusNode: _internalStudyLabelFocusNode,
                                      initialValue: mStudy.internalStudyLabel,
                                      onChanged: (internalStudyLabel) {
                                        mStudy.internalStudyLabel =
                                            internalStudyLabel;
                                      },
                                      onFieldSubmitted: (internalStudyLabel) {
                                        _firebaseFirestoreService
                                            .updateStudyBasicDetail(
                                                widget.studyUID,
                                                'internalStudyLabel',
                                                mStudy.internalStudyLabel);
                                      },
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          borderSide: BorderSide(
                                            color: Colors.grey[400],
                                            width: 0.5,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
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
                                  DraftScreenCustomTextField(
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
                                            style:
                                                compulsoryFieldIndicatorTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    textFormField: TextFormField(
                                      focusNode: _masterPasswordFocusNode,
                                      initialValue: mStudy.masterPassword,
                                      onChanged: (masterPassword) {
                                        mStudy.masterPassword = masterPassword;
                                      },
                                      onFieldSubmitted: (masterPassword) {
                                        _updateMasterPassword();
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          borderSide: BorderSide(
                                            color: Colors.grey[400],
                                            width: 0.5,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
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
                                      if (beginDate != null) {
                                        var formatter = DateFormat(
                                            DateFormat.YEAR_ABBR_MONTH_DAY);
                                        mStudy.startDate =
                                            formatter.format(beginDate);
                                        setState(() {});
                                        await _firebaseFirestoreService
                                            .updateStudyBasicDetail(
                                          widget.studyUID,
                                          'startDate',
                                          mStudy.startDate,
                                        );
                                      }
                                    },
                                    heading: 'START DATE',
                                    subtitle: Text(
                                      mStudy.startDate ?? 'Select a date',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: mStudy.startDate == null
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
                                      if (endDate != null) {
                                        var formatter = DateFormat(
                                            DateFormat.YEAR_ABBR_MONTH_DAY);
                                        mStudy.endDate =
                                            formatter.format(endDate);
                                        setState(() {});
                                        await _firebaseFirestoreService
                                            .updateStudyBasicDetail(
                                                widget.studyUID,
                                                'endDate',
                                                mStudy.endDate);
                                      }
                                    },
                                    heading: 'END DATE',
                                    subtitle: Text(
                                      mStudy.endDate ?? 'Select a date',
                                      textAlign: TextAlign.start,
                                      // TODO -> Set a bool here, if date is selected then textStyle will be different
                                      style: TextStyle(
                                        color: mStudy.endDate == null
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
                                ],
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              Row(
                                children: [
                                  StudySetupScreenCustomInputField(
                                    onTap: () async {
                                      final introPageMessage =
                                          await showGeneralDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              barrierLabel:
                                                  MaterialLocalizations.of(
                                                          context)
                                                      .modalBarrierDismissLabel,
                                              barrierColor: Colors.black45,
                                              transitionDuration:
                                                  const Duration(
                                                      milliseconds: 200),
                                              pageBuilder: (BuildContext
                                                      context,
                                                  Animation<double> animation,
                                                  Animation<double>
                                                      secondaryAnimation) {
                                                return CustomTextEditingBox(
                                                  hintText:
                                                      'Enter intro page message',
                                                  initialValue:
                                                      mStudy.introPageMessage,
                                                );
                                              });

                                      mStudy.introPageMessage =
                                          introPageMessage.toString();
                                      await _updateStudyDetail(
                                          widget.studyUID,
                                          'introPageMessage',
                                          mStudy.introPageMessage);
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
                                      final studyClosedMessage =
                                          await showGeneralDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              barrierLabel:
                                                  MaterialLocalizations.of(
                                                          context)
                                                      .modalBarrierDismissLabel,
                                              barrierColor: Colors.black45,
                                              transitionDuration:
                                                  const Duration(
                                                      milliseconds: 200),
                                              pageBuilder: (BuildContext
                                                      context,
                                                  Animation<double> animation,
                                                  Animation<double>
                                                      secondaryAnimation) {
                                                return CustomTextEditingBox(
                                                  hintText:
                                                      'Enter a study end message',
                                                  initialValue:
                                                      mStudy.studyClosedMessage,
                                                );
                                              });
                                      mStudy.studyClosedMessage =
                                          studyClosedMessage.toString();
                                      _updateStudyDetail(
                                          widget.studyUID,
                                          'studyClosedMessage',
                                          mStudy.studyClosedMessage);
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
                                      final commonInviteMessage =
                                          await showGeneralDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              barrierLabel:
                                                  MaterialLocalizations.of(
                                                          context)
                                                      .modalBarrierDismissLabel,
                                              barrierColor: Colors.black45,
                                              transitionDuration:
                                                  const Duration(
                                                      milliseconds: 200),
                                              pageBuilder: (BuildContext
                                                      context,
                                                  Animation<double> animation,
                                                  Animation<double>
                                                      secondaryAnimation) {
                                                return CustomTextEditingBox(
                                                  hintText:
                                                      'Enter a common invite message',
                                                  initialValue: mStudy
                                                      .commonInviteMessage,
                                                );
                                              });
                                      mStudy.commonInviteMessage =
                                          commonInviteMessage.toString();
                                      _updateStudyDetail(
                                          widget.studyUID,
                                          'commonInviteMessage',
                                          mStudy.commonInviteMessage);
                                    },
                                    heading: 'COMMON INVITE MESSAGE',
                                    subtitle: Text(
                                      'Enter a common invite message',
                                      textAlign: TextAlign.start,
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
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 1.0),
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
                                    categories: _categories,
                                  ),
                                  SizedBox(
                                    width: 40.0,
                                  ),
                                  StudySetupScreenCategoryCheckBox(
                                    categoryName: 'Health',
                                    categories: _categories,
                                  ),
                                  SizedBox(
                                    width: 40.0,
                                  ),
                                  StudySetupScreenCategoryCheckBox(
                                    categoryName: 'Auto',
                                    categories: _categories,
                                  ),
                                  SizedBox(
                                    width: 40.0,
                                  ),
                                  StudySetupScreenCategoryCheckBox(
                                    categoryName: 'Fashion',
                                    categories: _categories,
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
                                    categories: _categories,
                                  ),
                                  SizedBox(
                                    width: 40.0,
                                  ),
                                  StudySetupScreenCategoryCheckBox(
                                    categoryName: 'Product',
                                    categories: _categories,
                                  ),
                                  SizedBox(
                                    width: 40.0,
                                  ),
                                  StudySetupScreenCategoryCheckBox(
                                    categoryName: 'Futures',
                                    categories: _categories,
                                  ),
                                  SizedBox(
                                    width: 40.0,
                                  ),
                                  StudySetupScreenCategoryCheckBox(
                                    categoryName: 'Others',
                                    categories: _categories,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      _groups.length > 1
                                          ? IconButton(
                                              onPressed: () async {
                                                var groupUID =
                                                    _groups.last.groupUID;
                                                setState(() {
                                                  _groups.removeLast();
                                                });
                                                await _firebaseFirestoreService
                                                    .deleteGroup(
                                                        widget.studyUID,
                                                        groupUID);
                                              },
                                              icon: Icon(Icons.close_outlined),
                                              color: Colors.red[700],
                                            )
                                          : SizedBox(),
                                      IconButton(
                                        onPressed: () async {
                                          var group =
                                              await _firebaseFirestoreService
                                                  .createGroup(widget.studyUID,
                                                      _groups.length + 1);
                                          setState(() {
                                            _groups.add(group);
                                          });
                                        },
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
                              FutureBuilder(
                                future: _futureGroups,
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: _groups.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return DraftScreenGroupWidget(
                                          group: _groups[index],
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                          height: 30.0,
                                        );
                                      },
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                },
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      _topics.length > 1
                                          ? IconButton(
                                              onPressed: () async {
                                                await _firebaseFirestoreService
                                                    .deleteTopic(
                                                        widget.studyUID,
                                                        _topics.last.topicUID);
                                                setState(() {
                                                  _topics.removeLast();
                                                });
                                              },
                                              icon: Icon(Icons.close_outlined),
                                              color: Colors.red[700],
                                            )
                                          : SizedBox(),
                                      IconButton(
                                        onPressed: () async {
                                          var topic =
                                              await _firebaseFirestoreService
                                                  .createTopic(widget.studyUID,
                                                      _topics.length + 1);
                                          setState(() {
                                            _topics.add(topic);
                                          });
                                        },
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
                              FutureBuilder(
                                future: _futureTopics,
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: _topics.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return StudySetupScreenTopicWidget(
                                          topic: _topics[index],
                                          studyUID: widget.studyUID,
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                          height: 30.0,
                                        );
                                      },
                                    );
                                  } else {
                                    return SizedBox();
                                  }
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
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class DraftScreenGroupWidget extends StatefulWidget {
  final String studyUID;
  final Group group;

  const DraftScreenGroupWidget({
    Key key,
    this.studyUID,
    this.group,
  }) : super(key: key);

  @override
  _DraftScreenGroupWidgetState createState() => _DraftScreenGroupWidgetState();
}

class _DraftScreenGroupWidgetState extends State<DraftScreenGroupWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${widget.group.groupIndex}.',
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: TextFormField(
            initialValue: widget.group.groupName,
            decoration: InputDecoration(
                hintText: 'Enter Group Name',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
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
            initialValue: widget.group.internalGroupLabel,
            decoration: InputDecoration(
                hintText: 'Enter Internal Group Label',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(
                    color: Colors.grey[300],
                    width: 0.5,
                  ),
                )),
          ),
        ),
      ],
    );
  }
}

class DraftScreenCustomTextField extends StatelessWidget {
  final Widget child;
  final TextFormField textFormField;

  const DraftScreenCustomTextField(
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