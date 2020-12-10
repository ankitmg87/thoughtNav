import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;

import 'dart:ui' as ui;

import 'package:webview_flutter/webview_flutter.dart';

class QuillScreen extends StatefulWidget {
  @override
  _QuillScreenState createState() => _QuillScreenState();
}

class _QuillScreenState extends State<QuillScreen> {
  html.Element variable;

  @override
  void initState() {
    // variable = ui.platformViewRegistry.registerViewFactory(
    //     'hello-world-html',
    //         (int viewId) => IFrameElement()
    //       ..width = '640'
    //       ..height = '360'
    //       ..src = 'assets/quill.html'
    //       ..style.border = 'none'
    // );

    variable = html.querySelector('#quill.html');

    //print(variable.className);
    //print(variable.dir);
    //print(variable.baseUri);

    var type = 'click';

    var iFrameElement = html.IFrameElement()
      ..src = 'assets/quill.html'
      ..addEventListener('click', (event){
      })
      ..onLoad.listen((event) {
        print('quill loaded');
      });

    // ignore: undefined_prefixed_name
    // ui.platformViewRegistry.registerViewFactory(
    //   'quillEditor',
    //   (int viewId) => iFrameElement,
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(variable.innerHtml);

    return Scaffold(
      body: Container(
        child: Center(
          child: HtmlElementView(
            viewType: 'quillEditor',
          ),
        ),
        // child: WebView(
        //   initialUrl: 'assets/quill.html',
        // ),
      ),
    );
  }
}
