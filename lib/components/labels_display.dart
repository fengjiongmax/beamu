/*
components/labels_display.dart
*/

import 'package:flutter/material.dart';

import 'package:beamu/model/label_model.dart';

class LabelCard extends StatelessWidget{
  final LabelModel label;

  LabelCard({this.label,Key key}):assert(label != null),super(key:key);

  @override
  Widget build(BuildContext context) {
    Color colorPicker = new Color(int.parse('0xFF'+label.color));
      var y = 0.2126*colorPicker.red + 0.7152*colorPicker.green + 0.0722*colorPicker.blue;
      return Card(
        child: Container(
          color: colorPicker,
          child: ListTile(
            title: Text(
              label.name,
              style: TextStyle(
                color:y<128? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      );
  }
}

class LabelsDisplay extends StatelessWidget{
  final ScrollController scrollController;
  final List<LabelModel> labels;

  LabelsDisplay({this.labels,this.scrollController,Key key}):super(key:key);

  @override
  Widget build(BuildContext context) {

    return ListView(
      controller: scrollController,
      children: labels.map((l){
        return LabelCard(label: l,);
      }).toList(),
    );
  }

}