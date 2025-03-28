import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dayoneasia/screen/authen/login/login_screen.dart';
import 'package:dayoneasia/screen/authen/update_password/update_password_screen.dart';
import 'package:dayoneasia/screen/dashboard/booking_history/cubit/booking_history_cubit.dart';
import 'package:dayoneasia/screen/dashboard/profile/widget/list_title_widget.dart';
import 'package:dayoneasia/screen/dashboard/profile/widget/section_widget.dart';
import 'package:dayoneasia/screen/main/cubit/main_cubit.dart';
import 'package:dayoneasia/screen/main/main_page.dart';
import 'package:dayoneasia/screen/profile/app_info/app_info_screen.dart';
import 'package:dayoneasia/screen/profile/booking_statistics/booking_statistics_screen.dart';
import 'package:dayoneasia/screen/profile/electronic_contract/electronic_contract_screen.dart';
import 'package:dayoneasia/screen/profile/info_contract/info_contract_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:myutils/utils/widgets/my_button.dart';

import 'cubit/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? reloadLanguage;

  static const String route = '/profile';
  final ScrollController profileScrollController;

  const ProfileScreen({super.key, this.reloadLanguage, required this.profileScrollController});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('ProfileScreen build');
    return _Body(
      reloadLanguage: () {
        setState(() {
          widget.reloadLanguage?.call();
          print('reloadLanguage');
        });
      },
      profileScrollController: widget.profileScrollController,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _Body extends BaseStatelessScreenV2 {
  final VoidCallback reloadLanguage;
  final ScrollController profileScrollController;

  const _Body({
    super.key,
    required this.reloadLanguage,
    required this.profileScrollController,
  });

  @override
  // TODO: implement title
  String? get title => 'profile.account'.tr();

  @override
  // TODO: implement backgroundColor
  Color? get backgroundColor => MyColors.backgroundColor;

  @override
  bool get automaticallyImplyLeading => false;

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: CustomRefreshIndicator(
                trailingScrollIndicatorVisible: false,
                builder: MaterialIndicatorDelegate(
                  builder: (context, controller) {
                    return Icon(
                      Icons.refresh,
                      color: MyColors.mainColor,
                      size: 30,
                    );
                  },
                ).call,
                onRefresh: () {
                  pageContext.read<MainCubit>().callApiGetProfileInformation(showLoading: false);
                  return Future.delayed(const Duration(milliseconds: 1300));
                },
                child: ListView(
                  controller: profileScrollController,
                  children: [
                    SectionWidget(
                      title: 'profile.bookingList'.tr(),
                      children: [
                        ListTitleWidget(
                          title: 'profile.groupClassBookingStatistics'.tr(),
                          icon: 'profile/class.svg',
                          showArrow: true,
                          onTap: () {
                            context.push(BookingStatisticsScreen.route, extra: ClassType.CLASS);

                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Text('home.featureInDevelopment'.tr()),
                            //     duration: const Duration(seconds: 3),
                            //   ),
                            // );
                          },
                        ),
                        ListTitleWidget(
                          title: 'profile.groupPracticeBookingStatistics'.tr(),
                          icon: 'profile/practice.svg',
                          showArrow: true,
                          onTap: () {
                            context.push(BookingStatisticsScreen.route, extra: ClassType.CLASS_PRACTICE);

                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Text('home.featureInDevelopment'.tr()),
                            //     duration: const Duration(seconds: 3),
                            //   ),
                            // );
                          },
                        ),
                        ListTitleWidget(
                          title: 'global.history'.tr(),
                          icon: 'profile/clock.svg',
                          showArrow: true,
                          onTap: () {
                            final mainPageState = (pageContext.findAncestorStateOfType<MainPageState>() as MainPageState);
                            mainPageState.onItemTapped(3);
                          },
                        ),
                      ],
                    ),
                    SectionWidget(
                      title: 'profile.customize'.tr(),
                      children: [
                        ListTitleWidget(
                          title: 'profile.infoAccount'.tr(),
                          icon: 'profile/lock_close.svg',
                          showArrow: true,
                          onTap: () {
                            pageContext.push(InformationContractScreen.route).then((value) {
                              if (value != null && value is bool && value) {
                                pageContext.read<MainCubit>().callApiGetProfileInformation();
                              }
                            });
                          },
                        ),
                        if (!context.read<ProfileCubit>().inDev)   ListTitleWidget(
                          title: 'profile.contractInfo'.tr(),
                          icon: 'profile/clipboard.svg',
                          showArrow: true,
                          onTap: () {
                            pageContext.push(ElectronicContractScreen.route);
                          },
                        ),
                        ListTitleWidget(
                          title: 'Blog',
                          icon: 'profile/write.svg',
                          showArrow: true,
                          onTap: () {
                            final mainPageState = (pageContext.findAncestorStateOfType<MainPageState>() as MainPageState);
                            mainPageState.onItemTapped(1);
                          },
                        ),

                        ListTitleWidget(
                          title: 'authentication.changePassword'.tr(),
                          icon: 'profile/lock_close.svg',
                          showArrow: true,
                          onTap: () {
                            // final dataUserInfo = pageContext.read<MainCubit>().state.userOutput?.data;
                            // context.push(LoginInfoScreen.route, extra: dataUserInfo);

                            context.push(UpdatePasswordScreen.route, extra: true);
                          },
                        ),
                        // ListTitleWidget(
                        //   title: 'profile.centerReview'.tr(),
                        //   icon: 'profile/write.svg',
                        //   showArrow: true,
                        //   onTap: () {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(
                        //         content: Text('home.featureInDevelopment'.tr()),
                        //         duration: const Duration(seconds: 3),
                        //       ),
                        //     );
                        //   },
                        // ),

                        // ListTitleWidget(
                        //   title: 'profile.changeLanguage'.tr(),
                        //   icon: 'profile/language.svg',
                        //   showArrow: true,
                        //   onTap: () {
                        //     showSelectLanguage(
                        //         pageContext: context,
                        //         reloadLanguage: () {
                        //           LocalStream.shared.refreshDataInHome();
                        //           LocalStream.shared.refreshBannerInHome();
                        //           reloadLanguage();
                        //         });
                        //   },
                        // ),
                      ],
                    ),
                    SectionWidget(
                      title: 'profile.information'.tr(),
                      children: [
                        ListTitleWidget(
                          title: 'profile.appInfo'.tr(),
                          icon: 'profile/info.svg',
                          showArrow: true,
                          onTap: () {
                            context.push(AppInfoScreen.route);
                          },
                        ),
                        ListTitleWidget(
                          title: 'Email: ',
                          icon: 'profile/mail.svg',
                          showArrow: false,
                          underlineText: context.read<ProfileCubit>().companyEmail ?? '',
                          underline: true,
                          onTap: () {
                            ToolHelper.launchEmail(context.read<ProfileCubit>().companyEmail ?? '');
                          },
                        ),
                        ListTitleWidget(
                          title: 'Hotline: ',
                          icon: 'profile/tel.svg',
                          showArrow: false,
                          underlineText: context.read<ProfileCubit>().hotline ?? '',
                          underline: true,
                          onTap: () {
                            ToolHelper.launchPhone(context.read<ProfileCubit>().hotline ?? '');
                          },
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: TextButton(
                          onPressed: () {
                            MyPopupMessage.confirmPopUp(
                              cancelText: 'profile.cancel'.tr(),
                              confirmText: 'profile.logout'.tr(),
                              title: 'profile.logout'.tr(),
                              context: context,
                              barrierDismissible: false,
                              description: 'profile.confirmLogoutMessage'.tr(),
                              onConfirm: () {
                                context.pushReplacement(LoginScreen.route);
                                context.read<ProfileCubit>().callApiLogout(
                                    onSuccess: () {},
                                    onError: (String message) {
                                      // MyPopupMessage(context).showError(
                                      //   title: 'profile.notification'.tr(),
                                      //   error: message,
                                      //   // hideCancelBtn: true,
                                      // );
                                    });
                              },
                            );
                          },
                          child: Text(
                            'profile.logout'.tr(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: MyColors.redLogoutColor,
                              decorationColor: MyColors.redColor,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (context.read<ProfileCubit>().inReleaseIOSFromApi)
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: MyButton(
                          borderRadius: 8,
                          width: double.infinity,
                          fontSize: 14,
                          text: 'Xoá tài khoản',
                          color: MyColors.mainColor.withOpacity(0.5),
                          height: 38.h,
                          onPressed: (value) {
                            MyPopupMessage.confirmPopUp(
                                cancelText: 'bookingClass.goBack'.tr(),
                                cancelColor: MyColors.lightGrayColor2,
                                confirmColor: MyColors.emeraldGreenColor,
                                width: Dimens.getScreenWidth(context),
                                fontWeight: FontWeight.w500,
                                confirmText: 'bookingClass.confirm'.tr(),
                                title: 'Xoá tài khoản',
                                context: context,
                                barrierDismissible: false,
                                description: 'Bạn có chắc muốn xóa tài khoản không?',
                                onConfirm: () {
                                  context.read<ProfileCubit>().deleteAccount(onError: (String message) {
                                    MyPopupMessage(context).showError(
                                      title: 'profile.notification'.tr(),
                                      error: message,
                                      // hideCancelBtn: true,
                                    );
                                  }, onSuccess: () {
                                    context.pushReplacement(LoginScreen.route);
                                    // context.pushReplacement(WelcomeScreen.route);
                                  });
                                });
                          },
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListTile(
      {required BuildContext context,
      required String title,
      required String icon,
      bool showArrow = true,
      bool underline = false,
      Function()? onTap,
      String? underlineText}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            MyAppIcon.iconNamedCommon(iconName: icon, width: 24, height: 24),
            const SizedBox(width: 6),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14),
                children: [
                  TextSpan(
                      text: title,
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.w400,
                      )),
                  if (underlineText != null)
                    TextSpan(
                      text: underlineText,
                      style: const TextStyle(decoration: TextDecoration.underline),
                    ),
                ],
              ),
            ),
            const Spacer(),
            if (showArrow)
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
                size: 14,
              )
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: List.generate(children.length, (index) {
              final isLastItem = index == children.length - 1;
              return Column(
                children: [
                  children[index],
                  if (!isLastItem && children.length > 1) const Divider(),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class InfoProfile extends StatelessWidget {
  const InfoProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.orange,
          padding: const EdgeInsets.all(16),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/profile_image.jpg'),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phan Thi Ngoc Lan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Xem thông tin cá nhân',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: const [
              ListTile(
                leading: Icon(Icons.support),
                title: Text('Hỗ trợ'),
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Thông báo'),
              ),
              ListTile(
                leading: Icon(Icons.description),
                title: Text('Hợp đồng'),
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Lịch sử đăng kí'),
              ),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Lịch sử buổi học'),
              ),
              ListTile(
                leading: Icon(Icons.star),
                title: Text('Khen thưởng'),
              ),
              ListTile(
                leading: Icon(Icons.apps),
                title: Text('Ứng dụng của nhà phát triển'),
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Thông tin đăng nhập'),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Đăng xuất'),
                textColor: Colors.orange,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
