import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

// import '../assistant/request_data.dart';
// import '../constant/constasnt.dart';
import 'direction.dart';
import 'user_model.dart';

class UserData extends ChangeNotifier {
  UserModel? currentUserInfo;
  final _auth = FirebaseAuth.instance;
  Direction? userFromAddr;
  Direction? userDestinationAddr;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void getCurrentUserInfo() {
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child('Drivers')
        .child(_auth.currentUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        currentUserInfo = UserModel.fromSnapshot(snap.snapshot);
        print(currentUserInfo!);

        notifyListeners();
      }
    });
  }
}

// void updateUserLocation(CameraPosition cameraPosition) async {
//   String address;
//   String fullAddress;
//
//   String urlAdrr =
//       "https://api.opencagedata.com/geocode/v1/json?q=${cameraPosition.target.latitude}+${cameraPosition.target.longitude}&key=$geocodeApi3&language=per";
//
//   var respond = await RequestAddress.receiveRequest(urlAdrr);
//
//   address = respond["results"][0]["components"]["city"] +
//       "، محله " +
//       respond["results"][0]["components"]["neighbourhood"] +
//       "، " +
//       respond["results"][0]["components"]["road"];
//
//   fullAddress = respond["results"][0]["formatted"];
//
//   Direction userAddress = Direction();
//   userAddress.locationLat = cameraPosition.target.latitude;
//   userAddress.locationLng = cameraPosition.target.longitude;
//   userAddress.locationName = address;
//   userAddress.fullAddr = fullAddress;
//   userFromAddr = userAddress;
//   notifyListeners();
// }
//
// void updateUserDestination(String? lat, String? lon) async {
//   String address;
//   String fullAddress;
//
//   String urlAdrr =
//       "https://api.opencagedata.com/geocode/v1/json?q=$lat+$lon&key=$geocodeApi3&language=per";
//
//   var respond = await RequestAddress.receiveRequest(urlAdrr);
//
//   address = respond["results"][0]["components"]["city"] +
//       "، محله " +
//       respond["results"][0]["components"]["neighbourhood"] +
//       "، " +
//       respond["results"][0]["components"]["road"];
//
//   fullAddress = respond["results"][0]["formatted"];
//
//   Direction userAddress = Direction();
//   userAddress.locationLat = double.parse(lat!);
//   userAddress.locationLng = double.parse(lon!);
//   userAddress.locationName = address;
//   userAddress.fullAddr = fullAddress;
//   userDestinationAddr = userAddress;
//   // Marker marker = Marker(
//   //     markerId: MarkerId("destinstion"),
//   //     position: LatLng(userAddress.locationLat!, userAddress.locationLng!),
//   //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));
//   //
//   // markers[MarkerId('destinstion')] = marker;
//
//   notifyListeners();
// }
//
// void clearData() {
//   markers.clear();
//   userDestinationAddr = null;
//   notifyListeners();
// }

// void updateUserFromAddr(Position? position) async {
//   String address;
//   String fullAddress;

//   String urlAdrr =
//       "https://api.opencagedata.com/geocode/v1/json?q=${position!.latitude}+${position!.longitude}&key=$geocodeApi3&language=per";

//   var respond = await RequestAddress.receiveRequest(urlAdrr);

//   address = respond["results"][0]["components"]["city"] +
//       "، محله " +
//       respond["results"][0]["components"]["neighbourhood"] +
//       "، " +
//       respond["results"][0]["components"]["road"];

//   fullAddress = respond["results"][0]["formatted"];

//   Direction userAddress = Direction();
//   userAddress.locationLat = position.latitude;
//   userAddress.locationLng = position.longitude;
//   userAddress.locationName = address;
//   userAddress.fullAddr = fullAddress;
//   userFromAddr = userAddress;
//   notifyListeners();
// }
