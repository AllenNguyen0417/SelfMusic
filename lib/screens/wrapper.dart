import 'package:first_firebase_project/models/user.dart';
import 'package:first_firebase_project/screens/authenticate/authenticate.dart';
import 'package:first_firebase_project/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_firebase_project/screens/authenticate/sign_in.dart';

import 'authenticate/register.dart';
class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    // ignore: unnecessary_null_comparison
    if(user == null) {
      return Authenticate();
    }
    else {
      return Home();
    }
  }
}