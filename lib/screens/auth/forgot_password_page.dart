import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dissertation/services/AuthService.dart';
import 'package:dissertation/services/Utils.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(10, 46, 54, 1),
        body: Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
              children: <Widget>[
                Center(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Get an email to reset your password!"),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: emailController,
                            cursorColor: Colors.white,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(labelText: "Email"),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter a valid email'
                                : null,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50)),
                            icon: const Icon(Icons.lock_open, size: 32),
                            label: const Text(
                              'Reset Password',
                              style: TextStyle(fontSize: 24),
                            ),
                            onPressed: resetPassword,
                          ),
                          const SizedBox(height: 10),
                          RichText(
                              text:
                              TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Theme.of(context).colorScheme.secondary
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap = back
                              )
                          )
                        ],
                      ),
                    )
                )
              ],
            )
        )
    );
  }

  back() {
    Navigator.push(context,MaterialPageRoute(builder: (context) => const AuthService()));
  }

  Future resetPassword() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Color.fromRGBO(10, 46, 54, 1),
          ),
        )
    );

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());

      if(!mounted) return;
      Utils.showSnackBar('Password Reset Email Sent', false);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message, true);
      Navigator.of(context).pop();
    }
  }
}
