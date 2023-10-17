import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver_app/constant/constasnt.dart';
import 'package:driver_app/models/ride_request_detail.dart';
import 'package:driver_app/push_notif/dialogbox.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PushNotification {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future initializeCloudMessaging(BuildContext context) async {
    // when app is closed and recieve push notif:
    FirebaseMessaging.instance.getInitialMessage().then((remoteMessage) {
      if (remoteMessage != null) {
        // display ride request
        readRequestInfo(remoteMessage.data["requestID"], context);
      }
    });

    // when app is open an recieve push notif:
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      readRequestInfo(remoteMessage.data["requestID"], context);
    });
    //when app is run in background:
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      readRequestInfo(remoteMessage.data["requestID"], context);
    });
  }

  readRequestInfo(String requestID, BuildContext context) {
    Map originInfo;
    RideRequestDetail ride;
    FirebaseDatabase.instance
        .ref()
        .child("Trip Records")
        .child(requestID)
        .once()
        .then((data) => {
              if (data.snapshot.value != null)
                {
                  print("hi"),
                  assetsAudioPlayer
                      .open(Audio('sounds/music_notification.mp3')),
                  assetsAudioPlayer.play(),
                  originInfo = data.snapshot.value! as Map,

                  // print(originInfo),
                  ride = RideRequestDetail.fromJson(
                      originInfo, data.snapshot.key!),

                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          DialogBox(rideRequestDetail: ride))
                  // print("thid is ride detail:  ${ride.userName}")
                }
              else
                {Fluttertoast.showToast(msg: 'سفری وجود ندارددددددد!')}
            });
  }

  Future generateToken() async {
    String? token = await messaging.getToken();

    print('token: $token');
    FirebaseDatabase.instance
        .ref()
        .child('Drivers')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('token')
        .set(token);
    messaging.subscribeToTopic('allDrivers');
    messaging.subscribeToTopic('allUsers');
  }
}
