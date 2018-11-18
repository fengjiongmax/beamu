import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:beamu/data/user_data.dart';
import 'package:beamu/data/issue_data.dart';
import 'package:beamu/data/repository_data.dart';
import 'package:beamu/data/milestone_data.dart';
import 'package:beamu/data/label_data.dart';

import 'package:beamu/model/repository_model.dart';
import 'package:beamu/model/issue_model.dart';
import 'package:beamu/model/milestone_model.dart';
import 'package:beamu/model/label_model.dart';
import 'package:beamu/model/user_model.dart';

import 'package:beamu/components/markdown_render.dart';
import 'package:beamu/components/center_text.dart';
import 'package:beamu/components/loading.dart';
import 'package:beamu/components/drawer.dart';

import 'package:beamu/share/time_since.dart';
import 'package:beamu/routes/issue.dart';


class Repository extends StatefulWidget{
  final RepositoryModel repo;

  Repository({@required this.repo,Key key}):super(key:key);

  @override
  State<StatefulWidget> createState() => new RepositoryState(repo: repo);

}

class RepositoryState extends State<Repository> with SingleTickerProviderStateMixin {
  final RepositoryModel repo;

  List<MilestoneModel> _milestones = new List<MilestoneModel>();
  List<IssueModel> _issues = new List<IssueModel>();
  String _readme;
  List<UserModel> _collaborators = new List<UserModel>();
  List<LabelModel> _labels = new List<LabelModel>();

  TabController _tabController;

  var _readmeLoading = true;

  RepositoryState({@required this.repo}):super();

  Widget _buildUrlList(BuildContext curContext){

    List<UrlContain> urlList = [
      UrlContain(title: 'SSH',url: repo.sshUrl),
      UrlContain(title: 'HTML',url: repo.htmlUrl),
      UrlContain(title: 'CLONE',url: repo.cloneUrl)
    ];
    return Center(
      child: ListView(
        children: urlList.map((k){
          return Container(
            child: Card(
              child: ListTile(
                leading: Text(k.title),
                title: Text(k.url),
                trailing: IconButton(
                  icon: Icon(Icons.content_copy),
                  onPressed: () async{
                    Clipboard.setData(ClipboardData(text: k.url)).then((v){
                      final snackBar = SnackBar(
                        content: Text('Copied to clipboard'),
                      );
                      Scaffold.of(curContext).showSnackBar(snackBar);
                    });
                  },
                ),
              ),
            )
          );
        }).toList(),
      ),
    );
  }

  @override
  void initState(){
    super.initState();
    _tabController = TabController(vsync: this,length: tabContents.length);
    getRepoIssues(repo).then((v){
      if(this.mounted){
        setState(() {
          _issues.addAll(v);
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
    getRepoMilestones(repo).then((v){
      if(this.mounted){
        setState(() {
          _milestones.addAll(v);
        });
      }
    });
    getRepoCollaborators(repo).then((v){
      if(this.mounted){
        setState(() {
          _collaborators.addAll(v);
        });
      }
    });
    getRepoLabels(repo).then((v){
      if(this.mounted){
        setState(() {
          _labels.addAll(v);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BeamuDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
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
      body:  Builder(
        builder: (context)=>TabBarView(
          controller: _tabController,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: _readmeLoading?LoadingContent(): _readme==null?CenterText(centerText: 'README.md not found',) : MarkdownRender(data:_readme,),
            ),
            IssueList(issues: _issues,repo: repo,),
            MilestoneList(milestoneList: _milestones,),
            CollaboratorList(collaborators: _collaborators,),
            LabelList(labels: _labels,),
            _buildUrlList(context),
          ],
        ),
      )
    );
  }
}

class UrlContain{
  final String title;
  final String url;

  const UrlContain({this.title,this.url});
}

class Choice{
  const Choice({this.title});

  final String title;
}

const List<Choice> tabContents = const <Choice>[
  const Choice(title: 'README'),
  const Choice(title: 'ISSUES'),
  const Choice(title: 'MILESTONES'),
  const Choice(title: 'COLLABORATORS'),
  const Choice(title: 'LABELS'),
  const Choice(title: 'URLS')
];

class IssueList extends StatelessWidget{
  final RepositoryModel repo;
  final List<IssueModel> issues;

  const IssueList({this.repo,this.issues,Key key}):super(key:key);

  @override
  Widget build(BuildContext context) {

  if(issues==null){
    return LoadingContent();
  }
    
  if(issues ==null || issues.isEmpty || issues.length==0){
    return CenterText(centerText: 'Issue not found',);
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

class MilestoneList extends StatelessWidget{
  final List<MilestoneModel> milestoneList;

  MilestoneList({@required this.milestoneList,Key key}):super(key:key);

  final DateFormat formatter = new DateFormat('yyyy-MM-dd');

  Widget _buildSingleMilestone(MilestoneModel milestone){
    return Card(
      child: ListTile(
        leading: milestone.state=='closed'?Icon(Icons.cancel,color: Colors.red,):Icon(Icons.check_box,color: Colors.green),
        title: Text(milestone.title),
        trailing: Container(
          width: 40,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                Icon(Icons.check_box,color: Colors.grey,size: 15,),
                Text(milestone.openIssues.toString())
              ],),
              Row(
                children: <Widget>[
                Icon(Icons.cancel,color: Colors.grey,size: 15,),
                Text(milestone.closedIssues.toString())
              ],)
            ],
          ),
        ),
        subtitle: Text(formatter.format(milestone.state=='open'?milestone.dueOn:milestone.closedAt)),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if(milestoneList== null){
      return LoadingContent();
    }

    if(milestoneList.isEmpty || milestoneList.length==0){
      return CenterText(centerText: 'Milestone not found',);
    }
    return ListView(
      children: milestoneList.map((m) =>  _buildSingleMilestone(m)).toList(),
    );
  }
}

class CollaboratorList extends StatelessWidget{
  final List<UserModel> collaborators;

  CollaboratorList({@required this.collaborators,Key key}):super(key:key);

  Widget _buildUserCard(UserModel user){
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18.0/11.0,
            child: Image.network(user.avatarUrl),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(user.username)
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(collaborators== null){
      return LoadingContent();
    }

    if(collaborators.isEmpty || collaborators.length==0){
      return CenterText(centerText: 'Collaborators not found',);
    }
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(16.0),
      childAspectRatio: 8.0/9.0,
      children: collaborators.map((u){
        return _buildUserCard(u);
      }),
    );
  }
}

class LabelList extends StatelessWidget{
  final List<LabelModel> labels;

  LabelList({this.labels,Key key}):super(key:key);

  Widget _buildLabelCard(LabelModel label){
    Color colorPicker = new Color(int.parse('0xFF'+label.color));
    var y = 0.2126*colorPicker.red + 0.7152*colorPicker.green + 0.0722*colorPicker.blue;
    return Card(
      child: Container(
        color: colorPicker,
        child: ListTile(
          title: Text(
            label.name,
            style: TextStyle(
              color:y<128? Colors.white : Colors.black,
            ),
          ),
          //TODO: Edit label
          // trailing: IconButton(
          //   icon: Icon(Icons.edit,color: Colors.grey,),
          //   onPressed: (){
              
          //   },
          // ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    if(labels== null){
      return LoadingContent();
    }

    if(labels.isEmpty || labels.length==0){
      return CenterText(centerText: 'Labels not found',);
    }
    return ListView(
      children: labels.map((l){
        return _buildLabelCard(l);
      }).toList(),
    );
  }
}




