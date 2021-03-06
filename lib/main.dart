import 'package:flutter/material.dart';

import 'routes/login.dart';
import 'routes/repositories_list.dart';

import 'package:beamu/components/loading.dart';

import 'share/authorizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beamu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>{
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loginCHK(),
      builder: (BuildContext context,AsyncSnapshot snapshot){
        if(snapshot.hasData){
          if(snapshot.data){
            return RepositoriesList();
          }else{
            return Login();
          }
        }
        return Scaffold(
          body: Center(
            child: LoadingContent(),
          ),
        );
      },
    );
  }
}
