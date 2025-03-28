import 'package:dayoneasia/screen/authen/apple_testing/forget_password/apple_forget_password_screen.dart';
import 'package:dayoneasia/screen/authen/apple_testing/otp/apple_otp_screen.dart';
import 'package:dayoneasia/screen/authen/apple_testing/register/apple_register_account_screen.dart';
import 'package:dayoneasia/screen/authen/forget_password/forget_password_screen.dart';
import 'package:dayoneasia/screen/authen/login/login_screen.dart';
import 'package:dayoneasia/screen/authen/otp/otp_screen.dart';
import 'package:dayoneasia/screen/authen/reset_password/reset_password_screen.dart';
import 'package:dayoneasia/screen/authen/update_password/update_password_screen.dart';
import 'package:dayoneasia/screen/authen/welcome/welcome_screen.dart';
import 'package:dayoneasia/screen/blog/bloc_all/blog_all_screen.dart';
import 'package:dayoneasia/screen/blog/blog_detail/blog_detail_screen.dart';
import 'package:dayoneasia/screen/blog/blog_detail/cubit/blog_detail_cubit.dart';
import 'package:dayoneasia/screen/booking/booking_class/booking_class_cancel/booking_history_cancel_screen.dart';
import 'package:dayoneasia/screen/booking/booking_class/booking_class_detail/booking_class_detail_screen.dart';
import 'package:dayoneasia/screen/booking/booking_class/class_detail/booking_class_detail_screen.dart';
import 'package:dayoneasia/screen/booking/booking_class/class_detail/cubit/booking_class_detail_cubit.dart';
import 'package:dayoneasia/screen/booking/booking_class/class_list/booking_class_list_screen.dart';
import 'package:dayoneasia/screen/booking/booking_practice/practice_detail/booking_practice_detail_screen.dart';
import 'package:dayoneasia/screen/booking/booking_practice/practice_list/booking_practice_list_screen.dart';
import 'package:dayoneasia/screen/booking/booking_select_piano/booking_select_piano_screen.dart';
import 'package:dayoneasia/screen/booking/branch_list_screen/branch_list_screen.dart';
import 'package:dayoneasia/screen/dashboard/booking_history/booking_history_screen.dart';
import 'package:dayoneasia/screen/dashboard/booking_history/cubit/booking_history_cubit.dart';
import 'package:dayoneasia/screen/dashboard/home/contracts/contracts_screen.dart';
import 'package:dayoneasia/screen/dashboard/home/home_screen.dart';
import 'package:dayoneasia/screen/dashboard/profile/profile_screen.dart';
import 'package:dayoneasia/screen/feedback/feedback_from_center/feedback_from_center_screen.dart';
import 'package:dayoneasia/screen/feedback/user_feedback/user_feedback_screen.dart';
import 'package:dayoneasia/screen/main/main_page.dart';
import 'package:dayoneasia/screen/notification/notification_screen.dart';
import 'package:dayoneasia/screen/profile/app_info/app_info_screen.dart';
import 'package:dayoneasia/screen/profile/booking_statistics/booking_statistics_screen.dart';
import 'package:dayoneasia/screen/profile/electronic_contract/electronic_contract_screen.dart';
import 'package:dayoneasia/screen/profile/history/booking_statistics_history_screen.dart';
import 'package:dayoneasia/screen/profile/info_contract/info_contract_screen.dart';
import 'package:dayoneasia/screen/profile/login_info/login_info_screen.dart';
import 'package:dayoneasia/screen/profile/my_qr_code/my_qr_code_screen.dart';
import 'package:dayoneasia/screen/profile/pdf/pdf_viewer_screen.dart';
import 'package:dayoneasia/screen/profile/update_information/update_information_screen.dart';
import 'package:dayoneasia/screen/splash/splash_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/base/router/app_router.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/data/cache_helper/cache_helper.dart';
import 'package:myutils/data/network/model/input/apple_register_account_input.dart';
import 'package:myutils/data/network/model/input/forget_password_input.dart';
import 'package:myutils/data/network/model/output/booking_11/booking_11_detail_output.dart';
import 'package:myutils/data/network/model/output/booking_11/coaches_output.dart';
import 'package:myutils/data/network/model/output/booking_11/contracts_output.dart';
import 'package:myutils/data/network/model/output/contract_output.dart';
import 'package:myutils/data/network/model/output/list_class_output.dart';
import 'package:myutils/data/network/model/output/user_output.dart';

import '../screen/authen/apple_testing/confirm/apple_confirm_password_screen.dart';
import '../screen/booking/booking_11/booking/booking_11_screen.dart';
import '../screen/booking/booking_11/coach_list/coach_list_screen.dart';
import '../screen/booking/booking_11/detail/booking_11_detail_screen.dart';
import 'package:myutils/data/network/model/output/contracts/booking_class_type_v5_output.dart'
    as DataContractV5;

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
LocaleManager localeManager = injector();
final accessToken = localeManager.getString(StorageKeys.accessToken);

BuildContext? get rootContext => _rootNavigatorKey.currentState?.context;
final List<RouteBase> childRouters = [
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: SplashScreen.route,
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: WelcomeScreen.route,
    builder: (context, state) => const WelcomeScreen(),
  ),
];
final myBaseRouters = [
  ...authenticationRouters,
  ...childRouters,
  ...profileInfoRouters,
  ...homeShellRouter,
  ...bookingWithRootKeyRouters,
];

String currentRoute() {
  return myRouter.routerDelegate.currentConfiguration.last.matchedLocation;
}

final myRouter = AppRouter(
  initialLocation: accessToken == null ? LoginScreen.route : HomeScreen.route,
  routers: myBaseRouters,
  rootNavigatorKey: _rootNavigatorKey,
).generateRouter();
final List<RouteBase> authenticationRouters = [
  GoRoute(
    path: LoginScreen.route,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) {
      return const LoginScreen();
    },
  ),
  GoRoute(
    path: OtpScreen.route,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) {
      ForgetPasswordInput forgetPasswordInput =
          state.extra as ForgetPasswordInput;
      return OtpScreen(forgetPasswordInput: forgetPasswordInput);
    },
  ),
  GoRoute(
    path: ForgetPasswordScreen.route,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) {
      return const ForgetPasswordScreen();
    },
  ),
  GoRoute(
    path: ResetPasswordScreen.route,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) {
      ForgetPasswordInput forgetPasswordInput =
          state.extra as ForgetPasswordInput; // -> casting is important
      return ResetPasswordScreen(
        forgetPasswordInput: forgetPasswordInput,
      );
    },
  ),
  GoRoute(
    path: UpdatePasswordScreen.route,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) {
      final bool isCanPop = state.extra as bool;
      return UpdatePasswordScreen(
        isCanPop: isCanPop,
      );
    },
  ),
  GoRoute(
    path: AppleRegisterAccountScreen.route,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) {
      return const AppleRegisterAccountScreen();
    },
  ),
  GoRoute(
    path: AppleOtpScreen.route,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) {
      final data = state.extra as AppleRegisterAccountInput;
      return AppleOtpScreen(
        appleRegisterAccountInput: data,
      );
    },
  ),
  GoRoute(
    path: AppleConfirmPasswordScreen.route,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) {
      final data = state.extra as AppleRegisterAccountInput;
      return AppleConfirmPasswordScreen(
        appleRegisterAccountInput: data,
      );
    },
  ),
  GoRoute(
    path: AppleForgetPasswordScreen.route,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) {
      return const AppleForgetPasswordScreen();
    },
  ),
];
final List<RouteBase> profileInfoRouters = [
  GoRoute(
    path: InformationContractScreen.route,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) {
      return InformationContractScreen();
    },
  ),
  GoRoute(
    path: MyQrCodeScreen.route,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) {
      DataUserInfo data = state.extra as DataUserInfo;
      return MyQrCodeScreen(dataUserInfo: data);
    },
  ),
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: AppInfoScreen.route,
    builder: (context, state) {
      return const AppInfoScreen();
    },
  ),
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: BookingStatisticsScreen.route,
    builder: (context, state) {
      final ClassType classType = state.extra as ClassType;
      return BookingStatisticsScreen(
        classType: classType,
      );
    },
  ),
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: BookingStatisticsHistoryScreen.route,
    builder: (context, state) {
      return const BookingStatisticsHistoryScreen();
    },
  ),
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: LoginInfoScreen.route,
    builder: (context, state) {
      final DataUserInfo data = state.extra as DataUserInfo;
      return LoginInfoScreen(dataUserInfo: data);
    },
  ),
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: ElectronicContractScreen.route,
    builder: (context, state) {
      return const ElectronicContractScreen();
    },
  ),
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: PdfViewerScreen.route,
    builder: (context, state) {
      final DataPdf data = state.extra as DataPdf;
      return PdfViewerScreen(
        data: data,
      );
    },
  ),
  GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: UpdateInformationScreen.route,
    builder: (context, state) {
      final DataUserInfo dataUserInfo = state.extra as DataUserInfo;
      return UpdateInformationScreen(
        dataUserInfo: dataUserInfo,
      );
    },
  ),
];

final bookingWithRootKeyRouters = DayoneBookingRouter.bookingBaseRouters(
  rootKey: _rootNavigatorKey,
  shellKey: _shellNavigatorKey,
);
final List<RouteBase> homeShellRouter = [
  ShellRoute(
    navigatorKey: _shellNavigatorKey,
    builder: (context, state, child) => const MainPage(),
    routes: [
      GoRoute(
        path: HomeScreen.route,
        name: "home",
        parentNavigatorKey: _shellNavigatorKey,
        pageBuilder: (context, state) {
          final ScrollController scrollController = ScrollController();
          return NoTransitionPage(
            key: state.pageKey,
            child: HomeScreen(
              key: state.pageKey,
              homeScrollController: scrollController,
            ),
          );
        },
      ),
      GoRoute(
        path: BookingHistoryScreen.route,
        parentNavigatorKey: _shellNavigatorKey,
        pageBuilder: (context, state) => NoTransitionPage(
            child: BookingHistoryScreen(
          key: state.pageKey,
        )),
      ),
      GoRoute(
        path: BlogAllScreen.route,
        parentNavigatorKey: _shellNavigatorKey,
        pageBuilder: (context, state) {
          final ScrollController scrollController = ScrollController();
          return NoTransitionPage(
            key: state.pageKey,
            child: BlogAllScreen(
              blogScrollController: scrollController,
            ),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _shellNavigatorKey,
        path: ProfileScreen.route,
        pageBuilder: (context, state) {
          final ScrollController scrollController = ScrollController();
          return NoTransitionPage(
              key: state.pageKey,
              child: ProfileScreen(
                profileScrollController: scrollController,
              ));
        },
      ),
    ],
  ),
];

extension DayoneBookingRouter on AppRouter {
  static List<RouteBase> bookingBaseRouters(
      {GlobalKey<NavigatorState>? rootKey,
      GlobalKey<NavigatorState>? shellKey}) {
    List<RouteBase> bookingRouters = [
      GoRoute(
        parentNavigatorKey: rootKey,
        path: BookingPracticeDetailScreen.route,
        name: 'practice-detail', //Used for pushNamed and pass params
        builder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;
          String? bookingCode = extra['bookingCode'] as String?;
          RefreshAction? refreshAction =
              extra['refreshAction'] as RefreshAction?;
          return BookingPracticeDetailScreen(
            key: state.pageKey,
            bookingCode: bookingCode,
            refreshAction: refreshAction ?? RefreshAction.refreshPracticeList,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: BookingClassListScreen.route,
        name: 'class-list', //Used for pushNamed and pass params
        builder: (context, state) {
          final data = state.extra as DataContractV5.Items?;
          return BookingClassListScreen(data: data);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: BookingPracticeListScreen.route,
        name: BookingPracticeListScreen
            .route, //Used for pushNamed and pass params
        builder: (context, state) {
          final keyType = state.extra as String?;
          return BookingPracticeListScreen(keyType: keyType);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: ContractsScreen.route,
        name: ContractsScreen.route, //Used for pushNamed and pass params
        builder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;

          String? title = extra['title'] as String?;
          DataContractV5.Data data = extra['data'] as DataContractV5.Data;
          String? messageEmpty = extra['message_empty'] as String?;

          return ContractsScreen(
            titleAppbar: title,
            data: data,
            messageEmpty: messageEmpty,
          );
        },
      ),

      GoRoute(
        parentNavigatorKey: rootKey,
        path: Booking11Screen.route,
        name: Booking11Screen.route, //Used for pushNamed and pass params
        builder: (context, state) {
          final data = state.extra as DataContractV5.Items;
          return Booking11Screen(data: data);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: Booking11DetailScreen.route,
        name: Booking11DetailScreen.route, //Used for pushNamed and pass params
        builder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;

          Booking11DetailScreenMode? mode =
              extra['mode'] as Booking11DetailScreenMode?;
          DataBooking11Detail? booking11Input =
              extra['data'] as DataBooking11Detail?;
          String? bookingCode = extra['bookingCode'] as String?;
          RefreshAction refreshAction = extra['refreshAction'] as RefreshAction;
          return Booking11DetailScreen(
              mode: mode ?? Booking11DetailScreenMode.detail,
              data: booking11Input,
              bookingCode: bookingCode,
              refreshAction: refreshAction);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: BookingClassDetailsScreen.route,
        name: 'booking-details',
        builder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;
          String? classLessonCode = extra['class_lesson_code'] as String?;
          String? contractSlug = extra['contract_slug'] as String?;
          return BookingClassDetailsScreen(
            key: state.pageKey,
            classId: classLessonCode,
            contractSlug: contractSlug,
            typeViewBooking: TypeViewBooking.detail,
          );
        },
      ),
      //BookingSelectPianoScreen
      GoRoute(
        parentNavigatorKey: rootKey,
        path: BookingSelectPianoScreen.route,
        name:
            BookingSelectPianoScreen.route, //Used for pushNamed and pass params
        builder: (context, state) {
          String? classId = state.extra as String?;
          return BookingSelectPianoScreen(
            key: state.pageKey,
            classId: classId,
          );
        },
        // routes: const [],
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: BookingClassDetailScreen.route,
        name: 'booking-history-detail', //Used for pushNamed and pass params
        builder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;
          String? classId = extra['bookingCode'] as String?;
          RefreshAction? refreshAction =
              extra['refreshAction'] as RefreshAction?;
          return BookingClassDetailScreen(
            key: state.pageKey,
            classId: classId,
            typeViewBooking: TypeViewBooking.history,
            refreshAction: refreshAction ?? RefreshAction.refreshHistory,
          );
        },
        // routes: const [],
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: BookingClassCancelScreen.route,
        name: 'booking-history-cancel', //Used for pushNamed and pass params
        builder: (context, state) {
          String? classId = state.extra as String?;
          return BookingClassCancelScreen(
            key: state.pageKey,
            classId: classId,
            typeViewBooking: TypeViewBooking.cancel,
          );
        },
        // routes: const [],
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: BranchListScreen.route,
        name: 'select-branch', //Used for pushNamed and pass params
        builder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;
          DataInfoNameBooking? dataBranchSelected =
              extra['dataBranchSelected'] as DataInfoNameBooking?;
          List<DataInfoNameBooking>? branches =
              extra['branches'] as List<DataInfoNameBooking>?;
          return BranchListScreen(
            branches: branches,
            dataBranchSelected: dataBranchSelected,
            key: state.pageKey,
          );
        },
        // routes: const [],
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: CoachListScreen.route,
        name: 'select-coach',
        builder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;
          DataInfoNameBooking? dataBranchSelected =
              extra['dataBranchSelected'] as DataInfoNameBooking?;
          DataCoach? dataCoach = extra['dataCoach'] as DataCoach?;
          DataCoach? dataCoachSelected =
              extra['dataCoachSelected'] as DataCoach?;
          DataContractV5.Items? dataContact =
              extra['dataContractSelected'] as DataContractV5.Items?;

          return CoachListScreen(
            dataCoachSelected: dataCoachSelected,
            dataCoach: dataCoach,
            dataContractSelected: dataContact,
            dataBranchSelected: dataBranchSelected,
            key: state.pageKey,
          );
        },
        // routes: const [],
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: FeedbackFromCenterWidget.route,
        name: 'feedback-from-center', //Used for pushNamed and pass params
        builder: (context, state) {
          return FeedbackFromCenterWidget(
            key: state.pageKey,
          );
        },
        // routes: const [],
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: UserFeedbackScreen.route,
        name: 'user-feedback', //Used for pushNamed and pass params
        builder: (context, state) {
          return UserFeedbackScreen(
            key: state.pageKey,
          );
        },
        // routes: const [],
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: BlogDetailScreen.route,
        name: BlogDetailScreen.route,
        builder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;
          String slug = extra['blogSlug'] as String;
          BlogDetailScreenType type = extra['blogType'] as BlogDetailScreenType;
          return BlogDetailScreen(key: state.pageKey, slug: slug, type: type);
        },
        // routes: const [],
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: NotificationScreen.route,
        name: NotificationScreen.route,
        builder: (context, state) {
          return NotificationScreen(
            key: state.pageKey,
          );
        },
        // routes: const [],
      ),
    ];
    return bookingRouters;
  }
}
