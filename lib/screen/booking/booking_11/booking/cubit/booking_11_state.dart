part of 'booking_11_cubit.dart';

class Booking11State extends Equatable {
  final BranchesOutput? branchesOutput;
  final DataInfoNameBooking? dataBranchSelected;
  final DataCoach? dataCoachSelected;
  final List<DataCalendar>? currentWeek;
  final DataCalendar? dataCalendarSelected;
  final SelectedTimeRange? selectedTimeRange;
  final List<DataTimeSlot>? timeSlots;
  final DataTimeSlot? timeSlotSelected;
  final DataBooking11Detail? dataBooking11Input;
  final String? error;

  const Booking11State(
      {this.branchesOutput,
      this.dataBranchSelected,
      this.dataCoachSelected,
      this.currentWeek,
      this.selectedTimeRange,
      this.timeSlots,
      this.timeSlotSelected,
      this.dataCalendarSelected,
      this.dataBooking11Input,
      this.error});

  @override
  List<Object?> get props => [
        branchesOutput,
        dataBranchSelected,
        dataCalendarSelected,
        dataCoachSelected,
        currentWeek,
        selectedTimeRange,
        timeSlots,
        timeSlotSelected,
        dataBooking11Input,
        error
      ];

  Booking11State copyWith({
    BranchesOutput? branchesOutput,
    DataInfoNameBooking? dataBranchSelected,
    DataCoach? dataCoachSelected,
    List<DataCalendar>? currentWeek,
    SelectedTimeRange? selectedTimeRange,
    List<DataTimeSlot>? timeSlots,
    DataTimeSlot? timeSlotSelected,
    DataCalendar? dataCalendarSelected,
    DataBooking11Detail? dataBooking11Input,
    String? error,
  }) {
    return Booking11State(
        branchesOutput: branchesOutput ?? this.branchesOutput,
        dataBranchSelected: dataBranchSelected ?? this.dataBranchSelected,
        dataCalendarSelected: dataCalendarSelected ?? this.dataCalendarSelected,
        dataCoachSelected: dataCoachSelected ?? this.dataCoachSelected,
        currentWeek: currentWeek ?? this.currentWeek,
        selectedTimeRange: selectedTimeRange ?? this.selectedTimeRange,
        timeSlots: timeSlots ?? this.timeSlots,
        timeSlotSelected: timeSlotSelected ?? this.timeSlotSelected,
        dataBooking11Input: dataBooking11Input ?? this.dataBooking11Input,
        error: error ?? this.error);
  }
}
