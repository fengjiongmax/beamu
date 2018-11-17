import 'package:flutter/material.dart';


void showToast(BuildContext context,String content){
  final scaffold = Scaffold.of(context);

  scaffold.showSnackBar(
    SnackBar(
      content: Text(content),
      action: SnackBarAction(
        label: 'OKAY',onPressed: scaffold.hideCurrentSnackBar,
      ),
    )
  );
}