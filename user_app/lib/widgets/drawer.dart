import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/splashScreen/splash_screen.dart';

class MyDrawer extends StatefulWidget {
  final String name;
  final String email;
  MyDrawer(this.name, this.email);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

final _auth = FirebaseAuth.instance;

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ksecondColor,
      width: 300,
      child: ListView(
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(color: kthirdColor),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: ksecondColor,
                    radius: 30,
                    child: Icon(
                      Icons.person,
                      color: kfourthColor,
                      size: 35,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.name,
                        style: kmediumTextStyle.copyWith(color: kfourthColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.email,
                        style: kmediumTextStyle.copyWith(color: kfourthColor),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text(
              'تاریخچه',
              style: kmediumTextStyle.copyWith(color: kfourthColor),
            ),
            onTap: () {
              print('salam');
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'پروفایل',
              style: kmediumTextStyle.copyWith(color: kfourthColor),
            ),
            onTap: () {
              print('salam');
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(
              'درباره',
              style: kmediumTextStyle.copyWith(color: kfourthColor),
            ),
            onTap: () {
              print('salam');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'خروج',
              style: kmediumTextStyle.copyWith(color: kfourthColor),
            ),
            onTap: () {
              _auth.signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MySplashScreen()));
            },
          )
        ],
      ),
    );
  }
}
