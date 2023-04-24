class Entry {

  // variable declaration

  late final String uid;
  late final String name; // name of task
  late final String description; // description of task

  // constructor

  Entry(this.uid, this.name, this.description);

  // getters

  String getUid() {
    return uid;
  }

  String getName() {
    return name;
  }

  String getDescription() {
    return description;
  }

  // setters

  void setUid(String uid) {
    this.uid = uid;
  }

  void setName(String name) {
    this.name = name;
  }

  void setDescription(String description) {
    this.description = description;
  }

  // toJson

  toJson() {
    return {
      "uid": uid,
      "name": name,
      "description": description
    };
  }

  factory Entry.fromJson(dynamic json) {
    return Entry(json["uid"], json["name"], json["description"]);
  }

}