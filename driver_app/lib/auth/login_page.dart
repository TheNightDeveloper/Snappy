import 'package:driver_app/auth/signup_page.dart';
import 'package:driver_app/constant/constasnt.dart';
import 'package:driver_app/mainScreens/main_screen.dart';
import 'package:driver_app/splashScreen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/progress_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validForm() {
    if (!emailTextEditingController.text.contains('@')) {
      Fluttertoast.showToast(
          msg: 'ایمیل یا کلمه عبور اشتباه است', backgroundColor: ksecondColor);
    } else if (passwordTextEditingController.text.length < 6) {
      Fluttertoast.showToast(
          msg: 'ایمیل یا کلمه عبور اشتباه است', backgroundColor: ksecondColor);
    } else {
      loggingDriver();
    }
  }

  loggingDriver() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            ProgressDialog('...درحال دریافت اطلاعات'));
    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
              email: emailTextEditingController.text.trim(),
              password: passwordTextEditingController.text.trim()))
          .user;
      if (user != null) {
        DatabaseReference driverRef = FirebaseDatabase.instance.ref().child('Drivers');
        driverRef.child(_auth.currentUser!.uid).once().then((driverKey){
          final snap=driverKey.snapshot;
          if(snap.value !=null){

            Fluttertoast.showToast(msg: 'وارد شدید');
            Navigator.push(context, MaterialPageRoute(builder: (context) => MySplashScreen()));
          }else{
            Fluttertoast.showToast(msg: "کاربری یافت نشد.");
            _auth.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
          }
        });

      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'خطا');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: kmainColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('img/logo4.jpg'),
            const SizedBox(
              height: 20,
            ),
            Text(
              'ورود به حساب کاربری ',
              style: kLargeTextStyle.copyWith(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: TextFieldMaker(
                  nametextEditingController: emailTextEditingController,
                  hintText: 'ایمیل خود را وارد نمایید',
                  labelText: 'ایمیل',
                  textInputType: TextInputType.text,
                )),
            Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: TextFieldMaker(
                  nametextEditingController: passwordTextEditingController,
                  hintText: 'کلمه عبور خود را وارد نمایید',
                  labelText: 'کلمه عبور',
                  textInputType: TextInputType.text,
                )),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: kButtomColor),
                onPressed: () {
                  validForm();
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: const Text(
                  'ورود ',
                  style: kmediumTextStyle,
                )),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignupPage()));
              },
              child: Text('حساب کاربری ندارید؟  ازاینجا ثبت نام کنید',
                  style: kmediumTextStyle.copyWith(color: ksecondColor)),
            )
          ],
        ),
      ),
    ));
  }
}
