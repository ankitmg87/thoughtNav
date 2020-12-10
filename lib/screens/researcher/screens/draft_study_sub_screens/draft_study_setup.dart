import 'dart:async';

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
import 'package:thoughtnav/screens/researcher/widgets/custom_text_editing_box.dart';
import 'package:thoughtnav/screens/researcher/widgets/study_setup_screen_category_check_box.dart';
import 'package:thoughtnav/screens/researcher/widgets/study_setup_screen_custom_input_field.dart';
import 'package:thoughtnav/screens/researcher/widgets/study_setup_screen_topic_widget.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/moderator_firestore_service.dart';

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
  final addQuestionsKey = GlobalKey();

  Future<void> _futureDraftStudy;
  Future<void> _futureGroups;
  Future<void> _futureTopics;

  final FirebaseFirestoreService _firebaseFirestoreService =
      FirebaseFirestoreService();

  final _moderatorFirestoreService = ModeratorFirestoreService();

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

  Categories _categories = Categories(
    lifestyle: false,
    health: false,
    auto: false,
    fashion: false,
    advertising: false,
    product: false,
    futures: false,
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

  int _selectedTimeZone;

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
    mStudy = await _moderatorFirestoreService.getStudy(widget.studyUID);
    _selectedTimeZone = _getTimeZone();
  }

  void _getCategories() async {
    _categories =
        await _firebaseFirestoreService.getCategories(widget.studyUID);
  }

  Future<void> _getGroups() async {
    _groups = await _firebaseFirestoreService.getGroups(widget.studyUID);
    _groups ??= <Group>[];
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getTopics() async {
    _topics = await _moderatorFirestoreService.getTopics(widget.studyUID);
    _topics ??= <Topic>[];
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  Scrollable.ensureVisible(addQuestionsKey.currentContext);
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
                                          if (mStudy.studyName.isNotEmpty ||
                                              mStudy.studyName != null) {
                                            _updateStudyName();
                                          }
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
                                          if (mStudy.internalStudyLabel
                                                  .isNotEmpty ||
                                              mStudy.internalStudyLabel !=
                                                  null) {
                                            _updateInternalStudyLabel();
                                          }
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
                                          mStudy.masterPassword =
                                              masterPassword;
                                        },
                                        onFieldSubmitted: (masterPassword) {
                                          if (mStudy
                                                  .masterPassword.isNotEmpty ||
                                              mStudy.masterPassword != null) {
                                            _updateMasterPassword();
                                          }
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
                                        var introPageMessage =
                                            await showGeneralDialog(
                                                context: context,
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
                                        if (introPageMessage != null ||
                                            introPageMessage
                                                .toString()
                                                .isNotEmpty) {
                                          setState(() {
                                            mStudy.introPageMessage =
                                                introPageMessage.toString();
                                          });
                                          await _updateStudyDetail(
                                              widget.studyUID,
                                              'introPageMessage',
                                              mStudy.introPageMessage);
                                        }
                                      },
                                      heading: 'INTRO PAGE MESSAGE',
                                      subtitle: Text(
                                        mStudy.introPageMessage == null
                                            ? 'Enter an intro page message'
                                            : 'Intro page message set',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: mStudy.introPageMessage == null
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
                                        final studyClosedMessage =
                                            await showGeneralDialog(
                                                context: context,
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
                                                    initialValue: mStudy
                                                        .studyClosedMessage,
                                                  );
                                                });
                                        if (studyClosedMessage != null ||
                                            studyClosedMessage
                                                .toString()
                                                .isNotEmpty) {
                                          setState(() {
                                            mStudy.studyClosedMessage =
                                                studyClosedMessage.toString();
                                          });
                                          _updateStudyDetail(
                                              widget.studyUID,
                                              'studyClosedMessage',
                                              mStudy.studyClosedMessage);
                                        }
                                      },
                                      heading: 'STUDY END MESSAGE',
                                      subtitle: Text(
                                        mStudy.studyClosedMessage == null
                                            ? 'Enter a study end message'
                                            : 'Study end message set',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color:
                                              mStudy.studyClosedMessage == null
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
                                        if (commonInviteMessage != null ||
                                            commonInviteMessage
                                                .toString()
                                                .isNotEmpty) {
                                          setState(() {
                                            mStudy.commonInviteMessage =
                                                commonInviteMessage.toString();
                                          });
                                          _updateStudyDetail(
                                              widget.studyUID,
                                              'commonInviteMessage',
                                              mStudy.commonInviteMessage);
                                        }
                                      },
                                      heading: 'COMMON INVITE MESSAGE',
                                      subtitle: Text(
                                        mStudy.commonInviteMessage == null
                                            ? 'Enter a common invite message'
                                            : 'Common invite message set',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color:
                                              mStudy.commonInviteMessage == null
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
                                          await _moderatorFirestoreService
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
                                          await _moderatorFirestoreService
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
                                          await _moderatorFirestoreService
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
                                          await _moderatorFirestoreService
                                              .updateTimeZone(
                                                  widget.studyUID, mStudy);
                                        }),
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
                                      key: selectCategoryKey,
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
                                                icon:
                                                    Icon(Icons.close_outlined),
                                                color: Colors.red[700],
                                              )
                                            : SizedBox(),
                                        IconButton(
                                          onPressed: () async {
                                            var group =
                                                await _moderatorFirestoreService
                                                    .createGroup(
                                                        widget.studyUID,
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
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: _groups.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return DraftScreenGroupWidget(
                                            studyUID: widget.studyUID,
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
                                      key: addQuestionsKey,
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
                                        runSpacing: 10.0,
                                        spacing: 10.0,
                                        onReorder: _onReorder,
                                        children: [
                                          for (var topic in _topics)
                                            StudySetupScreenTopicWidget(
                                              topic: topic,
                                              studyUID: widget.studyUID,
                                              groups: _groups,
                                            ),
                                        ],
                                      );

                                      // return ReorderableListView(
                                      //   onReorder: (int oldIndex, int newIndex) {  },
                                      //   children: [
                                      //     for(var topic in _topics)
                                      //       StudySetupScreenTopicWidget(
                                      //         key: ValueKey(topic),
                                      //         topic: topic,
                                      //         studyUID: widget.studyUID,
                                      //         groups: _groups,
                                      //       ),
                                      //   ],
                                      // );

                                      // return ListView.separated(
                                      //   physics: NeverScrollableScrollPhysics(),
                                      //   shrinkWrap: true,
                                      //   itemCount: _topics.length,
                                      //   itemBuilder:
                                      //       (BuildContext context, int index) {
                                      //     return StudySetupScreenTopicWidget(
                                      //       topic: _topics[index],
                                      //       studyUID: widget.studyUID,
                                      //       groups: _groups,
                                      //     );
                                      //   },
                                      //   separatorBuilder:
                                      //       (BuildContext context, int index) {
                                      //     return SizedBox(
                                      //       height: 30.0,
                                      //     );
                                      //   },
                                      // );
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
                                          await _moderatorFirestoreService
                                              .createTopic(widget.studyUID,
                                                  _topics.length + 1)
                                              .then((topic) {
                                            setState(() {
                                              _topics.add(topic);
                                            });
                                          });
                                        },
                                        icon: Icon(Icons.add),
                                        color: PROJECT_GREEN,
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
              }
            },
          ),
        ),
      ],
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
  final FirebaseFirestoreService _firebaseFirestoreService =
      FirebaseFirestoreService();

  final FocusNode _groupNameFocusNode = FocusNode();
  final FocusNode _internalGroupLabelFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _groupNameFocusNode.addListener(() {
      if (!_groupNameFocusNode.hasFocus) {
        if (widget.group.groupName.isNotEmpty ||
            widget.group.groupName != null) {
          _updateGroupDetails();
        }
      }
    });
    _internalGroupLabelFocusNode.addListener(() {
      if (!_internalGroupLabelFocusNode.hasFocus) {
        if (widget.group.internalGroupLabel.isNotEmpty ||
            widget.group.groupName != null) {
          _updateGroupDetails();
        }
      }
    });
  }

  void _updateGroupDetails() async {
    await _firebaseFirestoreService.updateGroup(widget.studyUID, widget.group);
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
            focusNode: _groupNameFocusNode,
            initialValue: widget.group.groupName,
            onChanged: (groupName) {
              widget.group.groupName = groupName;
            },
            onFieldSubmitted: (groupName) {
              if (groupName != null || groupName.isNotEmpty) {
                _updateGroupDetails();
              }
            },
            decoration: InputDecoration(
              hintText: 'Enter Group Name',
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
        Expanded(
          child: TextFormField(
            focusNode: _internalGroupLabelFocusNode,
            initialValue: widget.group.internalGroupLabel,
            onChanged: (internalGroupLabel) {
              widget.group.internalGroupLabel = internalGroupLabel;
            },
            onFieldSubmitted: (internalGroupLabel) {
              if (internalGroupLabel != null || internalGroupLabel.isNotEmpty) {
                _updateGroupDetails();
              }
            },
            decoration: InputDecoration(
              hintText: 'Enter Internal Group Label',
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
