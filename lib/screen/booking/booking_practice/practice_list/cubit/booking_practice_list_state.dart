part of 'booking_practice_list_cubit.dart';

class BookingPracticeListState extends Equatable {
  final String? error;
  final bool isInitialLoading;
  final bool isLoading;
  final DataInfoNameBooking? dataBranchSelected;
  final List<DataInfoNameBooking>? branches;
  final List<DataCalendar>? currentWeek;
  final ListPianoOutput? listPianoOutput;
  final String? textEmptyPiano;
  final ListBookingInput listBookingInput;
  final BannerClassTypeOutput? bannerClassTypeOutput;
  final DurationsOutput? durationsOutput;

  BookingPracticeListState({
    this.branches,
    this.currentWeek,
    this.error,
    this.isLoading = false,
    this.isInitialLoading = false,
    this.dataBranchSelected,
    this.listPianoOutput,
    this.durationsOutput,
    this.bannerClassTypeOutput,
    String? textEmptyPiano,
    ListBookingInput? listBookingInput,
  })  : textEmptyPiano = textEmptyPiano ?? 'bookingPractice.pleaseSelectRoom'.tr(),
        listBookingInput = listBookingInput ?? ListBookingInput(page: 1, limit: 10);

  BookingPracticeListState copyWith({
    List<DataInfoNameBooking>? branches,
    List<DataCalendar>? currentWeek,
    String? error,
    bool? isLoading,
    bool? isInitialLoading,
    bool? isLoadingMore,
    DataInfoNameBooking? dataBranchSelected,
    ListPianoOutput? listPianoOutput,
    String? textEmptyPiano,
    ListBookingInput? listBookingInput,
    DurationsOutput? durationsOutput,
    BannerClassTypeOutput? bannerClassTypeOutput,
  }) {
    return BookingPracticeListState(
      branches: branches ?? this.branches,
      currentWeek: currentWeek ?? this.currentWeek,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      dataBranchSelected: dataBranchSelected ?? this.dataBranchSelected,
      listPianoOutput: listPianoOutput ?? this.listPianoOutput,
      textEmptyPiano: textEmptyPiano ?? this.textEmptyPiano,
      listBookingInput: listBookingInput ?? this.listBookingInput,
      durationsOutput: durationsOutput ?? this.durationsOutput,
      bannerClassTypeOutput: bannerClassTypeOutput ?? this.bannerClassTypeOutput,
    );
  }

  @override
  List<Object?> get props => [
        branches,
        currentWeek,
        error,
        isLoading,
        isInitialLoading,
        dataBranchSelected,
        listPianoOutput,
        textEmptyPiano,
        listBookingInput,
        durationsOutput,
        bannerClassTypeOutput,
      ];

// @override
// CachedWidgetState? fromJson(Map<String, dynamic> json) {
//
//   return PracticeListState(
//     branches: json['branches'] != null
//         ? (json['branches'] as List).map((e) => DataInfoNameBooking.fromJson(e)).toList()
//         : null,
//     currentWeek: json['currentWeek'] != null
//         ? (json['currentWeek'] as List).map((e) => DataCalendar.fromJson(e)).toList()
//         : null,
//     error: json['error'] != null ? json['error'] as String : null,
//     isLoading: json['isLoading']!= null ? json['isLoading'] as bool : false,
//     isInitialLoading: json['isInitialLoading'] != null ? json['isInitialLoading'] as bool : false,
//     // dataBranchSelected: json['dataBranchSelected'] != null
//     //     ? DataInfoNameBooking.fromJson(json['dataBranchSelected'] as Map<String, dynamic>)
//     //     : null,
//     // listPianoOutput: json['listPianoOutput'] != null
//     //     ? ListPianoOutput.fromJson(json['listPianoOutput'] as Map<String, dynamic>)
//     //     : null,
//     // textEmptyPiano: json['textEmptyPiano'] != null ? json['textEmptyPiano'] as String : null,
//     // listBookingInput: json['listBookingInput'] != null
//     //     ? ListBookingInput.fromJson(json['listBookingInput'] as Map<String, dynamic>)
//     //     : null,
//     durationsOutput: json['durationsOutput'] != null
//         ? DurationsOutput.fromJson(json['durationsOutput'] as Map<String, dynamic>)
//         : null,
//     bannerClassTypeOutput: json['bannerClassTypeOutput'] != null
//         ? BannerClassTypeOutput.fromJson(json['bannerClassTypeOutput'] as Map<String, dynamic>)
//         : null,
//   );
// }
//
// @override
// Map<String, dynamic> toJson() {
//   return {
//     'branches': this.branches?.map((e) => e.toJson()).toList(),
//     'currentWeek': this.currentWeek?.map((e) => e.toJson()).toList(),
//     'error': this.error,
//     'isLoading': this.isLoading,
//     'isInitialLoading': this.isInitialLoading,
//     // 'dataBranchSelected': this.dataBranchSelected?.toJson(),
//     // 'listPianoOutput': this.listPianoOutput?.toJson(),
//     // 'textEmptyPiano': this.textEmptyPiano,
//     // 'listBookingInput': this.listBookingInput.toJson(),
//     'durationsOutput': this.durationsOutput?.toJson(),
//     'bannerClassTypeOutput': this.bannerClassTypeOutput?.toJson(),
//   };
// }
}
