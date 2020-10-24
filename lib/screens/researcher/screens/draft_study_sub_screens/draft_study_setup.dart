import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/screens/researcher/widgets/draft_topic_widget.dart';
import 'package:thoughtnav/screens/researcher/widgets/category_widget.dart';
import 'package:thoughtnav/screens/researcher/widgets/dynamic_group_and_question_addition_widget.dart';
import 'package:thoughtnav/screens/researcher/widgets/group_widget.dart';
import 'package:thoughtnav/screens/researcher/widgets/topic_widget.dart';

// Study object is passed here via navigator

class DraftStudySetup extends StatefulWidget {
  final Study study;

  const DraftStudySetup({Key key, this.study}) : super(key: key);

  @override
  _DraftStudySetupState createState() => _DraftStudySetupState();
}

class _DraftStudySetupState extends State<DraftStudySetup> {
  final formKey = GlobalKey<FormState>();

  final ScrollController _controller = ScrollController();

  String _beginDate = 'Begin Date';
  String _endDate = 'End Date';

  List<Group> _groups = [];
  List<Topic> _topics = [];

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

  void addNumberOfGroups() {
    setState(() {
      numberOfGroups++;
    });
  }

  void reduceNumberOfGroups() {
    if (numberOfGroups > 1) {
      setState(() {
        numberOfGroups--;
      });
    }
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
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            StudySetupScreenCustomInputField(
                              onTap: () {},
                              heading: 'BEGIN DATE',
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
                            SizedBox(
                              width: 40.0,
                            ),
                            StudySetupScreenCustomInputField(
                              onTap: () {},
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
                              onTap: () {},
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
                              onTap: () {},
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
                              onTap: () {},
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
                                        onPressed: () => reduceNumberOfGroups(),
                                        icon: Icon(Icons.close_outlined),
                                        color: Colors.red[700],
                                      )
                                    : SizedBox(),
                                IconButton(
                                  onPressed: () => addNumberOfGroups(),
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
                                        onPressed: () => reduceNumberOfGroups(),
                                        icon: Icon(Icons.close_outlined),
                                        color: Colors.red[700],
                                      )
                                    : SizedBox(),
                                IconButton(
                                  onPressed: () {},
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
                              onTap: () {},
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 30.0,
                            );
                          },
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
}

class StudySetupScreenTopicWidget extends StatefulWidget {
  final Function onTap;

  const StudySetupScreenTopicWidget({Key key, this.onTap}) : super(key: key);

  @override
  _StudySetupScreenTopicWidgetState createState() =>
      _StudySetupScreenTopicWidgetState();
}

class _StudySetupScreenTopicWidgetState
    extends State<StudySetupScreenTopicWidget> {
  int numberOfQuestions = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300],
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Topic Name',
                    hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
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
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    border: Border.all(
                      width: 0.75,
                      color: Colors.grey[300],
                    ),
                  ),
                  child: InkWell(
                    onTap: widget.onTap,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 10.0,
                      ),
                      child: Text(
                        'Select Date',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add_circle_outlined,
                    ),
                    color: PROJECT_GREEN,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 20.0,);
            },
            itemCount: numberOfQuestions,
            itemBuilder: (BuildContext context, int index) {
              return StudySetupScreenQuestionWidget();
            },
          )
        ],
      ),
    );
  }
}

class StudySetupScreenQuestionWidget extends StatefulWidget {

  @override
  _StudySetupScreenQuestionWidgetState createState() => _StudySetupScreenQuestionWidgetState();
}

class _StudySetupScreenQuestionWidgetState extends State<StudySetupScreenQuestionWidget> {

  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                '1.1',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Question Title',
                    hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
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
              Expanded(
                child: SizedBox(),
              ),
            ],
          ),

        ],
      ),
    );
  }
}


class StudySetupScreenCategoryCheckBox extends StatefulWidget {
  final String categoryName;
  final bool categorySelected;

  const StudySetupScreenCategoryCheckBox({
    Key key,
    this.categoryName,
    this.categorySelected,
  }) : super(key: key);

  @override
  _StudySetupScreenCategoryCheckBoxState createState() =>
      _StudySetupScreenCategoryCheckBoxState();
}

class _StudySetupScreenCategoryCheckBoxState
    extends State<StudySetupScreenCategoryCheckBox> {
  bool categorySelected;

  @override
  void initState() {
    super.initState();
    categorySelected = widget.categorySelected;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.0),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Theme(
                  data: ThemeData(
                    accentColor: PROJECT_GREEN,
                    unselectedWidgetColor: Colors.grey[300],
                  ),
                  child: Checkbox(
                    // TODO -> Change tick colour
                    value: categorySelected,
                    onChanged: (bool value) {
                      setState(() {
                        categorySelected = !categorySelected;
                      });
                    },
                  ),
                ),
                Text(
                  widget.categoryName,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
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

class StudySetupScreenCustomInputField extends StatelessWidget {
  const StudySetupScreenCustomInputField({
    Key key,
    @required this.headingTextStyle,
    @required this.compulsoryFieldIndicatorTextStyle,
    this.onTap,
    this.heading,
    this.subtitle,
  }) : super(key: key);

  final TextStyle headingTextStyle;
  final TextStyle compulsoryFieldIndicatorTextStyle;
  final Function onTap;
  final String heading;
  final Widget subtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: heading,
                  style: headingTextStyle,
                ),
                TextSpan(
                  text: ' *',
                  style: compulsoryFieldIndicatorTextStyle,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              border: Border.all(
                width: 0.75,
                color: Colors.grey[300],
              ),
            ),
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 10.0,
                ),
                child: subtitle ?? SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StudySetupScreenCustomTextField extends StatelessWidget {
  final Widget child;

  const StudySetupScreenCustomTextField({Key key, @required this.child})
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
          TextFormField(
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
        ],
      ),
    );
  }
}

// Expanded(
//   child: Container(
//     alignment: Alignment.center,
//     child: Container(
//       padding: EdgeInsets.only(
//         top: 20.0,
//         left: 30.0,
//         right: 30.0,
//       ),
//       constraints: BoxConstraints(
//         maxWidth: 700.0,
//       ),
//       child: ListView(
//         children: [
//           Align(
//             alignment: Alignment.centerRight,
//             child: FlatButton(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(4.0),
//               ),
//               color: PROJECT_GREEN,
//               onPressed: () {
//                 formKey.currentState.validate();
//               },
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.save_alt,
//                     color: Colors.white,
//                     size: 16.0,
//                   ),
//                   SizedBox(
//                     width: 10.0,
//                   ),
//                   Text(
//                     'Save',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14.0,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 10.0,
//           ),
//           Form(
//             key: formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Card(
//                   elevation: 4.0,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'STUDY INFO',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 16.0,
//                               fontWeight: FontWeight.w900,
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10.0,
//                         ),
//                         Container(
//                           height: 1.0,
//                           color: Colors.grey[300],
//                         ),
//                         SizedBox(
//                           height: 16.0,
//                         ),
//                         TextFormField(
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return 'Please enter a study name';
//                             } else {
//                               return null;
//                             }
//                           },
//                           cursorColor: PROJECT_NAVY_BLUE,
//                           decoration: InputDecoration(
//                             hintText: 'Study Name',
//                             border: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.circular(10.0),
//                             ),
//                           ),
//                           onChanged: (studyName) {
//                             widget.study.studyName = studyName;
//                           },
//                         ),
//                         SizedBox(
//                           height: 20.0,
//                         ),
//                         TextFormField(
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return 'Please enter a internal study label';
//                             } else {
//                               return null;
//                             }
//                           },
//                           cursorColor: PROJECT_NAVY_BLUE,
//                           decoration: InputDecoration(
//                             hintText: 'Internal Study Label',
//                             border: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.circular(10.0),
//                             ),
//                           ),
//                           onChanged: (internalStudyLabel) {
//                             widget.study.internalStudyLabel =
//                                 internalStudyLabel;
//                           },
//                         ),
//                         SizedBox(
//                           height: 20.0,
//                         ),
//                         TextFormField(
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return 'Please enter a master password';
//                             } else {
//                               return null;
//                             }
//                           },
//                           cursorColor: PROJECT_NAVY_BLUE,
//                           decoration: InputDecoration(
//                             hintText: 'Master Password',
//                             border: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.circular(10.0),
//                             ),
//                           ),
//                           onChanged: (masterPassword) {
//                             widget.study.masterPassword =
//                                 masterPassword;
//                           },
//                         ),
//                         SizedBox(
//                           height: 20.0,
//                         ),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: InkWell(
//                                 onTap: () async {
//                                   final date = await showDatePicker(
//                                     context: context,
//                                     initialDate: DateTime(2020),
//                                     firstDate: DateTime(2020),
//                                     lastDate: DateTime(2030),
//                                   );
//                                   setState(() {
//                                     _beginDate = date.toString();
//                                   });
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius:
//                                         BorderRadius.circular(10.0),
//                                     border: Border.all(
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 10.0,
//                                       vertical: 15.0),
//                                   child: Text(
//                                     _beginDate,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 20.0,
//                             ),
//                             Expanded(
//                               child: InkWell(
//                                 onTap: () async {
//                                   final date = await showDatePicker(
//                                     context: context,
//                                     initialDate: DateTime(2020),
//                                     firstDate: DateTime(2020),
//                                     lastDate: DateTime(2030),
//                                   );
//                                   setState(() {
//                                     _endDate = date.toString();
//                                   });
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius:
//                                         BorderRadius.circular(10.0),
//                                     border: Border.all(
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 10.0,
//                                       vertical: 15.0),
//                                   child: Text(
//                                     _endDate,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 20.0,
//                         ),
//                         TextFormField(
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return 'Please set a common invite message';
//                             } else {
//                               return null;
//                             }
//                           },
//                           cursorColor: PROJECT_NAVY_BLUE,
//                           minLines: 5,
//                           maxLines: 20,
//                           decoration: InputDecoration(
//                             hintText: 'Invite Message',
//                             border: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.circular(10.0),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20.0,
//                         ),
//                         TextFormField(
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return 'Please set an introduction page message';
//                             } else {
//                               return null;
//                             }
//                           },
//                           cursorColor: PROJECT_NAVY_BLUE,
//                           minLines: 5,
//                           maxLines: 20,
//                           decoration: InputDecoration(
//                             hintText: 'Intro-Page Message',
//                             border: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.circular(10.0),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20.0,
//                         ),
//                         TextFormField(
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return 'Please set a study closed message';
//                             } else {
//                               return null;
//                             }
//                           },
//                           cursorColor: PROJECT_NAVY_BLUE,
//                           minLines: 5,
//                           maxLines: 20,
//                           decoration: InputDecoration(
//                             hintText: 'Study Closed Message',
//                             border: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.circular(10.0),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20.0,
//                 ),
//                 Card(
//                   elevation: 4.0,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'SELECT CATEGORY',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16.0,
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10.0,
//                         ),
//                         Container(
//                           height: 1.0,
//                           color: Colors.grey[300],
//                         ),
//                         SizedBox(
//                           height: 16.0,
//                         ),
//                         GridView(
//                           shrinkWrap: true,
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 4,
//                             crossAxisSpacing: 16.0,
//                             childAspectRatio: 1920 / 1080,
//                             mainAxisSpacing: 16.0,
//                           ),
//                           children: [
//                             CategoryWidget(
//                               imagePath:
//                                   'images/study_categories/lifestyle_category_thoughtnav.png',
//                               categoryTitle: 'Lifestyle',
//                             ),
//                             CategoryWidget(
//                               imagePath:
//                                   'images/study_categories/health_category_thoughtnav.png',
//                               categoryTitle: 'Health',
//                             ),
//                             CategoryWidget(
//                               imagePath:
//                                   'images/study_categories/auto_category_thoughtnav.png',
//                               categoryTitle: 'Auto',
//                             ),
//                             CategoryWidget(
//                               imagePath:
//                                   'images/study_categories/fashion_category_thoughtnav.png',
//                               categoryTitle: 'Fashion',
//                             ),
//                             CategoryWidget(
//                               imagePath:
//                                   'images/study_categories/advertising_category_thoughtnav.png',
//                               categoryTitle: 'Advertising',
//                             ),
//                             CategoryWidget(
//                               imagePath:
//                                   'images/study_categories/product_tests_category_thoughtnav.png',
//                               categoryTitle: 'Product Tests',
//                             ),
//                             CategoryWidget(
//                               imagePath:
//                                   'images/study_categories/futures_category_thoughtnav.png',
//                               categoryTitle: 'Futures',
//                             ),
//                             CategoryWidget(
//                               imagePath:
//                                   'images/study_categories/other_category_thoughtnav.png',
//                               categoryTitle: 'Other',
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20.0,
//                 ),
//                 DynamicGroupAndQuestionAdditionWidget(
//                   title: 'CREATE GROUPS',
//                   child: GroupWidget(
//                     groups: _groups,
//                   ),
//                   separatorWidget: SizedBox(
//                     height: 16.0,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20.0,
//                 ),
//                 DynamicGroupAndQuestionAdditionWidget(
//                   title: 'ADD QUESTIONS',
//                   child: DraftTopicWidget(),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 50.0,
//           ),
//         ],
//       ),
//     ),
//   ),
// ),
