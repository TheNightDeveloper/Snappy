import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_app/assistant/request_adress.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/models/direction.dart';
import 'package:user_app/models/online_drivers.dart';
import 'user_model.dart';

class UserData extends ChangeNotifier {
  UserModel? currentUserInfo;
  final _auth = FirebaseAuth.instance;
  Direction? userFromAddr;
  Direction? userDestinationAddr;
  String? selectedDriverId;

  Set<Marker> driverMarker = <Marker>{};
  int? nm;
  List driverInfo = [];
  List<OnlineDriver> onlineDrivers = [];
  void listLen() {
    nm = onlineDrivers.length;
    print("onlines:${nm}");
    print('marker:${driverMarker.length}');
    notifyListeners();
  }

  void updateUserLocation(CameraPosition cameraPosition) async {
    String address;
    String fullAddress;

    String urlAdrr =
        "https://api.opencagedata.com/geocode/v1/json?q=${cameraPosition.target.latitude}+${cameraPosition.target.longitude}&key=${geocodeApi3}&language=per";

    var respond = await RequestAddress.receiveRequest(urlAdrr);

    address = respond["results"][0]["components"]["city"] +
        "، محله " +
        respond["results"][0]["components"]["neighbourhood"] +
        "، " +
        respond["results"][0]["components"]["road"];

    fullAddress = respond["results"][0]["formatted"];

    Direction userAddress = Direction();
    userAddress.locationLat = cameraPosition.target.latitude;
    userAddress.locationLng = cameraPosition.target.longitude;
    userAddress.locationName = address;
    userAddress.fullAddr = fullAddress;
    userFromAddr = userAddress;
    notifyListeners();
  }

  void updateUserDestination(String? lat, String? lon) async {
    String address;
    String fullAddress;

    String urlAdrr =
        "https://api.opencagedata.com/geocode/v1/json?q=${lat}+${lon}&key=${geocodeApi3}&language=per";

    var respond = await RequestAddress.receiveRequest(urlAdrr);

    address = respond["results"][0]["components"]["city"] +
        "، محله " +
        respond["results"][0]["components"]["neighbourhood"] +
        "، " +
        respond["results"][0]["components"]["road"];

    fullAddress = respond["results"][0]["formatted"];

    Direction userAddress = Direction();
    userAddress.locationLat = double.parse(lat!);
    userAddress.locationLng = double.parse(lon!);
    userAddress.locationName = address;
    userAddress.fullAddr = fullAddress;
    userDestinationAddr = userAddress;
    Marker marker = Marker(
        markerId: MarkerId("destinstion"),
        position: LatLng(userAddress.locationLat!, userAddress.locationLng!),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));

    // markers[MarkerId('destinstion')] = marker;
    driverMarker.add(marker);

    notifyListeners();
  }

  void displayOnlineDrivers() async {
    for (OnlineDriver driver in onlineDrivers) {
      Marker marker = Marker(
          markerId: MarkerId(driver.driverId),
          position: LatLng(driver.lat, driver.lon),
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(2, 2)), 'img/car.png'),
          rotation: 360);
      driverMarker.add(marker);
      notifyListeners(); // markers['drivers']!.add(marker);
    }
  }

  void clearData() {
    driverMarker
        .removeWhere((element) => element.markerId.value == 'destinstion');
    userDestinationAddr = null;
    notifyListeners();
  }

  void addOnlineDrivers(OnlineDriver onlineDriver) {
    onlineDrivers.add(onlineDriver);

    notifyListeners();
  }

  void deleteOfflineDriver(String driverID) {
    int indexNum =
        onlineDrivers.indexWhere((element) => element.driverId == driverID);
    onlineDrivers.removeAt(indexNum);
    driverMarker.removeWhere((element) => element.markerId.value == driverID);
    notifyListeners();
  }

  void updateOnlineDriverLocation(OnlineDriver movingDriver) {
    int indexNum = onlineDrivers
        .indexWhere((element) => element.driverId == movingDriver.driverId);
    onlineDrivers[indexNum].lat = movingDriver.lat;
    onlineDrivers[indexNum].lon = movingDriver.lon;
    notifyListeners();
  }

  void retriveDriverInfo() async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child('Drivers');
    for (int driver = 0; driver < onlineDrivers.length; driver++) {
      await reference
          .child(onlineDrivers[driver].driverId.toString())
          .once()
          .then((data) {
        driverInfo.add(data.snapshot.value);
        print(driverInfo);
        notifyListeners();
      });
    }
  }

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
  void getSelectedDriverID(String id) {
    selectedDriverId = id;
    notifyListeners();
  }

  void getCurrentUserInfo() {
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child('Users')
        .child(_auth.currentUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        currentUserInfo = UserModel.fromSnapshot(snap.snapshot);
        notifyListeners();
        print('name:${currentUserInfo!.name.toString()}');
        print('email:${currentUserInfo!.email.toString()}');
      }
    });
  }
}
