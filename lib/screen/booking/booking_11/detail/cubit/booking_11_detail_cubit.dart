import 'dart:io';

import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/model/output/booking_11/booking_11_detail_output.dart';
import 'package:myutils/data/network/model/output/booking_11/booking_11_output.dart';
import 'package:myutils/data/network/model/output/count_cancel_booking_output.dart';
import 'package:myutils/data/network/network_manager.dart';
import 'package:myutils/data/repositories/booking_repository.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';

import '../booking_11_detail_screen.dart';

part 'booking_11_detail_state.dart';

class Booking11DetailCubit extends WidgetCubit<Booking11DetailState> {
  final DataBooking11Detail? data;
  final String? bookingCode;
  final Booking11DetailScreenMode mode;

  Booking11DetailCubit({
    required this.mode,
    this.data,
    this.bookingCode,
  }) : super(widgetState: const Booking11DetailState());

  final BookingRepository _bookingRepository = injector();
  final NetworkManager _networkManager = injector();

  @override
  void onWidgetCreated() {}

  Future<void> initData({
    Function(String message)? onBookingError,
  }) async {
    if (mode == Booking11DetailScreenMode.confirm) {
      emit(state.copyWith(dataBooking11Detail: data));
    } else {
      await getDetailBooking11(onBookingError: onBookingError);
    }
  }

  bool showButtonCancel() {
    final bookingData = state.dataBooking11Detail;
    return (bookingData?.isCancel ?? false);
  }
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
            () => _bookingRepository.cancelBooking11(data),
        showLoading: true,
      );
      if (bookingResult?.statusCode == ApiStatusCode.success) {
        LocalStream.shared.handleAction(refreshAction);
        onSuccess();
      } else if (bookingResult?.statusCode == ApiStatusCode.blockBooking) {
        LocalStream.shared.handleAction(refreshAction);
        onBookingBlock(bookingResult?.message ?? '');
        getDetailBooking11();
      } else {
        onError(bookingResult?.message ?? '');
      }
    } catch (e) {
      onError(isDebug ? e.toString() : MyString.messageError);
    }
  }
  //call api get detail booking11
  Future<void> getDetailBooking11({
    Function(String message)? onBookingError,
  }) async {
    try {
      final result = await fetchApi(
        () => _bookingRepository.booking11Detail(bookingCode ?? ''),
      );
      if (result?.statusCode == ApiStatusCode.success) {
        final data = result?.data;
        emit(state.copyWith(dataBooking11Detail: data));
      } else {
        onBookingError!(result?.message ?? '');
        // emit(state.copyWith(booking11Input: null));
      }
    } catch (e) {
      onBookingError!(e.toString());
      print('error: $e');
    }
  }

  Future<void> countBookingCancel({
    required Function(DataCancelBooking? data) onSuccess,
    required Function(String message) onError,
    required Function(String) onBookingBlock,
  }) async {
    var data = {
      "type": state.dataBooking11Detail?.type  ?? '',
      "booking_code": bookingCode ?? ''
    };
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
        getDetailBooking11();
      } else {
        onError(countResult?.message ?? '');
      }
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    }
  }

  /// Gets the booking success description text.
  String textBookingSuccessDes(DataBooking11? dataBooking) {
    return [
      dataBooking?.textBookingCode,
      dataBooking?.textFullTime,
      dataBooking?.textBranch
    ].where((text) => text?.isNotEmpty == true).join('\n');
  }

  Future<void> booking({
    required Function(DataBooking11? data) onBookingSuccess,
    required Function(String) onBookingError,
    required Function(String) onBookingBlock,
  }) async {
    //call api booking11
    try {
      final bookingResult = await fetchApi(
          () => _bookingRepository.booking11(state.dataBooking11Detail!),
          showLoading: true);
      if (bookingResult?.statusCode == ApiStatusCode.success) {
        final data = bookingResult?.data;
        // if (language == 'en') {
        //   await _translateBookingData(data);
        // }
        LocalStream.shared.handleAction(RefreshAction.refreshBooking11List);
        onBookingSuccess(data);
        // hideEasyLoading();
      } else if (bookingResult?.statusCode == ApiStatusCode.blockBooking) {
        onBookingBlock(bookingResult?.message ?? '');
        // hideEasyLoading();
      } else {
        LocalStream.shared.refreshBooking11List();
        final message = language == 'en'
            ? await ToolHelper.translateText(bookingResult?.message ?? '')
            : bookingResult?.message ?? '';
        onBookingError(message);
        // hideEasyLoading();
      }
    } catch (e) {
      onBookingError(e.toString());
      // emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
