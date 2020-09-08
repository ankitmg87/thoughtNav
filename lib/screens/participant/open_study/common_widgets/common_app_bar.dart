import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/string_constants.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        APP_NAME,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      leading: GestureDetector(
        onTap: () {},
        child: Container(
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Color(0xFFB6ECC7),
            shape: BoxShape.circle,
          ),
          child: Image(
            image: AssetImage('images/avatars/batman.png'),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.menu,
            color: PROJECT_GREEN,
          ),
          onPressed: () {},
        ),
      ],
    );
    ;
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
