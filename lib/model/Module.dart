import 'package:dissertation/model/Entry.dart';

class Module extends Entry {

  Module(super.uid, super.name, super.description, super.startDate, super.endDate);

  factory Module.fromJson(dynamic json) {
    return Module(json["uid"], json["name"], json["description"], json["startDate"], json["endDate"]);
  }
}