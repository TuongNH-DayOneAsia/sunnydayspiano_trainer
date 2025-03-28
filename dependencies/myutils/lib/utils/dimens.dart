import 'package:flutter/material.dart';

/**
 * Created by Nguyen Huu Tu on 28/03/2022.
 */

class FontSize {
  static const double xxSmall = 6;
  static const double xSmall = 8;
  static const double small = 10;
  static const double medium = 12;
  static const double normal = 14;
  static const double large = 16;
  static const double xLarge = 18;
  static const double xxLarge = 20;
  static const double xxxLarge = 22;
  static const double superLarge = 24;
  static const double xSuperLarge = 26;
  static const double xxSuperLarge = 28;
  static const double xxxSuperLarge = 30;
  static const double xxxxSuperLarge = 32;
}

class Dimens {
  static const double figmaWidth = 390;
  static const double figmaHeight = 844;
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

 static double getAdaptiveFontSize(BuildContext context, double baseFontSize) {
    double screenWidth = getScreenWidth(context);
    double scaleFactor = screenWidth / 375;
    return baseFontSize * scaleFactor;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getProportionalScreenWidth(BuildContext context, double width) {
    return (width / figmaWidth) * MediaQuery.of(context).size.width;
  }

  static double getProportionalScreenHeight(BuildContext context, double height) {
    return (height / figmaHeight) * MediaQuery.of(context).size.height;
  }
}
