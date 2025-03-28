import 'package:dayoneasia/screen/authen/update_password/update_password_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/data/network/model/output/user_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';

import 'cutbit/login_info_cubit.dart';

class LoginInfoScreen extends BaseStatelessScreenV2 {
  final DataUserInfo? dataUserInfo;
  static const String route = '/login_info';

  const LoginInfoScreen({
    super.key,
    this.dataUserInfo,
  });

  @override
  // TODO: implement title
  String? get title => 'authentication.changePassword'.tr();

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocProvider(
      create: (context) => LoginInfoCubit()..emitUsernameAndPhoneNumber(dataUserInfo?.name ?? '', dataUserInfo?.phone ?? ''),
      child: BlocBuilder<LoginInfoCubit, LoginInfoState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(16.0.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),
                  Text(
                    'profile.nameAccount'.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextWidget(
                    value: state.username ?? '',
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'profile.phoneNumber'.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextWidget(
                    value: state.phoneNumber ?? '',
                  ),
                  SizedBox(height: 16.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.push(UpdatePasswordScreen.route, extra: true);
                      },
                      child: Text(
                        'authentication.changePassword'.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: MyColors.grayColor,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  final String value;

  const TextWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0xFFB6B6B6),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: MyColors.darkGrayColor,
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
