// ignore_for_file: unused_import
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_app/assistant/assistant_method.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/main%20screens/search_screen.dart';
import 'package:user_app/main%20screens/select_driver.dart';
import 'package:user_app/models/direction.dart';
import 'package:user_app/models/location_model.dart';
import 'package:user_app/models/online_drivers.dart';
import 'package:user_app/models/user_data.dart';
import 'package:user_app/models/user_model.dart';
import 'package:user_app/widgets/drawer.dart';
import 'package:user_app/widgets/progress_dialog.dart';
import 'package:haversine_distance/haversine_distance.dart';
// import 'package:user_app/assistant/assistant_method.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //////////////////////// Variabels /////////////////////

  CameraPosition? cameraPosition;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(36.297631387790176, 59.6059363335371),
    zoom: 14.4746,
  );
  Position? position;
  // final startCoordinate =  Location(position!.latitude, 5.322323);
  // final endCoordinate =  Location(60.393032, 5.327248);

  final haversineDistance = HaversineDistance();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  GoogleMapController? newGoogleMapController;
  bool _openDrawer = true;

  GlobalKey<ScaffoldState> skey = GlobalKey<ScaffoldState>();

  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;
  DatabaseReference? tripRecords;
// //////////////////////////////////////////////// functions///////////////

  locateUserPosition() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    position = currentPosition;
    LatLng latLngPosition = LatLng(position!.latitude, position!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    geofireListener();
  }

  checkpermission() async {
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkpermission();
  }

  void seachOnlineDriver(int amount) async {
    // var status;
    tripRecords = FirebaseDatabase.instance.ref().child('Trip Records').push();
    Map tripInfo = {
      'origin': {
        'latitude': Provider.of<UserData>(context, listen: false)
            .userFromAddr!
            .locationLat
            .toString(),
        'longitude': Provider.of<UserData>(context, listen: false)
            .userFromAddr!
            .locationLng
            .toString(),
        'Adress': Provider.of<UserData>(context, listen: false)
            .userFromAddr!
            .locationName,
      },
      'destination': {
        'latitude': Provider.of<UserData>(context, listen: false)
            .userDestinationAddr!
            .locationLat
            .toString(),
        'longitude': Provider.of<UserData>(context, listen: false)
            .userDestinationAddr!
            .locationLng
            .toString(),
        'Adress': Provider.of<UserData>(context, listen: false)
            .userDestinationAddr!
            .locationName
      },
      'time': DateTime.now().toString(),
      'user info': {
        'name': Provider.of<UserData>(context, listen: false)
            .currentUserInfo!
            .name
            .toString(),
        "phone": Provider.of<UserData>(context, listen: false)
            .currentUserInfo!
            .phoneNum,
      },
      'driverId': '',
    };
    tripRecords!.set(tripInfo);

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) =>
            ProgressDialog('درحال یافتن خودرو '));
    Future.delayed(Duration(seconds: 3), () async {
      if (Provider.of<UserData>(context, listen: false).onlineDrivers.isEmpty) {
        tripRecords!.remove();
        Fluttertoast.showToast(msg: "راننده ای یافت نشد.");
        Navigator.pop(context);
      } else {
        Provider.of<UserData>(context, listen: false).retriveDriverInfo();

       var status=await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SelectDriver(amount: amount, tripRef: tripRecords)));
        Navigator.pop(context);
        
          if(status){FirebaseDatabase.instance
              .ref()
              .child("Drivers")
              .child(Provider.of<UserData>(context,listen: false).selectedDriverId!)
              .once()
              .then((snap) => {
                    if (snap.snapshot.value != null)
                      {
                        // send notification to driver
                        sendNotification(
                            Provider.of<UserData>(context,listen: false).selectedDriverId!)
                      }
                    else
                      {Fluttertoast.showToast(msg: "راننده ای وجود ندارد")}
                  });
           }
        
      }
    });
  }

  sendNotification(String diverrID) {
    // assign rideRequestId to newRideRequest
    FirebaseDatabase.instance
        .ref()
        .child("Drivers")
        .child(Provider.of<UserData>(context,listen: false).selectedDriverId!)
        .child("newRideStatus")
        .set(tripRecords!.key);
  }

  int calculateAmount(Direction originLoc, Direction destinationLoc) {
    var distance = haversineDistance.haversine(
        Location(originLoc.locationLat!, originLoc.locationLng!),
        Location(destinationLoc.locationLat!, destinationLoc.locationLng!),
        Unit.KM);
    return (distance.round() * 5000);
  }

  // void _launchURL(Uri url) async {
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  geofireListener() {
    Geofire.initialize('activeDrivers');
    Geofire.queryAtLocation(position!.latitude, position!.longitude, 5)!
        .listen((map) {
      // search active driver around user location
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:

            /// when any driver get online:
            OnlineDriver onlineDriver = OnlineDriver(
                driverId: map['key'],
                lat: map['latitude'],
                lon: map['longitude']);
            Provider.of<UserData>(context, listen: false)
                .addOnlineDrivers(onlineDriver);

            break;

          case Geofire.onKeyExited: // when any driver get offline
            Provider.of<UserData>(context, listen: false)
                .deleteOfflineDriver(map['key']);
            break;

          case Geofire.onKeyMoved: // Update your key's location
            OnlineDriver onlineMovingDriver = OnlineDriver(
                driverId: map['key'],
                lat: map['latitude'],
                lon: map['longitude']);
            Provider.of<UserData>(context, listen: false)
                .updateOnlineDriverLocation(onlineMovingDriver);
            Provider.of<UserData>(context, listen: false)
                .displayOnlineDrivers();

            break;

          case Geofire.onGeoQueryReady:
            Provider.of<UserData>(context, listen: false)
                .displayOnlineDrivers();

            // All Intial Data is loaded
            break;
        }
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserData>(
      builder: (context, userdata, child) {
        return SafeArea(
            child: Scaffold(
          key: skey,
          drawer: MyDrawer(userdata.currentUserInfo!.name.toString(),
              userdata.currentUserInfo!.email.toString()),
          body: Stack(
            children: [
              GoogleMap(
                markers: userdata.driverMarker,
                onCameraMove: (CameraPosition cameraPositioned) {
                  setState(() {
                    cameraPosition = cameraPositioned;
                  });
                },
                onCameraIdle: () {
                  print(cameraPosition!.target);
                  userdata.updateUserLocation(cameraPosition!);
                  userdata.listLen();
                },
                padding: const EdgeInsets.only(bottom: 210),
                initialCameraPosition: _kGooglePlex,
                mapType: MapType.normal,
                myLocationEnabled: true,
                onMapCreated: ((GoogleMapController controller) {
                  _controller.complete(controller);
                  newGoogleMapController = controller;
                  // for black theme:
                  newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
                  locateUserPosition();
                }),
              ),
              Positioned(
                  top: 30,
                  left: 20,
                  child: IconButton(
                    icon: Icon(_openDrawer ? Icons.menu : Icons.close,
                        color: ksecondColor, size: 30),
                    onPressed: () {
                      if (_openDrawer) {
                        skey.currentState!.openDrawer();
                      } else {
                        userdata.clearData();
                        _openDrawer = true;
                      }
                    },
                  )),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 120),
                    curve: Curves.easeIn,
                    child: Container(
                      height: 210,
                      decoration: const BoxDecoration(
                        color: ksecondColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 20),
                        child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        ':مبدا',
                                        style: kmediumTextStyle,
                                      ),
                                      Text(
                                        userdata.userFromAddr != null
                                            ? userdata
                                                .userFromAddr!.locationName
                                                .toString()
                                            : "موقعیت کنونی",
                                        style: kmediumTextStyle,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  const Icon(Icons.add_location_alt_outlined),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: kthirdColor,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  var response = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SearchLocationScreen()));
                                  if (response == 'Destination Applied') {
                                    setState(() {
                                      _openDrawer = false;
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          ':مقصد',
                                          style: kmediumTextStyle,
                                        ),
                                        Text(
                                          userdata.userDestinationAddr != null
                                              ? userdata.userDestinationAddr!
                                                  .locationName
                                                  .toString()
                                              : "موقعیت کنونی",
                                          style: kmediumTextStyle,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.right,
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    const Icon(Icons.add_location_alt_outlined),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: kthirdColor,
                              ),
                              const SizedBox(
                                height: 13,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  userdata.userFromAddr != null &&
                                          userdata.userDestinationAddr != null
                                      ? ElevatedButton(
                                          onPressed: () async {
                                            var amount = calculateAmount(
                                                userdata.userFromAddr!,
                                                userdata.userDestinationAddr!);
                                            seachOnlineDriver(amount);

                                            print(
                                                'Amount: ${calculateAmount(userdata.userFromAddr!, userdata.userDestinationAddr!)}');
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: kthirdColor),
                                          child: Text(
                                            'درخواست خودرو',
                                            style: kmediumTextStyle.copyWith(
                                                color: kfourthColor),
                                          ),
                                        )
                                      : ElevatedButton(
                                          onPressed: null,
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: kthirdColor),
                                          child: Text(
                                            'درخواست خودرو',
                                            style: kmediumTextStyle.copyWith(
                                                color: kfourthColor),
                                          ),
                                        ),
                                  // userdata.userFromAddr != null &&
                                  //         userdata.userDestinationAddr != null
                                  //     ? ElevatedButton(
                                  //         onPressed: () {
                                  //           final Uri _url = Uri.parse(
                                  //               'https://www.google.com/maps/dir/?api=1&origin=${userdata.userFromAddr!.locationLat!},${userdata.userFromAddr!.locationLng!} &destination=${userdata.userDestinationAddr!.locationLat!},${userdata.userDestinationAddr!.locationLng!}&travelmode=driving');

                                  //           _launchURL(_url);
                                  //         },
                                  //         style: ElevatedButton.styleFrom(
                                  //             backgroundColor: kthirdColor),
                                  //         child: Text(
                                  //           'مسیریابی',
                                  //           style: kmediumTextStyle.copyWith(
                                  //               color: kfourthColor),
                                  //         ),
                                  //       )
                                  //     : ElevatedButton(
                                  //         onPressed: null,
                                  //         style: ElevatedButton.styleFrom(
                                  //             backgroundColor: kthirdColor),
                                  //         child: Text(
                                  //           'مسیریابی',
                                  //           style: kmediumTextStyle.copyWith(
                                  //               color: kfourthColor),
                                  //         ),
                                  //       )
                                ],
                              )
                            ]),
                      ),
                    ),
                  )),
              const Positioned(
                width: 395,
                height: 600,
                child: Icon(
                  Icons.location_on_sharp,
                  size: 30,
                  color: kthirdColor,
                ),
              )
            ],
          ),
        ));
      },
    );
  }
}
