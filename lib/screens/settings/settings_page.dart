import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dissertation/services/AuthService.dart';
import 'package:dissertation/services/utils.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(10, 46, 54, 1),
      body: Center(child:
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.arrow_back, size: 32),
              label: const Text(
                'Sign Out',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthService()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.start, size: 32),
              label: const Text(
                'Startup reset',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () => resetStartup(),
            ),
          )
        ],
      )
      ),
    );
  }

  resetStartup() async {
    if (await storage.containsKey(key: "KEY_STARTUP_FLAG_${FirebaseAuth.instance.currentUser?.uid}")) {
      await storage.write(key: "KEY_STARTUP_FLAG_${FirebaseAuth.instance.currentUser?.uid}", value: "false");
      Utils.showSnackBar("You will see the setup pages the next time you login or open the app", false);
    }
  }
}
