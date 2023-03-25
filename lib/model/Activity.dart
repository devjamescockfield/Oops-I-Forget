import 'package:dissertation/model/Entry.dart';

class Activity extends Entry {

  final bool daily;
  final bool weekly;
  final bool monthly;
  final bool yearly;
  final bool allDay;


  Activity(super.uid, super.name, super.description, super.startDate, super.endDate, this.daily, this.weekly, this.monthly, this.yearly, this.allDay);

  @override
  toJson() {
    return {
      "uid": uid,
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

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      map['uid'],
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

  factory Activity.fromJson(dynamic json) {
    return Activity(json["uid"], json["name"], json["description"], json["startDate"], json["endDate"], json["daily"], json["weekly"], json["monthly"], json["yearly"], json["allDay"]);
  }
}