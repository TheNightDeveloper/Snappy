import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? name;
  String? phoneNum;
  String? id;
  String? email;
  String? carColor;
  String? carNumber;
  String? carModel;
  UserModel(this.name, this.phoneNum, this.id, this.email, this.carColor,
      this.carModel, this.carNumber);

  UserModel.fromSnapshot(DataSnapshot snap) {
    phoneNum = (snap.value as dynamic)["phone Number"];
    name = (snap.value as dynamic)["name"];
    id = snap.key;
    email = (snap.value as dynamic)["email"];
    carModel = (snap.value as dynamic)["Car Datails"]["Car Model"];
    carNumber = (snap.value as dynamic)["Car Datails"]["Car Number"];
    carColor = (snap.value as dynamic)["Car Datails"]["Car Color"];
  }
}
