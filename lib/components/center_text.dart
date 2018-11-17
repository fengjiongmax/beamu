import 'package:flutter/material.dart';

class CenterText extends StatelessWidget{
  final String centerText;

  CenterText({this.centerText,Key key}):super(key:key);

  @override
  Widget build(BuildContext context){
    return Center(
      child: Text(
        centerText
      ),
    );
  }
}