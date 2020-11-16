import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/constants/string_constants.dart';
import 'package:thoughtnav/screens/participant/open_study/dashboard/dashboard_widgets/end_drawer_expansion_tile.dart';
import 'package:thoughtnav/screens/participant/open_study/questions/questions_widgets/question_and_description_container.dart';
import 'package:thoughtnav/screens/participant/open_study/questions/quick_intro_tutorial/quick_intro_tutorial_widgets/comment_widget.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/response.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

import 'quick_intro_tutorial/quick_intro_tutorial_widgets/user_post_widget.dart';

class ParticipantResponseScreen extends StatefulWidget {
  @override
  _ParticipantResponseScreenState createState() =>
      _ParticipantResponseScreenState();
}

class _ParticipantResponseScreenState extends State<ParticipantResponseScreen> {
  final _firebaseFirestoreService = FirebaseFirestoreService();

  String _studyUID;
  String _participantUID;
  String _topicUID;
  String _questionUID;

  Participant _participant;
  Question _question;

  List<Topic> _topics;

  Future<void> _futureParticipant;
  Future<void> _futureTopics;
  Future<void> _futureQuestion;

  Stream<QuerySnapshot> _responsesStream;

  Future<void> _getQuestionUIDAndTopicUID() async {}

  Future<void> _getTopics(String studyUID) async {
    _topics = await _firebaseFirestoreService.getTopics(studyUID);
  }

  Future<void> _getParticipant(String studyUID, String participantUID) async {
    _participant = await _firebaseFirestoreService.getParticipant(
        studyUID, participantUID);
  }

  Future<void> _getQuestion(String studyUID) async {
    Map<String, String> arguments =
        await ModalRoute.of(context).settings.arguments;

    _topicUID = arguments['topicUID'];
    _questionUID = arguments['questionUID'];

    _responsesStream = _getResponsesStream(studyUID);

    _question = await _firebaseFirestoreService.getQuestion(
        studyUID, _topicUID, _questionUID);
  }

  Stream<QuerySnapshot> _getResponsesStream(String studyUID) {
    return _firebaseFirestoreService.getResponsesAsStream(
        studyUID, _topicUID, _questionUID);
  }

  @override
  void initState() {
    var getStorage = GetStorage();

    _studyUID = getStorage.read('studyUID');
    _participantUID = getStorage.read('participantUID');

    _futureTopics = _getTopics(_studyUID);
    _futureParticipant = _getParticipant(_studyUID, _participantUID);
    _responsesStream = _getResponsesStream(_studyUID);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _futureQuestion = _getQuestion(_studyUID);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (screenSize.width < screenSize.height) {
      return buildPhoneScaffold(context, screenSize);
    } else {
      return _desktopScaffoldFutureBuilder();
    }
  }

  Scaffold buildPhoneScaffold(BuildContext context, Size screenSize) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF333333),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          APP_NAME,
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 10.0,
            color: PROJECT_GREEN.withOpacity(0.2),
          ),
          QuestionAndDescriptionContainer(
            screenSize: screenSize,
            // studyName: 'Power Wheelchair Study',
            number: '0.1',
            title: 'Tell Us Your Story',
            description:
                'To test the system, please tell us about yourself in a few sentences.\nPlease include any details about work, family, pets, hobbies, etc. ',
          ),
          SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image(
                  width: 16.0,
                  image: AssetImage(
                    'images/eye_icon.png',
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  'Will be visible to Everyone',
                  style: TextStyle(
                      color: TEXT_COLOR.withOpacity(0.6),
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 30.0, right: 30.0, top: 8.0, bottom: 20.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: PROJECT_LIGHT_GREEN,
                              ),
                              child: Center(
                                child: Image(
                                  width: 20.0,
                                  image: AssetImage(
                                    'images/avatars/batman.png',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              'Batman (me)',
                              style: TextStyle(
                                color: TEXT_COLOR.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8.0)),
                          child: TextField(
                            maxLines: 3,
                            minLines: 3,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Write your response',
                              hintStyle: TextStyle(
                                color: TEXT_COLOR.withOpacity(0.4),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Transform.rotate(
                              angle: 2.35619,
                              child: Icon(
                                Icons.attach_file,
                                color: PROJECT_GREEN,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              'Add an attachment',
                              style: TextStyle(
                                  color: TEXT_COLOR.withOpacity(0.4),
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Material(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(4.0),
                            bottomRight: Radius.circular(4.0),
                          ),
                          color: PROJECT_GREEN,
                          child: InkWell(
                            highlightColor: Colors.black.withOpacity(0.2),
                            splashColor: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(4.0),
                              bottomRight: Radius.circular(4.0),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Post',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All responses',
                  style: TextStyle(
                    color: TEXT_COLOR.withOpacity(0.5),
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sort By',
                      style: TextStyle(
                        color: TEXT_COLOR.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Recent',
                            style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(
                            width: 2.0,
                          ),
                          Transform.rotate(
                            angle: 1.5708,
                            child: Icon(
                              CupertinoIcons.right_chevron,
                              color: Colors.lightBlue,
                              size: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // UserResponseWidget(
          //   hasImage: true,
          //   screenSize: screenSize,
          // ),
          CommentWidget(),
          // UserResponseWidget(hasImage: false, screenSize: screenSize),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              children: [
                Expanded(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(TOPIC_COMPLETE_SCREEN),
                    color: PROJECT_GREEN,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
        ],
      ),
    );
  }

  FutureBuilder _desktopScaffoldFutureBuilder() {
    return FutureBuilder(
      future: _futureParticipant,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Material(
              child: Center(
                child: Text(
                  'Something went wrong.',
                ),
              ),
            );
            break;
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Material(
              child: Center(
                child: Text('Loading...'),
              ),
            );
            break;
          case ConnectionState.done:
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                title: Text(
                  APP_NAME,
                  style: TextStyle(
                    color: TEXT_COLOR,
                  ),
                ),
                actions: [
                  Center(
                    child: Text(
                      'Hello ${_participant.userName}',
                      style: TextStyle(
                        color: TEXT_COLOR.withOpacity(0.7),
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: CachedNetworkImage(
                      imageUrl: _participant.profilePhotoURL,
                      imageBuilder: (buildContext, imageProvider) {
                        return Container(
                          padding: EdgeInsets.all(6.0),
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: PROJECT_LIGHT_GREEN,
                          ),
                          child: Image(
                            width: 20.0,
                            image: imageProvider,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              body: Row(
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 300.0,
                    ),
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 20.0),
                          child: Text(
                            'Study Navigator',
                            style: TextStyle(
                              color: TEXT_COLOR.withOpacity(0.7),
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1.0,
                                color: TEXT_COLOR.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: FutureBuilder(
                            future: _futureTopics,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                case ConnectionState.active:
                                  return Center(
                                    child: Text('Loading Topics...'),
                                  );
                                  break;
                                case ConnectionState.done:
                                  if (_topics != null) {
                                    return ListView.builder(
                                      itemCount: _topics.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return EndDrawerExpansionTile(
                                          title: _topics[index].topicName,
                                          questions: _topics[index].questions,
                                        );
                                      },
                                    );
                                  } else {
                                    return Center(
                                      child: Text('Some error occurred'),
                                    );
                                  }
                                  break;
                                default:
                                  return SizedBox();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: _futureQuestion,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Center(
                              child: Text('Something went wrong'),
                            );
                            break;
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            return Center(
                              child: Text('Loading...'),
                            );
                            break;
                          case ConnectionState.done:
                            return ListView(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 10.0,
                                  color: PROJECT_GREEN.withOpacity(0.2),
                                ),
                                QuestionAndDescriptionContainer(
                                  screenSize: MediaQuery.of(context).size,
                                  number: _question.questionNumber,
                                  title: _question.questionTitle,
                                  description: _question.questionStatement,
                                ),
                                SizedBox(
                                  height: 40.0,
                                ),
                                StreamBuilder(
                                  stream: _responsesStream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                        return SizedBox();
                                        break;
                                      case ConnectionState.waiting:
                                      case ConnectionState.active:
                                        if (snapshot.hasData) {

                                          var responses = snapshot.data.documents;

                                          return ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                                responses.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {

                                              print(responses[index]);
                                              print(responses[index]['alias']);

                                              return UserResponseWidget(
                                                response: Response(
                                                  responseUID: responses[index]['responseUID'],
                                                  participantUID: responses[index]['participantUID'],
                                                  avatarURL: responses[index]['avatarURL'],
                                                  alias: responses[index]['alias'],
                                                  userName: responses[index]['userName'],
                                                  // timeElapsed: responses[index]['timeElapsed']
                                                ),
                                              );
                                            },
                                          );
                                        } else if (snapshot.data == null) {
                                          return Center(
                                            child: Text('No responses yet'),
                                          );
                                        } else {
                                          return Center(
                                            child: Text('No responses yet'),
                                          );
                                        }
                                        break;
                                      case ConnectionState.done:
                                      default:
                                        return Center(
                                          child: Text('No responses yet'),
                                        );
                                    }
                                  },
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
            break;
          default:
            return SizedBox();
        }
      },
    );
  }

  Scaffold _buildDesktopScaffold(BuildContext context, Size screenSize) {
    return Scaffold(
      body: Row(
        children: [
          // Container(
          //   constraints: BoxConstraints(
          //     maxWidth: 300.0,
          //   ),
          //   color: Colors.white,
          //   child: Column(
          //     mainAxisSize: MainAxisSize.max,
          //     children: [
          //       Container(
          //         alignment: Alignment.center,
          //         padding:
          //             EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          //         child: Text(
          //           'Study Navigator',
          //           style: TextStyle(
          //             color: TEXT_COLOR.withOpacity(0.7),
          //             fontWeight: FontWeight.bold,
          //             fontSize: 12.0,
          //           ),
          //         ),
          //       ),
          //       Row(
          //         children: [
          //           Expanded(
          //             child: Container(
          //               height: 1.0,
          //               color: TEXT_COLOR.withOpacity(0.2),
          //             ),
          //           ),
          //         ],
          //       ),
          //       Expanded(
          //         child: FutureBuilder(
          //           future: _futureTopics,
          //           builder: (BuildContext context,
          //               AsyncSnapshot<dynamic> snapshot) {
          //             switch (snapshot.connectionState) {
          //               case ConnectionState.none:
          //               case ConnectionState.waiting:
          //               case ConnectionState.active:
          //                 return Center(
          //                   child: Text('Loading Topics...'),
          //                 );
          //                 break;
          //               case ConnectionState.done:
          //                 if (_topics != null) {
          //                   return ListView.builder(
          //                     itemCount: _topics.length,
          //                     itemBuilder: (BuildContext context, int index) {
          //                       return EndDrawerExpansionTile(
          //                         title: _topics[index].topicName,
          //                         questions: _topics[index].questions,
          //                       );
          //                     },
          //                   );
          //                 } else {
          //                   return Center(
          //                     child: Text('Some error occurred'),
          //                   );
          //                 }
          //                 break;
          //               default:
          //                 return SizedBox();
          //             }
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  width: double.infinity,
                  height: 10.0,
                  color: PROJECT_GREEN.withOpacity(0.2),
                ),
                QuestionAndDescriptionContainer(
                  screenSize: screenSize,
                  //studyName: 'Power Wheelchair Study',
                  number: '0.1',
                  title: 'Tell Us Your Story',
                  description:
                      'To test the system, please tell us about yourself in a few sentences.\nPlease include any details about work, family, pets, hobbies, etc. ',
                ),
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image(
                        width: 16.0,
                        image: AssetImage(
                          'images/eye_icon.png',
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'Will be visible to Everyone',
                        style: TextStyle(
                            color: TEXT_COLOR.withOpacity(0.6),
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 30.0, right: 30.0, top: 8.0, bottom: 20.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: PROJECT_LIGHT_GREEN,
                                    ),
                                    child: Center(
                                      child: Image(
                                        width: 20.0,
                                        image: AssetImage(
                                          'images/avatars/batman.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    'Batman (me)',
                                    style: TextStyle(
                                      color: TEXT_COLOR.withOpacity(0.8),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: TextField(
                                  maxLines: 3,
                                  minLines: 3,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Write your response',
                                    hintStyle: TextStyle(
                                      color: TEXT_COLOR.withOpacity(0.4),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Transform.rotate(
                                    angle: 2.35619,
                                    child: Icon(
                                      Icons.attach_file,
                                      color: PROJECT_GREEN,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    'Add an attachment',
                                    style: TextStyle(
                                        color: TEXT_COLOR.withOpacity(0.4),
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Material(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(4.0),
                                  bottomRight: Radius.circular(4.0),
                                ),
                                color: PROJECT_GREEN,
                                child: InkWell(
                                  highlightColor: Colors.black.withOpacity(0.2),
                                  splashColor: Colors.black.withOpacity(0.1),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(4.0),
                                    bottomRight: Radius.circular(4.0),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Post',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All responses',
                        style: TextStyle(
                          color: TEXT_COLOR.withOpacity(0.5),
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Sort By',
                            style: TextStyle(
                              color: TEXT_COLOR.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Recent',
                                  style: TextStyle(
                                    color: Colors.lightBlue,
                                    fontSize: 12.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 2.0,
                                ),
                                Transform.rotate(
                                  angle: 1.5708,
                                  child: Icon(
                                    CupertinoIcons.right_chevron,
                                    color: Colors.lightBlue,
                                    size: 10.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // UserResponseWidget(
                //   hasImage: true,
                //   screenSize: screenSize,
                // ),
                CommentWidget(),
                // UserResponseWidget(hasImage: false, screenSize: screenSize),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          onPressed: () => Navigator.of(context)
                              .pushNamed(TOPIC_COMPLETE_SCREEN),
                          color: PROJECT_GREEN,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponseTextField extends StatelessWidget {
  const _ResponseTextField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 8.0, bottom: 20.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: PROJECT_LIGHT_GREEN,
                        ),
                        child: Center(
                          child: Image(
                            width: 20.0,
                            image: AssetImage(
                              'images/avatars/batman.png',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Batman (me)',
                        style: TextStyle(
                          color: TEXT_COLOR.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.0)),
                    child: TextField(
                      maxLines: 3,
                      minLines: 3,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Write your response',
                        hintStyle: TextStyle(
                          color: TEXT_COLOR.withOpacity(0.4),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Transform.rotate(
                        angle: 2.35619,
                        child: Icon(
                          Icons.attach_file,
                          color: PROJECT_GREEN,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Add an attachment',
                        style: TextStyle(
                            color: TEXT_COLOR.withOpacity(0.4),
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Material(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(4.0),
                      bottomRight: Radius.circular(4.0),
                    ),
                    color: PROJECT_GREEN,
                    child: InkWell(
                      highlightColor: Colors.black.withOpacity(0.2),
                      splashColor: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4.0),
                        bottomRight: Radius.circular(4.0),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Post',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
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
