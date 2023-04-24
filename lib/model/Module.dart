import 'package:dissertation/model/Entry.dart';

class Module extends Entry {

  Module(super.uid, super.name, super.description);

  factory Module.fromJson(dynamic json) {
    return Module(json["uid"], json["name"], json["description"]);
  }
}