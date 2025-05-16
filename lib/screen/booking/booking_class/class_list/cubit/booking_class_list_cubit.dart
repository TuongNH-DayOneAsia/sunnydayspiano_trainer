import 'dart:async';

import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/data/network/model/input/list_booking_input.dart';
import 'package:myutils/data/network/model/output/api_key_output.dart';
import 'package:myutils/data/network/model/output/branches_output.dart';
import 'package:myutils/data/network/model/output/contracts/booking_class_type_v5_output.dart';
import 'package:myutils/data/network/model/output/currrent_week_output.dart';
import 'package:myutils/data/network/model/output/list_class_output.dart';
import 'package:myutils/data/repositories/booking_repository.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:easy_localization/easy_localization.dart';

import 'booking_class_list_state.dart';

class BookingClassListCubit extends WidgetCubit<BookingClassListState> {
  final Items? data;

  BookingClassListCubit(this.data) : super(widgetState: const BookingClassListState());

  final BookingRepository _bookingRepository = injector();

  ListBookingInput _listBookingInput = ListBookingInput(page: 1, limit: 10);

  String get textRequestClassLesson =>
      localeManager
          .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
          ?.textRequestClassLesson ??
      '';

  Future<void> emitIndexBranchSelected(DataInfoNameBooking data) async {
    emit(state.copyWith(dataBranchSelected: data));
    filter(branchId: data.id);
  }

  Future<void> refreshListClass() async {
    EventBus.shared.refreshClassList = () {
      filter(showLoading: false);
    };
  }

  String textEmpty() {
    final branches = state.branchesOutput?.data ?? [];
    const defaultMessage = 'Chưa có thông tin chi nhánh!';
    if (branches.isNotEmpty == true &&
        (branches.length == 1 && branches.first.haveRoom == false)) {
      return branches.first.message ?? defaultMessage;
    }

    return state.listBookingOutput?.message ?? 'bookingClass.classInfoNotAvailable'.tr();
  }

  Future<void> callApiClassLessonRequestChange(
      {required String classLessonCode, required Function() onSuccess}) async {
    try {
      final result = await fetchApi(
        () => _bookingRepository
            .classLessonRequestChange({'class_lesson_code': classLessonCode}),
        showLoading: false,
      );
      if (result?.statusCode == ApiStatusCode.success) {
        updateListStatus(classLessonCode);
        onSuccess();
      }
    } catch (e) {
      emit(state.copyWith(
          error: isDebug ? e.toString() : MyString.messageError));
    }
  }

  void updateListStatus(String bookingCode) {
    final listClass = state.listBookingOutput?.listClass;
    if (listClass == null) return;

    final index =
        listClass.indexWhere((item) => item.classLessonCode == bookingCode);
    if (index == -1) return;

    final updatedListClass = List<DataClass>.from(listClass);
    updatedListClass[index] =
        listClass[index].copyWith(isRequestClassLesson: true);
    emit(state.copyWith(
        listBookingOutput:
            state.listBookingOutput?.copyWith(listClass: updatedListClass)));
  }

  bool canChooseBranch() {
    return (state.branchesOutput?.data?.length ?? 0) > 1;
  }

  //bannerClassType
  callApiBannerClass() async {
    try {
      final map = {
        'key': data?.key ?? 'CLASS',
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

  bool _isValidInitialData(
      BranchesOutput? branchesResult, CurrentWeekOutput? currentWeekResult) {
    return branchesResult?.statusCode == ApiStatusCode.success &&
        currentWeekResult?.statusCode == ApiStatusCode.success &&
        branchesResult?.data?.isNotEmpty == true &&
        currentWeekResult?.data?.isNotEmpty == true;
  }

  Future<void> _processLanguageSpecificData(BranchesOutput? branchesResult,
      CurrentWeekOutput? currentWeekResult) async {
    if (language == 'en') {
      branchesResult?.data?.forEach((branch) {
        branch.name = branch.name?.removeDiacritics();
        branch.fullAddress = branch.fullAddress?.removeDiacritics();
      });

      final futures = currentWeekResult?.data?.map((item) async {
            item.date = item.date?.convertDateFormatToEn();
            item.day = await ToolHelper.translateText(item.day ?? '');
          }).toList() ??
          [];

      await Future.wait(futures);
    }
  }


  Future<void> loadInitialDataV2() async {
    emit(state.copyWith(isInitialLoading: true));
    try {
      final data = {'key': this.data?.key ?? 'CLASS', 'slug_contract': this.data?.slugContract ?? ''};
      final results = await _fetchInitialData(data);
      final (branchesResult, currentWeekResult) = results;

      if (_shouldReturnEarlyForBranches(branchesResult)) {
        _emitInitialState(branchesResult, currentWeekResult);
        return;
      }

      if (!_isValidInitialData(branchesResult, currentWeekResult)) {
        _handleInvalidData(branchesResult, currentWeekResult);
        return;
      }

      await _processValidData(branchesResult, currentWeekResult);
    } catch (e) {
      _emitError(isDebug ? e.toString() : MyString.messageError);
    }
  }

  Future<(dynamic, dynamic)> _fetchInitialData(Map<String, String> data) async {
    final branchesResult = await fetchApi(
        () => _bookingRepository.branchesV2(data),
        showLoading: false);
    final currentWeekResult = await fetchApi(
        () => _bookingRepository.currentWeek(data),
        showLoading: false);
    return (branchesResult, currentWeekResult);
  }

  bool _shouldReturnEarlyForBranches(dynamic branchesResult) {
    return branchesResult?.data?.isEmpty == true ||
        (branchesResult?.data?.isNotEmpty == true &&
            branchesResult?.data?.first.haveRoom == false &&
            branchesResult?.data?.length == 1);
  }

  void _emitInitialState(dynamic branchesResult, dynamic currentWeekResult) {
    // dataBranchSelected:
    //           selectedBranchId != null ? branchesResult?.data?.first : null,
    emit(state.copyWith(
      branchesOutput: branchesResult,
      currentWeek: currentWeekResult?.data,
      isLoading: false,
      isInitialLoading: false,
      dataBranchSelected: branchesResult?.data?.length == 1 ? branchesResult?.data?.first: null,
    ));
  }

  Future<void> _processValidData(
      dynamic branchesResult, dynamic currentWeekResult) async {
    final isSingleValidBranch = branchesResult?.data?.length == 1 &&
        branchesResult?.data?.first.haveRoom == true;

    final selectedBranchId =
        isSingleValidBranch ? branchesResult?.data?.first.id : null;

    _listBookingInput = _listBookingInput.copyWith(
      branchId: selectedBranchId,
      classStartDate: currentWeekResult?.data?.first.fullDate ?? '',
    );

    final listBookingResult = isSingleValidBranch
        ? await _fetchListBooking(showLoading: false, isInitialFetch: true)
        : ListClassOutput(listClass: []);

    _processLanguageSpecificData(branchesResult, currentWeekResult);

    emit(state.copyWith(
      branchesOutput: branchesResult,
      currentWeek: currentWeekResult?.data,
      isLoading: false,
      isInitialLoading: false,
      dataBranchSelected:
          selectedBranchId != null ? branchesResult?.data?.first : null,
      listBookingOutput: listBookingResult,
    ));
  }

  void _handleInvalidData(dynamic branchesResult, dynamic currentWeekResult) {
    final errorMessages = [
      if (branchesResult?.statusCode != ApiStatusCode.success)
        branchesResult?.message,
      if (currentWeekResult?.statusCode != ApiStatusCode.success)
        currentWeekResult?.message,
    ].where((msg) => msg != null).join(', ');

    final error =
        errorMessages.isNotEmpty ? errorMessages : MyString.messageError;
    _emitError(error);
  }

  String convertDateFormat(String inputDate) {
    List<String> parts = inputDate.split('/');
    if (parts.length != 2) {
      throw const FormatException('Invalid date format');
    }
    return '${parts[1]}/${parts[0]}';
  }

  Future<ListClassOutput> _fetchListBooking({
    required bool showLoading,
    int? millisecondsDelay,
    bool isInitialFetch = false,
  }) async {
    if (!isInitialFetch && state.dataBranchSelected == null) {
      return ListClassOutput(listClass: []);
    }

    final result = await fetchApi(
      () => _bookingRepository.listBookingClass(_listBookingInput.toJson()),
      showLoading: showLoading,
      millisecondsDelay: millisecondsDelay ?? 500,
    );

    if (result == null) {
      throw Exception(MyString.messageError);
    }

    if (result.statusCode == ApiStatusCode.success) {
      if (language == 'en') {
        result.listClass =
            await Future.wait(result.listClass?.map((item) async {
                  item.branch?.name = item.branch?.name?.removeDiacritics();
                  item.textIsBook =
                      await ToolHelper.translateText(item.textIsBook ?? '');
                  return item;
                }) ??
                []);
      }
      return result;
    }
    throw Exception(MyString.messageError);
  }

  Future<void> filter(
      {String? dateSelected, int? branchId, bool? showLoading}) async {
    if (_listBookingInput.classStartDate == dateSelected ||
        (branchId != null && _listBookingInput.branchId == branchId)) {
      return;
    }
    _listBookingInput = _listBookingInput.copyWith(
      branchId: branchId ?? _listBookingInput.branchId,
      classStartDate: dateSelected ?? _listBookingInput.classStartDate,
      page: 1, // Reset page to 1 when filtering
    );
    if (kDebugMode) {
      print('filter date: ${_listBookingInput.classStartDate}');
      print('filter branch: ${_listBookingInput.branchId}');
    }
    emit(state.copyWith(isLoading: true));
    try {
      final listBookingResult = await _fetchListBooking(
          showLoading: showLoading ?? true, millisecondsDelay: 1000);
      emit(state.copyWith(
        listBookingOutput: listBookingResult,
        isLoading: false,
      ));
    } catch (e) {
      _emitError(isDebug ? e.toString() : MyString.messageError);
    }
  }

  void _emitError(String error) {
    emit(state.copyWith(
      error: error,
      isLoading: false,
      isInitialLoading: false,
    ));
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore) return;

    final numberCurrentPage =
        state.listBookingOutput?.pagination?.currentPage ?? 0;
    final numberTotalPage = state.listBookingOutput?.pagination?.totalPage ?? 0;

    if (numberCurrentPage < numberTotalPage) {
      emit(state.copyWith(isLoadingMore: true)); // Set isLoadingMore to true

      try {
        _listBookingInput =
            _listBookingInput.copyWith(page: numberCurrentPage + 1);
        final newListBookingResult =
            await _fetchListBooking(showLoading: false);
        if (newListBookingResult.listClass != null &&
            newListBookingResult.listClass!.isNotEmpty) {
          final updatedListBooking = [
            ...state.listBookingOutput!.listClass!,
            ...newListBookingResult.listClass!
          ];

          final updatedListBookingOutput = state.listBookingOutput!.copyWith(
            listClass: updatedListBooking,
            pagination: newListBookingResult.pagination,
          );

          emit(state.copyWith(
              listBookingOutput: updatedListBookingOutput,
              isLoadingMore: false // Set isLoadingMore back to false
              ));
        } else {
          emit(state.copyWith(
              isLoadingMore: false)); // Set isLoadingMore back to false
        }
      } catch (e) {
        emit(state.copyWith(
            error: isDebug ? e.toString() : MyString.messageError,
            isLoadingMore:
                false // Set isLoadingMore back to false even on error
            ));
      }
    }

    if (kDebugMode) {
      print('numberCurrentPage $numberCurrentPage');
      print('numberTotalPage $numberTotalPage');
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }

  @override
  void onWidgetCreated() {
    // TODO: implement onWidgetCreated
  }
}
