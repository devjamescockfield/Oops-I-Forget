import 'package:dissertation/services/StartupService.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:dissertation/services/Utils.dart';
import 'package:dissertation/screens/auth/forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final Function() onClickedSignUp;

  const LoginPage({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: "");
  final passwordController = TextEditingController(text: "");
  final storage = const FlutterSecureStorage();
  final localAuth = LocalAuthentication();
  bool _savePassword = false;

  Future<void> _readFromStorage() async {

    String isLocalAuthEnabled = await storage.read(key: "KEY_LOCAL_AUTH_ENABLED") ?? "false";

    if("true" == isLocalAuthEnabled) {
      bool didAuthenticate = await localAuth.authenticate(localizedReason: 'Please authenticate to sign in');

      if(didAuthenticate) {
        emailController.text = await storage.read(key: "KEY_USERNAME") ?? '';
        passwordController.text = await storage.read(key: "KEY_PASSWORD") ?? '';
        _savePassword = true;

        signIn();
      }
    } else {
      emailController.text = await storage.read(key: "KEY_USERNAME") ?? '';
      passwordController.text = await storage.read(key: "KEY_PASSWORD") ?? '';
    }
  }

  @override
  void initState() {
    super.initState();
    _readFromStorage();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

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
                            style: const TextStyle(color: Colors.white),
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
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) => value != null && value.length < 6
                                ? 'Enter min. 6 characters'
                                : null,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                  value: _savePassword,
                                  onChanged: (val) {
                                    setState(() {
                                      _savePassword = val!;
                                    });
                                  }
                              ),
                              const Text("Remember Me", style: TextStyle(color: Colors.white),)
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50)),
                            icon: const Icon(Icons.lock_open, size: 32),
                            label: const Text(
                              'Sign In',
                              style: TextStyle(fontSize: 24),
                            ),
                            onPressed: signIn,
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontSize: 20),
                              ),
                              onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => const ForgotPasswordPage(),
                              ))
                          ),
                          const SizedBox(height: 10),
                          RichText(
                              text: TextSpan(
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                  text: 'No Account?  ',
                                  children: [
                                    TextSpan(
                                        text: 'Sign Up',
                                        style: TextStyle(
                                            decoration: TextDecoration.underline,
                                            color: Theme.of(context).colorScheme.secondary
                                        ),
                                        recognizer: TapGestureRecognizer()..onTap = widget.onClickedSignUp
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

  Future signIn() async {
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      if (!await storage.containsKey(key: "KEY_STARTUP_FLAG_${FirebaseAuth.instance.currentUser?.uid}")) {
        await storage.write(key: "KEY_STARTUP_FLAG_${FirebaseAuth.instance.currentUser?.uid}", value: "false");
      }

      if(_savePassword) {
        await storage.write(key: "KEY_USERNAME", value: emailController.text.trim());
        await storage.write(key: "KEY_PASSWORD", value: passwordController.text.trim());
      }

      if(!mounted) return;
      navigate();
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message, true);
      Navigator.of(context).pop();
    }
  }

  navigate() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const StartupService()));
  }
}
