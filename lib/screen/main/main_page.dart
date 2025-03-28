import 'package:dayoneasia/screen/authen/update_password/update_password_screen.dart';
import 'package:dayoneasia/screen/blog/bloc_all/blog_all_screen.dart';
import 'package:dayoneasia/screen/blog/bloc_all/cubit/blog_all_cubit.dart';
import 'package:dayoneasia/screen/dashboard/booking_history/booking_history_screen.dart';
import 'package:dayoneasia/screen/dashboard/booking_history/cubit/booking_history_cubit.dart';
import 'package:dayoneasia/screen/dashboard/home/cubit/home/home_cubit.dart';
import 'package:dayoneasia/screen/dashboard/home/home_screen.dart';
import 'package:dayoneasia/screen/dashboard/profile/cubit/profile_cubit.dart';
import 'package:dayoneasia/screen/dashboard/profile/profile_screen.dart';
import 'package:dayoneasia/screen/profile/my_qr_code/my_qr_code_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/base/bloc/app_cubit.dart';
import 'package:myutils/base/bloc/app_state.dart';
import 'package:myutils/base/view/bottom_nav_bar_item.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';

import 'cubit/main_cubit.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static const String route = '/mainPage';

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  late MainCubit _mainCubit;
  final Key _historyKey = UniqueKey();
  final Map<int, DateTime> _lastTapMap = {};
  bool _isBottomNavVisible = true;
  final Duration _animDuration = const Duration(milliseconds: 300);
  bool _hasShownForceUpdatePopup = false;

  final Map<int, ScrollController> _scrollControllers = {
    0: ScrollController(), // Home
    1: ScrollController(), // Blog
    2: ScrollController(), // History
    3: ScrollController(), // Profile
  };

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _initializeMainCubit();
    _setupLocalStreams();
    _setupScrollControllers();
  }

  void _initializeMainCubit() {
    _mainCubit = MainCubit();
    _mainCubit.callApiGetProfileInformation(goToUpdatePassWord: () {
      context.push(UpdatePasswordScreen.route, extra: false).then((value) {
        if (value is bool && value) {
          _mainCubit.callApiGetProfileInformation(showLoading: false);
        }
      });
    });
  }

  void callApiGetProfileInformation() {
    _mainCubit.callApiGetProfileInformation(goToUpdatePassWord: () {
      context.push(UpdatePasswordScreen.route, extra: false).then((value) {
        if (value is bool && value) {
          _mainCubit.callApiGetProfileInformation(showLoading: false);
        }
      });
    });
  }

  void _setupScrollControllers() {
    _scrollControllers.forEach((index, controller) {
      controller.addListener(() {
        _handleScroll(controller);
      });
    });
  }

  void _handleScroll(ScrollController controller) {
    if (!mounted) return;

    final isScrollingDown =
        controller.position.userScrollDirection == ScrollDirection.reverse;
    final isScrollingUp =
        controller.position.userScrollDirection == ScrollDirection.forward;

    if (isScrollingDown && _isBottomNavVisible) {
      setState(() => _isBottomNavVisible = false);
    } else if (isScrollingUp && !_isBottomNavVisible) {
      setState(() => _isBottomNavVisible = true);
    }
  }

  void _setupLocalStreams() {
    LocalStream.shared.goToScreenHistory = () => onItemTapped(3);
    LocalStream.shared.refreshApiProfile =
        () => _mainCubit.callApiGetProfileInformation();
  }

  @override
  void dispose() {
    // for (var controller in _scrollControllers.values) {
    //   controller.removeListener(() => _handleScroll(controller));
    //   controller.dispose();
    // }
    super.dispose();
  }

  void onItemTapped(int index) {
    final targetIndex = index >= 2 ? index - 1 : index;

    if (targetIndex == _selectedIndex) {
      _scrollControllers[targetIndex]?.animateTo(
        0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
      return;
    }

    setState(() {
      _selectedIndex = targetIndex;
    });
  }

  void _handleDoubleTab(int index) {
    final adjustedIndex = index >= 2 ? index - 1 : index;
    _scrollControllers[adjustedIndex]?.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _mainCubit,
        ),
        BlocProvider(
          create: (context) => HomeCubit()..loadInitialData(),
        ),
        BlocProvider(
          create: (context) => BookingHistoryCubit(),
        ),
        BlocProvider(
          create: (context) => BlogAllCubit(),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(mainCubit: _mainCubit),
        ),
      ],
      child: BlocListener<AppCubit, AppState>(
        listener: (context, state) async {
          if (state.dataKeyPrivate == null) return;
          ToolHelper.forceUpdate(context: context, data: state.dataKeyPrivate!);
        },
        child: BlocBuilder<MainCubit, MainState>(
          builder: (context, state) {
            return Scaffold(
              body: IndexedStack(
                index: _selectedIndex,
                children: [
                  HomeScreen(homeScrollController: _scrollControllers[0]!),
                  BlogAllScreen(blogScrollController: _scrollControllers[1]!),
                  BookingHistoryScreen(
                      key: _historyKey,
                      historyScrollController: _scrollControllers[2]!),
                  ProfileScreen(
                      reloadLanguage: () => setState(() {}),
                      profileScrollController: _scrollControllers[3]!),
                ],
              ),
              // bottomNavigationBar: AnimatedContainer(
              //   duration: _animDuration,
              //   height: _isBottomNavVisible ? kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom : 0,
              //   child: AnimatedOpacity(
              //     duration: _animDuration,
              //     opacity: _isBottomNavVisible ? 1 : 0,
              //     child: _buildBottomNavigation(state),
              //   ),
              // ),

              bottomNavigationBar: _buildBottomNavigation(state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(MainState state) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 10.0,
          unselectedFontSize: 10.0,
          items: _buildNavItems(),
          currentIndex:
              _selectedIndex >= 2 ? _selectedIndex + 1 : _selectedIndex,
          onTap: onItemTapped,
        ),
        _buildQrButtonV2(state),
        // if (_isBottomNavVisible) _buildQrButton(state),
      ],
    );
  }

  List<BottomNavigationBarItem> _buildNavItems() {
    return [
      _buildNavItem("home", 0, 'global.home'.tr()),
      _buildNavItem("write", 1, 'Bài viết'),
      const BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
      _buildNavItem("clock", 2, 'Lịch sử'),
      _buildNavItem("user", 3, 'global.profile'.tr()),
    ];
  }

  BottomNavBarItem _buildNavItem(String iconBase, int index, String label) {
    final isActive = _selectedIndex == index;
    final iconName =
        "dashboard/$iconBase-${isActive ? 'active' : 'unactive'}.svg";
    if (kDebugMode) {
      print('iconName: $iconName');
    }
    return BottomNavBarItem(
      icon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: MyAppIcon.iconNamedCommon(
              iconName: iconName, width: 24.w, height: 24.w)),
      label: label,
      initialLocation: _getRouteForIndex(index),
    );
  }

  String _getRouteForIndex(int index) {
    switch (index) {
      case 0:
        return HomeScreen.route;
      case 1:
        return BlogAllScreen.route;
      case 2:
        return BookingHistoryScreen.route;
      case 3:
        return ProfileScreen.route;
      default:
        return '';
    }
  }

  Widget _buildQrButtonV2(MainState state) {
    return Positioned(
      left: MediaQuery.of(context).size.width * 0.5 - 28,
      bottom: MediaQuery.of(context).padding.bottom + 8.w,
      // bottom: MediaQuery.of(context).padding.bottom + 5.w,
      child: GestureDetector(
        onTap: () {
          if (state.userOutput?.data != null) {
            context.push(MyQrCodeScreen.route, extra: state.userOutput?.data);
          }
        },
        child: Container(
          width: 60.w,
          height: 60.w,
          padding: EdgeInsets.all(4.w),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Container(
            width: 58.w,
            height: 58.w,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [
                  Color(0xFFFFA63D),
                  Color(0xFFFF8B00),
                  Color(0xFFEE8100)
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(14.w),
              child: MyAppIcon.iconNamedCommon(
                  iconName: 'profile/bi_qr_code_scan.svg',
                  width: 24.w,
                  height: 24.w),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQrButton(MainState state) {
    return Positioned(
      left: MediaQuery.of(context).size.width * 0.5 - 28,
      // bottom: MediaQuery.of(context).padding.bottom + 8.w,
      bottom: MediaQuery.of(context).padding.bottom + 5.w,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (state.userOutput?.data != null) {
                context.push(MyQrCodeScreen.route,
                    extra: state.userOutput?.data);
              }
            },
            child: Container(
              width: 60.w,
              height: 60.w,
              padding: EdgeInsets.all(4.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Container(
                width: 58.w,
                height: 58.w,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.00, -1.00),
                    end: Alignment(0, 1),
                    colors: [
                      Color(0xFFFFA63D),
                      Color(0xFFFF8B00),
                      Color(0xFFEE8100)
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(14.w),
                  child: MyAppIcon.iconNamedCommon(
                      iconName: 'profile/bi_qr_code_scan.svg',
                      width: 24.w,
                      height: 24.w),
                ),
              ),
            ),
          ),
          Text('Quét mã QR',
              style: TextStyle(fontSize: 11.sp, color: MyColors.darkGrayColor)),
        ],
      ),
    );
  }
}
