import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dissertation/screens/layout.dart';
import 'package:dissertation/screens/startup/setup_app.dart';

class StartupService extends StatelessWidget {
  const StartupService({Key? key}) : super(key: key);

  final storage = const FlutterSecureStorage();

  Future<bool> _checkStartUp() async{
    if ("false" == await storage.read(key: "KEY_STARTUP_FLAG_${FirebaseAuth.instance.currentUser?.uid}")) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkStartUp(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool flag = snapshot.data!;
          if (flag) {
            return const AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: Layout(),
            );
          } else {
            return const AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: StartUpPage(),
            );
          }
        }
        return const CircularProgressIndicator(); // or some other widget
      },
    );
  }
}
