part of 'booking_history_cubit.dart';

class BookingHistoryState extends Equatable {
  final String? error;
  final String? msgEmpty;
  final bool isInitialLoading;
  final bool isLoading;
  final bool isLoadingMore;

  final DataPagination? pagination;
  final List<DataHistoryStatus>? listHistoryStatus;
  final List<DataHistoryMain>? listHistoryBooking;

  const BookingHistoryState(
      {this.error,
      this.msgEmpty,
      this.isLoading = false,
      this.isInitialLoading = false,
      this.isLoadingMore = false,
      this.listHistoryStatus,
      this.pagination,
      this.listHistoryBooking});

  //copyWith method
  BookingHistoryState copyWith({
    String? error,
    String? msgEmpty,
    bool? isLoading,
    bool? isInitialLoading,
    bool? isLoadingMore,
    List<DataHistoryStatus>? listHistoryStatus,
    List<DataHistoryMain>? listHistoryBooking,
    DataPagination? pagination,
  }) {
    return BookingHistoryState(
      error: error ?? this.error,
      msgEmpty: msgEmpty ?? this.msgEmpty,
      isLoading: isLoading ?? this.isLoading,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      listHistoryStatus: listHistoryStatus ?? this.listHistoryStatus,
      listHistoryBooking: listHistoryBooking ?? this.listHistoryBooking,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  List<Object?> get props =>
      [error, isLoading, isInitialLoading, isLoadingMore, listHistoryStatus, listHistoryBooking, pagination, msgEmpty];
}
