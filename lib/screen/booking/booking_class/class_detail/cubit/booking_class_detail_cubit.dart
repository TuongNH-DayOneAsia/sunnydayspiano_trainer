import 'dart:io';

import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:dayoneasia/screen/dashboard/booking_history/cubit/booking_history_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/data/network/model/output/api_key_output.dart';
import 'package:myutils/data/network/model/output/booking_output.dart';
import 'package:myutils/data/network/model/output/count_cancel_booking_output.dart';
import 'package:myutils/data/network/model/output/list_class_output.dart';
import 'package:myutils/data/network/network_manager.dart';
import 'package:myutils/data/repositories/booking_repository.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';

part 'booking_class_detail_state.dart';

enum TypeViewBooking { detail, history, cancel }

const int bookingCancel = 0;
const int bookingBooked = 1;
const int notGotoClass = 1;

class BookingClassDetailCubit extends WidgetCubit<BookingClassDetailState> {
  BookingClassDetailCubit({this.classId, this.typeViewBooking}) : super(widgetState: const BookingClassDetailState());
  final BookingRepository _bookingRepository = injector();
  final NetworkManager _networkManager = injector();

  final String? classId;
  final TypeViewBooking? typeViewBooking;
  String get noteDetailBookingClass =>
      localeManager
          .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
          ?.noteDetailBookingClass ??
          '';
  String get noteBookingClass =>
      localeManager
          .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
          ?.noteBookingClass ??
          '';

  String bookingNote (){
    if (typeViewBooking == TypeViewBooking.detail) {
      return noteBookingClass;

    } else {
      return noteDetailBookingClass;
    }
  }

  @override
  void onWidgetCreated() {}

  bool showButtonCancel() {
    return state.dataClass?.isCancel ?? false;
  }

  Future<void> callApiClassDetail() async {
    if (kDebugMode) {
      print('callApiClassDetail $classId typeViewBooking $typeViewBooking');
    }
    emit(state.copyWith(isLoading: true));
    try {
      final detailResult = await fetchApi(
        () => typeViewBooking == TypeViewBooking.detail
            ? _bookingRepository.classDetail(classId ?? '')
            : _bookingRepository.bookingDetail(classId ?? ''),
        showLoading: false,
        millisecondsDelay: 1000,
      );

      if (detailResult?.statusCode == ApiStatusCode.success) {
        final dataClass = detailResult?.dataClass;
        if (dataClass != null && language == 'en') {
          await _translateAndFormatClassData(dataClass, typeViewBooking ?? TypeViewBooking.detail);
        }
        emit(state.copyWith(dataClass: dataClass, isLoading: false));
      } else {
        emit(state.copyWith(messageError: detailResult?.message ?? '', isLoading: false));
      }
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      emit(state.copyWith(messageError: isDebug ? e.toString() : MyString.messageError, isLoading: false));
    }
  }

  Future<void> countBookingCancel({
    required Function(DataCancelBooking? data) onSuccess,
    required Function(String? message) onError,
    required Function(String) onBookingBlock,
  }) async {
    var data = {"type": ClassType.CLASS.name, "booking_code": classId ?? ''};
    try {
      final countResult = await fetchApi(
        () => _bookingRepository.cancelBookingPractice(data),
        showLoading: true,
      );
      if (countResult?.statusCode == ApiStatusCode.success && countResult?.data != null) {
        onSuccess(countResult?.data!);
      } else if (countResult?.statusCode == ApiStatusCode.blockBooking) {
        onBookingBlock(countResult?.message ?? '');
      } else {
        onError(countResult?.message ?? '');
      }
    } catch (e) {
      onError(isDebug ? e.toString() : MyString.messageError);

      if (kDebugMode) {
        print('error: $e');
      }
    }
  }

  Future<void> callApiBook({
    required String id,
    required Function(DataBooking?) onBookingSuccess,
    required Function(String) onBookingError,
    required Function(String) onBookingBlock,
    required String contractSlug
  }) async {
    showEasyLoading();
    try {
      final data = {
        "class_lesson_code": id,
        "contract_slug": contractSlug,
        "ip": await _networkManager.getIPAddress() ?? '',
        "device_id": await deviceIdApp() ?? '',
        "platform": Platform.isAndroid ? 'android' : 'ios'

      };
      final bookingResult = await fetchApi(
        () async => _bookingRepository.bookingClass(data),
        showLoading: false,
      );

      if (bookingResult?.statusCode == ApiStatusCode.success) {
        final data = bookingResult?.data;
        if (language == 'en') {
          await _translateBookingData(data);
        }
        LocalStream.shared.handleAction(RefreshAction.refreshClassList);
        onBookingSuccess(data);
        hideEasyLoading();
      } else if (bookingResult?.statusCode == ApiStatusCode.blockBooking) {
        onBookingBlock(bookingResult?.message ?? '');
        hideEasyLoading();
      } else {
        final message =
            language == 'en' ? await ToolHelper.translateText(bookingResult?.message ?? '') : bookingResult?.message ?? '';
        onBookingError(message);
        hideEasyLoading();
      }
    } catch (e) {
      onBookingError(isDebug ? e.toString() : MyString.messageError);
      hideEasyLoading();
    }
  }

  Future<void> _translateBookingData(DataBooking? data) async {
    final translations = await Future.wait([
      ToolHelper.translateText(data?.textBranch ?? ''),
      ToolHelper.translateText(data?.textFullTime ?? ''),
      ToolHelper.translateText(data?.textBookingCode ?? ''),
    ]);

    data?.textBranch = translations[0];
    data?.textFullTime = translations[1];
    data?.textBookingCode = translations[2];
  }

  Future<void> cancelBooking({
    required String bookingCode,
    required Function() onSuccess,
    required Function(String message) onError,
    required Function(String) onBookingBlock,
    required RefreshAction refreshAction,
  }) async {
    var data = {
      "booking_code": bookingCode,
      "ip": await _networkManager.getIPAddress() ?? '',
      "device_id": await deviceIdApp() ?? '',
      "platform": Platform.isAndroid ? 'android' : 'ios'
    };
    try {
      final bookingResult = await fetchApi(
        () => _bookingRepository.cancelBooking(data),
        showLoading: true,
      );
      if (language == 'en') {
        bookingResult?.message = await ToolHelper.translateText(bookingResult.message ?? '');
      }
      if (bookingResult?.statusCode == ApiStatusCode.success) {
        LocalStream.shared.handleAction(refreshAction);
        onSuccess();
      } else if (bookingResult?.statusCode == ApiStatusCode.blockBooking) {
        onBookingBlock(bookingResult?.message ?? '');
        callApiClassDetail();
        LocalStream.shared.handleAction(refreshAction);
      } else {
        onError(bookingResult?.message ?? '');
      }
    } catch (e) {
      onError(isDebug ? e.toString() : MyString.messageError);
    }
  }

  String textBookingSuccessDes(DataBooking? dataBooking) {
    List<String> parts = [];

    if (dataBooking?.textBookingCode?.isNotEmpty == true) {
      parts.add(dataBooking?.textBookingCode ?? '');
    }
    if (dataBooking?.textFullTime?.isNotEmpty == true) {
      parts.add(dataBooking?.textFullTime ?? '');
    }
    if (dataBooking?.textBranch?.isNotEmpty == true) {
      parts.add(dataBooking?.textBranch ?? '');
    }
    return parts.isNotEmpty ? parts.join('\n') : '';
  }

  Future<void> _translateAndFormatClassData(DataClass dataClass, TypeViewBooking typeViewBooking) async {
    if (typeViewBooking == TypeViewBooking.detail) {
      dataClass.classStartDate = dataClass.classStartDate?.convertDateFormatToEn() ?? '';
      dataClass.branch?.name = dataClass.branch?.name?.removeDiacritics() ?? '';
      dataClass.classroom?.name = await ToolHelper.translateText(dataClass.classroom?.name ?? '');
    } else {
      dataClass.classLessonStartDate = dataClass.classLessonStartDate?.convertDateFormatToEn() ?? '';
      dataClass.createdAt = dataClass.createdAt?.convertDateFormatToEn() ?? '';
    }

    if (dataClass.statusBooking != null) {
      try {
        final futures = await Future.wait([
          ToolHelper.translateText(dataClass.coaches ?? ''),
          ToolHelper.translateText(dataClass.statusBookingText ?? ''),
          ToolHelper.translateText(dataClass.statusInClassText ?? ''),
          ToolHelper.translateText(dataClass.branchHisTory?.fullAddress ?? ''),
        ]);

        dataClass.coaches = futures[0];
        dataClass.statusBookingText = futures[1];
        dataClass.statusInClassText = futures[2];
        dataClass.branchHisTory?.fullAddress = futures[3];
      } catch (e) {
        if (kDebugMode) {
          print('Translation error: $e');
        }
        // Keep original text if translation fails
      }
    }
  }
}
