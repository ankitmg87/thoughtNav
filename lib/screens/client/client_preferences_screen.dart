// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/researcher/models/client.dart';
import 'package:thoughtnav/services/client_firestore_service.dart';
import 'package:thoughtnav/services/client_storage_service.dart';
import 'package:thoughtnav/services/firebase_auth_service.dart';

class ClientPreferencesScreen extends StatefulWidget {
  @override
  _ClientPreferencesScreenState createState() => _ClientPreferencesScreenState();
}

class _ClientPreferencesScreenState extends State<ClientPreferencesScreen> {

  final _clientStorageService = ClientStorageService();

  final _clientFirestoreService = ClientFirestoreService();

  final _firebaseAuthService = FirebaseAuthService();

  final _phoneFormatter = MaskTextInputFormatter(
      mask: '(###) ###-####', filter: {'#': RegExp(r'[0-9]')});

  String _oldPassword;
  String _newPassword;

  String _oldPhone;
  String _newPhone;

  Client _client;

  String _studyUID;
  String _clientUID;

  Future<void> _futureClient;

  Future<void> _getClient(String studyUID, String clientUID) async {
    _client = await _clientFirestoreService.getClient(studyUID, clientUID);
  }

  Future<void> _pickAvatar(String clientUID) async {
    var pickedImageFile =
    await ImagePickerWeb.getImage(outputType: ImageType.file);

    if (pickedImageFile != null) {
      var imageURI = await _clientStorageService
          .uploadAvatarToFirebase(clientUID, pickedImageFile);

      _client.clientAvatarURL = '$imageURI';

      await _clientFirestoreService.updateClient(_studyUID, _client);

      setState(() {});
    }
  }

  @override
  void initState() {


    var getStorage = GetStorage();

    _studyUID = getStorage.read('studyUID');
    _clientUID = getStorage.read('clientUID');


    _futureClient = _getClient(_studyUID, _clientUID);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (screenSize.width > screenSize.height) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'ThoughtNav',
            style: TextStyle(
                color: Colors.black
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder(
          future: _futureClient,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(
                  child: Text(
                      'Loading...'
                  ),
                );
                break;
              case ConnectionState.done:

                _oldPhone = _client.phone;
                _newPhone = _client.phone;

                _oldPassword = _client.password;
                _newPassword = _client.password;


                return Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: screenSize.width * 0.3),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'PREFERENCES',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        _client.clientAvatarURL == null
                            ? InkWell(
                          onTap: () async {
                            await _pickAvatar(_clientUID);
                          },
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            height: 60.0,
                            width: 60.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey[700],
                                width: 2.0,
                              ),
                            ),
                            child: Image(
                              width: 50.0,
                              height: 50.0,
                              image: AssetImage(
                                'images/researcher_images/researcher_dashboard/participant_icon.png',
                              ),
                            ),
                          ),
                        )
                            : InkWell(
                          onTap: () async {
                            await _pickAvatar(_clientUID);
                          },
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: CachedNetworkImage(
                            imageUrl: _client.clientAvatarURL,
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                padding: EdgeInsets.all(10.0),
                                width: 60.0,
                                height: 60.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey[700],
                                    width: 2.0,
                                  ),
                                ),
                                child: Image(
                                  width: 50.0,
                                  height: 50.0,
                                  image: imageProvider,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          children: [
                            Text(
                              'Name:',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Text(
                              '${_client.firstName} ${_client.lastName}',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            Text(
                              'Email:',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Text(
                              '${_client.email}',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            Text(
                              'Password:',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: TextFormField(
                                initialValue: _client.password,
                                onChanged: (password) {
                                  _newPassword = password;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            Text(
                              'Phone:',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: TextFormField(
                                initialValue: _client.phone,
                                onChanged: (phone) {
                                  _newPhone = phone;
                                },
                                inputFormatters: [
                                  _phoneFormatter,
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        RaisedButton(
                          elevation: 4.0,
                          color: PROJECT_GREEN,
                          onPressed: () async {
                            if(_oldPhone != _newPhone){
                              _client.phone = _newPhone;
                              await _clientFirestoreService.updateClient(_studyUID, _client);
                            }
                            if(_newPassword != _oldPassword){
                              _client.password = _newPassword;
                              try{
                                await _firebaseAuthService.changeUserPassword(_newPassword).then((value) async {
                                  await _clientFirestoreService.updateClient(_studyUID, _client);
                                });
                              } catch (e) {
                                if(e.code == 'requires-recent-login'){
                                  await _firebaseAuthService.signInUser(_client.email, _oldPassword);
                                  await _firebaseAuthService.changeUserPassword(_newPassword);
                                  await _clientFirestoreService.updateClient(_studyUID, _client);
                                }
                              }
                            }
                            await Navigator.of(context).popAndPushNamed(CLIENT_DASHBOARD_SCREEN);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
                break;
              default:
                return Center(
                  child: Text(
                      'Something went wrong. Please contact administrator'
                  ),
                );
            }
          },
        ),
      );
    } else {
      return Material(
        child: Center(
          child: Text(
            'Please change orientation of the device',
          ),
        ),
      );
    }
  }
}
