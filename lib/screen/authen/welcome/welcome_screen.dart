import 'dart:io';

import 'package:dayoneasia/screen/authen/apple_testing/forget_password/apple_forget_password_screen.dart';
import 'package:dayoneasia/screen/authen/forget_password/forget_password_screen.dart';
import 'package:dayoneasia/screen/authen/login/login_screen.dart';
import 'package:dayoneasia/screen/authen/widget/change_language_widget.dart';
import 'package:dayoneasia/screen/authen/widget/register_terms_and_conditions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/image_extension.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/widgets/my_button.dart';

import 'cubit/welcome_cubit.dart';

class WelcomeScreen extends StatelessWidget {
  static const String route = '/welcome';

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WelcomeCubit(),
      child: BlocBuilder<WelcomeCubit, WelcomeState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                // Background image
                MyImage.cachedImgFromUrl(
                  hasPlaceholder: false,
                  url: context.read<WelcomeCubit>().bannerApp,
                  width: double.infinity,
                  height: double.infinity,
                ),
                if (!context.read<WelcomeCubit>().inReleaseIOSFromApi)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 16,
                    right: 16,
                    child: ChangeLanguageWidget(
                      onTap: () {
                        if (!context.read<WelcomeCubit>().inDev) {
                          final currentLang = context.read<WelcomeCubit>().language;
                          final newLang = currentLang == 'vi' ? 'en' : 'vi';
                          context.setLocale(Locale(newLang));
                          context.read<WelcomeCubit>().localeManager.setStringValue(StorageKeys.cachedLang, newLang);
                          EventBus.shared.setLocale(newLang);
                          MyPopupMessage.showPopUpWithIcon(
                            title: 'profile.changeLanguageSuccess'.tr(),
                            context: context,
                            barrierDismissible: false,
                            cancelText: 'bookingClass.goBack'.tr(),
                            cancelColor: MyColors.mainColor,
                            iconAssetPath: 'booking/success.svg',
                          );
                          // showSelectLanguage(
                          //   pageContext: context,
                          // );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('home.featureInDevelopment'.tr()),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      code: context.read<WelcomeCubit>().language,
                    ),
                  ),
                // Bottom container
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 277.h,
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                      color: Color(0xCC2E2E2E),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(height: 64.h),
                              MyButton(
                                width: Dimens.getProportionalScreenWidth(context, 295),
                                fontSize: 14.sp,
                                text: 'authentication.login'.tr(),
                                color: MyColors.mainColor,
                                height: 38.h,
                                onPressed: (value) {
                                  context.push(LoginScreen.route);
                                },
                              ),
                              TextButton(
                                onPressed: () {
                                  if (context.read<WelcomeCubit>().inReleaseIOSFromApi) {
                                    context.push(AppleForgetPasswordScreen.route);
                                    return;
                                  }
                                  context.push(ForgetPasswordScreen.route);
                                },
                                child: Text(
                                  'authentication.forgotPassword'.tr(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const TermsAndConditions(
                          color: Colors.white,
                        ),
                        if (Platform.isIOS) SizedBox(height: 18.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
