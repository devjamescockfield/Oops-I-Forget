import 'package:dissertation/screens/create/create_activity.dart';
import 'package:dissertation/screens/create/create_assignment.dart';
import 'package:dissertation/screens/create/create_class.dart';
import 'package:dissertation/screens/create/create_exam.dart';
import 'package:dissertation/screens/create/create_module.dart';
import 'package:dissertation/screens/create/create_other.dart';
import 'package:dissertation/screens/create/create_tutorial.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(10, 46, 54, 1),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 35),
        child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () => {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CreateModule()))
                      },
                      child: const Text("Create Module")
                  ),
                  ElevatedButton(
                      onPressed: () => {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CreateActivity()))
                      },
                      child: const Text("Create Activity")
                  ),
                  ElevatedButton(
                      onPressed: () => {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CreateOther()))
                      },
                      child: const Text("Create Other Entry")
                  ),
                  ElevatedButton(
                      onPressed: () => {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CreateClass()))
                      },
                      child: const Text("Create Class")
                  ),
                  ElevatedButton(
                      onPressed: () => {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CreateAssignment()))
                      },
                      child: const Text("Create Assignment")
                  ),
                  ElevatedButton(
                      onPressed: () => {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CreateExam()))
                      },
                      child: const Text("Create Exam")
                  ),
                  ElevatedButton(
                      onPressed: () => {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CreateTutorial()))
                      },
                      child: const Text("Create Tutorial")
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}