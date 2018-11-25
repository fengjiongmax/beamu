class MilestoneModel{
  MilestoneModel({
    this.id,
    this.title,
    this.description,
    this.state,
    this.openIssues,
    this.closedIssues,
    this.closedAt,
    this.dueOn
  });

  int id;
  String title;
  String description;
  String state;
  int openIssues;
  int closedIssues;
  DateTime closedAt;
  DateTime dueOn;

  factory MilestoneModel.fromJson(Map<String,dynamic> json){
    return MilestoneModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      state: json['state'],
      openIssues: json['open_issues'],
      closedIssues: json['closed_issues'],
      closedAt: json['closed_at'] == null? null : DateTime.parse(json['closed_at']),
      dueOn: json['due_on'] == null? null : DateTime.parse(json['due_on'])
    );
  }
}