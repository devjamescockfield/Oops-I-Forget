import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dissertation/main.dart';
import 'package:dissertation/services/Utils.dart';

class SignUpPage extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUpPage({Key? key, required this.onClickedSignIn}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final storage = const FlutterSecureStorage();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();

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
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: passwordController,
                            cursorColor: Colors.white,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(labelText: "Password"),
                            obscureText: true,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) => value != null && value.length < 6
                                ? 'Enter min. 6 characters'
                                : null,
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: passwordConfirmController,
                            cursorColor: Colors.white,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(labelText: "Confirm Password"),
                            obscureText: true,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) => value != null && value.length < 6
                                ? 'Enter min. 6 characters'
                                : null,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50)),
                            icon: const Icon(Icons.lock_open, size: 32),
                            label: const Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 24),
                            ),
                            onPressed: signUp,
                          ),
                          const SizedBox(height: 10),
                          RichText(
                              text: TextSpan(
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                  text: 'Already have an account?  ',
                                  children: [
                                    TextSpan(
                                        text: 'Sign In',
                                        style: TextStyle(
                                            decoration: TextDecoration.underline,
                                            color: Theme.of(context).colorScheme.secondary
                                        ),
                                        recognizer: TapGestureRecognizer()..onTap = widget.onClickedSignIn
                                    )
                                  ]
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

  Future signUp() async {
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
      if (passwordConfirmController.text.trim() != passwordController.text.trim()) {
        Utils.showSnackBar("Passwords don't match", true);
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());

        await storage.write(key: "KEY_USERNAME", value: emailController.text.trim());
        await storage.write(key: "KEY_PASSWORD", value: passwordController.text.trim());

        Utils.showSnackBar("User Created Successfully", false);
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message, true);
    }

    navKey.currentState!.popUntil((route) => route.isFirst);
  }
}
