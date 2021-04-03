import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/researcher/models/study.dart';
import 'package:thoughtnav/screens/researcher/widgets/study_widget.dart';
import 'package:thoughtnav/services/firebase_auth_service.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

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

  final _firebaseAuthService = FirebaseAuthService();

  final FirebaseFirestoreService _firebaseFirestoreService =
      FirebaseFirestoreService();

  final ResearcherAndModeratorFirestoreService
      _researcherAndModeratorFirestoreService =
      ResearcherAndModeratorFirestoreService();

  bool _searching = false;

  final TextEditingController _searchController = TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();

  ListView _studyListView = ListView();

  List<Study> _allStudiesList = [];
  List<Study> _activeStudiesList = [];
  List<Study> _completedStudiesList = [];
  List<Study> _closedStudiesList = [];
  List<Study> _draftStudiesList = [];

  List<Study> _searchedStudiesList = [];

  bool _allSelected = true;
  bool _activeSelected = false;
  bool _completedSelected = false;
  bool _closedSelected = false;
  bool _draftSelected = false;

  Widget _listView;

  Widget _allStudies;

  Future<List<Study>> _futureAllStudies;

  void _unAwaited(Future<void> future) {}

  void _createStudyAndGoToSetupScreen() async {
    var loadingDialogContext;

    _unAwaited(showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext dialogContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          loadingDialogContext = dialogContext;

          return Center(
            child: Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Creating a new study...',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }));

    var study = await _researcherAndModeratorFirestoreService.createStudy();

    final getStorage = GetStorage();
    await getStorage.write('studyUID', study.studyUID);
    await getStorage.write('studyName', study.studyName);

    if (study != null) {
      await Navigator.of(loadingDialogContext).pop();
      await Navigator.of(context).pushNamed(DRAFT_STUDY_SCREEN);
    }
  }

  void _makeSearchedStudiesList(String searchQuery) {
    _searchedStudiesList = [];

    if (searchQuery != null) {
      if (searchQuery.isNotEmpty) {
        for (var study in _allStudiesList) {
          var studyName = study.studyName.toLowerCase();
          var internalStudyLabel = study.studyName.toLowerCase();

          if (studyName.contains(searchQuery) ||
              internalStudyLabel.contains(searchQuery)) {
            _searchedStudiesList.add(study);
          }
        }
      }
    }
    setState(() {});
  }

  Widget _buildSearchedStudiesListView(List<Study> searchedStudiesList) {
    if (searchedStudiesList.isEmpty) {
      return Center(
        child: Text(
          'Search a study',
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return ListView.separated(
        itemCount: searchedStudiesList.length,
        itemBuilder: (BuildContext context, int index) {
          return StudyWidget(
            study: searchedStudiesList[index],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 10.0,
          );
        },
      );
    }
  }

  Future<List<Study>> _getAllStudies() async {
    _allStudiesList =
        await _researcherAndModeratorFirestoreService.getAllStudies();
    return _allStudiesList;
  }

  @override
  void initState() {
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        setState(() {
          _searching = true;
        });
      } else {
        setState(() {
          _searching = false;
        });
      }
    });

    _futureAllStudies = _getAllStudies();

    super.initState();
    initializeViews();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (screenSize.width < screenSize.height) {
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
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: _buildBody(),
      );
    }
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
        Container(
          height: kToolbarHeight,
          width: 1.0,
          color: Colors.grey[300],
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .popAndPushNamed(MODERATOR_PREFERENCES_SCREEN);
              },
              child: Text(
                'Preferences',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Container(
          height: kToolbarHeight,
          width: 1.0,
          color: Colors.grey[300],
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
              onTap: () async {
                await _firebaseAuthService.signOutUser();
                await Navigator.of(context).popAndPushNamed(LOGIN_SCREEN);
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
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
              RaisedButton(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                color: PROJECT_GREEN,
                onPressed: () {
                  _createStudyAndGoToSetupScreen();
                },
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
                  _searching
                      ? SizedBox()
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                _allSelected = true;
                                _activeSelected = false;
                                _completedSelected = false;
                                _closedSelected = false;
                                _draftSelected = false;

                                _setListType();
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Text(
                                  'All',
                                  style: _allSelected
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
                                _allSelected = false;
                                _activeSelected = true;
                                _completedSelected = false;
                                _closedSelected = false;
                                _draftSelected = false;

                                _setListType();
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Text(
                                  'Active',
                                  style: _activeSelected
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
                                _allSelected = false;
                                _activeSelected = false;
                                _completedSelected = true;
                                _closedSelected = false;
                                _draftSelected = false;

                                _setListType();
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Text(
                                  'Completed',
                                  style: _completedSelected
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
                                _allSelected = false;
                                _activeSelected = false;
                                _completedSelected = false;
                                _closedSelected = true;
                                _draftSelected = false;

                                _setListType();
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Text(
                                  'Closed',
                                  style: _closedSelected
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
                                _allSelected = false;
                                _activeSelected = false;
                                _completedSelected = false;
                                _closedSelected = false;
                                _draftSelected = true;

                                _setListType();
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Text(
                                  'Draft',
                                  style: _draftSelected
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
                        child: TextFormField(
                          focusNode: _searchFocusNode,
                          controller: _searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search',
                            isDense: true,
                          ),
                          cursorColor: PROJECT_NAVY_BLUE,
                          onChanged: (searchQuery) {
                            if (searchQuery.isNotEmpty) {
                              var query = searchQuery.toLowerCase();
                              _makeSearchedStudiesList(query);
                            }
                          },
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
          child: _searching
              ? _buildSearchedStudiesListView(_searchedStudiesList)
              : _listView,
        ),
      ],
    );
  }

  void initializeViews() {
    _allStudies = allStudiesFutureBuilder();
    _listView = _allStudies;
  }

  FutureBuilder<List<Study>> allStudiesFutureBuilder() {
    return FutureBuilder<List<Study>>(
      future: _futureAllStudies,
      builder: (BuildContext context, AsyncSnapshot<List<Study>> snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Center(
            child: Text(
              'You\'re not connected to the internet',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text(
              'Loading studies...',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty) {
              return ListView.separated(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return StudyWidget(
                    study: snapshot.data[index],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 10.0,
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'Please create a new study',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
          } else {
            return Center(
              child: Text(
                'No studies found',
              ),
            );
          }
        }
      },
    );
  }

  void _sortStudies() {
    _activeStudiesList = [];
    _completedStudiesList = [];
    _closedStudiesList = [];
    _draftStudiesList = [];

    for (var study in _allStudiesList) {
      if (study.studyStatus == 'Active') {
        _activeStudiesList.add(study);
      }
      if (study.studyStatus == 'Completed') {
        _completedStudiesList.add(study);
      }
      if (study.studyStatus == 'Closed') {
        _closedStudiesList.add(study);
      }
      if (study.studyStatus == 'Draft') {
        _draftStudiesList.add(study);
      }
    }
  }

  void _setListType() {
    _sortStudies();
    setState(() {
      if (_allSelected) {
        _listView = _allStudies;
        return;
      } else if (_activeSelected) {
        if (_activeStudiesList.isEmpty) {
          _listView = Center(
            child: Text(
              'No active studies',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          _listView = ListView.separated(
            itemCount: _activeStudiesList.length,
            itemBuilder: (BuildContext context, int index) {
              return StudyWidget(
                study: _activeStudiesList[index],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 10.0,
              );
            },
          );
        }
        return;
      } else if (_completedSelected) {
        if (_completedStudiesList.isEmpty) {
          _listView = Center(
            child: Text(
              'No completed studies',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          _listView = ListView.separated(
            itemCount: _completedStudiesList.length,
            itemBuilder: (BuildContext context, int index) {
              return StudyWidget(
                study: _completedStudiesList[index],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 10.0,
              );
            },
          );
        }
        return;
      } else if (_closedSelected) {
        if (_closedStudiesList.isEmpty) {
          _listView = Center(
            child: Text(
              'No closed studies',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          _listView = ListView.separated(
            itemCount: _closedStudiesList.length,
            itemBuilder: (BuildContext context, int index) {
              return StudyWidget(
                study: _closedStudiesList[index],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 10.0,
              );
            },
          );
        }
      } else if (_draftSelected) {
        if (_draftStudiesList.isEmpty) {
          _listView = Center(
            child: Text(
              'No draft studies',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          _listView = ListView.separated(
            itemCount: _draftStudiesList.length,
            itemBuilder: (BuildContext context, int index) {
              return StudyWidget(
                study: _draftStudiesList[index],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 10.0,
              );
            },
          );
        }
        return;
      }
    });
  }
}
