/*
components/markdown_render.dart
*/

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownRender extends StatelessWidget{
  final String data;

  MarkdownRender({@required this.data,Key key}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      onTapLink: (url){
        _launchURL(url);
      },
    );
  }

  _launchURL(String url) async{
    if(await canLaunch(url)){
      await launch(url);
    }

  }

}