import 'package:flutter/material.dart';
import 'package:myaccount/widget/login_widget.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const LoginWidget(),
    );
  }
}
