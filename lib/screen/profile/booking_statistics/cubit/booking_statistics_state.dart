part of 'booking_statistics_cubit.dart';

final class BookingStatisticsState extends Equatable {
  final StatisticsOutput? statisticsOutput;
  final StatisticsYearsOutput? statisticsYearsOutput;
  final List<DataPoint>? listPoint;
  final int? total;
  final String? dateSelected; // ->9/2024
  final String? monthSelected; // ->9
  final String? yearSelected; // ->2024
  final String? errorMessages;
  final bool isLoading;

  const BookingStatisticsState( {
    this.statisticsOutput,
    this.listPoint,
    this.total,
    this.statisticsYearsOutput,
    this.dateSelected,
    this.yearSelected,
    this.monthSelected,
    this.errorMessages,
    this.isLoading = false
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        statisticsOutput,
        listPoint,
        total,
        statisticsYearsOutput,
        dateSelected,
        yearSelected,
        monthSelected,
        errorMessages,
        isLoading
      ];

  //copyWith
  BookingStatisticsState copyWith({
    StatisticsOutput? statisticsOutput,
    List<DataPoint>? listPoint,
    int? total,
    StatisticsYearsOutput? statisticsYearsOutput,
    String? dateSelected,
    String? monthSelected,
    String? yearSelected,
    String? errorMessages,
    bool? isLoading,
  }) {
    return BookingStatisticsState(
      statisticsOutput: statisticsOutput ?? this.statisticsOutput,
      listPoint: listPoint ?? this.listPoint,
      total: total ?? this.total,
      statisticsYearsOutput: statisticsYearsOutput ?? this.statisticsYearsOutput,
      dateSelected: dateSelected ?? this.dateSelected,
      monthSelected: monthSelected ?? this.monthSelected,
      yearSelected: yearSelected ?? this.yearSelected,
      errorMessages: errorMessages ?? this.errorMessages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
