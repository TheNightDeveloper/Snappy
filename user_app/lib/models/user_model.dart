// import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? name;
  String? phoneNum;
  String? id;
  String? email;

  UserModel(this.name, this.phoneNum, this.id, this.email);

  UserModel.fromSnapshot(DataSnapshot snap) {
    phoneNum = (snap.value as dynamic)["phone Number"];
    name = (snap.value as dynamic)["name"];
    id = snap.key;
    email = (snap.value as dynamic)["email"];
  }
}
