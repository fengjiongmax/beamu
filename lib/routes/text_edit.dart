import 'package:flutter/material.dart';
// import 'package:zefyr/zefyr.dart';
import 'package:notus/notus.dart';
import 'package:notus/convert.dart';
import 'package:quill_delta/quill_delta.dart';

enum FINISH_METHOD{
  POST,
  PATCH
}

class Editor extends StatefulWidget{
  final FINISH_METHOD method;
  final String url;
  final String content;

  Editor({this.method,this.url,this.content,Key key}):super(key:key);

  @override
  EditorState createState() => new EditorState(method: method,url: url,content: content);
}

class EditorState extends State<Editor>{
  final FINISH_METHOD method;
  final String url;
  final String content;

  EditorState({this.method,this.url,this.content}):super();

  TextEditingController _controller ;
  bool _hintTextChanged = false;

  Future<bool> _saveValue() async{
    bool _retVal = false;

    return _retVal;
  }

  // TODO: check if text has changed
  // @override
  // void dispose(){
  //   if(!_hintTextChanged){
  //     super.dispose();
  //   }
  //   else{
  //     final snackBar = SnackBar(
  //       content: ListTile(
  //         title: Text('Save changes?'),
  //         trailing: Row(
  //           children: <Widget>[
  //             Text("hello"),
  //             Text("show")
  //           ],
  //         ),
  //       ),
  //     );
  //     Scaffold.of(context).showSnackBar(snackBar);
  //   }
  // }

  @override
  void initState(){
    super.initState();
    _controller = new TextEditingController(text: content);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) =>
        Scaffold(
          appBar: AppBar(
            title: Text('editing'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.save),
                onPressed: (){
                  _saveValue().then((v){
                    if(v){
                      print('success!');
                    }
                  });
                }
              )
            ],
          ),
          body: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: SingleChildScrollView(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (v){
                    if(v!= content){
                      _hintTextChanged=true;
                    }
                  },
                ),
              )
            ),
        )
    );
  }
}