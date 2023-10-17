import 'package:driver_app/splashScreen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({super.key});

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  final _ath = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            _ath.signOut();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MySplashScreen()));
          },
          child: Text('خروج از حساب کاربری')),
    );
  }
}
