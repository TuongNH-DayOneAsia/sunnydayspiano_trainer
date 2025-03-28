import 'dart:async';

import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/model/input/notifications_input.dart';
import 'package:myutils/data/network/model/output/notifications_output.dart';
import 'package:myutils/data/repositories/booking_repository.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';

import '../../blog/blog_detail/blog_detail_screen.dart';
import '../../blog/blog_detail/cubit/blog_detail_cubit.dart';
import '../../booking/booking_11/detail/booking_11_detail_screen.dart';
import '../../booking/booking_class/booking_class_detail/booking_class_detail_screen.dart';
import '../../booking/booking_practice/practice_detail/booking_practice_detail_screen.dart';
import '../../dashboard/booking_history/cubit/booking_history_cubit.dart';

part 'notifications_state.dart';

class NotificationsCubit extends WidgetCubit<NotificationsState> {
  NotificationsCubit() : super(widgetState: const NotificationsState()) {
    LocalStream.shared.handleSlugCallback = (String slug) {
      refreshNotificationsWithDebounce();
    };
  }
  // Constants for object types
  static const String BOOKING = 'BOOKING';
  static const String NEWS = 'NEWS';
  static const String PROMOTION = 'PROMOTION';

  // Route mappings moved to static constants
  final Map<String, String> routeBookingMapping = {
    ClassType.CLASS_PRACTICE.name: BookingPracticeDetailScreen.route,
    ClassType.CLASS.name: BookingClassDetailScreen.route,
    ClassType.ONE_PRIVATE.name: Booking11DetailScreen.route,
    ClassType.ONE_GENERAL.name: Booking11DetailScreen.route,
    ClassType.P1P2.name: Booking11DetailScreen.route,
  };

  final Map<String, String> routeEventsMapping = {
    NEWS: BlogDetailScreen.route,
    PROMOTION: BlogDetailScreen.route,
  };
  final BookingRepository _bookingRepository = injector();

  NotificationsInput _notificationsInput = NotificationsInput(page: 1, limit: 10);
  Timer? _debounceTimer;
  final Map<num, List<DataNotifications>> _notificationsCache = {};
  Map<String, dynamic> getNavigationParams(DataNotifications item) {
    switch (item.objectType) {
      case BOOKING:
        return {
          'route': routeBookingMapping[item.booking?.type],
          'extra': {
            'bookingCode': item.booking?.bookingCode ?? '',
            'refreshAction': RefreshAction.refreshDataInHome,
          }
        };

      case NEWS:
      case PROMOTION:
        return {
          'route': BlogDetailScreen.route,
          'extra': {
            'blogSlug': item.slug,
            'blogType': item.objectType == NEWS
                ? BlogDetailScreenType.BLOG
                : BlogDetailScreenType.PROMOTION,
          }
        };
      default:
        return {};
    }
  }

  bool canHandleNotification(DataNotifications item) {
    return item.objectType == BOOKING
        ? routeBookingMapping.containsKey(item.booking?.type)
        : routeEventsMapping.containsKey(item.objectType);
  }
  //get notifications
  void initNotifications({bool? showLoading}) async {
    emit(state.copyWith(isLoading: true));
    //call api to get notifications
    try {
      final notificationsOutput = await _fetchNotifications(showLoading: showLoading ?? false);
      emit(state.copyWith(notificationsOutput: notificationsOutput, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
  void checkPermission(BuildContext context){
    ToolHelper.checkNotificationPermission(context);
  }


  void allSeen() {
    seenNotification(
        slug: 'all',
        onSuccess: () {
          LocalStream.shared.refreshApiProfile();

          _notificationsInput = NotificationsInput(page: 1, limit: 10);
          _fetchNotifications(showLoading: true, millisecondsDelay: 1000).then((value) {
            if (value?.statusCode == ApiStatusCode.success) {
              emit(state.copyWith(notificationsOutput: value, isLoading: false));
            }
          });
        });
  }

  void refreshNotificationsWithDebounce() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      refreshNotifications();
    });
  }

  // Refresh Notification
  void refreshNotifications() {
    _notificationsInput = NotificationsInput(page: 1, limit: 10);
    _fetchNotifications(showLoading: false).then((value) {
      if (value?.statusCode == ApiStatusCode.success) {
        emit(state.copyWith(notificationsOutput: value, isLoading: false));
      } else {
        emit(state.copyWith(error: "Có lỗi xảy ra"));
      }
    }).catchError((error) {
      emit(state.copyWith(error: error.toString()));
    });
  }

  void resetSwitch() {
    emit(state.copyWith(switchValue: false));
  }

  void switchSeen(bool isSeen) {
    emit(state.copyWith(
      switchValue: isSeen,
    ));

    _notificationsInput = NotificationsInput(page: 1, limit: 10);

    _fetchNotifications(showLoading: true).then((value) {
      if (value?.statusCode == ApiStatusCode.success) {
        emit(state.copyWith(notificationsOutput: value, switchValue: isSeen));
      } else {
        emit(state.copyWith(error: "Có lỗi xảy ra", switchValue: isSeen));
      }
    }).catchError((error) {
      emit(state.copyWith(error: error.toString(), switchValue: isSeen));
    });
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore) return;

    final currentPage = state.notificationsOutput?.data?.pagination?.currentPage ?? 0;
    final totalPage = state.notificationsOutput?.data?.pagination?.totalPage ?? 0;

    if (currentPage >= totalPage) return;

    try {
      emit(state.copyWith(isLoadingMore: true));
      _notificationsInput = _notificationsInput.copyWith(page: currentPage + 1);

      final newNotifications = await _fetchNotifications(
        showLoading: false,
        millisecondsDelay: 0,
      );

      if (newNotifications?.data?.notifications?.isEmpty ?? true) {
        return;
      }

      final updatedNotifications = [
        ...?state.notificationsOutput?.data?.notifications,
        ...?newNotifications?.data?.notifications
      ];

      emit(state.copyWith(
        notificationsOutput: state.notificationsOutput?.copyWith(
          data: state.notificationsOutput?.data?.copyWith(
            notifications: updatedNotifications,
            pagination: newNotifications?.data?.pagination,
          ),
        ),
        isLoadingMore: false,
      ));
      print('currentPage: $currentPage');
      print('totalPage: $totalPage');
      print('length: ${updatedNotifications.length}');
    } catch (e) {
      emit(state.copyWith(
        error: isDebug ? e.toString() : MyString.messageError,
        isLoadingMore: false,
      ));
    }
  }

  // seen notification
  void seenNotification({required String slug, Function()? onSuccess}) async {
    try {
      final result = await fetchApi(
          () => _bookingRepository.seenNotification(
                slug,
              ),
          showLoading: false);
      if (result?.statusCode == ApiStatusCode.success) {
        if (onSuccess != null) {
          onSuccess();
        }
      }
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    _notificationsCache.clear();
    return super.close();
  }

  Future<NotificationsOutput?> _fetchNotifications({
    required bool showLoading,
    int? millisecondsDelay,
  }) async {
    final page = _notificationsInput.page;

    final result = await fetchApi(
      () => _bookingRepository.notifications(_notificationsInput, state.switchValue),
      showLoading: showLoading,
      millisecondsDelay: millisecondsDelay ?? 500,
    );

    if (result?.data?.notifications != null) {
      _notificationsCache[page] = result!.data!.notifications!;
    }

    return result;
  }

  void updateNotificationStatus(String slug) {
    final notifications = state.notificationsOutput?.data?.notifications;
    if (notifications == null) return;

    final index = notifications.indexWhere((item) => item.slug == slug);
    if (index == -1) return;

    final updatedNotifications = List<DataNotifications>.from(notifications);
    updatedNotifications[index] = notifications[index].copyWith(seen: 1);

    emit(state.copyWith(
        notificationsOutput: state.notificationsOutput
            ?.copyWith(data: state.notificationsOutput?.data?.copyWith(notifications: updatedNotifications))));
  }

  @override
  void onWidgetCreated() {
    // TODO: implement onWidgetCreated
  }
}


