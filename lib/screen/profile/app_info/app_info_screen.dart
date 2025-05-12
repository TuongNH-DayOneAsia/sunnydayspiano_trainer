import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:myutils/utils/popup/my_present_view_helper.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:myutils/utils/widgets/my_web_view.dart';

class AppInfoScreen extends BaseStatelessScreenV2 {
  static const String route = '/app_info_screen';

  const AppInfoScreen({super.key});

  @override
  // TODO: implement backgroundColor
  Color? get backgroundColor => MyColors.backgroundColor;

  @override
  String get title => 'profile.appInfo'.tr();

  @override
  Widget buildBody(BuildContext pageContext) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: const AppInfo(),
    );
  }
}

class AppInfo extends StatelessWidget {
  const AppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100.h,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Stack(
            children: [
              // Positioned content on the left
              Positioned(
                left: 16,
                top: 29,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App title
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Sunny Days ',
                            style: GoogleFonts.unbounded(
                              fontSize: 18.sp,
                              color: MyColors.mainColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: 'Piano',
                            style: GoogleFonts.unbounded(
                              fontSize: 18.sp,
                              color: MyColors.grayColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // FutureBuilder for app version
                    FutureBuilder<String>(
                      future: ToolHelper.getBuildNumber(),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Show a loading spinner while waiting
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error loading version',
                            style: TextStyle(
                              color: MyColors.lightGrayColor2,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        } else {
                          return Text(
                            '${'profile.version'.tr()} ${snapshot.data}', // Show the version when data is available
                            style: TextStyle(
                              color: MyColors.lightGrayColor2,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Positioned Flutter logo with opacity
              Positioned(
                right: -0.5,
                child: MyAppIcon.iconNamedCommon(iconName: 'profile/sunnydays.svg', width: 100.w, height: 100.w),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 18.h,
        ),
        const AppInfoOptionsWidget(),
      ],
    );
  }
}

class AppInfoOptionsWidget extends StatelessWidget {
  const AppInfoOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  MyPresentViewHelper.presentView(
                    context: context,
                    title: 'profile.termsAndConditions'.tr(),
                    contentPadding: EdgeInsets.zero,
                    enableDrag: false,
                    hasInsetBottom: false,
                    builder: Builder(
                      builder: (contextBuilder) {
                        return FutureBuilder(
                          future: Future.delayed(Duration.zero),
                          builder: (contextFuture, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return MyWebViewWidget(
                                // url: context.read<ProfileCubit>().urlPolicy,
                                url: 'https://sunnydays.vn/privacy-policy',
                              );
                            } else {
                              return const Center(child: CircularProgressIndicator());
                            }
                          },
                        );
                      },
                    ),
                  );
                },
                child: _buildItem(
                  title: 'authentication.privacyPolicy'.tr(),
                ),
              ),
              const Divider(
                height: 1,
                color: Color(0xFFE1E1E1),
              ),
              InkWell(
                onTap: () {
                  ToolHelper.openAppStore();
                },
                child: _buildItem(
                  title: 'profile.feedBackApp'.tr(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItem({required String title}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: MyColors.darkGrayColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.grey,
            size: 14,
          )
        ],
      ),
    );
  }
}
