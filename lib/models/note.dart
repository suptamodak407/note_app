import 'dart:math';

class Note {
  int _id = Random().nextInt(100);
  late String title;
  late String? description;
  late String date;
  late int priority;
  Note(this.title, this.date, this.priority, [this.description]);
  Note.withId(this._id, this.title, this.date, this.priority, this.description);

  int get id => _id;
  String get _title => title;
  String get _description => description!;
  int get _priority => priority;
  String get _date => date;

  // set id(int newid) {
  //   this._id = newid;
  // }

  set _title(String newTitle) {
    if (newTitle.length <= 255) {
      this.title = newTitle;
    }
  }

  set _description(String newDescription) {
    if (newDescription.length <= 255) {
      this.description = newDescription;
    }
  }

  set _priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this.priority = newPriority;
    }
  }

  set _date(String newDate) {
    this.date = newDate;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = title;
    map['description'] = description;
    map['priority'] = priority;
    map['date'] = date;
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this.title = map['title'];
    this.description = map['description'];
    this.priority = map['priority'];
    this.date = map['date'];
  }
}
