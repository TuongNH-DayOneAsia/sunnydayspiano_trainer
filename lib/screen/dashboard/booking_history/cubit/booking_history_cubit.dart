import 'dart:developer' as developer;

import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/model/input/list_history_input.dart';
import 'package:myutils/data/network/model/output/history_booking_output.dart';
import 'package:myutils/data/network/model/output/list_class_output.dart';
import 'package:myutils/data/network/model/output/status_history_output.dart';
import 'package:myutils/data/repositories/booking_repository.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';

part 'booking_history_state.dart';

enum ClassType { CLASS, CLASS_PRACTICE, ONE_PRIVATE, ONE_GENERAL,P1P2,TRIAL }

class BookingHistoryCubit extends WidgetCubit<BookingHistoryState> {
  BookingHistoryCubit() : super(widgetState: const BookingHistoryState());
  final BookingRepository _bookingRepository = injector();

  ListHistoryInput listHistoryInput =
      ListHistoryInput(page: 1, limit: 10, statusBooking: -1, classType: ClassType.CLASS_PRACTICE);



  @override
  void onWidgetCreated() {
    loadInitialData();
    // TODO: implement onWidgetCreated
  }

  Future<void> loadInitialData() async {
    final stopwatch = Stopwatch()..start();
    developer.log('Starting loadInitialData');

    if (isClosed) return;
    // emit(state.copyWith(isInitialLoading: true));

    try {
      developer.log('Starting fetchApi statusHistory');
      // var classType = await fetchApi(() => _bookingRepository.classType(), showLoading: false);
      var statusHistory = await fetchApi(() => _bookingRepository.statusHistory(), showLoading: false);
      developer.log('Finished fetchApi statusHistory: ${stopwatch.elapsedMilliseconds}ms');

      if (isClosed) return;

      if (statusHistory?.statusCode == ApiStatusCode.success && statusHistory?.data?.isNotEmpty == true) {
        developer.log('Starting _fetchListHistoryBooking');
        final listBookingResult = await _fetchListHistoryBooking(showLoading: false);
        developer.log('Finished _fetchListHistoryBooking: ${stopwatch.elapsedMilliseconds}ms');

        if (language == 'en' && statusHistory?.data?.isNotEmpty == true) {
          developer.log('Starting translation of statusHistory');
          for (var item in statusHistory?.data ?? []) {
            item.name = await ToolHelper.translateText(item.name ?? '');
          }
          developer.log('Finished translation of statusHistory: ${stopwatch.elapsedMilliseconds}ms');
        }

        developer.log('Starting getListHistory');
        final listHistoryBooking = await getListHistory(listFromApi: listBookingResult.data?.rows ?? []);
        developer.log('Finished getListHistory: ${stopwatch.elapsedMilliseconds}ms');

        emit(state.copyWith(
          listHistoryStatus: statusHistory?.data,
          listHistoryBooking: listHistoryBooking,
          isLoading: false,
          error: '',
          msgEmpty: listBookingResult.message ?? '',
          isInitialLoading: false,
          pagination: listBookingResult.data?.pagination,
        ));
        developer.log('New state emitted: ${stopwatch.elapsedMilliseconds}ms');
      } else {
        if (isClosed) return;
        _emitError('No history information available!');
        developer.log('Error emitted: No history information available!');
      }
    } catch (e) {
      if (isClosed) return;
      _emitError(isDebug
          ? e.toString()
          : isDebug
              ? e.toString()
              : MyString.messageError);
      developer.log('Error emitted: ${MyString.messageError}. Details: $e');
    }

    stopwatch.stop();
    developer.log('Total execution time of loadInitialData: ${stopwatch.elapsedMilliseconds}ms');
  }

  Future<void> filter({int? status, bool? showLoading}) async {
    if (listHistoryInput.statusBooking == status) {
      return;
    }

    listHistoryInput = listHistoryInput.copyWith(
      statusBooking: status,

      page: 1, // Reset page to 1 when filtering
    );

    emit(state.copyWith(isLoading: true));
    try {
      final listBookingResult = await _fetchListHistoryBooking(showLoading: showLoading ?? true, millisecondsDelay: 1000);
      emit(state.copyWith(
        msgEmpty: listBookingResult.message ?? '',
        pagination: listBookingResult.data?.pagination,
        listHistoryBooking: await getListHistory(listFromApi: listBookingResult.data?.rows ?? []),
        isLoading: false,
      ));
      final listHistoryBooking = getListHistory(listFromApi: listBookingResult.data?.rows ?? []);
      if (kDebugMode) {
        print('listHistoryBooking $listHistoryBooking');
      }
    } catch (e) {
      _emitError(isDebug ? e.toString() : MyString.messageError);
    }
  }

  Future<List<DataHistoryMain>> getListHistory({List<DataHistoryBooking>? listFromApi}) async {
    final stopwatch = Stopwatch()..start();

    developer.log('Starting getListHistory');

    Map<String, List<DataHistoryBooking>> groupedByDay = {};
    List<Future<void>> translationFutures = [];

    developer.log('Starting grouping and creating translation Futures');
    for (DataHistoryBooking item in listFromApi ?? []) {
      String key = item.key ?? '';
      if (!groupedByDay.containsKey(key)) {
        groupedByDay[key] = [];
      }
      groupedByDay[key]!.add(item);

      if (language == 'en') {
        item.classLessonStartDate = item.classLessonStartDate?.convertDateFormatToEn();
        item.branchName = item.branchName?.removeDiacritics();
        translationFutures.add(translateItem(item));
      }
    }
    developer.log('Finished grouping and creating translation Futures: ${stopwatch.elapsedMilliseconds}ms');

    if (language == 'en') {
      developer.log('Starting translation');
      await Future.wait(translationFutures);
      developer.log('Finished translation: ${stopwatch.elapsedMilliseconds}ms');
    }

    developer.log('Starting to create result list');
    final result = groupedByDay.entries.map((entry) {
      String header = language == 'en' ? entry.key : (entry.value.isNotEmpty ? entry.value.first.dayOfWeek ?? '' : '');

      return DataHistoryMain(
        header: header,
        listSub: entry.value,
      );
    }).toList();
    developer.log('Finished creating result list: ${stopwatch.elapsedMilliseconds}ms');

    stopwatch.stop();
    developer.log('Total execution time of getListHistory: ${stopwatch.elapsedMilliseconds}ms');

    return result;
  }

  Future<HistoryBookingOutput> _fetchListHistoryBooking({required bool showLoading, int? millisecondsDelay}) async {
    if (kDebugMode) {
      print('_listHistoryInput ${listHistoryInput.toJson()}');
    }
    final result = await fetchApi(
        () => _bookingRepository.histories(
              listHistoryInput,
            ),
        showLoading: showLoading,
        millisecondsDelay: millisecondsDelay ?? 500);

    if (result?.statusCode == ApiStatusCode.success) {
      return result!;
    }
    throw Exception(MyString.messageError);
  }

  Future<void> translateItem(DataHistoryBooking item) async {
    final itemStopwatch = Stopwatch()..start();
    final translations = await Future.wait([
      ToolHelper.translateText(item.classTypeName ?? ''),
      ToolHelper.translateText(item.coach ?? ''),
      ToolHelper.translateText(item.statusBookingText ?? ''),
      ToolHelper.translateText(item.statusInClassText ?? ''),
      ToolHelper.translateText(item.instrumentStartEndTime ?? ''),
    ]);

    item.classTypeName = translations[0];
    item.coach = translations[1];
    item.statusBookingText = translations[2];
    item.statusInClassText = translations[3];
    item.instrumentStartEndTime = translations[4];
    itemStopwatch.stop();
    developer.log('Thời gian dịch một item: ${itemStopwatch.elapsedMilliseconds}ms');
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

    final numberCurrentPage = state.pagination?.currentPage ?? 0;
    final numberTotalPage = state.pagination?.totalPage ?? 0;

    if (numberCurrentPage < numberTotalPage) {
      emit(state.copyWith(isLoadingMore: true));
      try {
        listHistoryInput = listHistoryInput.copyWith(page: numberCurrentPage + 1);
        final newListBookingResult = await _fetchListHistoryBooking(showLoading: false);
        if (newListBookingResult.data?.rows != null && newListBookingResult.data?.rows?.isNotEmpty == true) {
          final List<DataHistoryMain> newItems = await getListHistory(listFromApi: newListBookingResult.data?.rows ?? []);
          final List<DataHistoryMain> updatedListBooking = mergeHistoryLists(state.listHistoryBooking ?? [], newItems);

          emit(
            state.copyWith(
                listHistoryBooking: updatedListBooking, pagination: newListBookingResult.data?.pagination, isLoadingMore: false),
          );
        } else {
          emit(state.copyWith(isLoadingMore: false));
        }
      } catch (e) {
        emit(
          state.copyWith(error: isDebug ? e.toString() : MyString.messageError, isLoadingMore: false),
        );
      }
    }

    if (kDebugMode) {
      print('numberCurrentPage $numberCurrentPage');
      print('numberTotalPage $numberTotalPage');
    }
  }

  List<DataHistoryMain> mergeHistoryLists(List<DataHistoryMain> existingList, List<DataHistoryMain> newList) {
    Map<String, DataHistoryMain> mergedMap = {};

    for (var item in existingList) {
      mergedMap[item.header ?? ''] = item;
    }
    for (var newItem in newList) {
      if (mergedMap.containsKey(newItem.header)) {
        mergedMap[newItem.header]?.listSub?.addAll(newItem.listSub ?? []);
      } else {
        mergedMap[newItem.header ?? ''] = newItem;
      }
    }
    return mergedMap.values.toList();
  }

}
