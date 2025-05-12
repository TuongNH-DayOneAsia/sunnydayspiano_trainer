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
import 'package:myutils/data/network/model/output/booking_detail_practice_output.dart';
import 'package:myutils/data/network/model/output/count_cancel_booking_output.dart';
import 'package:myutils/data/network/network_manager.dart';
import 'package:myutils/data/repositories/booking_repository.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';

part 'booking_practice_detail_state.dart';

class BookingPracticeDetailCubit extends WidgetCubit<BookingPracticeDetailState> {
  BookingPracticeDetailCubit({this.bookingCode}) : super(widgetState: const BookingPracticeDetailState());
  final BookingRepository _bookingRepository = injector();
  final NetworkManager _networkManager = injector();

  final String? bookingCode;
  String get noteDetailBookingClassPractice =>
      localeManager
          .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
          ?.noteDetailBookingClassPractice ??
          '';
  @override
  void onWidgetCreated() {}

  bool showButtonCancel() {
    final bookingData = state.bookingDetailPracticeOutput?.data;
    return (bookingData?.isCancel ?? false);
  }

  callApiDetail() async {
    emit(state.copyWith(isLoading: true)); // Set loading state to true

    try {
      final detailResult = await fetchApi(
        () => _bookingRepository.bookingDetailPractice(bookingCode ?? ''),
        showLoading: false,
        millisecondsDelay: 1000,
      );
      if (language == 'en' && detailResult?.data != null) {
        // showEasyLoading();
        await _translateAndFormatData(detailResult?.data);
        // hideEasyLoading();
      }
      emit(state.copyWith(
        isLoading: false, // Set loading to false on success
        dataDetail: detailResult,
      ));
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      emit(state.copyWith(
        isLoading: false, // Set loading to false on error
        messageError: isDebug ? e.toString() : MyString.messageError,
      ));
    }
  }

//

//
  Future<void> cancelBooking({
    required RefreshAction refreshAction,
    required String bookingCode,
    required Function() onSuccess,
    required Function(String message) onError,
    required Function(String) onBookingBlock,
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
      if (bookingResult?.statusCode == ApiStatusCode.success) {
        EventBus.shared.handleAction(refreshAction);
        onSuccess();
      } else if (bookingResult?.statusCode == ApiStatusCode.blockBooking) {
        EventBus.shared.handleAction(refreshAction);
        onBookingBlock(bookingResult?.message ?? '');
        callApiDetail();
      } else {
        onError(bookingResult?.message ?? '');
      }
    } catch (e) {
      onError(isDebug ? e.toString() : MyString.messageError);
    }
  }

  Future<void> countBookingCancel({
    required Function(DataCancelBooking? data) onSuccess,
    required Function(String message) onError,
    required Function(String) onBookingBlock,
  }) async {
    var data = {"type": ClassType.CLASS_PRACTICE.name, "booking_code": bookingCode ?? ''};
    try {
      final countResult = await fetchApi(
        () => _bookingRepository.cancelBookingPractice(data),
        showLoading: true,
      );
      if (countResult?.statusCode == ApiStatusCode.success) {
        if (countResult?.data == null) {
          onError(countResult?.message ?? '');
          return;
        }
        onSuccess(countResult?.data);
      } else if (countResult?.statusCode == ApiStatusCode.blockBooking) {
        onBookingBlock(countResult?.message ?? '');
        callApiDetail();
      } else {
        onError(countResult?.message ?? '');
      }
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    }
  }

  Future<void> _translateAndFormatData(DataDetailPractice? data) async {
    data?.branchName = data.branchName?.removeDiacritics() ?? '';
    data?.instrumentStartDate = data.instrumentStartDate?.convertDateFormatToEn() ?? '';

    data?.instrumentDuration = await ToolHelper.translateText(data.instrumentDuration ?? '');
    data?.createdAt = data.createdAt?.convertDateFormatToEn() ?? '';
    data?.bookNote = await ToolHelper.translateText(data.bookNote ?? '');
    // data.clasTypeName = await ToolHelper.translateText(data.clasTypeName ?? '');
    // data.instrumentCode = await ToolHelper.translateText(data.instrumentCode ?? '');

    if (data?.statusBooking != null) {
      try {
        final futures = await Future.wait([
          ToolHelper.translateText(data?.statusBookingText ?? ''),
          ToolHelper.translateText(data?.statusInClassText ?? ''),
        ]);

        data?.statusBookingText = futures[0];
        data?.statusInClassText = futures[1];
      } catch (e) {
        if (kDebugMode) {
          print('Translation error: $e');
        }
      }
    }
  }
}
