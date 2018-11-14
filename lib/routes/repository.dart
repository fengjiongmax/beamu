import 'package:flutter/material.dart';

import 'package:beamu/data/issue_data.dart';
import 'package:beamu/data/repository_content.dart';

import 'package:beamu/model/repository_model.dart';
import 'package:beamu/model/issue_model.dart';

import 'package:beamu/components/markdown_render.dart';

import 'package:beamu/share/time_since.dart';
import 'issue.dart';


class Repository extends StatefulWidget{
  final RepositoryModel repo;

  Repository({@required this.repo,Key key}):super(key:key);

  @override
  State<StatefulWidget> createState() => new RepositoryState(repo: repo);

}

class RepositoryState extends State<Repository> with SingleTickerProviderStateMixin {
  final RepositoryModel repo;

  List<IssueModel> _issues = new List<IssueModel>();
  TabController _tabController;

  String _readme;


  var _issueLoading = true;
  var _readmeLoading = true;

  RepositoryState({@required this.repo}):super();

  @override
  void initState(){
    super.initState();
    _tabController = TabController(vsync: this,length: tabContents.length);
    getRepoIssues(repo.owner.username, repo.name).then((v){
      if(this.mounted){
        setState(() {
          _issues.addAll(v);
          _issueLoading=false;
        });
      }
    });
    getREADME(repo).then((v){
      if(this.mounted){
        setState(() {
          _readme = v;
          _readmeLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(
            children: <Widget>[
              Text(repo.owner.username+"/"+repo.name),
              Text(timeSince(repo.updatedAt))
            ],
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: tabContents.map((tab){
            return Tab(
              text:tab.title
            );
          }).toList()
        ),
      ),
      body:  TabBarView(
        controller: _tabController,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: MarkdownRender(data: _readme==null?'README.md not found':_readme,),
          ),
          IssueList(issues: _issues,repo: repo,),
          Center(child: Text("SETTINGS!"),)
        ],
      )
    );
  }
}

class IssueList extends StatelessWidget{
  final RepositoryModel repo;
  final List<IssueModel> issues;

  const IssueList({this.repo,this.issues});

  @override
  Widget build(BuildContext context) {
    
  if(issues ==null || issues.isEmpty || issues.length==0){
    return Center(child: Text('Issue not found'));
  }
  return ListView(
      children: issues.map((issue){
        // String updateSince = timeSince(issue.updateAt);
        return Card(
          child: Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(16, 0, 14, 0),
                  title: Text(
                    issue.title,
                    softWrap: true,
                    ),
                  subtitle: Text("#"+issue.number.toString()+" by "+issue.user.username),
                  trailing: Container(
                    width: 40,
                    height: 10,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.chat),
                        Text(issue.comments.toString())    
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context)=>Issues(repo: repo,issue: issue)
                      )
                    );
                  },
                ),
                issue.labels != null?Container(
                  height: 35.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:  issue.labels.map((label){
                      Color colorPicker = new Color(int.parse('0xFF'+label.color));
                      var y = 0.2126*colorPicker.red + 0.7152*colorPicker.green + 0.0722*colorPicker.blue;
                      return Container(
                        height: 12.0,
                        margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color:colorPicker
                        ),
                        child: Text(
                          label.name,
                          style: TextStyle(
                            color:y<128? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    }).toList()
                  ),
                ):null,
              ],
            ),
          )
        );
      }).toList()
    );
  }
}

class Choice{
  const Choice({this.title});

  final String title;
}

const List<Choice> tabContents = const <Choice>[
  const Choice(title: 'README'),
  const Choice(title: 'ISSUES'),
  const Choice(title: 'SETTINGS')
];

// class TabContent extends StatefulWidget{

// }