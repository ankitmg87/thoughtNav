import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';

class CustomFlatButton extends StatelessWidget {

  final String label;
  final String routeName;

  const CustomFlatButton({
    Key key, @required this.label, @required this.routeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        children: [
          Expanded(
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: PROJECT_GREEN,
              onPressed: (){
                if(routeName != null){
                  Navigator.of(context).pushNamedAndRemoveUntil(routeName, (route) => false);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
