import 'package:flutter/material.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';

class MyInputMsc {
  static BoxDecoration inputDecoration = BoxDecoration(
    border: Border.all(
      color: MyColors.blueGrey,
    ),
    borderRadius: BorderRadius.circular(6),
  );

  static BoxDecoration inputErrorDecoration = BoxDecoration(
    border: Border.all(
      color: MyColors.crimsonRed,
    ),
    borderRadius: BorderRadius.circular(6),
  );

  static TextStyle inputStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: MyColors.inkBlack,
  );

  static TextStyle errorStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: MyColors.crimsonRed,
  );
}

enum MyInputValidation {
  required,
  invalid,
  valid,
  notMatched,
}

enum MyInputValidationField {
  text,
  email,
  phoneNumber,
}

extension MyInputValidationFieldExt on MyInputValidationField {
  TextInputType inputType() {
    switch (this) {
      case MyInputValidationField.text:
        return TextInputType.text;
      case MyInputValidationField.email:
        return TextInputType.emailAddress;
      case MyInputValidationField.phoneNumber:
        return TextInputType.phone;
    }
  }
}