import 'user_model.dart';
import 'label_model.dart';
import 'milestone_model.dart';
//import 'pull_request_model.dart';

class IssueModel{
  IssueModel({
    this.id,
    this.url,
    this.number,
    this.user,
    this.title,
    this.body,
    this.labels,
    this.milestone,
    this.assignee,
    this.assignees,
    this.state,
    this.comments,
    this.createAt,
    this.updateAt
    //@required this.PullRequest
  });

  int id;
  String url;
  int number;
  UserModel user;
  String title;
  String body;
  List<LabelModel> labels;
  MilestoneModel milestone;
  UserModel assignee;
  List<UserModel> assignees;
  String state;
  int comments;
  DateTime createAt;
  DateTime updateAt;

  //pull requests are not inplemented in gogs api v1 yet
  //final PullRequesModel pullRequest;

  factory IssueModel.fromJson(Map<String,dynamic> json){
    List<LabelModel> labels;
    if(json['labels'] != null){
      labels = new List<LabelModel>();
      for(final item in json['labels']){
        labels.add(LabelModel.fromJson(item));
      }
    }

    List<UserModel> assignees;
    if(json['assignees'] != null){
      assignees = new List<UserModel>();
      for(final item in json['assignees']){
        assignees.add(UserModel.fromJson(item));
      }
    }

    return IssueModel(
      id: json['id'],
      url: json['url'],
      number: json['number'],
      user: UserModel.fromJson(json['user']),
      title: json['title'],
      body: json['body'],
      labels: labels,
      milestone: json['milestone']==null?null:MilestoneModel.fromJson(json['milestone']),
      assignee: json['assignee']==null? null:UserModel.fromJson(json['assignee']),
      assignees: assignees,
      state: json['state'],
      comments: json['comments'],
      createAt: DateTime.parse(json['created_at']),
      updateAt: DateTime.parse(json['updated_at']),
      //pullRequest: PullRequest.fromJson(json['pull_request'])
    );
  }
}


class SubmitIssueModel{
  SubmitIssueModel({this.assignee,this.assignees,this.body,this.dueDate,this.milestone,this.state,this.title});

  UserModel assignee;
  List<UserModel> assignees;
  String body;
  DateTime dueDate;
  MilestoneModel milestone;
  String state;
  String title;

  factory SubmitIssueModel.fromIssue(IssueModel issue){
    return SubmitIssueModel(
      assignee:issue.assignee,
      assignees: issue.assignees,
      body:  issue.body,
      // dueDate: issue.
      milestone: issue.milestone,
      state: issue.state,
      title: issue.title
    );
  }

  Map<String,dynamic> toJson()=>{
    'assignee':assignee,
    'assignees': assignees,
    'body':  body,
    // dueDate: issue.
    'milestone': milestone,
    'state': state,
    'title': title
  };
}