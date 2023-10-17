import 'package:driver_app/constant/constasnt.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

import '../models/ride_request_detail.dart';
import '../models/user_data.dart';

class TripInfoPage extends StatefulWidget {
  final RideRequestDetail rideRequestDetail;
  TripInfoPage({required this.rideRequestDetail});

  @override
  State<TripInfoPage> createState() => _TripInfoPageState();
}

class _TripInfoPageState extends State<TripInfoPage> {
  Position? driverCurrentLocation;
  bool tripIsStarted = false;

  ///////// functions/////////
  void navigatorToOrigin() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverCurrentLocation = currentPosition;
    Uri _url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=${driverCurrentLocation!.latitude},${driverCurrentLocation!.longitude} &destination=${widget.rideRequestDetail.originLatLng!.latitude},${widget.rideRequestDetail.originLatLng!.longitude}&travelmode=driving');
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  void navigatorToDestination() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverCurrentLocation = currentPosition;
    Uri _url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=${driverCurrentLocation!.latitude},${driverCurrentLocation!.longitude} &destination=${widget.rideRequestDetail.destinationLatLng!.latitude},${widget.rideRequestDetail.destinationLatLng!.longitude}&travelmode=driving');
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      addDriverInfo();
    });
  }

  addDriverInfo() {
    Provider.of<UserData>(context, listen: false).getCurrentUserInfo();
    var currentUser =
        Provider.of<UserData>(context, listen: false).currentUserInfo!;
    Map<String, dynamic> driverInfo = {
      "Driver Id": currentUser.id,
      "Driver Name": currentUser.name,
      "Driver Phone": currentUser.phoneNum,
      "Driver Car": {
        "Car Model": currentUser.carModel,
        "Car Number": currentUser.carNumber,
        "Car Color": currentUser.carColor
      }
    };
    FirebaseDatabase.instance
        .ref()
        .child("Trip Records")
        .child(widget.rideRequestDetail.rideRequestID!)
        .once()
        .then((value) => {
              FirebaseDatabase.instance
                  .ref()
                  .child("Trip Records")
                  .child(widget.rideRequestDetail.rideRequestID!)
                  .child("driverId")
                  .set(driverInfo)
            });

    saveRequestToDriverHistory();
  }

  void saveRequestToDriverHistory() {
    FirebaseDatabase.instance
        .ref()
        .child("Drivers")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("Trip History")
        .child(widget.rideRequestDetail.rideRequestID!)
        .set(true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: kmainColor,
        centerTitle: true,
        title: const Text(
          "اطلاعات سفر",
          style: kmediumTextStyle,
        ),
      ),
      backgroundColor: kmainColor,
      body: Container(
        width: double.infinity,
        height: 480,
        decoration: const BoxDecoration(
          color: ksecondColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const Text(
                "اطلاعات مسافر",
                style: kLargeTextStyle,
              ),
              const Divider(
                thickness: 2,
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        launchUrl(Uri.parse(
                            "tel:${widget.rideRequestDetail.userPhone!}"));
                      },
                      icon: const Icon(
                        Icons.call,
                        size: 35,
                        color: kButtomColor,
                      )),
                  Row(
                    children: [
                      Text(
                        widget.rideRequestDetail.userName!,
                        style: kmediumTextStyle,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.person,
                        color: kmainColor,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      child: Text(
                        widget.rideRequestDetail.originAddress!,
                        style: kmediumTextStyle.copyWith(
                            color: kmainColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
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
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(widget.rideRequestDetail.destinationAddress!,
                        style: kmediumTextStyle.copyWith(
                            color: kmainColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
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
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text("هزینه سفر: 25000 تومان",
                        style: kmediumTextStyle.copyWith(
                            color: kmainColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                        textDirection: TextDirection.rtl),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    Icons.attach_money_outlined,
                    size: 32,
                    color: kmainColor,
                  ),
                ],
              ),
              const Divider(
                thickness: 2,
                height: 20,
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  tripIsStarted
                      ? ElevatedButton.icon(
                          onPressed: () {
                            navigatorToDestination();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kButtomColor,
                          ),
                          icon: const Icon(Icons.route),
                          label: const Text(
                            "مسیریابی به سمت مقصد",
                            style: kmediumTextStyle,
                          ),
                        )
                      : ElevatedButton.icon(
                          onPressed: () {
                            navigatorToOrigin();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kButtomColor,
                          ),
                          icon: const Icon(Icons.route),
                          label: const Text(
                            "مسیریابی به سمت مبدا",
                            style: kmediumTextStyle,
                          ),
                        ),
                  tripIsStarted
                      ? ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              tripIsStarted = false;
                            });
                            // navigator();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kButtomColor,
                          ),
                          icon: const Icon(Icons.location_pin),
                          label: const Text(
                            "به مقصد رسیدم",
                            style: kmediumTextStyle,
                          ),
                        )
                      : ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              tripIsStarted = true;
                            });
                            // navigator();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kButtomColor,
                          ),
                          icon: const Icon(Icons.location_pin),
                          label: const Text(
                            "به مبدا رسیدم",
                            style: kmediumTextStyle,
                          ),
                        )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
