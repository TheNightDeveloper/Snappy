import 'dart:math';

import 'package:driver_app/auth/car_info_page.dart';
import 'package:driver_app/constant/constasnt.dart';
import 'package:driver_app/widgets/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_page.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nametextEditingController = TextEditingController();
  TextEditingController emailtextEditingController = TextEditingController();
  TextEditingController phonetextEditingController = TextEditingController();
  TextEditingController passwordtextEditingController = TextEditingController();

  final FirebaseAuth _user = FirebaseAuth.instance;

  validForm() {
    if (nametextEditingController.text.length < 3) {
      Fluttertoast.showToast(
          msg: 'نام باید حداقل دارای 3 حرف باشد',
          backgroundColor: ksecondColor);
    } else if (!emailtextEditingController.text.contains('@')) {
      Fluttertoast.showToast(
          msg: 'ایمیل را بطور صحیح وارد کنید', backgroundColor: ksecondColor);
    } else if (phonetextEditingController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'شماره موبایل راوارد کنید', backgroundColor: ksecondColor);
    } else if (passwordtextEditingController.text.length < 6) {
      Fluttertoast.showToast(
          msg: 'کلمه عبور باید حداقل 6 کاراکتر باشد',
          backgroundColor: ksecondColor);
    } else {
      saveDriverInfo();
    }
  }

  saveDriverInfo() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            ProgressDialog('درحال ذخیره اطلاعات'));
    try{
      final User? newUser = (await _user
            .createUserWithEmailAndPassword(
                email: emailtextEditingController.text.trim(),
                password: passwordtextEditingController.text.trim())
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Error:${msg.toString()}');
    }))
        .user;
    if (newUser != null) {
      Map driverInfo = {
        'id': newUser.uid,
        'name': nametextEditingController.text.trim(),
        'email': emailtextEditingController.text.trim(),
        'phone Number': phonetextEditingController.text.trim()
      };
      DatabaseReference driverRef =
          FirebaseDatabase.instance.ref().child('Drivers');
      driverRef.child(newUser.uid).set(driverInfo);
      Fluttertoast.showToast(msg: 'ثبت نام با موفقیت انجام شد');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CarInfoPage()));
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'خطا');
    }
    }catch(e){
      print(e);
    }
    

    }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kmainColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('img/logo2.jpg'),
              const SizedBox(
                height: 20,
              ),
              Text(
                'ثبت نام بعنوان راننده',
                style: kLargeTextStyle.copyWith(color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: TextFieldMaker(
                  nametextEditingController: nametextEditingController,
                  hintText: 'نام خود را وارد نمایید',
                  labelText: 'نام',
                  textInputType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: TextFieldMaker(
                  nametextEditingController: emailtextEditingController,
                  hintText: 'ایمیل خود را وارد نمایید',
                  labelText: 'ایمیل',
                  textInputType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: TextFieldMaker(
                  nametextEditingController: phonetextEditingController,
                  hintText: 'شماره خود را وارد نمایید',
                  labelText: 'شماره همراه',
                  textInputType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: TextFieldMaker(
                  nametextEditingController: passwordtextEditingController,
                  hintText: 'رمز عبور خود را وارد نمایید',
                  labelText: 'رمز عبور',
                  textInputType: TextInputType.visiblePassword,
                  invisibleText: true,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: kButtomColor),
                  onPressed: () {
                    validForm();

                    // Navigator.push(context,
                    // MaterialPageRoute(builder: (context) => CarInfoPage()));
                  },
                  child: const Text(
                    'ایجاد حساب ',
                    style: kmediumTextStyle,
                  )),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text('قبلا ثبت نام کرده اید؟ از اینجا وارد شوید',
                    style: kmediumTextStyle.copyWith(color: ksecondColor)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldMaker extends StatelessWidget {
  TextFieldMaker(
      {required this.nametextEditingController,
      required this.labelText,
      required this.hintText,
      required this.textInputType,
      this.invisibleText = false});
  final String labelText;
  final String hintText;
  final TextInputType textInputType;
  final bool invisibleText;

  final TextEditingController nametextEditingController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      showCursor: false,
      obscureText: invisibleText,
      keyboardType: textInputType,
      style: const TextStyle(
          color: Colors.white70, fontFamily: 'yekan', fontSize: 13),
      controller: nametextEditingController,
      decoration: InputDecoration(
          labelText: labelText,
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ksecondColor)),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow)),
          floatingLabelAlignment: FloatingLabelAlignment.center,
          alignLabelWithHint: true,
          labelStyle: const TextStyle(
              color: Colors.yellowAccent,
              fontFamily: 'yekan',
              fontSize: 15,
              fontWeight: FontWeight.bold),
          hintText: hintText,
          hintStyle: const TextStyle(color: ksecondColor)),
      textAlign: TextAlign.right,
    );
  }
}
