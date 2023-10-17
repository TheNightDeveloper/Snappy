// // import 'dart:js';

// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_database/firebase_database.dart';
// // import 'package:flutter/src/widgets/framework.dart';
// // import 'package:provider/provider.dart';
// // import 'package:user_app/models/user_data.dart';
// // // import 'package:user_app/global/global.dart';
// // import 'package:user_app/models/user_model.dart';

// import 'package:geolocator/geolocator.dart';
// import 'package:provider/provider.dart';
// import 'package:user_app/assistant/request_adress.dart';
// import 'package:user_app/global/global.dart';
// import 'package:user_app/models/direction.dart';
// import 'package:user_app/models/user_data.dart';

// class AssistMethod {
//   static Future<String> searchAddress(Position position, context) async {
//     String fullAddress = "";
//     String urlAdrr =
//         "https://api.opencagedata.com/geocode/v1/json?q=${position.latitude}+${position.longitude}&key=${geocodeApi3}&language=per";

//     var respond = await RequestAddress.receiveRequest(urlAdrr);

//     fullAddress = respond["results"][0]["components"]["city"] +
//         "، محله " +
//         respond["results"][0]["components"]["neighbourhood"] +
//         "، " +
//         respond["results"][0]["components"]["road"];

//     Direction userAddress = Direction();
//     userAddress.locationLat = position.latitude;
//     userAddress.locationLng = position.longitude;
//     userAddress.locationName = fullAddress;

//     Provider.of<UserData>(context,listen: false).updateUserFromAddr(userAddress);

//     return fullAddress;
//   }
// }
