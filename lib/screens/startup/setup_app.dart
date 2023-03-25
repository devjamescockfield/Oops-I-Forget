import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:dissertation/services/StartupService.dart';

class StartUpPage extends StatefulWidget {
  const StartUpPage({Key? key}) : super(key: key);

  @override
  State<StartUpPage> createState() => _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {

  int _currentStep = 0;
  final storage = const FlutterSecureStorage();
  final _localAuth = LocalAuthentication();
  bool bioEnabled = false;
  bool useApp = false;

  tapped(int step){
    setState(() => _currentStep = step);
  }

  continued() async {
    _currentStep < 2 ?
    setState(() => _currentStep += 1): navigate();
  }

  cancel(){
    _currentStep > 0 ?
    setState(() => _currentStep -= 1) : null;
  }

  Future<void> checkBioAuth() async {
    String? localAuth = await storage.read(key: "KEY_LOCAL_AUTH_ENABLED");
    if ("true" == localAuth) {
      setState(() {
        bioEnabled = true;
      });
      return;
    }
    setState(() {
      bioEnabled = false;
    });
  }

  Future<void> toggleBiometricAuth() async {
    String? localAuth = await storage.read(key: "KEY_LOCAL_AUTH_ENABLED");
    if ("false" == localAuth) {
      bool didAuthenticate = await _localAuth.authenticate(localizedReason: 'Please authenticate to sign in');
      if(didAuthenticate) {
        await storage.write(key: "KEY_LOCAL_AUTH_ENABLED", value: "true");
        setState(() {
          bioEnabled = true;
        });
      }
    } else {
      await storage.write(key: "KEY_LOCAL_AUTH_ENABLED", value: "false");
      setState(() {
        bioEnabled = false;
      });
    }
  }

  Future<void> checkUseApp() async {
    String? _useApp = await storage.read(key: "KEY_USE_APP_AS_CALENDAR");
    if ("true" == _useApp) {
      setState(() {
        useApp = true;
      });
      return;
    }
    setState(() {
      useApp = false;
    });
  }

  Future<void> toggleUseApp() async {
    if(useApp) {
      await storage.write(key: "KEY_USE_APP_AS_CALENDAR", value: "true");
    } else {
      await storage.write(key: "KEY_USE_APP_AS_CALENDAR", value: "false");
    }
  }

  @override
  void initState() {
    super.initState();
    checkBioAuth();
    checkUseApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(10, 46, 54, 1),
      body: Center(
        child: Stepper(
          type: StepperType.vertical,
          physics: const ScrollPhysics(),
          currentStep: _currentStep,
          onStepTapped: (step) => tapped(step),
          onStepContinue: continued,
          onStepCancel: cancel,
          steps: [
            Step(
              content: Column(
                children: [
                  const Text("Press the button bellow to enable/disable Biometric Authentication", style: TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 10),
                  (bioEnabled)
                    ? ElevatedButton(onPressed: toggleBiometricAuth,style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.green), fixedSize: MaterialStatePropertyAll<Size?>(Size.square(100))), child: const Icon(Icons.fingerprint, color: Colors.black, size: 60.0, semanticLabel: 'Text to announce in accessibility modes',))
                    : ElevatedButton(onPressed: toggleBiometricAuth,style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.red), fixedSize: MaterialStatePropertyAll<Size?>(Size.square(100))), child: const Icon(Icons.fingerprint, color: Colors.white, size: 60.0, semanticLabel: 'Text to announce in accessibility modes',)),
                ],
              ),
              title: const Text("Biometric Authentication", style: TextStyle(color: Colors.white)),
              isActive: _currentStep >= 0,
              state: _currentStep >= 0 ? StepState.complete : StepState.disabled
            ),
            Step(
              title: const Text("Setup App", style: TextStyle(color: Colors.white)),
              content: Column(
                children: [
                  const Text("Would you like to use this app as your main calendar app?", style: TextStyle(color: Colors.white)),
                  Switch(
                    value: useApp,
                    onChanged: (val) {
                      setState(() {
                        useApp = val;
                        toggleUseApp();
                      });
                    }
                  )
                ],
              ),
              isActive: _currentStep >= 1,
              state: _currentStep >= 1 ? StepState.complete : StepState.disabled
             ), (!useApp) ? Step(
                title: const Text("Calendars", style: TextStyle(color: Colors.white)),
                content: Column(
                  children: [
                    const Text("Link the calendar you would like to export to", style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            iconSize: 50,
                            onPressed: () {
                              print("google");
                            },
                            icon: const FaIcon(FontAwesomeIcons.google)
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                            iconSize: 50,
                            onPressed: () {
                              print("apple");
                            },
                            icon: const FaIcon(FontAwesomeIcons.apple)
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          iconSize: 50,
                            onPressed: () {
                              print("microsoft");
                            },
                            icon: const FaIcon(FontAwesomeIcons.microsoft)
                        )
                      ],
                    )
                  ],
                ),
                isActive: _currentStep >= 2,
                state: _currentStep >= 2 ? StepState.complete : StepState.disabled
            ) : Step(
              title: const Text(""),
              content: Column(
                children: [
                  ElevatedButton(onPressed: navigate, child: const Text("Continue", style: TextStyle(color: Colors.white)))
                ],
              )
            )
          ],
        )
      )
    );
  }

  navigate() async {
    await storage.write(key: "KEY_STARTUP_FLAG_${FirebaseAuth.instance.currentUser?.uid}", value: "true");
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const StartupService()));
  }
}
