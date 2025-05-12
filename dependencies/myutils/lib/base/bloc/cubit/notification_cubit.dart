import 'dart:convert';
import 'package:dayoneasia/screen/authen/login/login_screen.dart';
import 'package:dayoneasia/screen/blog/blog_detail/blog_detail_screen.dart';
import 'package:dayoneasia/screen/blog/blog_detail/cubit/blog_detail_cubit.dart';
import 'package:dayoneasia/screen/booking/booking_11/detail/booking_11_detail_screen.dart';
import 'package:dayoneasia/screen/booking/booking_class/booking_class_detail/booking_class_detail_screen.dart';
import 'package:dayoneasia/screen/booking/booking_class/class_list/booking_class_list_screen.dart';
import 'package:dayoneasia/screen/booking/booking_practice/practice_detail/booking_practice_detail_screen.dart';
import 'package:dayoneasia/screen/booking/booking_practice/practice_list/booking_practice_list_screen.dart';
import 'package:dayoneasia/screen/notification/notification_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:dayoneasia/router/my_router.dart';
import 'package:dayoneasia/screen/dashboard/home/home_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/repositories/booking_repository.dart';
import '../../../constants/locale_keys_enum.dart';
import '../../../data/cache_helper/cache_helper.dart';
import '../../../data/repositories/notification_repository.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(const NotificationState());

  final NotificationRepository _notificationRepository = injector();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final BookingRepository _bookingRepository = injector();

  Future<void> initNotification() async {
    if (kDebugMode) {
      print('Calling initNotification');
    }
    await requestNotificationPermission();
    await initLocalNotifications();
    await setupInteractMessage();
    setupForegroundNotification();
  }

  // Request permission
  Future<void> requestNotificationPermission() async {
    if (kDebugMode) {
      print('Calling requestNotificationPermission');
    }
    final firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    final fcmToken = await firebaseMessaging.getToken();
    if (kDebugMode) {
      print('FCM Token: $fcmToken');
    }
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      if (kDebugMode) {
        var data = {'fcm_token': newToken};
        _notificationRepository.updateFcmToken(data);
        print('New FCM Token: $newToken');
      }
    });
  }

  // Init local notifications
  Future<void> initLocalNotifications() async {
    if (kDebugMode) {
      print('Calling initLocalNotifications');
    }
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/notification');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        if (kDebugMode) {
          print('Received iOS notification: $title');
        }
      },
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        if (kDebugMode) {
          print('Notification tapped: ${details.payload}');
        }
        final message = _lastMessage;
        if (message != null) {
          navigateToScreen(message);
        }
      },
    );
  }

  RemoteMessage? _lastMessage;

  // Setup handlers for background & terminated state
  Future<void> setupInteractMessage() async {
    if (kDebugMode) {
      print('Calling setupInteractMessage');
    }
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (kDebugMode) {
        print('App opened from background');
      }
      handleBackgroundMessage(message);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final message = await FirebaseMessaging.instance.getInitialMessage();
      if (message != null) {
        if (kDebugMode) {
          print('App opened from terminated state');
        }
        await Future.delayed(const Duration(seconds: 1));
        handleTerminatedMessage(message);
      }
    });
  }

  // Setup foreground handler
  void setupForegroundNotification() {
    if (kDebugMode) {
      print('Calling setupForegroundNotification');
    }
    FirebaseMessaging.onMessage.listen((message) async {
      if (kDebugMode) {
        print('Received foreground message');
      }
      _lastMessage = message;
      if (Platform.isIOS) {
        await handleIOSForegroundMessage(message);
      }
      if (Platform.isAndroid) {
        await showLocalNotification(message);
      }
      try {
        final data = message.data;
        final bool isBlock = data['is_block'] ?? false;
        if (isBlock) {
          EventBus.shared.handleAction(RefreshAction.refreshDataInHome);
        } else {
          EventBus.shared.refreshApiProfile();
        }
      } catch (e) {
        print('error: $e');
      }
      if (currentRoute() == NotificationScreen.route) {
        EventBus.shared.handleSlugCallback('');
      }
    });
  }

  // Handle messages from different states
  Future<void> handleTerminatedMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print('Calling handleTerminatedMessage');
    }
    if (kDebugMode) {
      print('Handling terminated message: ${message.messageId}');
      print('Message data: ${message.data}');
    }
    final accessToken = localeManager.getString(StorageKeys.accessToken);
    print('Access token: ${accessToken != null}');
    if (accessToken == null) {
      if (kDebugMode) {
        print('No access token, navigating to login');
      }
      myRouter.go(LoginScreen.route);
      return;
    }
    if (kDebugMode) {
      print('Navigating to home screen');
    }
    myRouter.go(HomeScreen.route);
    await Future.delayed(const Duration(milliseconds: 100));
    if (kDebugMode) {
      print('Navigating to detail');
    }
    navigateToScreen(message);
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print('Calling handleBackgroundMessage');
    }
    navigateToScreen(message);
  }

  // Show local notification
  Future<void> showLocalNotification(RemoteMessage message) async {
    if (kDebugMode) {
      print('Calling showLocalNotification');
    }
    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      showBadge: true,
      playSound: true,
    );
    final androidDetails = AndroidNotificationDetails(
      androidChannel.id,
      androidChannel.name,
      channelDescription: "High Importance Channel",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: androidChannel.sound,
      fullScreenIntent: true,
      visibility: NotificationVisibility.public,
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
      styleInformation: BigTextStyleInformation(
        message.notification?.body ?? '',
        htmlFormatBigText: true,
        contentTitle: message.notification?.title,
        htmlFormatContentTitle: true,
      ),
    );
    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      details,
      payload: jsonEncode(message.data),
    );
  }

  // Handle iOS foreground message
  Future<void> handleIOSForegroundMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print('Calling handleIOSForegroundMessage');
    }
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // Clear notifications
  Future<void> clearNotifications() async {
    if (kDebugMode) {
      print('Calling clearNotifications');
    }
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void navigateToScreen(RemoteMessage? message) {
    if (kDebugMode) {
      print('Calling navigateToDetail');
    }
    try {
      final data = message?.data;
      if (data == null) return;
      final String path = data['path'] ?? '';
      // Early return if path is empty
      final slug = data['slug'] ?? '';
      if (slug.isNotEmpty == true) {
        seenNotification(slug);
      }
      final accessToken = localeManager.getString(StorageKeys.accessToken);
      print('Access token: ${accessToken != null}');
      if (accessToken == null) {
        if (kDebugMode) {
          print('No access token, navigating to login');
        }
        _handleScreenNavigation(path: LoginScreen.route);
        return;
      }

      if (path.isEmpty) {
        _handleHomeNavigation();
        return;
      }
      // Only include extraParams for specific screens
      dynamic extraParams;
      if (_isValidBookingDetailPath(path)) {
        final String bookingCode = data['booking_code'] ?? 'default_code';
        extraParams = {
          'bookingCode': bookingCode,
          'refreshAction': RefreshAction.refreshDataInHome,
        };
      }
      if (_isValidBooking11DetailPath(path)) {
        final String bookingCode = data['booking_code'] ?? 'default_code';
        extraParams = {
          'bookingCode': bookingCode,
          'mode': Booking11DetailScreenMode.detail,
          'refreshAction': RefreshAction.refreshDataInHome,
        };
      }

      if (_isValidBlogDetailPath(path)) {
        final String slug = data['slug'] ?? 'default_code';
        final type = data['type'] ?? '';
        extraParams = {
          'blogSlug': slug,
          'blogType': type == BlogDetailScreenType.PROMOTION.name
              ? BlogDetailScreenType.PROMOTION
              : BlogDetailScreenType.BLOG,
        };
      }

      // if (_isValidBookingPath(path)) {
      //   final String keyType = data['booking_key_type'] ?? 'default_code';
      //   extraParams = keyType;
      // }

      // Handle navigation based on path
      _handleScreenNavigation(path: path, extraParams: extraParams);
    } catch (e) {
      print('Navigation error: $e');
    }
  }

  bool _isValidBookingPath(String path) {
    return path == BookingClassListScreen.route ||
        path == BookingPracticeListScreen.route;
  }

  bool _isValidBookingDetailPath(String path) {
    return path == BookingClassDetailScreen.route ||
        path == BookingPracticeDetailScreen.route;
  }

  bool _isValidBooking11DetailPath(String path) {
    return path == Booking11DetailScreen.route;
  }

  bool _isValidBlogDetailPath(String path) {
    return path == BlogDetailScreen.route;
  }

  void _handleHomeNavigation() {
    final isHomeScreen = currentRoute() == HomeScreen.route;
    isHomeScreen
        ? myRouter.pushReplacement(HomeScreen.route)
        : myRouter.push(HomeScreen.route);
  }

  void _handleScreenNavigation({required String path, dynamic? extraParams}) {
    final isCurrentRoute = currentRoute() == path;
    if (extraParams != null) {
      isCurrentRoute
          ? myRouter.pushReplacement(path, extra: extraParams)
          : myRouter.push(path, extra: extraParams);
    } else {
      isCurrentRoute ? myRouter.pushReplacement(path) : myRouter.push(path);
    }
  }

  // seen notification
  void seenNotification(String slug) async {
    try {
      _bookingRepository
          .seenNotification(
        slug,
      )
          .then((result) {
        if (result.statusCode == ApiStatusCode.success) {
          if (NotificationScreen.route == currentRoute()) {
            EventBus.shared.handleSlugCallback(slug);
          }
          EventBus.shared.refreshApiProfile();
          if (kDebugMode) {
            print('Seen notification success');
          }
        }
      });
    } catch (e) {
      print('error: $e');
    }
  }
}
