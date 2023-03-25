class Entry {

  // variable declaration

  late final String uid;
  late final String name; // name of task
  late final String description; // description of task
  late final String startDate; // start date time of task
  late final String endDate; // end date time of task

  // constructor

  Entry(this.uid, this.name, this.description, this.startDate, this.endDate);

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

  String getStartDate() {
    return startDate;
  }

  String getEndDate() {
    return endDate;
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

  void setStartDate(String startDate) {
    this.startDate = startDate;
  }

  void setEndDate(String endDate) {
    this.endDate = endDate;
  }

  // toJson

  toJson() {
    return {
      "uid": uid,
      "name": name,
      "description": description,
      "startDate": startDate,
      "endDate": endDate
    };
  }

  factory Entry.fromJson(dynamic json) {
    return Entry(json["uid"], json["name"], json["description"], json["startDate"], json["endDate"]);
  }

}