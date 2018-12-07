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
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Select labels'),
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
                    style: TextStyle(
                      color:y<128? Colors.white : Colors.black,
                    ),
                  ),
                  trailing: widget.selectedLabels != null && widget.selectedLabels.contains(l)? Icon(Icons.check,color: y<128? Colors.white : Colors.black,):null,
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
            child: Text('Close'),
            onPressed: (){
              Navigator.pop(context);
            },
          )
        ],
      );
  }

}

