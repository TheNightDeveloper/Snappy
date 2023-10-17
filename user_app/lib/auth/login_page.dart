import 'package:firebase_database/firebase_database.dart';
import 'package:user_app/auth/signup_page.dart';
import 'package:user_app/global/global.dart';
// import 'package:user_app/main screens/main_page.dart';
import 'package:user_app/splashScreen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  TextEditingController emailtextEditingController = TextEditingController();
  TextEditingController passwordtextEditingController = TextEditingController();

  validForm() {
    if (!emailtextEditingController.text.contains('@')) {
      Fluttertoast.showToast(
          msg: 'ایمیل یا کلمه عبور اشتباه است', backgroundColor: ksecondColor);
    } else if (passwordtextEditingController.text.length < 6) {
      Fluttertoast.showToast(
          msg: 'ایمیل یا کلمه عبور اشتباه است', backgroundColor: ksecondColor);
    } else {
      loggingUser();
    }
  }

  loggingUser() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            ProgressDialog('...درحال دریافت اطلاعات')
            );
    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
              email: emailtextEditingController.text.trim(),
              password: passwordtextEditingController.text.trim()))
          .user;
      if (user != null) {
        DatabaseReference driverRef = FirebaseDatabase.instance.ref().child('Users');
        driverRef.child(_auth.currentUser!.uid).once().then((driverKey){
          final snap=driverKey.snapshot;
          if(snap.value !=null){

            Fluttertoast.showToast(msg: 'وارد شدید');
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MySplashScreen()));
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
            Image.asset('img/logo2.png'),
            const SizedBox(
              height: 20,
            ),
            Text(
              'ورود به حساب کاربری ',
              style: kLargeTextStyle.copyWith(color: ksecondColor),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: TextFieldMaker(
                  nametextEditingController: emailtextEditingController,
                  hintText: 'ایمیل خود را وارد نمایید',
                  labelText: 'ایمیل',
                  textInputType: TextInputType.text,
                )),
            Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: TextFieldMaker(
                  nametextEditingController: passwordtextEditingController,
                  hintText: 'کلمه عبور خود را وارد نمایید',
                  labelText: 'کلمه عبور',
                  textInputType: TextInputType.text,
                )),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: ksecondColor),
                onPressed: () {
                  validForm();
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text(
                  'ورود ',
                  style: kmediumTextStyle.copyWith(color: kfourthColor),
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
