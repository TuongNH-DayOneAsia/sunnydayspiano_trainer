import 'package:flutter/material.dart';
import 'package:myutils/helpers/extension/image_extension.dart';
import 'package:path/path.dart' as p;

extension MyAppIcon on Icon {
  static Widget iconNamedSupplier({
    required String iconName,
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
  }) {
    String pathExtension = p.extension(iconName);
    if (pathExtension.toLowerCase() == ".svg") {
      return MyImage.svgFromSupplier(
        assetName: "assets/icons/$iconName",
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        color: color,
      );
    } else {
      return MyImage.imgFromSupplier(
        assetName: "assets/icons/$iconName",
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
      );
    }
  }

  static Widget iconNamedCommon(
      {required String iconName, double? width, double? height, BoxFit? fit, Color? color}) {
    String pathExtension = p.extension(iconName);
    if (pathExtension.toLowerCase() == ".svg") {
      return MyImage.svgFromCommon(
          color: color,
          assetName: "assets/icons/$iconName",
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain);
    } else {
      return MyImage.imgFromCommon(
        color: color,
          assetName: "assets/icons/$iconName",
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain);
    }
  }

  static Widget get radioCircle {
    return MyImage.svgFromSupplier(
        assetName: "assets/icons/radio/radio-circle-free.svg");
  }

  static Widget get radioCircleActive {
    return MyImage.svgFromSupplier(
        assetName: "assets/icons/radio/radio-circle-active.svg");
  }

  static Widget get radioCheckbox {
    return MyImage.svgFromSupplier(
        assetName: "assets/icons/radio/radio-checkbox.svg");
  }

  static Widget get radioCheckboxActive {
    return MyImage.svgFromSupplier(
        assetName: "assets/icons/radio/radio-checkbox-active.svg");
  }



  static Widget iconInsurance({required String status}) {
    return MyImage.svgFromSupplier(
        assetName: "assets/icons/status/booking-status-success.svg");
  }
}
