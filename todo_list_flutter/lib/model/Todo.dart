class Todo {
  int? id;
  String? title;
  String? description;
  String? date_end;
  bool? isComplete;

  Todo({this.id, this.title, this.description, this.date_end, this.isComplete});

  Todo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    date_end = json['date_end'];
    isComplete = json['is_complete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['date_end'] = this.date_end;
    data['is_complete'] = this.isComplete;
    return data;
  }
}
