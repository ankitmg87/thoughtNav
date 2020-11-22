import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/client.dart';

class ClientTile extends StatelessWidget {

  final Client client;

  const ClientTile({Key key, this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var _selected = false;

    return Container(
      padding: EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          Theme(
            data: ThemeData(
              accentColor: PROJECT_NAVY_BLUE,
              unselectedWidgetColor: Colors.grey[400],
            ),
            child: Checkbox(
              value: _selected,
              onChanged: (value) {
                _selected = !_selected;
              },
            ),
          ),
          SizedBox(
            width: 40.0,
          ),
          Expanded(
            child: Text(client.email),
          ),
          SizedBox(
            width: 40.0,
          ),
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(
                  10.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    4.0,
                  ),
                  border: Border.all(
                    color: Colors.grey[300],
                    width: 0.5,
                  ),
                ),
                child: Text(
                  'Unassigned',
                ),
              ),
            ),
          ),
          SizedBox(
            width: 40.0,
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.ellipsis_vertical,
              size: 14.0,
              color: Colors.grey[600],
            ),
            onPressed: () {},
          ),
          SizedBox(
            width: 20.0,
          ),
        ],
      ),
    );
  }
}
