import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dissertation/model/Task.dart';
import 'package:dissertation/screens/layout.dart';
import 'package:dissertation/services/utils.dart';
import 'package:dissertation/model/Module.dart';

class CreateTutorial extends StatefulWidget {
  const CreateTutorial({Key? key}) : super(key: key);

  @override
  State<CreateTutorial> createState() => _CreateTutorialState();
}

class _CreateTutorialState extends State<CreateTutorial> {
  final formKey = GlobalKey<FormState>();
  String _selectedModule = "";
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  late int startUnix = DateTime.now().microsecondsSinceEpoch;
  late String startDate = DateTime.now().toString();
  late int endUnix = DateTime.now().microsecondsSinceEpoch;
  late String endDate = DateTime.now().toString();
  late bool allDay = false;
  late bool repeatDaily = false;
  late bool repeatWeekly = false;
  late bool repeatMonthly = false;
  late bool repeatYearly = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(10, 46, 54, 1),
        body: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          const Text(
                            "Create Tutorial",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 20),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection("modules").snapshots(),
                            builder: (context, snapshot) {
                              if(!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              } else {
                                List<DropdownMenuItem> modules = [];

                                for(int i = 0; i < snapshot.data!.docs.length; i++) {
                                  DocumentSnapshot ds = snapshot.data!.docs[i];

                                  Module m = Module.fromJson(ds.data());

                                  if (m.uid != FirebaseAuth.instance.currentUser!.uid) continue;

                                  if(i == 0) {
                                    _selectedModule = ds.id;
                                  }

                                  modules.add(
                                      DropdownMenuItem(
                                        value: ds.id,
                                        child: Text(
                                          m.name,
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      )
                                  );
                                }
                                return Padding(
                                    padding: const EdgeInsets.only(left: 40, right: 40),
                                    child: DropdownButtonFormField(
                                        value: _selectedModule,
                                        elevation: 16,
                                        style: const TextStyle(color: Colors.white),
                                        dropdownColor: Colors.transparent.withOpacity(.75),
                                        alignment: Alignment.center,
                                        validator: (value) => value == null ? "Please Select one!" : null,
                                        items: modules,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedModule = value;
                                          });
                                        }
                                    )
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 40, right: 40),
                            child: TextFormField(
                              controller: nameController,
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              textInputAction: TextInputAction.next,
                              validator: (value) => value == null ? "Please enter a name!" : null,
                              decoration: const InputDecoration(labelText: "Enter a name", labelStyle: TextStyle(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 40, right: 40),
                            child: TextFormField(
                              controller: descriptionController,
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(labelText: "Enter a description (optional)", labelStyle: TextStyle(color: Colors.white)),
                              minLines: 3,
                              maxLines: 7,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text("Select a start date and time", style: TextStyle(color: Colors.white)),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: startDateController,
                                  decoration: const InputDecoration(
                                      labelText: "Start Date",
                                      labelStyle: TextStyle(color: Colors.white)
                                  ),
                                  readOnly: true,
                                  validator: (value) => value == null ? "Please Select a Start Date!" : null,
                                  onTap: () async {
                                    DateTime? pickDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2022),
                                        lastDate: DateTime.now().add(const Duration(days: 365*4))
                                    );

                                    if (pickDate != null) {

                                      var timestamp = pickDate.microsecondsSinceEpoch;

                                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickDate);

                                      setState(() {
                                        startUnix = timestamp;
                                        startDateController.text = formattedDate;
                                      });
                                    } else {
                                      print("Date is not selected");
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: startTimeController,
                                  decoration: const InputDecoration(
                                      labelText: "Start Time",
                                      labelStyle: TextStyle(color: Colors.white)
                                  ),
                                  readOnly: true,
                                  validator: (value) => value == null ? "Please Select a Start Time!" : null,
                                  onTap: () async {
                                    TimeOfDay? pickTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now()
                                    );

                                    if (pickTime != null) {

                                      var date = DateTime.fromMicrosecondsSinceEpoch(startUnix);
                                      var selectedDateTime = DateTime(date.year, date.month, date.day, pickTime.hour, pickTime.minute);
                                      var timestamp = selectedDateTime;

                                      setState(() {
                                        startDate = timestamp.toString();
                                        startTimeController.text = DateFormat('HH:mm').format(selectedDateTime);
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text("Select an end date and time", style: TextStyle(color: Colors.white)),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: endDateController,
                                  decoration: const InputDecoration(
                                      labelText: "End Date",
                                      labelStyle: TextStyle(color: Colors.white)
                                  ),
                                  readOnly: true,
                                  validator: (value) => value == null ? "Please Select a End Date!" : null,
                                  onTap: () async {
                                    DateTime? pickDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2022),
                                        lastDate: DateTime.now().add(const Duration(days: 365*4))
                                    );

                                    if (pickDate != null) {

                                      var timestamp = pickDate.microsecondsSinceEpoch;

                                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickDate);

                                      setState(() {
                                        endUnix = timestamp;
                                        endDateController.text = formattedDate;
                                      });
                                    } else {
                                      print("Date is not selected");
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: endTimeController,
                                  decoration: const InputDecoration(
                                      labelText: "End Time",
                                      labelStyle: TextStyle(color: Colors.white)
                                  ),
                                  readOnly: true,
                                  validator: (value) => value == null ? "Please Select a End Time!" : null,
                                  onTap: () async {
                                    TimeOfDay? pickTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now()
                                    );

                                    if (pickTime != null) {

                                      var date = DateTime.fromMicrosecondsSinceEpoch(startUnix);
                                      var selectedDateTime = DateTime(date.year, date.month, date.day, pickTime.hour, pickTime.minute);
                                      var timestamp = selectedDateTime;

                                      setState(() {
                                        endDate = timestamp.toString();
                                        endTimeController.text = DateFormat('HH:mm').format(selectedDateTime);
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Repeat Daily?", style: TextStyle(
                                  color: Colors.white)),
                              Checkbox(
                                value: repeatDaily,
                                onChanged: (value) {
                                  setState(() {
                                    repeatDaily = value!;
                                  });
                                },
                                activeColor: const Color.fromRGBO(9, 161, 41, 1),
                                side: MaterialStateBorderSide.resolveWith((
                                    states) =>
                                const BorderSide(width: 1.0, color: Colors.white)),
                              ),
                              const Text("Repeat Weekly?", style: TextStyle(
                                  color: Colors.white)),
                              Checkbox(
                                value: repeatWeekly,
                                onChanged: (value) {
                                  setState(() {
                                    repeatWeekly = value!;
                                  });
                                },
                                activeColor: const Color.fromRGBO(9, 161, 41, 1),
                                side: MaterialStateBorderSide.resolveWith((
                                    states) =>
                                const BorderSide(width: 1.0, color: Colors.white)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Repeat Monthly?", style: TextStyle(
                                  color: Colors.white)),
                              Checkbox(
                                value: repeatMonthly,
                                onChanged: (value) {
                                  setState(() {
                                    repeatMonthly = value!;
                                  });
                                },
                                activeColor: const Color.fromRGBO(9, 161, 41, 1),
                                side: MaterialStateBorderSide.resolveWith((
                                    states) =>
                                const BorderSide(width: 1.0, color: Colors.white)),
                              ),
                              const Text("Repeat Yearly?", style: TextStyle(
                                  color: Colors.white)),
                              Checkbox(
                                value: repeatYearly,
                                onChanged: (value) {
                                  setState(() {
                                    repeatYearly = value!;
                                  });
                                },
                                activeColor: const Color.fromRGBO(9, 161, 41, 1),
                                side: MaterialStateBorderSide.resolveWith((
                                    states) =>
                                const BorderSide(width: 1.0, color: Colors.white)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("All day?", style: TextStyle(
                                  color: Colors.white)),
                              Checkbox(
                                value: allDay,
                                onChanged: (value) {
                                  setState(() {
                                    allDay = value!;
                                  });
                                },
                                activeColor: const Color.fromRGBO(9, 161, 41, 1),
                                side: MaterialStateBorderSide.resolveWith((
                                    states) =>
                                const BorderSide(width: 1.0, color: Colors.white)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(onPressed: addTutorial, child: const Text("Add Tutorial")),
                          const SizedBox(height: 10),
                          ElevatedButton(onPressed: back, child: const Text("Back"))
                        ],
                      ),
                    )
                ),
              ],
            )
        )
    );
  }

  addTutorial() async {

    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    var user = FirebaseAuth.instance.currentUser!;

    try {
      FirebaseFirestore.instance.collection("tasks").add(Task(user.uid, _selectedModule.trim(), "Tutorial", nameController.text.trim(), descriptionController.text.trim(), startDate, endDate, repeatDaily, repeatWeekly, repeatMonthly, repeatYearly, allDay).toJson());
      Utils.showSnackBar("Created module ${nameController.text.trim()}", false);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text("Would you like to add another tutorial?"),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        nameController.text = "";
                        descriptionController.text = "";
                        startDateController.text = "";
                        endDateController.text = "";
                        startTimeController.text = "";
                        endTimeController.text = "";
                        allDay = false;
                        repeatDaily = false;
                        repeatWeekly = false;
                        repeatMonthly = false;
                        repeatYearly = false;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text("Yes")
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Layout()));
                    },
                    child: const Text("No")
                )
              ],
            );
          }
      );
    } catch (e) {
      print(e);

      Utils.showSnackBar("Error: $e", true);
    }
  }

  back() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Layout()));
  }
}
