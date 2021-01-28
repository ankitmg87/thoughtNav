import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/researcher/models/moderator.dart';
import 'package:thoughtnav/services/firebase_auth_service.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';
import 'package:thoughtnav/services/researcher_and_moderator_storage_service.dart';

class ModeratorPreferencesScreen extends StatefulWidget {
  @override
  _ModeratorPreferencesScreenState createState() =>
      _ModeratorPreferencesScreenState();
}

class _ModeratorPreferencesScreenState
    extends State<ModeratorPreferencesScreen> {
  final _researcherAndModeratorFirestoreService =
      ResearcherAndModeratorFirestoreService();

  final _researcherAndModeratorStorageService =
      ResearcherAndModeratorStorageService();

  final _firebaseAuthService = FirebaseAuthService();

  final _phoneFormatter = MaskTextInputFormatter(
      mask: '(###) ###-####', filter: {'#': RegExp(r'[0-9]')});

  String _moderatorUID;

  String _oldPassword;
  String _newPassword;

  String _oldPhone;
  String _newPhone;

  Moderator _moderator;

  Future<Moderator> _futureModerator;

  Future<Moderator> _getModerator(String moderatorUID) async {
    var moderator = await _researcherAndModeratorFirestoreService
        .getModerator(moderatorUID);
    return moderator;
  }

  Future<void> _pickAvatar(String moderatorUID) async {
    var pickedImageFile =
        await ImagePickerWeb.getImage(outputType: ImageType.file);

    if (pickedImageFile != null) {
      var imageURI = await _researcherAndModeratorStorageService
          .uploadAvatarToFirebase(moderatorUID, pickedImageFile);

      _moderator.moderatorAvatar = '$imageURI';

      await _researcherAndModeratorFirestoreService.updateModerator(_moderator);

      setState(() {});
    }
  }

  @override
  void initState() {
    var getStorage = GetStorage();

    _moderatorUID = getStorage.read('moderatorUID');

    _futureModerator = _getModerator(_moderatorUID);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      backgroundColor: Colors.white,
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
        'Preferences',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .popAndPushNamed(MODERATOR_DASHBOARD_SCREEN);
              },
              child: Text(
                'Dashboard',
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
    return FutureBuilder<Moderator>(
      future: _futureModerator,
      builder:
          (BuildContext context, AsyncSnapshot<Moderator> moderatorSnapshot) {
        switch (moderatorSnapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: Text(
                'Loading...',
              ),
            );
            break;
          case ConnectionState.done:
            _moderator = moderatorSnapshot.data;

            _oldPassword = moderatorSnapshot.data.password;
            _newPassword = moderatorSnapshot.data.password;

            _oldPhone = moderatorSnapshot.data.phone;
            _newPhone = moderatorSnapshot.data.phone;

            return Center(
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.3),
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
                    moderatorSnapshot.data.moderatorAvatar == null
                        ? InkWell(
                            onTap: () async {
                              await _pickAvatar(_moderatorUID);
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
                              await _pickAvatar(_moderatorUID);
                            },
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: CachedNetworkImage(
                              imageUrl: moderatorSnapshot.data.moderatorAvatar,
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
                          '${_moderator.firstName} ${_moderator.lastName}',
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
                          '${_moderator.email}',
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
                            initialValue: _moderator.password,
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
                            initialValue: _moderator.phone,
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
                          _moderator.phone = _newPhone;
                          await _researcherAndModeratorFirestoreService.updateModerator(_moderator);
                        }
                        if(_newPassword != _oldPassword){
                          _moderator.password = _newPassword;
                          try{
                            await _firebaseAuthService.changeUserPassword(_newPassword).then((value) async {
                              await _researcherAndModeratorFirestoreService.updateModerator(_moderator);
                            });
                          } catch (e) {
                            if(e.code == 'requires-recent-login'){
                              await _firebaseAuthService.signInUser(_moderator.email, _oldPassword);
                              await _firebaseAuthService.changeUserPassword(_newPassword);
                              await _researcherAndModeratorFirestoreService.updateModerator(_moderator);
                            }
                          }
                        }
                        await Navigator.of(context).popAndPushNamed(MODERATOR_DASHBOARD_SCREEN);
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
                'Something went wrong',
              ),
            );
        }
      },
    );
  }
}
