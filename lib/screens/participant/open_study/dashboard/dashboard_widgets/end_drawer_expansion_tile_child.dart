import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';

class EndDrawerExpansionTileChild extends StatelessWidget {

  final String label;
  final Function onTap;

  const EndDrawerExpansionTileChild({
    Key key, this.label, this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap ?? (){},
      title: Text(
        label,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: 12.0,
        ),
      ),
      trailing: Icon(
        Icons.check_circle_outline,
        color: PROJECT_GREEN,
        size: 16.0,
      ),
      contentPadding: EdgeInsets.only(left: 30.0, right: 16.0,),
    );
  }
}