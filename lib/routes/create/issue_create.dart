import 'package:flutter/material.dart';

import 'package:beamu/model/issue_model.dart';

class IssueCreator extends StatefulWidget{
  @override
  _IssueCreatorState createState() => _IssueCreatorState();
}

class _IssueCreatorState extends State<IssueCreator>{
  PageController _pageController;

  @override
  void initState(){
    _pageController = new PageController();
    super.initState();
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        pageSnapping: true,
        children: <Widget>[
          Scaffold(
            body: Center(child: Text("Hello"),),      
            bottomNavigationBar: Row(
              children: <Widget>[
                SizedBox(width: 10,),
                Expanded(
                  child: RaisedButton(
                    onPressed: (){
                      _pageController.previousPage(duration: Duration(milliseconds: 400),curve: Curves.fastOutSlowIn);
                    },
                    child: Text("Cancel"),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: RaisedButton(
                    onPressed: (){
                      _pageController.nextPage(duration: Duration(milliseconds: 400),curve: Curves.fastOutSlowIn);
                    },
                    child: Text("Don't press me"),
                  ),
                ),
                SizedBox(width: 10,),
              ],
            )
          ),
          Scaffold(
            body: Center(child: Text("World"),),
            bottomNavigationBar: Row(
              children: <Widget>[
                SizedBox(width: 10,),
                Expanded(
                  child: RaisedButton(
                    onPressed: (){
                      _pageController.previousPage(duration: Duration(milliseconds: 400),curve: Curves.fastOutSlowIn);
                    },
                    child: Text("Press me"),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: RaisedButton(
                    onPressed: (){
                      _pageController.nextPage(duration: Duration(milliseconds: 400),curve: Curves.fastOutSlowIn);
                    },
                    child: Text("Don't press me"),
                  ),
                ),
                SizedBox(width: 10,),
              ],
            )
          ),
        ],
      ),
    );
  }
}

