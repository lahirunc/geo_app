import 'package:flutter/material.dart';

const kWhite = Color(0xFFFFFFFF);
const kGrey = Color(0xFF9E9E9E);
const kRed = Color(0xFFF44336);
const kBlue = Color(0xFF2196F3);
const kOrange = Color(0xFFFF9800);

class Config {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;
  }
}
