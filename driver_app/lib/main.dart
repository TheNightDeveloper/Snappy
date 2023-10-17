import 'package:driver_app/splashScreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'models/user_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(
      child: MaterialApp(
    title: 'Drivers App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: MySplashScreen(),
    debugShowCheckedModeBanner: false,
  )));
}

class MyApp extends StatefulWidget {
  MyApp({this.child});
  final Widget? child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserData(),
      child: KeyedSubtree(
        key: key,
        child: widget.child!,
      ),
    );
  }
}
