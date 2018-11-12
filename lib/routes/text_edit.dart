import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';
import 'package:notus/notus.dart';
import 'package:notus/convert.dart';

class Editor extends StatefulWidget{

  @override
  EditorState createState() => new EditorState();
}

class EditorState extends State<Editor>{
  static final document = new NotusDocument();
  final ZefyrController _controller = new ZefyrController(document);
  final FocusNode _focusNode = new FocusNode();
  static const NotusMarkdownCodec notusMarkdownCodec = const NotusMarkdownCodec();

  void dosomethign(){
    print(notusMarkdownCodec.encode(_controller.document.toDelta()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('editing'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: dosomethign
          )
        ],
      ),
      body: ZefyrEditor(
        controller: _controller,
        focusNode: _focusNode,
        
      ),
    );
  }
}