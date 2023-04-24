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

  @override
  void initState() {
    super.initState();
    nameController.text = "";
    descriptionController.text = "";
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
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
      FirebaseFirestore.instance.collection("modules").add(Module(user.uid.toString(), nameController.text.trim(), descriptionController.text.trim()).toJson());

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
