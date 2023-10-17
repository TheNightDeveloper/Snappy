import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideRequestDetail {
  LatLng? originLatLng;
  LatLng? destinationLatLng;
  String? originAddress;
  String? destinationAddress;
  String? userName;
  String? rideRequestID;
  String? userPhone;
  RideRequestDetail(
      {this.destinationAddress,
      this.originLatLng,
      this.userPhone,
      this.userName,
      this.originAddress,
      this.destinationLatLng,
      this.rideRequestID});

  RideRequestDetail.fromJson(Map requestInfo, String? key) {
    originLatLng = LatLng(double.parse(requestInfo["origin"]["latitude"]),
        double.parse(requestInfo["origin"]["longitude"]));
    destinationLatLng = LatLng(
        double.parse(requestInfo["destination"]["latitude"]),
        double.parse(requestInfo["destination"]["longitude"]));
    originAddress = requestInfo["origin"]["Adress"];
    destinationAddress = requestInfo["destination"]["Adress"];
    userName = requestInfo["user info"]["name"];
    userPhone = requestInfo["user info"]["phone"];
    rideRequestID = key;
  }
}
