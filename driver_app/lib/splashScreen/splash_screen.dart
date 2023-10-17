import 'dart:async';

import 'package:driver_app/auth/login_page.dart';

import 'package:driver_app/constant/constasnt.dart';
import 'package:driver_app/mainScreens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  startTimer() {
    Timer(const Duration(seconds: 5), () async {
      if (await _currentUser != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(),
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
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
    );
  }
  // void requestLocationPermission()async{
  //   var status = await Permission.location.status;
  //   if(status.isGranted){
  //     print('permission granted!');
  //   }else if(status.isDenied){
  //     if(await Permission.location.request().isGranted){
  //       print('permission granted!');
  //     }
  //   }
  // }
}
