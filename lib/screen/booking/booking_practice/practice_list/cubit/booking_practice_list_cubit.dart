import 'dart:io';

import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:myutils/config/app_config.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/data/network/model/input/api_key_input.dart';
import 'package:myutils/data/network/model/input/list_booking_input.dart';
import 'package:myutils/data/network/model/output/api_key_output.dart';
import 'package:myutils/data/network/model/output/banner_class_type_output.dart';
import 'package:myutils/data/network/model/output/booking_output.dart';
import 'package:myutils/data/network/model/output/branches_output.dart';
import 'package:myutils/data/network/model/output/currrent_week_output.dart';
import 'package:myutils/data/network/model/output/durations_output.dart';
import 'package:myutils/data/network/model/output/list_class_output.dart';
import 'package:myutils/data/network/model/output/list_piano_output.dart';
import 'package:myutils/data/network/network_manager.dart';
import 'package:myutils/data/repositories/authen_repository.dart';
import 'package:myutils/data/repositories/booking_repository.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';

part 'booking_practice_list_state.dart';

/// \[PracticeListCubit\] manages the state for the practice list screen.
class BookingPracticeListCubit extends WidgetCubit<BookingPracticeListState> {
  /// The type of key used for booking.
  final String? keyType;

  /// Creates a new instance of \[PracticeListCubit\].
  BookingPracticeListCubit({this.keyType}) : super(widgetState: BookingPracticeListState());

  /// Repository for booking-related operations.
  final BookingRepository _bookingRepository = injector();

  /// Network manager for network-related operations.
  final NetworkManager _networkManager = injector();
  String get noteBookingClassPractice =>
      localeManager
          .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
          ?.noteBookingClassPractice ??
          '';
  /// Repository for authentication-related operations.
  AuthenRepository authenRepository = injector();

  /// Gets the minimum date string for booking practice.
  String get minimumDateString =>
      localeManager
          .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
          ?.bookPracticeTimeStart ??
      '';

  /// Gets the maximum date string for booking practice.
  String get maximumDateString =>
      localeManager
          .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
          ?.bookPracticeTimeEnd ??
      '';

  /// Gets the minute interval for booking practice.
  String get minuteInterval =>
      localeManager
          .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
          ?.bookPracticeTimeStep ??
      '';

  /// Calculates the number of rows for instrument practice.
  int instrumentPracticeRow() {
    final row = localeManager
            .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
            ?.instrumentPracticeRow ??
        '1';
    final list = state.listPianoOutput?.data ?? [];
    return list.isEmpty || row.isEmpty
        ? 1
        : (list.length / int.parse(row)).ceil();
  }

  /// Calculates the number of rows for instrument practice (alternative method).
  int instrumentPracticeRow2() {
    final row = localeManager
            .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
            ?.instrumentPracticeRow ??
        '1';
    return row.isEmpty ? 1 : int.parse(row);
  }

  /// Emits the selected branch index.
  Future<void> emitIndexBranchSelected(DataInfoNameBooking data) async {
    emit(state.copyWith(dataBranchSelected: data));
    filter(branchId: data.id);
  }

  /// Emits the selected duration.
  Future<void> emitDurationSelected(String duration) async {
    final input = state.listBookingInput.copyWith(duration: duration);
    emit(state.copyWith(listBookingInput: input));
  }

  /// Calls the API to fetch banner class type.
  callApiBannerClass() async {
    try {
      final map = {
        'key': keyType ?? '',
      };

      final bannerClassType = await fetchApi(
        () => _bookingRepository.bannerClassType(map),
        showLoading: false,
      );
      if (bannerClassType?.statusCode == ApiStatusCode.success &&
          bannerClassType?.data?.isNotEmpty == true) {
        emit(state.copyWith(bannerClassTypeOutput: bannerClassType));
      }
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    }
  }

  /// Checks if the book button should be enabled.
  bool isEnableButtonBook() {
    return state.listBookingInput.instrumentCode?.isNotEmpty == true &&
        state.listBookingInput.branchId != null;
  }

  /// Calls the API to book a practice session.
  Future<void> callApiBook({
    required Function(DataBooking?) onBookingSuccess,
    required Function(String) onBookingError,
    required Function(String) onBookingBlock,
  }) async {
    showEasyLoading();
    if (kDebugMode) {
      print(
          'state.listBookingInput: ${state.listBookingInput.toJsonBookPractice()}');
    }
    try {
      final bookingResult = await fetchApi(
        () => _bookingRepository
            .bookingPractice(state.listBookingInput.toJsonBookPractice()),
        showLoading: false,
      );
      if (bookingResult?.statusCode == ApiStatusCode.success) {
        final data = bookingResult?.data;
        if (bookingResult?.data == null) {
          onBookingError('error.noInformation'.tr());
          return;
        }
        if (language == 'en') {
          await _translateBookingData(data);
        }
        await listPiano(state.listBookingInput.startTime ?? '');
        LocalStream.shared.handleAction(RefreshAction.refreshPracticeList);
        emit(state.copyWith(
            listBookingInput:
                state.listBookingInput.copyWith(instrumentCode: '')));
        onBookingSuccess(data);
        hideEasyLoading();
      } else if (bookingResult?.statusCode == ApiStatusCode.blockBooking) {
        onBookingBlock(bookingResult?.message ?? '');
        hideEasyLoading();
      } else {
        final message = language == 'en'
            ? await ToolHelper.translateText(bookingResult?.message ?? '')
            : bookingResult?.message ?? '';
        onBookingError(message);
        await listPiano(state.listBookingInput.startTime ?? '');
        hideEasyLoading();
      }
    } catch (e) {
      onBookingError(isDebug ? e.toString() : MyString.messageError);
      await listPiano(state.listBookingInput.startTime ?? '');
      hideEasyLoading();
    }
  }

  bool _shouldReturnEarlyForBranches(dynamic branchesResult) {
    return branchesResult?.data?.isEmpty == true ||
        (branchesResult?.data?.isNotEmpty == true &&
            branchesResult?.data?.first.haveRoom == false &&
            branchesResult?.data?.length == 1);
  }

  /// Loads the initial data for the practice list.
  Future<void> loadInitialData() async {
    emit(state.copyWith(isInitialLoading: true));

    try {
      final data = {
        'key': keyType ?? '',
      };
      final results = await Future.wait([
        fetchApi(() => _bookingRepository.branchesV2(data), showLoading: false),
        fetchApi(() => _bookingRepository.currentWeek(data),
            showLoading: false),
        fetchApi(() => _bookingRepository.durations(), showLoading: false),
      ]);

      final branchesResult = results[0] as BranchesOutput?;
      final currentWeekResult = results[1] as CurrentWeekOutput?;
      final durations = results[2] as DurationsOutput?;

      if (_areResultsValid(branchesResult, currentWeekResult, durations)) {
        final updatedListBookingInput = await _createUpdatedListBookingInput(
            branchesResult, currentWeekResult, durations);

        await _translateDataIfNeeded(branchesResult, currentWeekResult);
        durations?.data?.insert(0, 0);

        emit(_createUpdatedState(branchesResult, currentWeekResult, durations,
            updatedListBookingInput));
      } else {
        String error = MyString.messageError;

        if (branchesResult?.statusCode != ApiStatusCode.success ||
            currentWeekResult?.statusCode != ApiStatusCode.success) {
          error = [
            if (branchesResult?.statusCode != ApiStatusCode.success)
              branchesResult?.message,
            if (currentWeekResult?.statusCode != ApiStatusCode.success)
              currentWeekResult?.message,
          ].where((msg) => msg != null).join(', ');
        }
        error = error.isNotEmpty ? error : MyString.messageError;
        _emitError(error);
      }
    } catch (e) {
      _emitError(isDebug ? e.toString() : MyString.messageError);
    }
  }

  /// Checks if the API results are valid.
  bool _areResultsValid(BranchesOutput? branchesResult,
      CurrentWeekOutput? currentWeekResult, DurationsOutput? durations) {
    return branchesResult?.statusCode == ApiStatusCode.success &&
        currentWeekResult?.statusCode == ApiStatusCode.success &&
        durations?.statusCode == ApiStatusCode.success &&
        durations?.data?.isNotEmpty == true &&
        branchesResult?.data?.isNotEmpty == true &&
        currentWeekResult?.data?.isNotEmpty == true;
  }

  /// Creates an updated list booking input.
  Future<ListBookingInput> _createUpdatedListBookingInput(
      BranchesOutput? branchesResult,
      CurrentWeekOutput? currentWeekResult,
      DurationsOutput? durations) async {
    final selectedBranchId = branchesResult?.data?.length == 1
        ? branchesResult?.data?.first.id
        : null;

    return state.listBookingInput.copyWith(
        branchId: selectedBranchId,
        classStartDate: currentWeekResult?.data?.first.fullDate ?? '',
        ip: await _networkManager.getIPAddress() ?? '',
        deviceId: await deviceIdApp() ?? '',
        platform: Platform.isAndroid ? 'android' : 'ios',
        duration: durations?.data?.first.toString() ?? '30');
  }

  /// Creates an updated state for the practice list.
  BookingPracticeListState _createUpdatedState(
      BranchesOutput? branchesResult,
      CurrentWeekOutput? currentWeekResult,
      DurationsOutput? durations,
      ListBookingInput updatedListBookingInput) {
    return state.copyWith(
      branches: branchesResult?.data,
      currentWeek: currentWeekResult?.data,
      isLoading: false,
      isInitialLoading: false,
      textEmptyPiano: branchesResult?.data?.length == 1
          ? (branchesResult?.data?.first.message?.isNotEmpty == true
              ? branchesResult?.data?.first.message
              : 'bookingPractice.pleaseSelectRoom'.tr())
          : 'bookingPractice.pleaseSelectRoom'.tr(),
      error: '',
      dataBranchSelected: branchesResult?.data?.length == 1
          ? branchesResult?.data?.first
          : null,
      listBookingInput: updatedListBookingInput,
      durationsOutput: durations,
    );
  }

  /// Refreshes the practice list.
  Future<void> refresh() async {
    callApiKeyPrivate();
  }

  /// Calls the API to fetch the private API key.
  Future<void> callApiKeyPrivate() async {
    final data = ApiKeyInput(
        keyRandom: injector<AppConfig>().keyRandom ?? '',
        appSunnyDay: injector<AppConfig>().appSunnyDay ?? '',
        apiUserPassword: injector<AppConfig>().apiUserPassword ?? '',
        apiUserId: injector<AppConfig>().apiUserId ?? '');
    try {
      final request = await authenRepository.keyPrivate(data);
      if (request.statusCode == ApiStatusCode.success) {
        if (request.data?.apiKeyPrivate?.isNotEmpty == true) {
          await localeManager.setObject(
              StorageKeys.apiKeyPrivate, request.data!.toJson());
          listPiano(state.listBookingInput.startTime ?? '');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// Calls the API to fetch the list of pianos.
  Future<void> listPiano(String startTime) async {
    if (startTime.isEmpty) {
      return;
    }
    final listPiano = await fetchApi(
        () => _bookingRepository.listPiano(state.listBookingInput),
        showLoading: true);
    if (kDebugMode) {
      print(
          'state.listBookingInput: ${state.listBookingInput.toJsonBookPractice()}');
    }
    if (listPiano?.statusCode == ApiStatusCode.success) {
      print('listPiano length: ${listPiano?.data?.length ?? 0}');
      emit(state.copyWith(
        listPianoOutput: listPiano,
        textEmptyPiano:
            listPiano?.data?.isEmpty == true ? 'error.noInformation'.tr() : '',
      ));
    } else {
      _emitError(listPiano?.message ?? MyString.messageError,
          textEmptyPiano: 'error.noInformation'.tr());
    }
  }

  /// Calls the API to fetch the durations.
  Future<void> callApiDurations() async {
    final durations = await fetchApi(() => _bookingRepository.durations(),
        showLoading: false);
    if (durations?.statusCode == ApiStatusCode.success) {
      emit(state.copyWith(durationsOutput: durations));
    }
  }

  /// Selects a piano by its ID.
  void selectPiano(String id) {
    emit(state.copyWith(
        listBookingInput: state.listBookingInput.copyWith(instrumentCode: id)));
  }

  /// Converts a list of pianos to a 2D array.
  List<List<DataPiano>> convertTo2DArray(List<DataPiano> data, int rows) {
    int columns = (data.length / rows).ceil();
    return List.generate(
        rows,
        (row) => data.sublist(
            row * columns,
            (row + 1) * columns > data.length
                ? data.length
                : (row + 1) * columns));
  }

  /// Emits the selected time.
  Future<void> emitTimeSelected(DateTime time) async {
    String formattedTime =
        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    emit(state.copyWith(
        listBookingInput: state.listBookingInput
            .copyWith(startTime: formattedTime, instrumentCode: '')));
    await listPiano(formattedTime);
  }

  /// Filters the practice list based on the selected date and branch.
  Future<void> filter(
      {String? dateSelected, int? branchId, bool? showLoading}) async {
    // if (state.listBookingInput.classStartDate == dateSelected || state.listBookingInput.branchId == branchId) {
    //   return;
    // }
    final updatedListBookingInput = state.listBookingInput.copyWith(
        branchId: branchId ?? state.listBookingInput.branchId,
        classStartDate: dateSelected ?? state.listBookingInput.classStartDate,
        instrumentCode: '');

    emit(state.copyWith(listBookingInput: updatedListBookingInput));

    try {
      await listPiano(state.listBookingInput.startTime ?? '');
    } catch (e) {
      _emitError(isDebug ? e.toString() : MyString.messageError);
    }
  }

  /// Emits an error state.
  void _emitError(String error, {String? textEmptyPiano}) {
    emit(state.copyWith(
      textEmptyPiano: textEmptyPiano ?? 'bookingPractice.pleaseSelectRoom'.tr(),
      error: error ?? '',
      isLoading: false,
      isInitialLoading: false,
    ));
  }

  @override
  Future<void> close() => super.close();

  @override
  void onWidgetCreated() {}

  /// Translates the booking data to the current language.
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

  /// Translates the data if needed based on the current language.
  Future<void> _translateDataIfNeeded(BranchesOutput? branchesResult,
      CurrentWeekOutput? currentWeekResult) async {
    if (language == 'en') {
      _translateBranches(branchesResult?.data);
      await _translateCurrentWeek(currentWeekResult?.data);
    }
  }

  /// Translates the branch data to the current language.
  void _translateBranches(List<DataInfoNameBooking>? branches) {
    branches?.forEach((branch) {
      branch.name = branch.name?.removeDiacritics();
      branch.fullAddress = branch.fullAddress?.removeDiacritics();
    });
  }

  /// Translates the current week data to the current language.
  Future<void> _translateCurrentWeek(List<DataCalendar>? currentWeek) async {
    if (currentWeek?.isNotEmpty == true) {
      final futures = currentWeek!.map((item) async {
        item.date = item.date?.convertDateFormatToEn();
        item.day = await ToolHelper.translateText(item.day ?? '');
      });

      await Future.wait(futures);
    }
  }

  /// Gets the booking success description text.
  String textBookingSuccessDes(DataBooking? dataBooking) {
    return [
      dataBooking?.textBookingCode,
      dataBooking?.textFullTime,
      dataBooking?.textBranch
    ].where((text) => text?.isNotEmpty == true).join('\n');
  }
}
