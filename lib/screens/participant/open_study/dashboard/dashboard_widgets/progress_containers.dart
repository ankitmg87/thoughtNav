import 'package:flutter/material.dart';

class StartProgressContainer extends StatelessWidget {
  const StartProgressContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(1.0),
        height: 10.0,
        decoration: BoxDecoration(
          color: Color(0xFFDFE2ED).withOpacity(0.5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
          ),
        ),
      ),
    );
  }
}

class MiddleProgressContainer extends StatelessWidget {
  const MiddleProgressContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(0.5),
        height: 10.0,
        color: Color(0xFFDFE2ED).withOpacity(0.5),
      ),
    );
  }
}

class EndProgressContainer extends StatelessWidget {
  const EndProgressContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(1.0),
        height: 10.0,
        decoration: BoxDecoration(
          color: Color(0xFFDFE2ED).withOpacity(0.5),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ),
      ),
    );
  }
}