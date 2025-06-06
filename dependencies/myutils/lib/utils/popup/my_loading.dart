import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MyLoading {
  // late BuildContext context;
  bool isLoading = false;
  // GtdLoading(this.context);
  MyLoading();

  //Show loading
  Future<void> showLoading(BuildContext context) async {
    isLoading = true;
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent, // can change this to your prefered color
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        );
      },
    );
  }

  //Hide loading
  Future<void> hideLoading(BuildContext context) async {
    if (isLoading) {
      isLoading = false;
      Navigator.of(context).pop();
    }
  }

  static Future<void> show() {
    return EasyLoading.show(indicator: const CircularProgressIndicator(), maskType: EasyLoadingMaskType.custom);
  }

  static Future<void> hide() {
    return EasyLoading.dismiss(animation: true);
  }
}
