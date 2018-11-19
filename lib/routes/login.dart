import 'package:flutter/material.dart';
import 'package:beamu/share/authorizations.dart';

import 'repositories_list.dart';

class Login extends StatefulWidget{
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login>{
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _gogsHostController = TextEditingController();

  var _buttonPressed = false;

  Widget _buildLoginPage(){
    return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              children: <Widget>[
                SizedBox(height: 80.0),
                Column(
                  children: <Widget>[
                    // Image.asset('assets/gogs-lg.png',height: 80.0,width: 80.0),
                    SizedBox(height: 16.0),
                    Text('BEAM'),
                  ],
                ),
                SizedBox(height: 12.0),
                TextField(
                  controller: _gogsHostController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Your Gogs instance',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: (){
                        _gogsHostController.clear();
                      },
                    )
                  ),
                ),
                SizedBox(height: 12.0),
                TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    labelText: 'Username or email',
                    filled: true
                  ),
                ),
                SizedBox(height: 12.0),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                Center(
                  child: RaisedButton(
                    child: _buttonPressed? Text('Trying..'):Text("Login"),
                    onPressed: () {
                      if(_buttonPressed) return;
                      setState(() {
                        _buttonPressed=true;
                      });
                      loginAction(_userNameController.text, _passwordController.text, _gogsHostController.text).then((v){
                        if(v == LOGIN_STAT.success){
                          Navigator.of(context).pop();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RepositoriesList()));
                        }
                      });
                    },
                  ),
                )
              ],
            ),
          )
        );
  }

  @override
  Widget build(BuildContext context) {
    return _buildLoginPage();
  }

}
