import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;
import 'dart:js' as js;

var someVariable = html.querySelector('#RipVanWinkle');

class QuillScreen extends StatefulWidget {
  @override
  _QuillScreenState createState() => _QuillScreenState();
}

class _QuillScreenState extends State<QuillScreen> {
  String _src = 'quill.html';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: EasyWebView(
              height: 500.0,
              width: 500.0,
              src: _src,
              onLoaded: () {},
            ),
            // child: WebView(
            //   initialUrl: 'assets/quill.html',
            // ),
          ),
          FlatButton(onPressed: () {

            var text = js.context.callMethod('readLocalStorage');

            print(text);

          }, child: Text('Alert'),),
        ],
      ),
    );
  }
}
