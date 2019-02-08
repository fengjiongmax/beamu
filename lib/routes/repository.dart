/*
routes/repository.dart
*/

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:beamu/data/user_data.dart';
import 'package:beamu/data/issue_data.dart';
import 'package:beamu/data/repository_data.dart';
import 'package:beamu/data/milestone_data.dart';
import 'package:beamu/data/label_data.dart';
import 'package:beamu/data/organization_data.dart';

import 'package:beamu/model/repository_model.dart';
import 'package:beamu/model/issue_model.dart';
import 'package:beamu/model/milestone_model.dart';
import 'package:beamu/model/label_model.dart';
import 'package:beamu/model/user_model.dart';
import 'package:beamu/model/organization_model.dart';

import 'package:beamu/model/app/tab_choice.dart';

import 'package:beamu/components/markdown_render.dart';
import 'package:beamu/components/center_text.dart';
import 'package:beamu/components/loading.dart';
import 'package:beamu/components/drawer.dart';
import 'package:beamu/components/labels_display.dart';

import 'package:beamu/share/time_since.dart';

import 'package:beamu/routes/issue.dart';
import 'package:beamu/routes/create/issue_create.dart';

class UrlContain{
  final String title;
  final String url;

  const UrlContain({this.title,this.url});
}

const List<Choice> tabContents = const <Choice>[
  const Choice(title: 'README' ,showFab: false),
  const Choice(title: 'ISSUES' ,showFab: true),
  const Choice(title: 'MILESTONES',showFab: true),
  const Choice(title: 'COLLABORATORS',showFab: true),
  const Choice(title: 'LABELS',showFab: true),
  const Choice(title: 'URLS',showFab: false)
];

class Repository extends StatefulWidget{
  final String owner;
  final String repoName;

  // final RepositoryModel repo;
  final bool isOwnerOrg;

  Repository({@required this.owner,@required this.repoName,@required this.isOwnerOrg,Key key}):super(key:key);

  @override
  State<StatefulWidget> createState() => new RepositoryState();

}

class RepositoryState extends State<Repository> with SingleTickerProviderStateMixin {
  List<MilestoneModel> _milestones = List<MilestoneModel>();
  List<IssueModel> _issues = List<IssueModel>();
  String _readme;
  List<UserModel> _collaborators = new List<UserModel>();
  List<LabelModel> _labels = new List<LabelModel>();
  List<UserModel> _orgMembers = new List<UserModel>();
  RepositoryModel _repo;

  TabController _tabController;
  ScrollController _scrollController;

  bool _readmeLoading = true;
  bool _showFAB = false;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(vsync: this,length: tabContents.length);
    _tabController.addListener(_tabChange);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    _getRepoInfo();
    _getIssues();
    _getLables();
    _getMilestones();
    _getCollaborators();
    _getOwnerMembers();
  }

  @override
  void dispose(){
    _tabController.removeListener(_tabChange);
    _tabController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _showFAB?FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _onPlusPressed,
      ):null,
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
              Text(widget.owner+"/"+widget.repoName),
              // Text(timeSince(widget.repo.updatedAt))
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
            _buildIssueList(),
            _buildMilestones(),
            _buildCollaborators(),
            _buildLabels(),
            _buildUrlList(context),
          ],
        ),
      )
    );
  }

  void _onPlusPressed() async{
    switch(_tabController.index){
      case 0:
        break;
      case 1:
        // var _assigneeCandidate = _collaborators.sublist(0);//this copy from _collaborators to _assigneeCandidate
        // if(widget.isOwnerOrg) _assigneeCandidate.addAll(_orgMembers); // add member if owner of this repo is org
        // else if(!_collaborators.contains(widget.owner)) _assigneeCandidate.add(widget.owner); //add owner if does not contains owner
        // await Navigator.push(context, MaterialPageRoute(
        //   builder: (context) => IssueCreator(repo: widget.repo,
        //                                     repoLabels: _labels,
        //                                     repoMilestones: _milestones,
        //                                     assigneeCandidate: _assigneeCandidate,)
        // ));
        break;
      case 2:
        print("2");
        break;
    }
    //TODO:handle plus button press.
    print(_tabController.index.toString());
  }

  void _tabChange(){
    setState(() {
      _showFAB=tabContents[_tabController.index].showFab && tabContents[_tabController.index].title=='ISSUES';
      // _fabChild=_showFAB?tabContents[_tabController.index].fabIcon:null;
    });
  }

  void _scrollListener(){
    setState(() {
      // _showFAB = !(
      //             _scrollController.position.userScrollDirection == ScrollDirection.reverse 
      //               && tabContents[_tabController.index].showFab 
      //               && (widget.repo.permissions.admin || tabContents[_tabController.index].title=='ISSUES')
      //             );
    });
  }

  Widget _buildUrlList(BuildContext curContext){
    if(_repo == null){
      return LoadingContent();
    }

    List<UrlContain> urlList = [
      UrlContain(title: 'SSH',url: _repo.sshUrl),
      UrlContain(title: 'HTML',url: _repo.htmlUrl),
      UrlContain(title: 'CLONE',url: _repo.cloneUrl)
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

  Widget _buildIssueList(){
  if(_issues==null){
    return LoadingContent();
  }
    
  if(_issues ==null || _issues.isEmpty || _issues.length==0){
    return CenterText(centerText: 'No issue',);
  }
  return ListView(
    controller: _scrollController,
      children: _issues.map((issue){
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
                  onTap: () async{
                    //TODO:update depend on if issue's updated.

        var _assigneeCandidate = _collaborators.sublist(0);//this copy from _collaborators to _assigneeCandidate
        if(widget.isOwnerOrg) _assigneeCandidate.addAll(_orgMembers); // add member if owner of this repo is org
        else if(!_collaborators.contains(widget.owner)) _assigneeCandidate.add(_repo.owner); //add owner if does not contains owner
                    await Navigator.of(context).push<bool>(MaterialPageRoute(
                                            builder: (context)=>Issues(repo: _repo,
                                                                        issue: issue,
                                                                        repoIssues: _issues,
                                                                        repoLabels: _labels,
                                                                        repoMilestones: _milestones,
                                                                        assigneeCandidate: _assigneeCandidate,
                                                                )
                                          )
                                        );
                    _getIssues();
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

  Widget _buildLabels(){
    if(_labels== null){
      return LoadingContent();
    }

    if(_labels.isEmpty || _labels.length==0){
      return CenterText(centerText: 'No label',);
    }

    return LabelsDisplay(labels: _labels,scrollController: _scrollController,);
  }

  Widget _buildMilestones(){
    if(_milestones== null){
      return LoadingContent();
    }

    if(_milestones.isEmpty || _milestones.length==0){
      return CenterText(centerText: 'No milestone',);
    }

    Widget _buildSingleMilestone(MilestoneModel milestone){
      final DateFormat formatter = new DateFormat('yyyy-MM-dd');

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

    return ListView(
      controller: _scrollController,
      children: _milestones.map((m) =>  _buildSingleMilestone(m)).toList(),
    );
  }

  Widget _buildCollaborators(){
    if(_collaborators== null){
      return LoadingContent();
    }

    if(_collaborators.isEmpty || _collaborators.length==0){
      return CenterText(centerText: 'No collaborator',);
    }

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

    return GridView.count(
      controller: _scrollController,
      crossAxisCount: 2,
      padding: EdgeInsets.all(16.0),
      childAspectRatio: 8.0/9.0,
      children: _collaborators.map((u){
        return _buildUserCard(u);
      }),
    );
  }

  void _getREADME(){
    if(_repo != null){
      getDefaultREADME(widget.repoName,widget.repoName,_repo.defaultBranch).then((v){
        if(this.mounted){
          setState(() {
            _readme = v;
            _readmeLoading = false;
          });
        }
      });
    }
  }

  void _getIssues(){
    getRepoIssues(widget.owner,widget.repoName).then((v){
      if(this.mounted){
        setState(() {
          _issues.clear();
          _issues.addAll(v);
        });
      }
    });
  }

  void _getLables(){
    getRepoLabels(widget.owner,widget.repoName).then((v){
      if(this.mounted){
        setState(() {
          _labels.clear();
          _labels.addAll(v);
        });
      }
    });
  }

  void _getMilestones(){
    getRepoMilestones(widget.owner,widget.repoName).then((v){
      if(this.mounted){
        setState(() {
          _milestones.clear();
          _milestones.addAll(v);
        });
      }
    });
  }

  void _getCollaborators(){
    getRepoCollaborators(widget.owner,widget.repoName).then((v){
      if(this.mounted){
        setState(() {
          _collaborators.clear();
          _collaborators.addAll(v);
        });
      }
    });
  }

  void _getOwnerMembers(){
    if(widget.isOwnerOrg){
      getOrgMembers(widget.owner)
        .then((v){
          if(this.mounted){
            setState(() {
              _orgMembers.clear();
              _orgMembers.addAll(v);
            });
          }
        });
    }
  }

  void _getRepoInfo(){
    getRepoInfo(widget.owner,widget.repoName).then((v){
      if(this.mounted){
        setState(() {
                  _repo=v;
        });
        _getREADME();
      }
    });
  }

}



