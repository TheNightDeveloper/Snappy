import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:user_app/assistant/assistant_method.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/models/user_data.dart';

import '../auth/login_page.dart';
import '../main screens/main_page.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  startTimer() {
    _currentUser != null ? Provider.of<UserData>(context,listen: false).getCurrentUserInfo() : null;
    Timer(const Duration(seconds: 5), () async {
      if (await _currentUser != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: kmainColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset('img/logo1.png'),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Snapp!',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              const CircularProgressIndicator(
                color: Colors.white,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
