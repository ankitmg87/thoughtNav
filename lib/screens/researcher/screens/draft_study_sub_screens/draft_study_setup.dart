import 'dart:async';
import 'dart:js' as js;

import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reorderables/reorderables.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/categories.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/screens/researcher/screens/draft_study_sub_screens/draft_study_widgets/custom_categories_widget.dart';
import 'package:thoughtnav/screens/researcher/screens/draft_study_sub_screens/draft_study_widgets/draft_screen_custom_text_field.dart';
import 'package:thoughtnav/screens/researcher/widgets/study_setup_screen_category_check_box.dart';
import 'package:thoughtnav/screens/researcher/widgets/study_setup_screen_custom_input_field.dart';
import 'package:thoughtnav/screens/researcher/widgets/study_setup_screen_topic_widget.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

import 'draft_study_widgets/draft_screen_group_widget.dart';

class DraftStudySetup extends StatefulWidget {
  final String studyUID;

  const DraftStudySetup({Key key, this.studyUID}) : super(key: key);

  @override
  _DraftStudySetupState createState() => _DraftStudySetupState();
}

class _DraftStudySetupState extends State<DraftStudySetup> {
  final studyInfoKey = GlobalKey();
  final selectCategoryKey = GlobalKey();
  final createGroupsKey = GlobalKey();
  final _addQuestionsKey = GlobalKey();

  Future<void> _futureDraftStudy;
  Future<void> _futureGroups;
  Future<void> _futureTopics;

  DateTime _startDate;
  DateTime _endDate;

  final FirebaseFirestoreService _firebaseFirestoreService =
      FirebaseFirestoreService();

  final _researcherAndModeratorFirestoreService =
      ResearcherAndModeratorFirestoreService();

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

  int _selectedTimeZone;

  Categories _categories = Categories(
    lifestyle: false,
    health: false,
    auto: false,
    fashion: false,
    advertising: false,
    product: false,
    futures: false,
    others: false,
  );

  List<Group> _groups = [];
  List<Topic> _topics = [];

  final FocusNode _studyNameFocusNode = FocusNode();
  final FocusNode _internalStudyLabelFocusNode = FocusNode();
  final FocusNode _masterPasswordFocusNode = FocusNode();

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      _topics.insert(newIndex, _topics.removeAt(oldIndex));
    });
  }

  void _setSelectedRadio(int value) {
    setState(() {
      _selectedTimeZone = value;
    });
    _setTimeZone();
  }

  void _setTimeZone() {
    switch (_selectedTimeZone) {
      case 1:
        mStudy.studyTimeZone = 'PST';
        break;
      case 2:
        mStudy.studyTimeZone = 'MST';
        break;
      case 3:
        mStudy.studyTimeZone = 'CST';
        break;
      case 4:
        mStudy.studyTimeZone = 'EST';
        break;
      default:
        mStudy.studyTimeZone = 'CST';
    }
  }

  int _getTimeZone() {
    int _timeZone;

    switch (mStudy.studyTimeZone) {
      case 'PST':
        _timeZone = 1;
        break;
      case 'MST':
        _timeZone = 2;
        break;
      case 'CST':
        _timeZone = 3;
        break;
      case 'EST':
        _timeZone = 4;
        break;
    }
    return _timeZone;
  }

  void _saveCategories() async {
    await _researcherAndModeratorFirestoreService.saveCategories(
        widget.studyUID, _categories);
  }

  @override
  void initState() {

    _initializeFocusNodes();
    _futureDraftStudy = _getStudyDetails();

    _futureGroups = _getGroups();
    _futureTopics = _getTopics();

    super.initState();
  }

  void _initializeFocusNodes() {
    _studyNameFocusNode.addListener(() {
      if (!_studyNameFocusNode.hasFocus) {
        if (mStudy.studyName.isNotEmpty || mStudy.studyName != null) {
          _updateStudyName();
        }
      }
    });
    _internalStudyLabelFocusNode.addListener(() {
      if (!_internalStudyLabelFocusNode.hasFocus) {
        if (mStudy.internalStudyLabel.isNotEmpty ||
            mStudy.internalStudyLabel != null) {
          _updateInternalStudyLabel();
        }
      }
    });
    _masterPasswordFocusNode.addListener(() {
      if (!_masterPasswordFocusNode.hasFocus) {
        if (mStudy.masterPassword.isNotEmpty || mStudy.masterPassword != null) {
          _updateMasterPassword();
        }
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
    mStudy =
        await _researcherAndModeratorFirestoreService.getStudy(widget.studyUID);

    if(mStudy.startDate != null){
      _startDate = DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).parse(mStudy.startDate);
    }
    if(mStudy.endDate != null){
      _endDate = DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).parse(mStudy.endDate);
    }


    await _getCategories();
    _selectedTimeZone = _getTimeZone();
  }

  Future<void> _getCategories() async {
    _categories = await _researcherAndModeratorFirestoreService
        .getCategories(widget.studyUID);
  }

  Future<void> _getGroups() async {
    _groups = await _firebaseFirestoreService.getGroups(widget.studyUID);
    _groups ??= <Group>[];
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getTopics() async {
    _topics = await _researcherAndModeratorFirestoreService
        .getTopics(widget.studyUID);
    _topics ??= <Topic>[];
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus.unfocus();
      },
      child: Row(
        children: [
          Container(
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
                InkWell(
                  onTap: () {
                    Scrollable.ensureVisible(studyInfoKey.currentContext);
                  },
                  child: Text(
                    'STUDY INFO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                InkWell(
                  onTap: () {
                    Scrollable.ensureVisible(selectCategoryKey.currentContext);
                  },
                  child: Text(
                    'SELECT CATEGORY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                InkWell(
                  onTap: () {
                    Scrollable.ensureVisible(createGroupsKey.currentContext);
                  },
                  child: Text(
                    'CREATE GROUPS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                InkWell(
                  onTap: () {
                    Scrollable.ensureVisible(_addQuestionsKey.currentContext);
                  },
                  child: Text(
                    'ADD QUESTIONS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _futureDraftStudy,
              builder:
                  (BuildContext context, AsyncSnapshot<dynamic> studySnapshot) {
                switch (studySnapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return Center(
                      child: Text('Loading...'),
                    );
                    break;
                  case ConnectionState.done:
                    return Column(
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.0),
                            child: Form(
                              child: SingleChildScrollView(
                                child: Column(
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
                                          key: studyInfoKey,
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
                                          textFormField: TextFormField(
                                            focusNode: _studyNameFocusNode,
                                            initialValue: mStudy.studyName != 'Draft Study' ? mStudy.studyName : null,
                                            onChanged: (studyName) {
                                              mStudy.studyName = studyName;
                                            },
                                            onFieldSubmitted: (studyName) {
                                              if (mStudy.studyName.isNotEmpty ||
                                                  mStudy.studyName != null) {
                                                _updateStudyName();
                                              }
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'Draft Study',
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
                                        ),
                                        SizedBox(
                                          width: 40.0,
                                        ),
                                        DraftScreenCustomTextField(
                                          textFormField: TextFormField(
                                            focusNode:
                                                _internalStudyLabelFocusNode,
                                            initialValue: mStudy.internalStudyLabel != 'Internal Study Label' ? mStudy.internalStudyLabel : null,
                                            onChanged: (internalStudyLabel) {
                                              mStudy.internalStudyLabel =
                                                  internalStudyLabel;
                                            },
                                            onFieldSubmitted:
                                                (internalStudyLabel) {
                                              if (mStudy.internalStudyLabel
                                                      .isNotEmpty ||
                                                  mStudy.internalStudyLabel !=
                                                      null) {
                                                _updateInternalStudyLabel();
                                              }
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'Internal Study Label',
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
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 40.0,
                                    ),
                                    Row(
                                      children: [
                                        DraftScreenCustomTextField(
                                          textFormField: TextFormField(
                                            focusNode: _masterPasswordFocusNode,
                                            initialValue: mStudy.masterPassword != 'Master Password' ? mStudy.masterPassword : null,
                                            onChanged: (masterPassword) {
                                              mStudy.masterPassword =
                                                  masterPassword;
                                            },
                                            onFieldSubmitted: (masterPassword) {
                                              if (mStudy.masterPassword
                                                      .isNotEmpty ||
                                                  mStudy.masterPassword !=
                                                      null) {
                                                _updateMasterPassword();
                                              }
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'Password',
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
                                        ),
                                        SizedBox(
                                          width: 40.0,
                                        ),
                                        StudySetupScreenCustomInputField(
                                          onTap: () async {
                                            final beginDate =
                                                await showDatePicker(
                                              firstDate: DateTime.now(),
                                              initialDate: DateTime.now(),
                                              lastDate: _endDate ?? DateTime(2025),
                                              context: context,
                                            );
                                            if (beginDate != null) {
                                              _startDate = beginDate;
                                              var formatter = DateFormat(
                                                  DateFormat
                                                      .YEAR_ABBR_MONTH_DAY);
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
                                            final endDate =
                                                await showDatePicker(
                                              firstDate: _startDate ?? DateTime.now(),
                                              initialDate: _startDate ?? DateTime.now(),
                                              lastDate: DateTime(2025),
                                              context: context,
                                            );
                                            if (endDate != null) {
                                              _endDate = endDate;
                                              var formatter = DateFormat(
                                                  DateFormat
                                                      .YEAR_ABBR_MONTH_DAY);
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
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          'INTRODUCTION MESSAGE',
                                                      style: headingTextStyle,
                                                    ),
                                                    TextSpan(
                                                      text: ' *',
                                                      style:
                                                          compulsoryFieldIndicatorTextStyle,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              _buildTextEditor(
                                                  initialValue:
                                                      mStudy.introPageMessage,
                                                  titleMessage:
                                                      'Enter Introduction Message',
                                                  initialValueSetMessage:
                                                      'Introduction Message Set',
                                                  saveFunction: () async {
                                                    String text = js.context
                                                        .callMethod(
                                                            'readLocalStorage');
                                                    if (text.isNotEmpty) {
                                                      await _researcherAndModeratorFirestoreService
                                                          .saveIntroductionMessage(
                                                              widget.studyUID,
                                                              text);

                                                      mStudy.introPageMessage =
                                                          text;
                                                      setState(() {});
                                                    }
                                                  }),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40.0,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          'STUDY CLOSED MESSAGE',
                                                      style: headingTextStyle,
                                                    ),
                                                    TextSpan(
                                                      text: ' *',
                                                      style:
                                                          compulsoryFieldIndicatorTextStyle,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              _buildTextEditor(
                                                  initialValue:
                                                      mStudy.studyClosedMessage,
                                                  titleMessage:
                                                      'Enter Study Closed Message',
                                                  initialValueSetMessage:
                                                      'Study Closed Message Set',
                                                  saveFunction: () async {
                                                    String text = js.context
                                                        .callMethod(
                                                            'readLocalStorage');
                                                    if (text.isNotEmpty) {
                                                      await _researcherAndModeratorFirestoreService
                                                          .saveStudyClosedMessage(
                                                              widget.studyUID,
                                                              text);

                                                      mStudy.studyClosedMessage =
                                                          text;
                                                      setState(() {});
                                                    }
                                                  }),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40.0,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          'COMMON INVITE MESSAGE',
                                                      style: headingTextStyle,
                                                    ),
                                                    TextSpan(
                                                      text: ' *',
                                                      style:
                                                          compulsoryFieldIndicatorTextStyle,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              _buildTextEditor(
                                                  initialValue: mStudy
                                                      .commonInviteMessage,
                                                  titleMessage:
                                                      'Enter Common Invite Message',
                                                  initialValueSetMessage:
                                                      'Common Invite Message Set',
                                                  saveFunction: () async {
                                                    String text = js.context
                                                        .callMethod(
                                                            'readLocalStorage');
                                                    if (text.isNotEmpty) {
                                                      await _researcherAndModeratorFirestoreService
                                                          .saveCommonInviteMessage(
                                                              widget.studyUID,
                                                              text);
                                                      mStudy.commonInviteMessage =
                                                          text;
                                                      setState(() {});
                                                    }
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 40.0,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'SELECT TIME ZONE',
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
                                    Row(
                                      children: [
                                        _buildTimeZoneRadio(
                                            title: 'Pacific Standard Time',
                                            value: 1,
                                            groupValue: _selectedTimeZone,
                                            onChanged: (int value) async {
                                              _setSelectedRadio(value);
                                              mStudy.studyTimeZone = 'PST';
                                              await _researcherAndModeratorFirestoreService
                                                  .updateTimeZone(
                                                      widget.studyUID, mStudy);
                                            }),
                                        _buildTimeZoneRadio(
                                            title: 'Mountain Standard Time',
                                            value: 2,
                                            groupValue: _selectedTimeZone,
                                            onChanged: (int value) async {
                                              _setSelectedRadio(value);
                                              mStudy.studyTimeZone = 'MST';
                                              await _researcherAndModeratorFirestoreService
                                                  .updateTimeZone(
                                                      widget.studyUID, mStudy);
                                            }),
                                        _buildTimeZoneRadio(
                                            title: 'Central Standard Time',
                                            value: 3,
                                            groupValue: _selectedTimeZone,
                                            onChanged: (int value) async {
                                              _setSelectedRadio(value);
                                              mStudy.studyTimeZone = 'CST';
                                              await _researcherAndModeratorFirestoreService
                                                  .updateTimeZone(
                                                      widget.studyUID, mStudy);
                                            }),
                                        _buildTimeZoneRadio(
                                            title: 'Eastern Standard Time',
                                            value: 4,
                                            groupValue: _selectedTimeZone,
                                            onChanged: (int value) async {
                                              _setSelectedRadio(value);
                                              mStudy.studyTimeZone = 'EST';
                                              await _researcherAndModeratorFirestoreService
                                                  .updateTimeZone(
                                                      widget.studyUID, mStudy);
                                            }),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 40.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(bottom: 5.0),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0),
                                            ),
                                          ),
                                          child: Text(
                                            'SELECT CATEGORY',
                                            key: selectCategoryKey,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),

                                        InkWell(
                                          onTap: () async {
                                            await showGeneralDialog(
                                              context: context,
                                              pageBuilder: (BuildContext
                                                      generalDialogContext,
                                                  Animation<double> animation,
                                                  Animation<double>
                                                      secondaryAnimation) {

                                                return CustomCategoriesWidget(
                                                  studyUID: widget.studyUID,
                                                  categories: _categories,
                                                );

                                              },
                                            );

                                            setState(() {});
                                          },
                                          child: Text(
                                            'Custom Category',
                                            style: TextStyle(
                                              color: PROJECT_GREEN,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      children: [
                                        StudySetupScreenCategoryCheckBox(
                                          studyUID: widget.studyUID,
                                          categoryName: 'Lifestyle',
                                          categories: _categories,
                                        ),
                                        SizedBox(
                                          width: 40.0,
                                        ),
                                        StudySetupScreenCategoryCheckBox(
                                          studyUID: widget.studyUID,
                                          categoryName: 'Health',
                                          categories: _categories,
                                        ),
                                        SizedBox(
                                          width: 40.0,
                                        ),
                                        StudySetupScreenCategoryCheckBox(
                                          studyUID: widget.studyUID,
                                          categoryName: 'Auto',
                                          categories: _categories,
                                        ),
                                        SizedBox(
                                          width: 40.0,
                                        ),
                                        StudySetupScreenCategoryCheckBox(
                                          studyUID: widget.studyUID,
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
                                          studyUID: widget.studyUID,
                                          categoryName: 'Advertising',
                                          categories: _categories,
                                        ),
                                        SizedBox(
                                          width: 40.0,
                                        ),
                                        StudySetupScreenCategoryCheckBox(
                                          studyUID: widget.studyUID,
                                          categoryName: 'Product',
                                          categories: _categories,
                                        ),
                                        SizedBox(
                                          width: 40.0,
                                        ),
                                        StudySetupScreenCategoryCheckBox(
                                          studyUID: widget.studyUID,
                                          categoryName: 'Futures',
                                          categories: _categories,
                                        ),
                                        SizedBox(
                                          width: 40.0,
                                        ),
                                        StudySetupScreenCategoryCheckBox(
                                          studyUID: widget.studyUID,
                                          categoryName: 'Others',
                                          categories: _categories,
                                        ),
                                      ],
                                    ),
                                    _categories.customCategories != null ?
                                    _categories.customCategories.isNotEmpty ?
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 30.0,
                                        ),
                                        GridView.builder(
                                          itemCount:
                                          _categories.customCategories.length,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisSpacing: 40.0,
                                            mainAxisSpacing: 30.0,
                                            crossAxisCount: 4,
                                            childAspectRatio: 8 / 1.35,
                                          ),
                                          itemBuilder: (context, index) {
                                            var customCategory =
                                            CustomCategory.fromMap(_categories
                                                .customCategories[index]);

                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(2.0),
                                                border: Border.all(
                                                  width: 0.75,
                                                  color: Colors.grey[300],
                                                ),
                                              ),
                                              child: InkWell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 4.0,
                                                    right: 10.0,
                                                    top: 8.0,
                                                    bottom: 8.0,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Theme(
                                                        data: ThemeData(
                                                          accentColor:
                                                          PROJECT_NAVY_BLUE,
                                                          unselectedWidgetColor:
                                                          Colors.grey[300],
                                                        ),
                                                        child: Checkbox(
                                                          value: customCategory
                                                              .selected,
                                                          onChanged: (bool value) {
                                                            setState(() {
                                                              _categories.customCategories[
                                                              index]
                                                              ['selected'] =
                                                                  value;
                                                            });
                                                            _saveCategories();
                                                          },
                                                        ),
                                                      ),
                                                      Text(
                                                        _categories
                                                            .customCategories[
                                                        index]['category'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ) : SizedBox() : SizedBox(),
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
                                            padding:
                                                EdgeInsets.only(bottom: 5.0),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0),
                                              ),
                                            ),
                                            child: Text(
                                              'CREATE GROUPS',
                                              key: createGroupsKey,
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
                                                ? InkWell(
                                                    onTap: () async {
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
                                                    child: Text(
                                                      'Remove Group',
                                                      style: TextStyle(
                                                        color: Colors.red[700],
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                var group =
                                                    await _researcherAndModeratorFirestoreService
                                                        .createGroup(
                                                            widget.studyUID,
                                                            _groups.length + 1);
                                                setState(() {
                                                  _groups.add(group);
                                                });
                                              },
                                              child: Text(
                                                'Add Group',
                                                style: TextStyle(
                                                  color: PROJECT_GREEN,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0,
                                                ),
                                              ),
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
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: _groups.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              var groupNameController =
                                                  TextEditingController();
                                              var groupRewardController =
                                                  TextEditingController();

                                              groupNameController.text =
                                                  _groups[index].groupName;
                                              groupRewardController.text =
                                                  _groups[index]
                                                      .groupRewardAmount;

                                              return DraftScreenGroupWidget(
                                                studyUID: widget.studyUID,
                                                group: _groups[index],
                                                groupNameController:
                                                    groupNameController,
                                                groupRewardController:
                                                    groupRewardController,
                                              );
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
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
                                          key: _addQuestionsKey,
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
                                    FutureBuilder(
                                      future: _futureTopics,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return ReorderableWrap(
                                            needsLongPressDraggable: false,
                                            runSpacing: 10.0,
                                            spacing: 10.0,
                                            onReorder: _onReorder,
                                            children: [
                                              for (var topic in _topics)
                                                StudySetupScreenTopicWidget(
                                                  key: UniqueKey(),
                                                  topic: topic,
                                                  studyUID: widget.studyUID,
                                                  groups: _groups,
                                                  deleteTopic: () async {
                                                    await _researcherAndModeratorFirestoreService
                                                        .deleteTopic(
                                                            widget.studyUID,
                                                            topic.topicUID);

                                                    setState(() {
                                                      _topics.removeWhere(
                                                          (mTopic) {
                                                        return topic.topicUID ==
                                                            mTopic.topicUID;
                                                      });
                                                    });
                                                  },
                                                ),
                                            ],
                                          );
                                        } else {
                                          return SizedBox();
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _topics.length > 1
                                              ? InkWell(
                                                  onTap: () async {
                                                    WidgetsBinding
                                                        .instance
                                                        .focusManager
                                                        .primaryFocus
                                                        .unfocus();
                                                    await _firebaseFirestoreService
                                                        .deleteTopic(
                                                            widget.studyUID,
                                                            _topics
                                                                .last.topicUID);
                                                    setState(() {
                                                      _topics.removeLast();
                                                    });
                                                  },
                                                  child: Text(
                                                    'Delete Topic',
                                                    style: TextStyle(
                                                      color: Colors.red[700],
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                          SizedBox(
                                            width: 20.0,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              WidgetsBinding.instance
                                                  .focusManager.primaryFocus
                                                  .unfocus();
                                              await _researcherAndModeratorFirestoreService
                                                  .createTopic(widget.studyUID,
                                                      _topics.length + 1)
                                                  .then((topic) {
                                                setState(() {
                                                  _topics.add(topic);
                                                });
                                              });
                                            },
                                            child: Text(
                                              'Add Topic',
                                              style: TextStyle(
                                                color: PROJECT_GREEN,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    Container(
                                      height: 0.75,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(
                                      height: 50.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                    break;
                  default:
                    return SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildTimeZoneRadio(
      {String title, int value, int groupValue, Function onChanged}) {
    return Expanded(
      child: Row(
        children: [
          Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.grey[500],
              accentColor: PROJECT_NAVY_BLUE,
            ),
            child: Radio(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
    );
  }

  Widget _buildTextEditor({
    String initialValue,
    String titleMessage,
    String initialValueSetMessage,
    Function saveFunction,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        border: Border.all(
          width: 0.75,
          color: Colors.grey[300],
        ),
      ),
      child: InkWell(
        onTap: () {
          js.context.callMethod('setInitialValue', [initialValue]);
          showGeneralDialog(
              context: context,
              pageBuilder: (BuildContext textEditorContext,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return Center(
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.6,
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                titleMessage,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                onTap: () =>
                                    Navigator.of(textEditorContext).pop(),
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.red[700],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            height: 1.0,
                            color: Colors.grey[300],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Expanded(
                            child: EasyWebView(
                              width: MediaQuery.of(context).size.width * 0.3,
                              src: 'quill.html',
                              onLoaded: () {},
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: RaisedButton(
                              color: PROJECT_GREEN,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              onPressed: () async {
                                await saveFunction();
                                Navigator.of(textEditorContext).pop();
                              },
                              child: Text(
                                'SAVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 10.0,
          ),
          child: Text(
            initialValue != '' ? initialValueSetMessage : titleMessage,
            style: TextStyle(
              color: initialValue != '' ? Colors.grey[700] : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }
}
