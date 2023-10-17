import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver_app/constant/constasnt.dart';
import 'package:driver_app/models/ride_request_detail.dart';
import 'package:driver_app/models/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../mainScreens/trip_info_page.dart';

class DialogBox extends StatefulWidget {
  final RideRequestDetail rideRequestDetail;
  DialogBox({required this.rideRequestDetail});
  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  acceptRequest(BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("Drivers")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("newRideStatus")
        .once()
        .then((snap) => {
              if (snap.snapshot != null)
                {
                  FirebaseDatabase.instance
                      .ref()
                      .child("Drivers")
                      .child(FirebaseAuth.instance.currentUser!.uid)
                      .child("newRideStatus")
                      .set("Accepted"),
                }
              else
                {Fluttertoast.showToast(msg: "درخواستی وجود ندارد")},
            });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      backgroundColor: Colors.transparent,
      elevation: 2,
      child: Container(
        // margin: const EdgeInsets.all(1),
        width: double.infinity,

        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.mainTextColor),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "img/car_logo.png",
                width: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                ':درخواست سفر ',
                style: kLargeTextStyle.copyWith(color: kmainColor),
              ),
              const Divider(
                thickness: 2,
                height: 35,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.rideRequestDetail.originAddress!,
                            style: kmediumTextStyle.copyWith(
                                color: kmainColor, fontWeight: FontWeight.w600),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        'img/origin.png',
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                            widget.rideRequestDetail.destinationAddress!,
                            style: kmediumTextStyle.copyWith(
                                color: kmainColor, fontWeight: FontWeight.w600),
                            textDirection: TextDirection.rtl),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        'img/destination.png',
                        width: 20,
                        height: 20,
                      ),
                    ],
                  )
                ],
              ),
              const Divider(
                thickness: 2,
                height: 35,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    assetsAudioPlayer.pause();
                    assetsAudioPlayer.stop();
                    assetsAudioPlayer = AssetsAudioPlayer();
                    acceptRequest(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => TripInfoPage(
                                rideRequestDetail: widget.rideRequestDetail)));

                    // Navigator.pop(context);
                  },
                  child: Text(
                    "قبول سفر",
                    style: kmediumTextStyle.copyWith(fontSize: 20),
                  )),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kButtomColor,
                  ),
                  onPressed: () {
                    assetsAudioPlayer.pause();
                    assetsAudioPlayer.stop();
                    assetsAudioPlayer = AssetsAudioPlayer();
                    Navigator.pop(context);
                  },
                  child: Text(
                    "رد سفر",
                    style: kmediumTextStyle.copyWith(fontSize: 20),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
