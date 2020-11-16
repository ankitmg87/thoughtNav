import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';

const avatarURLs = {
  'avatar11':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F11.png?alt=media&token=f8bb82b3-4244-41ed-a028-a9c3d46c425f',
  'avatar12':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F12.png?alt=media&token=dd62a219-8273-47cf-8b5e-4de6e87b8af5',
  'avatar13':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F13.png?alt=media&token=0c66abd7-f069-419c-b66d-d6d704b542f0',
  'avatar14':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F14.png?alt=media&token=259fff5b-1e94-4cb5-9dae-9b7c4c9afd9d',
  'avatar15':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F15.png?alt=media&token=60b4abf4-b0f9-4794-86fa-df5c601b99c2',
  'avatar16':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F16.png?alt=media&token=e4dc5608-d325-483b-b748-6438b079a851',
  'avatar17':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F17.png?alt=media&token=6cedf7ac-4bd8-44cc-ac65-20d79b6c9738',
  'avatar18':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F18.png?alt=media&token=ee2e8e3f-564c-4af7-81ec-6e3f6adf94f8',
  'avatar19':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F19.png?alt=media&token=480591c2-54ed-4a21-b240-c1371919a30e',
  'avatar20':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F20.png?alt=media&token=44dd3e80-3dd5-4daa-a074-1a21b5830939',
  'avatar21':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F21.png?alt=media&token=08d37512-200c-4116-a0f6-6417ba4b9fdd',
  'avatar22':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F22.png?alt=media&token=7f48c6a3-d8f7-400d-985d-f42eb77775c7',
  'avatar23':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F23.png?alt=media&token=4ec2f10d-73c0-4b01-9800-b4e1163d2919',
  'avatar24':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F24.png?alt=media&token=5b3f7daa-478c-4551-bcb6-19ce5e0dc811',
  'avatar25':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F25.png?alt=media&token=005b7b66-2ddf-496b-ac5b-ba94e1b2acb6',
  'avatar26':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F26.png?alt=media&token=30bdf3aa-ea37-4dcf-a281-b10053109541',
  'avatar27':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F27.png?alt=media&token=5fb8a46a-1724-4d4a-8259-549daa370b1f',
  'batman':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2Fbatman.png?alt=media&token=1f96d810-aaff-4b33-8fe0-a5253a363566',
  'blue':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2Fblue.png?alt=media&token=98f74611-f57a-4879-8be2-c771c602ece3',
  'he_man':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2Fhe_man.png?alt=media&token=4db21514-130d-4881-a014-f08c1ad26acd',
  'lego':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2Flego.png?alt=media&token=d6977b8e-6957-4af8-b139-c358ab7fb922',
  'mr_t':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2Fmr_t.png?alt=media&token=5afeecf7-9a64-4425-b059-0be094a2d049',
  'mummy':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2Fmr_t.png?alt=media&token=5afeecf7-9a64-4425-b059-0be094a2d049',
  'queen':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2Fqueen.png?alt=media&token=5f976f60-26da-4937-808a-bfc08773cbdd',
  'spiderman':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2Fspiderman.png?alt=media&token=c11f14ec-afe2-47ec-9d97-a51af878d2e2',
  'wolverine':
      'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2Fwolverine.png?alt=media&token=339a799a-52c6-4441-aff9-7989e95fd806',
};

class CustomAvatarRadioWidget extends StatefulWidget {

  final Participant participant;

  const CustomAvatarRadioWidget({Key key, this.participant}) : super(key: key);

  @override
  _CustomAvatarRadioWidgetState createState() =>
      _CustomAvatarRadioWidgetState();
}

class _CustomAvatarRadioWidgetState extends State<CustomAvatarRadioWidget> {
  List<RadioModel> avatars = [];

  @override
  void initState() {
    avatarURLs.forEach((key, value) {
      avatars.add(RadioModel(false, value));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 300.0,
          maxHeight: 300.0,
        ),
        padding: EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: Colors.white70,
          border: Border.all(
            color: PROJECT_NAVY_BLUE.withOpacity(0.1),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: GridView.builder(

          itemCount: avatars.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: (){
                setState(() {
                  avatars.forEach((element) => element.isSelected = false);
                  avatars[index].isSelected = true;
                  widget.participant.profilePhotoURL = avatars[index].avatarURL;
                });
              },
              child: RadioItem(avatars[index]),
            );
          },
        ),
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CachedNetworkImage(
        imageUrl: _item.avatarURL,
        imageBuilder: (context, imageProvider) {
          return Container(
            width: 50.0,
            height: 50.0,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _item.isSelected ? PROJECT_LIGHT_GREEN : Colors.white,
              border: Border.all(
                width: 2.0,
                color: _item.isSelected ? PROJECT_GREEN : Colors.white,
              ),
            ),
            child: Image(
              image: imageProvider,
            ),
          );
        },
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String avatarURL;

  RadioModel(this.isSelected, this.avatarURL);
}
