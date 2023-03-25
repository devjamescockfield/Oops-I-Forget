import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dissertation/model/Module.dart';
import 'package:dissertation/services/utils.dart';
import 'package:dissertation/screens/layout.dart';

class CreateModule extends StatefulWidget {
  const CreateModule({Key? key}) : super(key: key);

  @override
  State<CreateModule> createState() => _CreateModuleState();
}

class _CreateModuleState extends State<CreateModule> {

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
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
  void initState() {
    super.initState();
    nameController.text = "";
    descriptionController.text = "";
    startDateController.text = "";
    endDateController.text = "";
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(10, 46, 54, 1),
      body: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget> [
              Center(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      const Text(
                        "Create Module",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
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
                      const Text("Select a start date", style: TextStyle(color: Colors.white)),
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

                                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickDate);

                                  var timestamp = pickDate.microsecondsSinceEpoch;

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
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text("Select an end date", style: TextStyle(color: Colors.white)),
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
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(onPressed: addModule, child: const Text("Add Module")),
                      const SizedBox(height: 10),
                      ElevatedButton(onPressed: back, child: const Text("Back"))
                    ],
                  ),
                ),
              )
            ],
          )
      ),
    );
  }

  addModule() async {

    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    var user = FirebaseAuth.instance.currentUser!;

    try {
      FirebaseFirestore.instance.collection("modules").add(Module(user.uid.toString(), nameController.text.trim(), descriptionController.text.trim(), DateTime.fromMicrosecondsSinceEpoch(startUnix).toString(), DateTime.fromMicrosecondsSinceEpoch(endUnix).toString()).toJson());

      Utils.showSnackBar("Created Module ${nameController.text.trim()}", false);

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text("Would you like to add another module?"),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        nameController.text = "";
                        descriptionController.text = "";
                        startDateController.text = "";
                        endDateController.text = "";
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
