import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:myaccount/app/app.dart';
import 'package:myaccount/pages/landing.dart';
import 'package:myaccount/pages/login.dart';
import 'package:myaccount/commons/constants/routes.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  runApp(App(
    authenticationRepository: AuthenticationRepository(),
    userRepository: UserRepository(),
  ));
}
