import 'package:dissertation/model/Entry.dart';

class Other extends Entry {

  final bool daily;
  final bool weekly;
  final bool monthly;
  final bool yearly;
  final bool allDay;


  Other(super.uid, super.name, super.description, super.startDate, super.endDate, this.daily, this.weekly, this.monthly, this.yearly, this.allDay);

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

  factory Other.fromMap(Map<String, dynamic> map) {
    return Other(
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

  factory Other.fromJson(dynamic json) {
    return Other(json["uid"], json["name"], json["description"], json["startDate"], json["endDate"], json["daily"], json["weekly"], json["monthly"], json["yearly"], json["allDay"]);
  }
}