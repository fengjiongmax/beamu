import 'package:flutter/material.dart';

import 'package:beamu/model/label_model.dart';

class LabelSelector extends StatefulWidget{
  final List<LabelModel> repoLabels;
  final List<LabelModel> selectedLabels;

  LabelSelector({this.repoLabels,this.selectedLabels,Key key})
                :assert(selectedLabels != null),
                  super(key:key);

  @override
  _LabelSelectorState createState() => _LabelSelectorState();
}

class _LabelSelectorState extends State<LabelSelector>{
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Select Labels'),
        content: ListView(
          children: widget.repoLabels ==null?<Widget>[]: widget.repoLabels.map((l){
            Color colorPicker = new Color(int.parse('0xFF'+l.color));
            var y = 0.2126*colorPicker.red + 0.7152*colorPicker.green + 0.0722*colorPicker.blue;
            return Card(
              child: Container(
                color: colorPicker,
                child: ListTile(
                  title: Text(
                    l.name,
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color:y<128? Colors.white : Colors.black,
                    ),
                  ),
                  trailing: widget.selectedLabels != null && widget.selectedLabels.map((f){
                    return f.id;
                  }).toList().contains(l.id)? Icon(Icons.check,color: y<128? Colors.white : Colors.black,):null,
                  onTap: (){
                    if(widget.selectedLabels.contains(l))
                    {
                      widget.selectedLabels.remove(l);
                    }
                    else{
                      widget.selectedLabels.add(l);
                    }
                    setState(() { });
                  },
                ),
              ),
            );
          }).toList(),
        ),
        actions: <Widget>[
          MaterialButton(
            child: Text('Clear'),
            onPressed: (){
              widget.selectedLabels.clear();
              Navigator.pop(context);
            },
          ),
          MaterialButton(
            child: Text('Close'),
            onPressed: (){
              Navigator.pop(context);
            },
          )
        ],
      );
  }

}

