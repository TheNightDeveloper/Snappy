import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

const kLargeTextStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold,
  fontFamily: 'yekan',
);
const kmediumTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  fontFamily: 'yekan',
);

const kmainColor = Color.fromARGB(255, 37, 43, 72);
const ksecondColor = Color.fromARGB(255, 91, 154, 139);
const kButtomColor = Color(0xffFF1953);

class AppColors {
  static final Color textColor1 = Color(0xFF989acd);
  static final Color textColor2 = Color(0xFF878593);
  static final Color bigTextColor = Color(0xFF2e2e31);
  static final Color mainColor = Color(0xFF5d69b3);
  static final Color starColor = Color(0xFFe7bb4e);
  static final Color mainTextColor = Color(0xFFababad);
  static final Color buttonBackground = Color(0xFFf1f1f9);
}

const String mapKeyAPI = "AIzaSyAF0LCJA_ncLl85KDNVdo8VsHgp4J6LVyk";
const String geocodeApi = "24fdb27b1bfee535e84100e45b460700";
const String geocodeApi2 = "pk.0684764f956449283ad2e19725fb9d1c"; // LocationIQ
const String geocodeApi3 = "e2d83108f5dc4a94b069908a8663d6db";

AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
