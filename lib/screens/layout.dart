import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dissertation/screens/calendar/calendar_page.dart';
import 'package:dissertation/screens/home/home_page.dart';
import 'package:dissertation/screens/settings/settings_page.dart';

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State createState() => _LayoutState();
}

class _LayoutState extends State {

  late int _selectedTab = 0;
  final storage = const FlutterSecureStorage();
  bool useApp = false;

  final List _pages = [
    const HomePage(),
    const Center(
      child: Text("About"),
    ),
    const Center(
      child: Text("Contact"),
    ),
    const SettingsPage(),
    const CalendarPage(),
  ];

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  Color navItem1 = const Color.fromRGBO(39, 251, 107, 1);
  Color navItem2 = const Color.fromRGBO(9, 161, 41, 1);
  Color navItem3 = const Color.fromRGBO(9, 161, 41, 1);
  Color navItem4 = const Color.fromRGBO(9, 161, 41, 1);

  Future<void> checkUseApp() async {
    if("false" == await storage.read(key: "KEY_USE_APP_AS_CALENDAR")) {
      setState(() {
        useApp = false;
      });
    } else {
      setState(() {
        useApp = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkUseApp();
  }

  @override
  Widget build(BuildContext context) {
    if (useApp) {
      return Scaffold(
        backgroundColor: const Color.fromRGBO(10, 46, 54, 1),
        floatingActionButton:FloatingActionButton(
          backgroundColor: const Color.fromRGBO(39, 251, 107, 1),
          onPressed: (){
            _changeTab(4);
          },
          child: const Icon(Icons.calendar_month, color: Color.fromRGBO(10, 46, 54, 1),), //icon inside button
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: _pages[_selectedTab],
        bottomNavigationBar: BottomAppBar(
          color: const Color.fromRGBO(10, 46, 54, .9),
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: IconButton(
                  icon: Icon(Icons.home, color: navItem1),
                  onPressed: () {
                    setState(() {
                      _changeTab(0);
                      navItem1 = const Color.fromRGBO(39, 251, 107, 1);
                      navItem2 = const Color.fromRGBO(9, 161, 41, 1);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: IconButton(icon: Icon(Icons.settings, color: navItem2), onPressed: () {
                  setState(() {
                    _changeTab(3);
                    navItem1 = const Color.fromRGBO(9, 161, 41, 1);
                    navItem2 = const Color.fromRGBO(39, 251, 107, 1);
                  });
                }),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: const Color.fromRGBO(10, 46, 54, 1),
        body: _pages[_selectedTab],
        bottomNavigationBar: BottomAppBar(
          color: const Color.fromRGBO(10, 46, 54, .9),
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: IconButton(
                  icon: Icon(Icons.home, color: navItem1),
                  onPressed: () {
                    setState(() {
                      _changeTab(0);
                      navItem1 = const Color.fromRGBO(39, 251, 107, 1);
                      navItem2 = const Color.fromRGBO(9, 161, 41, 1);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: IconButton(icon: Icon(Icons.settings, color: navItem2), onPressed: () {
                  setState(() {
                    _changeTab(3);
                    navItem1 = const Color.fromRGBO(9, 161, 41, 1);
                    navItem2 = const Color.fromRGBO(39, 251, 107, 1);
                  });
                }),
              ),
            ],
          ),
        ),
      );
    }
  }
}
