import 'dart:io';

import 'package:dayoneasia/screen/authen/apple_testing/forget_password/apple_forget_password_screen.dart';
import 'package:dayoneasia/screen/authen/apple_testing/register/apple_register_account_screen.dart';
import 'package:dayoneasia/screen/authen/forget_password/forget_password_screen.dart';
import 'package:dayoneasia/screen/authen/login/cubit/login_cubit.dart';
import 'package:dayoneasia/screen/authen/login/cubit/login_state.dart';
import 'package:dayoneasia/screen/authen/widget/register_terms_and_conditions.dart';
import 'package:dayoneasia/screen/dashboard/home/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:myutils/base/bloc/app_cubit.dart';
import 'package:myutils/base/bloc/app_state.dart';
import 'package:myutils/config/app_config.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/image_extension.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/widgets/customt_textfield_widget.dart';
import 'package:myutils/utils/widgets/my_button.dart';

class LoginScreen extends StatelessWidget {
  static const String route = '/login';

  @override
  bool get hasAppbar => false;

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext pageContext) {
    return BlocListener<AppCubit, AppState>(
      listener: (context, state) async {
        if (state.dataKeyPrivate == null) return;
        ToolHelper.forceUpdate(context: context, data: state.dataKeyPrivate!);
      },
  child: BlocProvider(
      create: (context) => LoginCubit(),
      child: const _BuildBodyLoginWidget(),
    ),
);
  }
}

class _BuildBodyLoginWidget extends StatefulWidget {
  const _BuildBodyLoginWidget();

  @override
  State<_BuildBodyLoginWidget> createState() => _BuildBodyLoginWidgetState();
}

class _BuildBodyLoginWidgetState extends State<_BuildBodyLoginWidget> with SingleTickerProviderStateMixin {
  bool _isLoginMode = false;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  bool _hideChangeLanguageWidget = false;

  void _handleFocusChange(bool hasFocus) {
    setState(() {
      _hideChangeLanguageWidget = hasFocus;
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    //
    _isLoginMode = true;
    _animationController.forward();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _heightAnimation =
        Tween<double>(begin: MediaQuery.of(context).size.height * 0.2728, end: MediaQuery.of(context).size.height * 0.588)
            .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOutCubic,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return KeyboardDismisser(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: MyImage.cachedImgFromUrl(
                  fit: BoxFit.cover,
                  hasPlaceholder: false,
                  url: context.read<LoginCubit>().bannerApp,
                  errorWidget: Image.asset(
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    'packages/common_resource/assets/icons/welcome_login.jpg',
                    // fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: _heightAnimation.value,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xCC2E2E2E),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30.0),
                        ),
                      ),
                      child: _isLoginMode ? _buildModeLogin(context) : _buildModelWelcome(context),
                    ),
                  );
                },
              ),
              // if (!context.read<LoginCubit>().inReleaseIOSFromApi && !_hideChangeLanguageWidget)
              //   Positioned(
              //     top: MediaQuery.of(context).padding.top + 16,
              //     right: 16,
              //     child: ChangeLanguageWidget(
              //       onTap: () {
              //         if (!context.read<LoginCubit>().inDev) {
              //           final currentLang = context.read<LoginCubit>().language;
              //           final newLang = currentLang == 'vi' ? 'en' : 'vi';
              //           if (kDebugMode) {
              //             print('newLang $newLang');
              //           }
              //
              //           context.setLocale(Locale(newLang));
              //           context.read<LoginCubit>().localeManager.setStringValue(StorageKeys.cachedLang, newLang);
              //           LocalStream.shared.setLocale(newLang);
              //
              //           MyPopupMessage.showPopUpWithIcon(
              //             title: 'profile.changeLanguageSuccess'.tr(),
              //             context: context,
              //             barrierDismissible: false,
              //             cancelText: 'bookingClass.goBack'.tr(),
              //             cancelColor: MyColors.mainColor,
              //             iconAssetPath: 'booking/success.svg',
              //           );
              //         } else {
              //           ScaffoldMessenger.of(context).showSnackBar(
              //             SnackBar(
              //               content: Text('home.featureInDevelopment'.tr()),
              //               duration: const Duration(seconds: 3),
              //             ),
              //           );
              //         }
              //       },
              //       code: context.read<LoginCubit>().language,
              //     ),
              //   ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModelWelcome(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: constraints.maxHeight * 0.1),
                        FractionallySizedBox(
                          widthFactor: 0.8,
                          child: MyButton(
                            text: 'authentication.login'.tr(),
                            color: MyColors.mainColor,
                            height: 38.h,
                            onPressed: (value) {
                              setState(() {
                                _isLoginMode = true;
                              });
                              _animationController.forward();
                            },
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (context.read<LoginCubit>().inReleaseIOSFromApi) {
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
                  Padding(
                    padding: EdgeInsets.only(bottom: constraints.maxHeight * 0.05),
                    child: const TermsAndConditions(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModeLogin(BuildContext context) {
    final env = injector<AppConfig>().flavor;
    final isProd = env == Flavor.prod;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Padding(
            padding: EdgeInsets.only(left: 32.w, right: 32.w, top: 64.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isProd)
                  Center(
                    child: Text(
                      '${env?.name ?? ''}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.unbounded(
                        // textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 26.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                Text(
                  'authentication.login'.tr(),
                  style: GoogleFonts.unbounded(
                    // textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text('authentication.enterPhoneNumberToLogin'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    )),
                SizedBox(
                  height: 20.h,
                ),
                CustomTextField(
                  onFocusChange: (hasFocus) {
                    _handleFocusChange(hasFocus);
                  },
                  filled: true,
                  keyboardType: context.read<LoginCubit>().inReleaseIOSFromApi ? TextInputType.emailAddress : TextInputType.phone,
                  onChanged: (email) {
                    context.read<LoginCubit>().onPhoneChanged(email);
                  },
                  hintText: context.read<LoginCubit>().inReleaseIOSFromApi ? 'Email' : 'authentication.phoneNumber'.tr(),
                  validateInput: (value) {
                    if (context.read<LoginCubit>().inReleaseIOSFromApi) {
                      return ''.validateEmail(value);
                    }
                    return ''.validatePhone(value);
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomTextField(
                  onFocusChange: (hasFocus) {
                    _handleFocusChange(hasFocus);
                  },
                  filled: true,
                  keyboardType: TextInputType.text,
                  onChanged: (password) {
                    context.read<LoginCubit>().onPasswordChanged(password);
                  },
                  hintText: 'authentication.password'.tr(),
                  isPassword: true,
                  validateInput: (value) {
                    return ''.validatePassword(value);
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          StreamBuilder<bool>(
            stream: context.read<LoginCubit>().isValidStream,
            initialData: false,
            builder: (context, snapshot) {
              return Center(
                child: MyButton(
                  width: Dimens.getProportionalScreenWidth(context, 295),
                  fontSize: 14.sp,
                  text: 'authentication.login'.tr(),
                  isEnable: snapshot.data!,
                  color: snapshot.data! ? MyColors.mainColor : MyColors.lightGrayColor.withOpacity(0.6),
                  height: 38.h,
                  onPressed: (value) {
                    if (snapshot.data!) {
                      context.read<LoginCubit>().callApiLogin(
                        onSuccess: () {
                          GoRouter.of(context).go(HomeScreen.route);
                        },
                        onError: (String message) {},
                        onMaintenance: (String message) {
                          MyPopupMessage.showPopUpWithIcon(
                            title: 'Thông báo',
                            context: context,
                            barrierDismissible: false,
                            description: message,
                            colorIcon: MyColors.redColor,
                            iconAssetPath: 'booking/booking_not_data.svg',
                            confirmText: 'bookingClass.goBack'.tr(),
                          );
                        },
                      );
                    }
                  },
                ),
              );
            },
          ),
          StreamBuilder<String>(
              stream: context.read<LoginCubit>().textErrorSubject,
              initialData: '',
              builder: (context, snapshot) {
                if (snapshot.data!.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: Text(
                        snapshot.data!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: MyColors.redColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
          Center(
            child: TextButton(
              onPressed: () {
                if (context.read<LoginCubit>().inReleaseIOSFromApi) {
                  context.push(AppleForgetPasswordScreen.route);
                  return;
                }
                context.push(ForgetPasswordScreen.route);
              },
              child: Text(
                '${'authentication.forgotPassword'.tr()}?',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          if (context.read<LoginCubit>().inReleaseIOSFromApi)
            Center(
              child: MyButton(
                width: Dimens.getProportionalScreenWidth(context, 295),
                fontSize: 14.sp,
                text: 'Tạo tài khoản',
                color: MyColors.mainColor,
                height: 38.h,
                onPressed: (value) async {
                  context.push(AppleRegisterAccountScreen.route);
                  if (kDebugMode) {
                    print('Register account');
                  }
                },
              ),
            ),
          SizedBox(height: 64.h),
          const TermsAndConditions(
            color: Colors.white,
          ),
          if (Platform.isIOS) SizedBox(height: 18.h),
        ],
      ),
    );
  }
}
