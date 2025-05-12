import 'dart:io';

import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/model/input/list_time_booking_11_input.dart';
import 'package:myutils/data/network/model/output/booking_11/booking_11_detail_output.dart';
import 'package:myutils/data/network/model/output/booking_11/booking_11_output.dart';
import 'package:myutils/data/network/model/output/booking_11/coaches_output.dart';
import 'package:myutils/data/network/model/output/booking_11/contracts_output.dart';
import 'package:myutils/data/network/model/output/booking_11/list_time_11_output.dart';
import 'package:myutils/data/network/model/output/branches_output.dart';
import 'package:myutils/data/network/model/output/currrent_week_output.dart';
import 'package:myutils/data/network/model/output/list_class_output.dart';
import 'package:myutils/data/network/network_manager.dart';
import 'package:myutils/data/repositories/booking_repository.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';

import 'data/data_booking_11.dart';
import 'package:myutils/data/network/model/output/contracts/booking_class_type_v5_output.dart'
as DataContractV5;
part 'booking_11_state.dart';

enum TimeSection { morning, afternoon, evening }

class Booking11Cubit extends WidgetCubit<Booking11State> {
  final DataContractV5.Items? data;

  Booking11Cubit({this.data})
      : super(widgetState: const Booking11State());
  final BookingRepository _bookingRepository = injector();
  TimeSection selectedSection = TimeSection.morning;
  DateTime? _lastTapTime;
  String? startTime;
  String? endTime;
  final NetworkManager _networkManager = injector();

  String ip = '';
  String deviceId = '';
  @override
  void onWidgetCreated() {
    // TODO: implement onWidgetCreated
  }
  String textBookingSuccessDes(DataBooking11? dataBooking) {
    return [
      dataBooking?.textBookingCode,
      dataBooking?.textFullTime,
      dataBooking?.textBranch
    ].where((text) => text?.isNotEmpty == true).join('\n');
  }
  //booking
  Future<void> booking({
    required Function(DataBooking11? data) onBookingSuccess,
    required Function(String) onBookingError,
    required Function(String) onBookingBlock,
  }) async {
    //call api booking11
    if (kDebugMode) {
      print('getDataBooking11Input()  ${getDataBooking11Input().bookingToJson()}');
    }
    try {
      final bookingResult = await fetchApi(
              () => _bookingRepository.booking11(getDataBooking11Input()),
          showLoading: true);
      if (bookingResult?.statusCode == ApiStatusCode.success) {
        final data = bookingResult?.data;
        EventBus.shared.handleAction(RefreshAction.refreshBooking11List);
        onBookingSuccess(data);
        // hideEasyLoading();
      } else if (bookingResult?.statusCode == ApiStatusCode.blockBooking) {
        onBookingBlock(bookingResult?.message ?? '');
        // hideEasyLoading();
      } else {
        EventBus.shared.refreshBooking11List();
        final message = language == 'en'
            ? await ToolHelper.translateText(bookingResult?.message ?? '')
            : bookingResult?.message ?? '';
        EventBus.shared.refreshDataInHome();
        onBookingError(message);
        // hideEasyLoading();
      }
    } catch (e) {
      EventBus.shared.refreshDataInHome();
      onBookingError(e.toString());
      // emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  //emit dataCalendarSelected
  Future<void> emitDataCalendarSelected({DataCalendar? data}) async {
    emit(state.copyWith(
      dataCalendarSelected: data,
      timeSlotSelected: DataTimeSlot(),
      selectedTimeRange: SelectedTimeRange(startTime: '', endTime: ''),
      timeSlots: [],
    ));
    await listTimeBooking11();
  }

  void resetAllSelections(List<DataTimeSlot> updatedSlots) {
    updatedSlots = updatedSlots
        .map((slot) => DataTimeSlot(
            time: slot.time,
            isSelected: false,
            isActive: slot.isActive,
            isBooked: slot.isBooked))
        .toList();
    emit(state.copyWith(
        timeSlots: updatedSlots, timeSlotSelected: timeSlotDefault()));
  }

  DataTimeSlot timeSlotDefault() {
    return DataTimeSlot(time: '', isSelected: false, isActive: false);
  }

  Future<void> loadInitialData() async {
    try {
      final data = {
        'key': this.data?.key ?? '',
        'slug_contract': this.data?.slugContract ?? '',
      };
      final results = await fetchApi(() => _bookingRepository.branchesV2(data), showLoading: false);

      if (results?.statusCode == ApiStatusCode.success && results?.data?.isNotEmpty == true) {
        final branch = results?.data?.length == 1 ? results?.data?.first : null;
        emit(state.copyWith(
          branchesOutput: results,
          dataBranchSelected: branch,
        ));

        ip = await _networkManager.getIPAddress() ?? '';
        deviceId = await deviceIdApp() ?? '';
      }else{
        emit(state.copyWith(
          branchesOutput: results,
        ));
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // call api current week
  Future<void> loadCurrentWeek() async {
    final data = {
      'key': this.data?.key ?? '',
    };
    try {
      final results = await fetchApi(() => _bookingRepository.currentWeek(data),
          showLoading: false);
      if (results?.statusCode == ApiStatusCode.success &&
          results?.data?.isNotEmpty == true) {
        emit(
          state.copyWith(
            currentWeek: results?.data,
            dataCalendarSelected: results?.data?.first,
            // timeSlots: getTimeSlots(),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> listTimeBooking11({bool showLoading = true}) async {
    try {
      final data = ListTimeBooking11Input(
          branchId: state.dataBranchSelected?.id,
          coachSlug: state.dataCoachSelected?.slug,
          currentDate: state.dataCalendarSelected?.fullDate,
          key: this.data?.key);
      final results = await fetchApi(
          () => _bookingRepository.listTimeBooking11(data),
          showLoading: showLoading,
          millisecondsDelay: 500);
      if (results?.statusCode == ApiStatusCode.success &&
          results?.data?.isNotEmpty == true) {
        emit(state.copyWith(timeSlots: results?.data ?? []));
        for (DataTimeSlot item in results?.data ?? []) {
          print(
              'timeSlot.time: ${item.time} - isActive ${item.isActive} - isBooked${item.isBooked}');
        }
      } else {
        emit(
          state.copyWith(
            error: results?.message ?? 'Không có khung giờ nào',
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  //emitIndexBranchSelected
  void emitIndexBranchSelected(DataInfoNameBooking? data) {
    emit(state.copyWith(
      dataBranchSelected: data,
      selectedTimeRange: SelectedTimeRange(startTime: '', endTime: ''),
      dataCoachSelected: DataCoach(),
      timeSlotSelected: DataTimeSlot(),
      timeSlots: [],
    ));
  }

  DataBooking11Detail getDataBooking11Input() {
    return DataBooking11Detail(
      dataBranchSelected: state.dataBranchSelected,
      dataCoachSelected: state.dataCoachSelected,
      durationString: '1 tiếng',
      currentDateDisplay:
          state.dataCalendarSelected?.fullDate?.convertDateFormat(),
      currentDate: state.dataCalendarSelected?.fullDate,
      startTime: state.selectedTimeRange?.startTime,
      endTime: state.selectedTimeRange?.endTime,
      key: data?.key,
      duration: 60,
      ip: ip ?? '',
      deviceId: deviceId ?? '',
      platform: Platform.isAndroid ? 'android' : 'ios',
      contractSlug: data?.slugContract ?? '',
    );
  }

  //emitIndexCoachSelected
  Future<void> emitIndexCoachSelected(DataCoach data) async {
    emit(state.copyWith(
      dataCoachSelected: data,
      selectedTimeRange: SelectedTimeRange(startTime: '', endTime: ''),
      timeSlotSelected: DataTimeSlot(),
      timeSlots: [],
    ));
    await listTimeBooking11();
  }

  // emitSelectedTimeRange
  void emitSelectedTimeRange({required SelectedTimeRange data}) {
    emit(state.copyWith(selectedTimeRange: data));
  }

  //clear SelectedTimeRange
  void clearSelectedTimeRange() {
    emit(
      state.copyWith(
        selectedTimeRange: SelectedTimeRange(startTime: '', endTime: ''),
      ),
    );
  }

  bool isEnableButton() {
    return state.timeSlotSelected?.time?.isNotEmpty == true;
  }

  void toggleSelection({
    required Function() onBookedSlot,
    required Function() onInsufficientTime,
    required Function() onOverlappingBooking,
    required Function(SelectedTimeRange) onTimeRangeSelected,
    required Function() onClearSelection,
    required int index,
  }) {
    if (state.timeSlots == null) return;
    List<DataTimeSlot> updatedSlots = List.from(state.timeSlots!);

    // Helper function to reset all selections
    if (updatedSlots[index].isBooked == true) {
      resetAllSelections(updatedSlots);
      onBookedSlot();
      return;
    }
    if (updatedSlots[index].isActive == false) {
      resetAllSelections(updatedSlots);
      // onBookedSlot();
      return;
    }

    int startIndex = index;
    int endIndex = startIndex + 3;

    if (endIndex >= state.timeSlots!.length) {
      resetAllSelections(updatedSlots);
      onInsufficientTime();
      return;
    }

    bool hasBookedSlot = state.timeSlots!
        .getRange(startIndex, endIndex + 1)
        .any((slot) => slot.isActive == false);

    if (hasBookedSlot) {
      resetAllSelections(updatedSlots);
      onOverlappingBooking();
      return;
    }

    if (updatedSlots[index].isSelected == true) {
      updatedSlots[index] = DataTimeSlot(
        time: updatedSlots[index].time,
        isSelected: false,
        isBooked: updatedSlots[index].isBooked,
        isActive: updatedSlots[index].isActive,
      );
      emit(state.copyWith(
          timeSlots: updatedSlots,
          timeSlotSelected: timeSlotDefault() // Reset when unselecting
          ));
    } else {
      updatedSlots = updatedSlots
          .map((slot) => DataTimeSlot(
              time: slot.time,
              isSelected: slot.time == updatedSlots[index].time,
              isBooked: slot.isBooked,
              isActive: slot.isActive))
          .toList();
      emit(
        state.copyWith(
            selectedTimeRange: SelectedTimeRange(
                startTime: updatedSlots[index].time ?? '',
                endTime: updatedSlots[index + 3].time ?? ''),
            timeSlots: updatedSlots,
            timeSlotSelected: updatedSlots[index] // Set selected slot
            ),
      );
      print(updatedSlots[index].time ?? '');
      print(updatedSlots[index + 3].time ?? '');
      print('selectedTimeRange: ${state.selectedTimeRange}');
    }
  }
}
