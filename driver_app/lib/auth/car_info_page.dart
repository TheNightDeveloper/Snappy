import 'package:driver_app/auth/signup_page.dart';
import 'package:driver_app/splashScreen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constant/constasnt.dart';
import 'login_page.dart';

class CarInfoPage extends StatefulWidget {
  @override
  State<CarInfoPage> createState() => _CarInfoPageState();
}

class _CarInfoPageState extends State<CarInfoPage> {
  final _auth = FirebaseAuth.instance;
  TextEditingController carModeltextEditingController = TextEditingController();
  TextEditingController carNumbertextEditingController =
      TextEditingController();
  TextEditingController carColortextEditingController = TextEditingController();

  saveCarInfo()async {
    Map carInfo = {
      'Car Color': carColortextEditingController.text.trim(),
      'Car Number': carNumbertextEditingController.text.trim(),
      'Car Model': carModeltextEditingController.text.trim(),
    };

    DatabaseReference carRef = FirebaseDatabase.instance.ref().child('Drivers');
    User? currentUser = await _auth.currentUser;
    carRef.child(currentUser!.uid).child('Car Datails').set(carInfo);
    Fluttertoast.showToast(msg: 'اطلاعات با موفقیت ذخیره شد');
     Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MySplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kmainColor,
        body: SingleChildScrollView(
            child: Column(
          children: [
            Image.asset('img/logo3.jpg'),
            const SizedBox(
              height: 20,
            ),
            Text(
              'مشخصات خودرو',
              style: kLargeTextStyle.copyWith(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
              child: TextFieldMaker(
                nametextEditingController: carModeltextEditingController,
                hintText: 'مدل خودرو خود را وارد نمایید',
                labelText: 'مدل خودرو',
                textInputType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
              child: TextFieldMaker(
                nametextEditingController: carNumbertextEditingController,
                hintText: 'شماره پلاک خود را وارد نمایید',
                labelText: 'شماره خودرو',
                textInputType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
              child: TextFieldMaker(
                nametextEditingController: carColortextEditingController,
                hintText: 'رنگ خودرو خود را وارد نمایید',
                labelText: 'رنگ',
                textInputType: TextInputType.text,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: kButtomColor),
                onPressed: () {
                  if (carColortextEditingController.text.isNotEmpty &&
                      carModeltextEditingController.text.isNotEmpty &&
                      carNumbertextEditingController.text.isNotEmpty) {
                    saveCarInfo();
                  }
                 
                },
                child: const Text(
                  'ذخیره ',
                  style: kmediumTextStyle,
                ))
          ],
        )),
      ),
    );
  }
}
