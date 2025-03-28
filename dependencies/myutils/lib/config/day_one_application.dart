import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dayoneasia/config/firebase_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/base/bloc/cubit/notification_cubit.dart';
import 'package:myutils/base/bloc/local_cubit.dart';
import 'package:myutils/base/bloc/app_cubit.dart';
import 'package:myutils/base/bloc/app_state.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import '../data/configuration/theme_config/my_app_theme.dart';
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class DayOneApplication extends StatelessWidget {
  final GoRouter? appRouter;

  const DayOneApplication({super.key,  this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => NotificationCubit()..initNotification()
        ),

        BlocProvider(
          create: (context) => AppCubit()..callApiKeyPrivate(),
        ),
        BlocProvider(
          create: (context) => LocalCubit()..initSetting(),
        ),

      ],
      child: BlocListener<AppCubit, AppState>(
        listenWhen: (previous, current) {
          return previous.connectivityResult != current.connectivityResult && previous.connectivityResult != null;
        },
        listener: (context, state) {
          if (state.connectivityResult == ConnectivityResult.none) {
            if (kDebugMode) {
              print('No internet connection');
            }
            scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: const Text('Bạn đang offline, vui lòng kiểm tra lại kết nối internet'),
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          } else if (state.connectivityResult == ConnectivityResult.mobile ||
              state.connectivityResult == ConnectivityResult.wifi) {
            scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: const Text('Kết nối internet đã được khôi phục'),
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          }
        },
        child: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            return EasyLocalization(
              supportedLocales: const [
                Locale.fromSubtags(languageCode: 'vi'),
                Locale.fromSubtags(languageCode: 'en'),
              ],
              path: 'assets/translations',
              saveLocale: false,
              fallbackLocale: const Locale('vi'),
              useOnlyLangCode: true,
              // startLocale: (context.read<AppCubit>().inReleaseProgress == true && Platform.isIOS)
              //     ? const Locale('en')
              //     : Locale(context.read<AppCubit>().cachedLanguage()),
              //
              startLocale: Locale(context.read<AppCubit>().cachedLanguage()),
              child: MyBaseApp(
                router: appRouter!,
                title: 'DayOne',
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyBaseApp extends StatefulWidget {
  const MyBaseApp({super.key, required this.router, required this.title});

  final GoRouter router;
  final String title;

  @override
  State<MyBaseApp> createState() => _MyBaseAppState();
}

class _MyBaseAppState extends State<MyBaseApp> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp.router(
        builder: (context, child) => GlobalScaffold(
          child: EasyLoading.init()(context, child),
        ),
        routeInformationParser: widget.router.routeInformationParser,
        routeInformationProvider: widget.router.routeInformationProvider,
        routerDelegate: widget.router.routerDelegate,
        backButtonDispatcher: RootBackButtonDispatcher(),
        debugShowCheckedModeBanner: false,
        title: widget.title,
        theme: MyThemeData.myLightTheme(context),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        scaffoldMessengerKey: GlobalContext.scaffoldMessengerKey,
      ),
    );
  }
}

void configureEasyLoading() {
  EasyLoading.instance
    ..backgroundColor = Colors.transparent
    ..maskColor = Colors.black.withOpacity(0.5)
    // ..maskColor = Colors.transparent
    ..userInteractions = false
    ..dismissOnTap = false
    // ..indicatorType = EasyLoadingIndicatorType.circle
    // ..loadingStyle = EasyLoadingStyle.dark
    ..boxShadow = <BoxShadow>[]
    ..maskType = EasyLoadingMaskType.custom
    ..loadingStyle = EasyLoadingStyle.custom
    ..textColor = Colors.white
    ..indicatorColor = Colors.transparent
    ..progressColor = MyColors.mainColor;
}

class GlobalScaffold extends StatelessWidget {
  final Widget child;

  const GlobalScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}

class GlobalContext {
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static final navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get context => scaffoldMessengerKey.currentContext ?? navigatorKey.currentContext;
}

