import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';

class QuestionTile extends StatelessWidget {
  const QuestionTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: InkWell(
        onTap: (){},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1.1 Getting to know you',
              style: TextStyle(
                color: PROJECT_GREEN,
                fontSize: 14.0,
              ),
            ),
            Icon(
              Icons.arrow_forward,
              color: PROJECT_GREEN,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
