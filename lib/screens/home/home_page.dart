import 'package:dissertation/screens/create/create_activity.dart';
import 'package:dissertation/screens/create/create_assignment.dart';
import 'package:dissertation/screens/create/create_class.dart';
import 'package:dissertation/screens/create/create_exam.dart';
import 'package:dissertation/screens/create/create_module.dart';
import 'package:dissertation/screens/create/create_other.dart';
import 'package:dissertation/screens/create/create_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
<<<<<<< Updated upstream
=======
import 'package:device_calendar/device_calendar.dart';
>>>>>>> Stashed changes

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _storage = const FlutterSecureStorage();
<<<<<<< Updated upstream

  checkStorage() async {
    if(await _storage.containsKey(key: "KEY_USE_APP_AS_CALENDAR")) {
=======
  final _deviceCalendarPlugin = DeviceCalendarPlugin();
  late List<Calendar> _calendars = [];
  late Calendar _selectedCalendar;
>>>>>>> Stashed changes

  @override
  void initState() {
    super.initState();
    _retrieveCalendars();
  }

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
                  calendarSelector(),
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

  Widget calendarSelector() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 150.0),
      child: ListView.builder(
        itemCount: _calendars.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCalendar = _calendars[index];
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      _calendars[index].name!,
                      style: const TextStyle(fontSize: 25.0),
                    ),
                  ),
                  Icon(_calendars[index].isReadOnly!
                      ? Icons.lock
                      : Icons.lock_open, color: Colors.white,)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _retrieveCalendars() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if(permissionsGranted.isSuccess && permissionsGranted.data != null) {
        print(1);
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || permissionsGranted.data != null) {
          print(2);
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      setState(() {
        _calendars = calendarsResult.data as List<Calendar>;
      });
    } catch(e) {
      print(e);
    }
  }
}