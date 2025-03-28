import 'package:dayoneasia/screen/dashboard/booking_history/cubit/booking_history_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

import 'image_extension.dart';

extension MyString on String {
  static const String messageError = 'Đã có lỗi xảy ra, vui lòng thử lại sau';

  // packages/resource/vib_assets/images/logo_b2c.svg
  static pathForAsset(String package, String assetName) {
    return 'packages/$package/$assetName';
  }

  static String iconApp() {
    return pathForAsset(commonResource, 'assets/icons/logo_app.png');
  }
  static String alphaText(String value) {
    final Map<String, String> alphaTextMap = {
      ClassType.CLASS.name: '---',
      ClassType.CLASS_PRACTICE.name: '---',
      ClassType.P1P2.name: 'P1P2',
      ClassType.ONE_GENERAL.name: 'G',
      ClassType.ONE_PRIVATE.name: 'P',
      ClassType.TRIAL.name: 'T',
    };
    return alphaTextMap[value] ?? '!';


  }
  static pathForAssetGlobal(String package, String assetName) {
    return 'packages/$package/$assetName';
  }
  String convertDateFormat() {
    try {
      final DateTime dateTime = DateTime.parse(this);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return this;
    }
  }
  String textBookingTypeInHome() {
    List<String> words = split(' ').map((word) => word.trim()).toList();
    words.insert(2, '\n');
    String formattedTitle = words
        .asMap()
        .entries
        .map((entry) {
          int index = entry.key;
          String word = entry.value;
          return index == 2 ? word : '$word ';
        })
        .join('')
        .trim();

    return formattedTitle;
  }
  // String nameAppbar() {
  //   // final key = data?.key ?? '';
  //   final Map<String, String> bookingIcons = {
  //     ClassType.ONE_PRIVATE.name: 'Lớp 1:1 không gian riêng',
  //     ClassType.ONE_GERENAL.name: 'Lớp 1:1 không gian chung',
  //     ClassType.P1P2.name: 'Trải nghiệm huấn luyện viên',
  //   };
  //   return bookingIcons[key] ?? 'Lớp 1:1 không gian chung';
  // }
  String removeDiacritics() {
    return replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
        .replaceAll(RegExp(r'[ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ]'), 'A')
        .replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e')
        .replaceAll(RegExp(r'[ÈÉẸẺẼÊỀẾỆỂỄ]'), 'E')
        .replaceAll(RegExp(r'[ìíịỉĩ]'), 'i')
        .replaceAll(RegExp(r'[ÌÍỊỈĨ]'), 'I')
        .replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
        .replaceAll(RegExp(r'[ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ]'), 'O')
        .replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u')
        .replaceAll(RegExp(r'[ÙÚỤỦŨƯỪỨỰỬỮ]'), 'U')
        .replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y')
        .replaceAll(RegExp(r'[ỲÝỴỶỸ]'), 'Y')
        .replaceAll(RegExp(r'[đ]'), 'd')
        .replaceAll(RegExp(r'[Đ]'), 'D');
  }

  String convertDateFormatToEn() {
    List<String> parts = split('/');

    if (parts.length == 2 || parts.length == 3) {
      if (parts[0].length == 2 && parts[1].length == 2 && int.tryParse(parts[0]) != null && int.tryParse(parts[1]) != null) {
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);

        if (day >= 1 && day <= 31 && month >= 1 && month <= 12) {
          String result = '${parts[1].padLeft(2, '0')}/${parts[0].padLeft(2, '0')}';

          if (parts.length == 3) {
            if (parts[2].length == 4 && int.tryParse(parts[2]) != null) {
              result += '/${parts[2]}';
            } else {
              return this;
            }
          }

          return result;
        }
      }
    }

    return this;
  }

  String capitalize() {
    if (isEmpty) return '';
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  bool containsCharacters() {
    return RegExp(r"[^a-z]", caseSensitive: false).hasMatch(this);
  }

  bool isNumeric() {
    if (isNotEmpty) {
      final value = double.tryParse(this);
      return value != null;
    }
    return false;
  }

  bool isPhoneNumber() {
    return (length == 10 && length == 11) && startsWith('0');
  }

  bool isEmailAddress() {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
  }

  String validatePassword(String password, {String? checkPasswordOld}) {
    if (password.isEmpty) {
      return 'authentication.enterPassword'.tr();
    }
    if (password.length < 8) {
      return 'authentication.passwordMustBeAtLeast8Characters'.tr();
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'authentication.passwordMustContainUppercaseLetter'.tr();
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'authentication.passwordMustContainNumber'.tr();
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'authentication.passwordMustContainSpecialCharacter'.tr();
    }
    if (checkPasswordOld != null && password == checkPasswordOld) {
      return 'authentication.newPasswordMustNotMatchOldPassword'.tr();
    }
    return ''; // Mật khẩu hợp lệ
  }

  String validatePhone(String phone) {
    if (phone.isEmpty) {
      return 'authentication.enterPhoneNumber'.tr();
    }

    if (!phone.startsWith('0')) {
      return '${'authentication.phoneNumberMustStartWithZero'.tr()}';
    }
    if (phone.length != 10 && phone.length != 11) {
      return 'authentication.phoneNumberMustBe10Or11Digits'.tr();
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      return 'authentication.phoneNumberMustContainOnlyDigits'.tr();
    }
    return '';
  }

  String validateEmail(String email) {
    if (email.isEmpty) {
      return 'authentication.enterEmail'.tr();
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'authentication.emailValidation'.tr();
    }
    return '';
  }

  DateTime toDateTime(String pattern) {
    return DateFormat(pattern).parse(this);
  }

  String toDateString({
    required String inputPattern,
    required String outputPattern,
  }) {
    final dateTime = toDateTime(inputPattern);
    return DateFormat(outputPattern).format(dateTime);
  }
}

extension MyStringNull on String? {
  bool isNullOrEmpty() {
    if (this == null) {
      return true;
    } else {
      if (this!.isEmpty) {
        return true;
      }
      return false;
    }
  }
}
