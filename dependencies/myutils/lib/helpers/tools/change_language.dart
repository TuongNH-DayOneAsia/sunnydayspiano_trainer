import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/data/cache_helper/cache_helper.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/popup/my_present_view_helper.dart';
import 'package:myutils/utils/widgets/my_radio.dart';
import 'package:myutils/utils/widgets/my_tap_widget.dart';

showSelectLanguage({required BuildContext pageContext, VoidCallback? reloadLanguage}) {
  LocaleManager localeManager = injector();
  MyPresentViewHelper.presentSheet<String?>(
    title: 'profile.selectLanguage'.tr(),
    context: pageContext,
    builder: Builder(
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ['vi', 'en'].map((code) {
              return SelectLanguageItem(
                code: code,
                onTap: () {
                  Navigator.of(context).pop();
                  context.setLocale(
                    Locale.fromSubtags(languageCode: code),
                  );
                  localeManager.setStringValue(StorageKeys.cachedLang, code);
                  LocalStream.shared.setLocale(code);
                  MyPopupMessage.showPopUpWithIcon(
                    title: 'profile.changeLanguageSuccess'.tr(),
                    context: pageContext,
                    barrierDismissible: false,
                    cancelText: 'bookingClass.goBack'.tr(),
                    cancelColor: MyColors.mainColor,
                    iconAssetPath: 'booking/success.svg',
                  );
                  if (reloadLanguage != null) {
                    reloadLanguage();
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    ),
  );
}
class SelectLanguageItem extends StatelessWidget {
  final String code;
  final VoidCallback onTap;

  const SelectLanguageItem({
    required this.code,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MyTapWidget(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: MyColors.snowGrey),
          ),
        ),
        child: Row(
          children: [
            MyRadio(
              value: code,
              groupValue: context.locale.languageCode,
              selectedIcon: const MySimpleRadioWidget(
                size: 24,
                isSelected: true,
              ),
              unselectedIcon: const MySimpleRadioWidget(
                size: 24,
              ),
            ),
            SizedBox(width: 16.w),
            MyAppIcon.iconNamedCommon(
                iconName: code == 'vi' ? 'profile/vi_flag.svg' : 'profile/en_flag.svg', width: 24, height: 24),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                'profile.$code'.tr(),
                style: TextStyle(
                  fontSize: 15.sp,
                  color: MyColors.inkBlack,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}