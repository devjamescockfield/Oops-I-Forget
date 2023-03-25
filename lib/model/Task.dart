import 'package:dissertation/model/Entry.dart';

class Task extends Entry {

  final String moduleName;
  final String taskType;
  final bool daily;
  final bool weekly;
  final bool monthly;
  final bool yearly;
  final bool allDay;

  Task(super.uid, this.moduleName, this.taskType, super.name, super.description, super.startDate, super.endDate, this.daily, this.weekly, this.monthly, this.yearly, this.allDay);

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "moduleName": moduleName,
      "taskType": taskType,
      "name": name,
      "description": description,
      "startDate": startDate,
      "endDate": endDate,
      "daily": daily,
      "weekly": weekly,
      "monthly": monthly,
      "yearly": yearly,
      "allDay": allDay
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      map['uid'],
      map['moduleName'],
      map['taskType'],
      map['name'],
      map['description'],
      map['startDate'],
      map['endDate'],
      map['daily'],
      map['weekly'],
      map['monthly'],
      map['yearly'],
      map['allDay'],
    );
  }

  @override
  toJson() {
    return {
      "uid": uid,
      "moduleName": moduleName,
      "taskType": taskType,
      "name": name,
      "description": description,
      "startDate": startDate,
      "endDate": endDate,
      "daily": daily,
      "weekly": weekly,
      "monthly": monthly,
      "yearly": yearly,
      "allDay": allDay
    };
  }

  factory Task.fromJson(dynamic json) {
    return Task(json["uid"], json["moduleName"], json["taskType"], json["name"], json["description"], json["startDate"], json["endDate"], json["daily"], json["weekly"], json["monthly"], json["yearly"], json["allDay"]);
  }
}