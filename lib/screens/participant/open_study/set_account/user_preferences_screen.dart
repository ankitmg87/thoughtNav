import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class UserPreferencesScreen extends StatefulWidget {
  @override
  _UserPreferencesScreenState createState() => _UserPreferencesScreenState();
}

class _UserPreferencesScreenState extends State<UserPreferencesScreen> {
  final _firebaseFirestoreService = FirebaseFirestoreService();

  String _studyUID;
  String _participantUID;

  Future<Participant> _getParticipant() async {
    var _participant = await _firebaseFirestoreService.getParticipant(
        _studyUID, _participantUID);
    return _participant;
  }

  @override
  void initState() {
    var getStorage = GetStorage();
    _studyUID = getStorage.read('studyUID');
    _participantUID = getStorage.read('participantUID');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: TEXT_COLOR,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder(
        future: _getParticipant(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return SizedBox();
              break;
            case ConnectionState.done:
              return ListView(
                children: [
                  Align(
                    child: Container(
                      width: screenSize.height > screenSize.width ? double.maxFinite : screenSize.width * 0.5,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 20.0,
                      ),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: snapshot.data.profilePhotoURL,
                            imageBuilder: (context, imageProvider){
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
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${snapshot.data.userFirstName} ${snapshot.data.userLastName}',
                                style: TextStyle(
                                  color: TEXT_COLOR,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                snapshot.data.displayName,
                                style: TextStyle(
                                  color: TEXT_COLOR,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    child: Container(
                      color: Colors.white,
                      width: screenSize.height > screenSize.width ? double.maxFinite : screenSize.width * 0.5,
                      padding: EdgeInsets.only(
                        left: 30.0,
                        right: 30.0,
                        top: 30.0,
                        bottom: 50.0,
                      ),
                      child: Column(
                        children: [
                          _CustomRow(
                            label: 'Display Name',
                            value: snapshot.data.displayName,
                          ),
                          _CustomRow(
                            label: 'Email Address',
                            value: snapshot.data.email,
                          ),
                          _CustomRow(
                            label: 'Group',
                            value: snapshot.data.userGroupName,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.grey[300],
                            height: 0.5,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          _CustomRow(
                            label: 'Full Name',
                            value: '${snapshot.data.userFirstName} ${snapshot.data.userLastName}',
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.all(12.0),
                                  child: Text(
                                    'Password',
                                    style: TextStyle(
                                      color: TEXT_COLOR.withOpacity(0.6),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  initialValue: snapshot.data.password,
                                  decoration: InputDecoration(
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      fillColor: Colors.grey[100]
                                  ),
                                  style: TextStyle(
                                    color: TEXT_COLOR,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.all(12.0),
                                  child: Text(
                                    'Phone',
                                    style: TextStyle(
                                      color: TEXT_COLOR.withOpacity(0.6),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  initialValue: snapshot.data.phone,
                                  decoration: InputDecoration(
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    fillColor: Colors.grey[100]
                                  ),
                                  style: TextStyle(
                                    color: TEXT_COLOR,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40.0,
                          ),

                          FlatButton(
                            color: PROJECT_GREEN,
                            child: Text(
                              'SAVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: (){},
                          ),
                        ],
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
    );
  }
}

class _CustomRow extends StatelessWidget {
  final String label;
  final String value;

  const _CustomRow({
    Key key,
    this.label,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(12.0),
            child: Text(
              label,
              style: TextStyle(
                color: TEXT_COLOR.withOpacity(0.6),
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                color: TEXT_COLOR,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
