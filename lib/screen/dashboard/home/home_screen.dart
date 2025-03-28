import 'dart:async';

import 'package:dayoneasia/screen/dashboard/home/cubit/home/home_state.dart';
import 'package:dayoneasia/screen/dashboard/home/widget/bell/notification_bell_widget.dart';
import 'package:dayoneasia/screen/dashboard/home/widget/blog_list_widget.dart';
import 'package:dayoneasia/screen/dashboard/home/widget/menu_booking_widget.dart';
import 'package:dayoneasia/screen/dashboard/home/widget/remind_booking_widget.dart';
import 'package:dayoneasia/screen/dashboard/home/widget/section_title_widget.dart';
import 'package:dayoneasia/screen/dashboard/profile/widget/avatar_widget.dart';
import 'package:dayoneasia/screen/main/cubit/main_cubit.dart';
import 'package:dayoneasia/screen/main/main_page.dart';
import 'package:dayoneasia/screen/notification/notification_screen.dart';
import 'package:dayoneasia/screen/profile/my_qr_code/my_qr_code_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/config/app_config.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/data/network/model/output/news_categories_output.dart';
import 'package:myutils/data/network/model/output/news_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/helpers/extension/image_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/tab/my_tab_bar.dart';
import 'package:shimmer/shimmer.dart';

import 'cubit/home/home_cubit.dart';

class HomeScreen extends StatefulWidget {
  static const String route = '/home';
  final ScrollController homeScrollController;

  const HomeScreen({super.key, required this.homeScrollController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.homeScrollController;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFF8B01),
              const Color(0xFFFFBC6C),
              const Color(0x66FFE0BB),
              Colors.white.withValues(alpha: 0)
            ],
            stops: const [0.0, 0.1, 0.2, 0.992],
          ),
        ),
        child: SafeArea(child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: RefreshIndicator(
                color: MyColors.mainColor,
                onRefresh: () => _handleRefresh(context),
                child: _buildContent(),
              ),
            );
          },
        )),
      ),
    );
  }

  Future<void> _handleRefresh(BuildContext context) async {
    context.read<MainCubit>().callApiGetProfileInformation(showLoading: false);
    context.read<HomeCubit>().refreshData();
    await Future.delayed(const Duration(milliseconds: 1300));
  }

  Widget _buildContent() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          child: Column(
            children: [
              _buildHeaderSection(context, state),
              SizedBox(height: 27.h),
              BuildSectionTitle(text: 'home.bookingOption'.tr()),
              SizedBox(height: 16.h),
              _buildBookingSection(context, state),
              SizedBox(height: 30.h),
              ..._buildRemindersSection(state),
              ..._buildBlogSection(state),
              SizedBox(height: 30.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection(BuildContext context, HomeState state) {
    return _buildTopV2();
  }

  Widget _buildBookingSection(BuildContext context, HomeState state) {
    return const MenuBookingWidget();
  }

  List<Widget> _buildRemindersSection(HomeState state) {
    return <Widget>[
      BuildSectionTitle(text: 'home.upcomingReminder'.tr()),
      SizedBox(height: 16.h),
      const RemindBookingWidget(),
    ];
  }

  bool _shouldShowNewsSection(HomeState state) {
    return state.newsCategoriesOutput?.data?.isNotEmpty == true;
  }

  List<Widget> _buildBlogSection(HomeState state) {
    return <Widget>[
      SizedBox(height: 30.h),
      BuildSectionTitle(
        text: 'Bài viết'.tr(),
        // showMoreWidget: _buildShowMoreWidget(),
      ),
      _buildTabbedPage(),
      SizedBox(height: 10.h),
      _buildListBlog(state.newsOutput?.data ?? []),
    ];
  }

  Widget _buildTopV2() {
    return BlocBuilder<MainCubit, MainState>(
      // onTap: _navigateToProfile,
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: InkWell(
            onTap: _navigateToProfile,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
              ),
              child: _buildUserGreeting(state),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopV1() {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return InkWell(
          onTap: _navigateToProfile,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                begin: Alignment(1, -0.03),
                end: Alignment(-1.00, 0.03),
                colors: [
                  Color(0xFFFFA63D),
                  Color(0xFFFF8B00),
                  Color(0xFFEE8100)
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AvatarWidget(
                  urlAvt: state.userOutput?.data?.avatar ?? '',
                  size: 50.sp,
                ),
                SizedBox(width: 13.w),
                Expanded(child: _buildUserGreeting(state)),
                // _buildQRCodeButton(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserGreeting(MainState state) {
    final env = injector<AppConfig>().flavor;
    final isProd = env == Flavor.prod;
    return Row(
      children: [
        AvatarWidget(
          urlAvt: state.userOutput?.data?.avatar ?? '',
          size: 40.w,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'home.hello'.tr(),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                state.userOutput?.data?.name ?? 'Loading...',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                state.userOutput?.data?.studentStatusName ?? 'Loading...',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: statusNameColor(state.userOutput?.data?.studentStatus ?? 0),
                ),
              ),
              if (!isProd)
                Text(
                  ' (${env?.name ?? ''})',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          )
        ),
        InkWell(
            onTap: () {
              context.read<HomeCubit>().goMessenger();
            },
            child: MyAppIcon.iconNamedCommon(iconName: 'profile/chat.svg')),
        IconButton(
          onPressed: () {
            context.push(NotificationScreen.route);
          },
          icon: NotificationBell(
            count: state.userOutput?.data?.unreadNotificationCount ?? 0,
          ),
        )
      ],
    );
  }

  Color statusNameColor(int status) {
    final statusColors = {
      0: MyColors.mainColor,
      2: Colors.green,
      3: Colors.red,
      4: MyColors.mainColor,
    };
    return statusColors[status] ??  MyColors.mainColor;
  }

  Widget _buildQRCodeButton(MainState state) {
    return InkWell(
      onTap: () => _navigateToQRCode(state),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.w),
        decoration: ShapeDecoration(
          color: Colors.black.withOpacity(0.10000000149011612),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7500),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyAppIcon.iconNamedCommon(
                iconName: 'profile/bi_qr_code_scan.svg',
                width: 24.w,
                height: 24.w),
            Text(
              'QR',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabbedPage() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final list = state.newsCategoriesOutput?.data ?? [];
        if (kDebugMode) {
          print('state.currentTabIndex  ${state.currentTabIndex}');
        }
        return list.isEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(3, (index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    );
                  }),
                ),
              )
            : MyTabbedPage2<DataNewsCategory>(
                currentIndex: state.currentTabIndex ?? 0,
                useCustomTabStyle: true,
                items: list,
                titleBuilder: (item) => item.name ?? '',
                onTap: (index) {
                  context.read<HomeCubit>().filterBlogs(index);
                },
              );
      },
    );
  }

  Widget _buildListBlog(List<DataBlog> list) {
    return const BlogListWidget();
  }

  void _navigateToProfile() {
    final mainPageState =
        (context.findAncestorStateOfType<MainPageState>() as MainPageState);
    mainPageState.onItemTapped(4);
  }

  Future<void> _navigateToQRCode(MainState state) async {
    final imageOK = await ToolHelper.checkImageWithoutHttp(
        state.userOutput?.data?.qrcodePath ?? '');
    if (imageOK) {
      context.push(MyQrCodeScreen.route, extra: state.userOutput?.data);
    } else {
      MyPopupMessage.showPopUpWithIcon(
        title: 'Thông báo',
        context: context,
        barrierDismissible: false,
        description: 'Mã QR không hợp lệ',
        colorIcon: MyColors.redColor,
        iconAssetPath: 'booking/booking_not_data.svg',
        confirmText: 'bookingClass.goBack'.tr(),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class ItemBlogWidget extends StatelessWidget {
  final DataBlog data;

  const ItemBlogWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: MyImage.cachedImgFromUrl(
                  hasPlaceholder: false,
                  url: data.avatar ?? '',
                  width: double.infinity,
                  height: Dimens.getScreenHeight(context) * 0.2618,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    // top: BorderSide(
                    //   color: Color(0xFFE5E5E5),
                    //   width: 1,
                    // ),
                    right: BorderSide(
                      color: Color(0xFFE5E5E5),
                      width: 1,
                    ),
                    left: BorderSide(
                      color: Color(0xFFE5E5E5),
                      width: 1,
                    ),
                    bottom: BorderSide(
                      color: Color(0xFFE5E5E5),
                      width: 1,
                    ),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name ?? '',
                      style: TextStyle(
                        color: const Color(0xFF3B3B3B),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.description ?? '',
                      style: TextStyle(
                        color: const Color(0xFF6A6A6A),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 10.w,
            top: 9.w,
            child: Container(
              width: 26.w,
              height: 26.w,
              decoration: ShapeDecoration(
                color: Colors.black.withOpacity(0.2),
                shape: const CircleBorder(),
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
