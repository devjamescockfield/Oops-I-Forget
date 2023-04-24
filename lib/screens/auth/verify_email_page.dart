import 'dart:async';
import 'package:dissertation/services/StartupService.dart';
import 'package:dissertation/services/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
            (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      print(e.message);
      Utils.showSnackBar(e.toString(), true);
    }
  }

  Future checkEmailVerified() async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();

      setState(() {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });

      if(isEmailVerified) timer?.cancel();
    } on FirebaseAuthException catch (e) {
      print(e.message);
      Utils.showSnackBar(e.toString(), true);
    }
  }


  @override
  Widget build(BuildContext context) => isEmailVerified ? const StartupService() : Scaffold(
      backgroundColor: const Color.fromRGBO(10, 46, 54, 1),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget> [
              Text('Waiting for email verification', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
              SizedBox(height: 50),
              CircularProgressIndicator(color: Color.fromRGBO(39, 251, 107, 1))
            ],
          )
      )
  );
}
