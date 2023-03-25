import 'package:flutter/material.dart';
import 'package:dissertation/screens/auth/login_page.dart';
import 'package:dissertation/screens/auth/signup_page.dart';

class AuthService extends StatefulWidget {
  const AuthService({Key? key}) : super(key: key);

  @override
  State<AuthService> createState() => _AuthServiceState();
}

class _AuthServiceState extends State<AuthService> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin ? LoginPage(onClickedSignUp: toggle) : SignUpPage(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
