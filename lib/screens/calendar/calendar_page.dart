import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dissertation/services/utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:dissertation/services/TaskDataSource.dart';
import 'package:dissertation/model/Task.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  var _tasks = [];
  DateTime selectedDay = DateTime.now();

  Future<List> getTasks() async {
    try {
      // get tasks
      CollectionReference crt = FirebaseFirestore.instance.collection("tasks");
      QuerySnapshot qst = await crt.get();

      List tasks = qst.docs.map(
              (doc) {
            Task t = Task.fromJson(doc.data());

            if(t.uid == FirebaseAuth.instance.currentUser?.uid) {
              return Task.fromMap(doc.data() as Map<String, dynamic>);
            }
          }
      ).toList();

      _tasks = [];
      _tasks.addAll(tasks);

      return tasks;

    } on FirebaseException catch (e) {
      Utils.showSnackBar("error", true);
      print(e.message);
    }

    return <Task>[];
  }

  @override
  void initState() {
    super.initState();
    _tasks = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: FutureBuilder(
          future: getTasks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: SafeArea(
                    child: SfCalendar(
                      view: CalendarView.month,
                      showDatePickerButton: true,
                      showNavigationArrow: true,
                      monthViewSettings: const MonthViewSettings(
                          numberOfWeeksInView: 4,
                          showAgenda: true
                      ),
                      headerHeight: 50,
                      dataSource: TaskDataSource(_tasks),
                      timeSlotViewSettings: const TimeSlotViewSettings(timeIntervalHeight: -1),
                      onLongPress: (CalendarLongPressDetails details) {
                        dynamic appointment = details.appointments;
                        DateTime date = details.date!;
                        CalendarElement element = details.targetElement;
                        _showDialog(appointment, date, element);
                      },
                    )
                ),
              );
            } else {
              return const Center(child: Text("An error has occurred. Try reopening the app"));
            }
          },
        ),
      ),
    );
  }

  _showDialog(List<dynamic> app, DateTime date, CalendarElement element) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            actionsAlignment: MainAxisAlignment.center,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            contentTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Add Entry'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('View Entries'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
}
