import 'dart:async';

import 'package:driver_app/constant/constasnt.dart';
import 'package:driver_app/models/user_data.dart';
import 'package:driver_app/push_notif/push_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  //////////// VARIABLES ///////////////
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  GoogleMapController? newGoogleMapController;

  StreamSubscription<Position>? _streamSubscription;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(36.3167131088979, 59.54024065285921),
    zoom: 14.4746,
  );

  Position? driverPosition;
  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  bool _isOnline = false;
  String _status = 'offline';

  //////////// FUNCTIONS /////////////

  locateDriverPosition() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverPosition = currentPosition;
    LatLng latLngPosition =
        LatLng(driverPosition!.latitude, driverPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  checkpermission() async {
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  readCurrentDriverInfo() async {
    PushNotification pushNotification = PushNotification();
    pushNotification.initializeCloudMessaging(context);
    pushNotification.generateToken();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkpermission();
    readCurrentDriverInfo();
  }

  driverIsOnline() {
    Geofire.initialize('activeDrivers');
    Geofire.setLocation(
        _currentUser!.uid, driverPosition!.latitude, driverPosition!.longitude);
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child('Drivers')
        .child(_currentUser!.uid)
        .child('newRideStatus');
    ref.set('idle'); // searching for ride request
    ref.onValue.listen((event) {});
  }

  streamDriverLocation() {
    _streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      driverPosition = position;
      if (_isOnline) {
        Geofire.setLocation(_currentUser!.uid, driverPosition!.latitude,
            driverPosition!.longitude);
      }
      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(
          LatLng(driverPosition!.latitude, driverPosition!.longitude)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onLongPress: (LatLng latlng) {
              print(latlng);
            },
            initialCameraPosition: _kGooglePlex,
            mapType: MapType.normal,
            myLocationEnabled: true,
            onMapCreated: ((GoogleMapController controller) {
              _controller.complete(controller);
              newGoogleMapController = controller;

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
              locateDriverPosition();
            }),
          ),
          _status != "online"
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  color: Colors.black54,
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedAlign(
                alignment: !_isOnline ? Alignment.center : Alignment.topCenter,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isOnline = !_isOnline;
                      });

                      if (_isOnline) {
                        _status = 'online';
                        driverIsOnline();
                        streamDriverLocation();
                      } else {
                        _status = 'offline';
                        Geofire.removeLocation(_currentUser!.uid);
                        DatabaseReference? ref = FirebaseDatabase.instance
                            .ref()
                            .child('Drivers')
                            .child(_currentUser!.uid)
                            .child('newRideStatus');
                        ref.onDisconnect();
                        ref.remove();
                        ref = null;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            !_isOnline ? ksecondColor : kButtomColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    child: !_isOnline
                        ? const Text(
                            'آفلاین هستید',
                            style: kmediumTextStyle,
                          )
                        : const Text(
                            'آنلاین هستید',
                            style: kmediumTextStyle,
                          )),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
