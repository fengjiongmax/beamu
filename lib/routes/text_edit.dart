import 'package:flutter/material.dart';
// import 'package:zefyr/zefyr.dart';
import 'package:notus/notus.dart';
import 'package:notus/convert.dart';
import 'package:quill_delta/quill_delta.dart';

import 'package:beamu/share/requests.dart';

import 'package:beamu/model/issue_model.dart';
import 'package:beamu/model/issue_comment_model.dart';

enum FINISH_METHOD{
  POST,
  PATCH
}

enum BODY{
  ISSUE,
  COMMENT
}
//this editor only update/create body
class Editor extends StatefulWidget{
  final FINISH_METHOD method;
  final String url;
  final BODY body;
  final IssueModel issue;
  final IssueCommentModel comment;

  Editor({@required this.method,@required this.url,@required this.body,this.issue,this.comment,Key key}):super(key:key);

  @override
  EditorState createState() => new EditorState();
}

class EditorState extends State<Editor>{

  String content;
  TextEditingController _controller ;
  bool _hintTextChanged = false;
  FocusNode _focusNode;

  @override
  void initState(){
    _focusNode = new FocusNode();
    super.initState();
    if(widget.body == BODY.ISSUE){
      _controller = new TextEditingController(text: widget.issue==null?'':widget.issue.body);
    }
    else if(widget.body == BODY.COMMENT){
      _controller = new TextEditingController(text: widget.comment==null?'':widget.comment.body);
    }
    setState(() {
      content=_controller.text;
    });
  }

  @override
  void dispose(){
    _focusNode.dispose();
    super.dispose();
  }

  Future<bool> _saveValue() async{
    bool _retVal = false;
    var _bodyString = _controller.text;
    switch(widget.body){
      case BODY.COMMENT:
        if(widget.comment == null && widget.method == FINISH_METHOD.POST){//update comment is not available for now
          var response = await httpPost(widget.url, '{"body":"'+_bodyString+'"}');
          _retVal = response.statusCode == 201;
          _hintTextChanged = false;
        }
        break;
      case BODY.ISSUE:
        // if(issue == null && method == FINISH_METHOD.POST){
        //   var response = await httpPost(url, '{"body":"'+_bodyString+'"}');
        //   _retVal 
        // }
        break;
    }
    return _retVal;
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Save changes?'),
        content: new Text('Changes was not saved'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            } ,
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () async{ 
              var _val = await _saveValue();
              Navigator.pop(context,_val);
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) =>
        WillPopScope(
          onWillPop:_hintTextChanged? _onWillPop:null,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: Text('editing'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: (){
                    _saveValue().then((v){
                      Navigator.pop(context,v);
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
                    focusNode: _focusNode,
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (v){
                      if(v!= content){
                        setState(() {
                          _hintTextChanged=true;
                         });
                      }
                    },
                  ),
                )
              ),
          ),
        )
    );
  }
}