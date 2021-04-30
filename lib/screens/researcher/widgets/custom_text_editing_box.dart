// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';

class CustomTextEditingBox extends StatefulWidget {
  final String hintText;
  final String initialValue;

  const CustomTextEditingBox({
    Key key,
    @required this.hintText,
    @required this.initialValue,
  }) : super(key: key);

  @override
  _CustomTextEditingBoxState createState() => _CustomTextEditingBoxState();
}

class _CustomTextEditingBoxState extends State<CustomTextEditingBox> {
  String _text;

  @override
  void initState() {
    super.initState();
    _text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        var size = MediaQuery.of(context).size;

        return Center(
          child: Material(
            color: Colors.white,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.75,
              ),
              color: Colors.white,
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: _text,
                    minLines: 5,
                    maxLines: 10,
                    onChanged: (text) {
                      _text = text;
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: _text ?? widget.hintText,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.0),
                        borderSide: BorderSide(
                          color: Colors.grey[400],
                          width: 0.5,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FlatButton(
                        onPressed: () => Navigator.pop(context, _text),
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      FlatButton(
                        onPressed: _text == null || _text.isEmpty
                            ? null
                            : () {
                                Navigator.pop(context, _text);
                              },
                        child: Text(
                          'SAVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        color: PROJECT_GREEN,
                        disabledColor: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
