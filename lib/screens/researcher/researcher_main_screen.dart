import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/widgets/study_widget.dart';

const TextStyle _SELECTED_TEXT_TEXT_STYLE = TextStyle(
  color: Color(0xFF00B85C),
  fontWeight: FontWeight.w700,
  fontSize: 16.0,
);

const TextStyle _UNSELECTED_TEXT_TEXT_STYLE = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w400,
  fontSize: 16.0,
);

class ResearcherMainScreen extends StatefulWidget {
  @override
  _ResearcherMainScreenState createState() => _ResearcherMainScreenState();
}

class _ResearcherMainScreenState extends State<ResearcherMainScreen> {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  bool moderatorInvitesOnly = false;

  TextEditingController _searchController = TextEditingController();

  ListView studyListView = ListView();

  List<Study> allStudiesList = [];
  List<Study> activeStudiesList = [];
  List<Study> completedStudiesList = [];
  List<Study> draftStudiesList = [];

  bool allSelected = true;
  bool activeSelected = false;
  bool completedSelected = false;
  bool draftSelected = false;

  Widget listView;

  Widget allStudies;
  Widget activeStudies;
  Widget completedStudies;
  Widget draftStudies;

  @override
  void initState() {
    super.initState();
    initializeViews();
  }

  void createStudy() async {
    Study newStudy = Study();

    newStudy.studyName = 'New Study';
    newStudy.studyStatus = 'Draft';

    await firestoreInstance
        .collection('studies')
        .add(
          newStudy.toMap(),
        )
        .then((value) {
      newStudy.studyUID = value.id;
      Navigator.of(context).pushNamed(
        DRAFT_STUDY_SCREEN,
        arguments: newStudy.toMap(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    if (screenSize.width < screenSize.height)
      return Scaffold(
        body: Center(
          child: Text(
            'Please use in landscape mode.',
            style: TextStyle(
              color: TEXT_COLOR.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
      );
    else
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: buildBody(moderatorInvitesOnly),
      );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leadingWidth: 140.0,
      leading: Center(
        child: Text(
          ' ThoughtNav',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
        ),
      ),
      title: Text(
        'Dashboard',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Stack(
              children: [
                Container(
                  child: Image(
                    image: AssetImage('images/avatars/batman.png'),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                    child: Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 12.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBody(bool moderatorInvitesOnly) {
    return Column(
      children: [
        SizedBox(
          height: 24.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Studies',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                color: PROJECT_GREEN,
                onPressed: createStudy,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 6.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.add_circled,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Create Study',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 24.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Card(
            elevation: 2.0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 6.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          allSelected = true;
                          activeSelected = false;
                          completedSelected = false;
                          draftSelected = false;

                          setListType();
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Text(
                            'All',
                            style: allSelected
                                ? _SELECTED_TEXT_TEXT_STYLE
                                : _UNSELECTED_TEXT_TEXT_STYLE,
                          ),
                        ),
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      InkWell(
                        onTap: () {
                          allSelected = false;
                          activeSelected = true;
                          completedSelected = false;
                          draftSelected = false;

                          setListType();
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Text(
                            'Active',
                            style: activeSelected
                                ? _SELECTED_TEXT_TEXT_STYLE
                                : _UNSELECTED_TEXT_TEXT_STYLE,
                          ),
                        ),
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      InkWell(
                        onTap: () {
                          allSelected = false;
                          activeSelected = false;
                          completedSelected = true;
                          draftSelected = false;

                          setListType();
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Text(
                            'Completed',
                            style: completedSelected
                                ? _SELECTED_TEXT_TEXT_STYLE
                                : _UNSELECTED_TEXT_TEXT_STYLE,
                          ),
                        ),
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      InkWell(
                        onTap: () {
                          allSelected = false;
                          activeSelected = false;
                          completedSelected = false;
                          draftSelected = true;

                          setListType();
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Text(
                            'Draft',
                            style: draftSelected
                                ? _SELECTED_TEXT_TEXT_STYLE
                                : _UNSELECTED_TEXT_TEXT_STYLE,
                          ),
                        ),
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Moderator Invites Only',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      // TODO -> Change this switch
                      StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Transform.scale(
                            scale: 0.6,
                            child: CupertinoSwitch(
                              value: moderatorInvitesOnly,
                              onChanged: (value) {
                                moderatorInvitesOnly = value;
                                setState(() {});
                              },
                              activeColor: PROJECT_GREEN,
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Icon(
                        Icons.search,
                        color: PROJECT_GREEN,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 2.0),
                        constraints: BoxConstraints(maxWidth: 200.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search',
                            isDense: true,
                          ),
                          cursorColor: PROJECT_NAVY_BLUE,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Expanded(
          child: listView,
        ),
      ],
    );
  }

  void initializeViews() {
    allStudies = allStudiesFutureBuilder();
    listView = allStudies;

    activeStudies = SizedBox();
    completedStudies = SizedBox();
    draftStudies = SizedBox();
  }

  FutureBuilder allStudiesFutureBuilder() {
    return FutureBuilder(
      initialData: allStudiesList,
      future: queryAllStudies(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> studiesSnapshot) {
        return ListView.separated(
          itemCount: studiesSnapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            return StudyWidget(
              study: studiesSnapshot.data[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 10.0,
            );
          },
        );
      },
    );
  }

  Future<List<Study>> queryAllStudies() async {
    allStudiesList = [];
    CollectionReference studiesReference =
        firestoreInstance.collection('studies');
    QuerySnapshot studiesSnapshot = await studiesReference.get();

    List<QueryDocumentSnapshot> snapshots = studiesSnapshot.docs;

    for (var snapshot in snapshots) {
      Study study = Study.fromMap(snapshot.data());
      study.studyUID = snapshot.id;
      allStudiesList.add(study);
    }

    sortStudies();

    return allStudiesList;
  }

  void sortStudies() {
    for (Study study in allStudiesList) {
      if (study.studyStatus == 'Active') {
        activeStudiesList.add(study);
      }
      if (study.studyStatus == 'Completed') {
        completedStudiesList.add(study);
      }
      if (study.isDraft) {
        draftStudiesList.add(study);
      }
    }
  }

  void setListType() {
    setState(() {
      if (allSelected) {
        listView = allStudies;
        return;
      } else if (activeSelected) {
        listView = ListView.separated(
          itemCount: activeStudiesList.length,
          itemBuilder: (BuildContext context, int index) {
            return StudyWidget(
              study: activeStudiesList[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 10.0,
            );
          },
        );
        return;
      } else if (completedSelected) {
        listView = ListView.separated(
          itemCount: completedStudiesList.length,
          itemBuilder: (BuildContext context, int index) {
            return StudyWidget(
              study: completedStudiesList[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 10.0,
            );
          },
        );
        return;
      } else if (draftSelected) {
        listView = ListView.separated(
          itemCount: draftStudiesList.length,
          itemBuilder: (BuildContext context, int index) {
            return StudyWidget(
              study: draftStudiesList[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 10.0,
            );
          },
        );
        return;
      }
    });
  }
}
