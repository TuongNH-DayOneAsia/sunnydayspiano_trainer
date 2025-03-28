part of 'coach_list_cubit.dart';

class CoachListState extends Equatable {
  final String? error;
  final bool isInitialLoading;
  final bool isLoading;
  final bool isLoadingMore;
  final List<DataCoach>? coaches;


  final DataPagination? pagination;
  const CoachListState({
    this.error,
    this.isLoading = false,
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.pagination,
    this.coaches,
  });

  @override
  List<Object?> get props => [
        error,
        isLoading,
        isInitialLoading,
        isLoadingMore,
        pagination,
        coaches,
      ];

  // copyWith method
  CoachListState copyWith({
    String? error,
    bool? isLoading,
    bool? isInitialLoading,
    bool? isLoadingMore,
    List<DataCoach>? coaches,
    DataPagination? pagination,
  }) {
    return CoachListState(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      coaches: coaches ?? this.coaches,
      pagination: pagination ?? this.pagination,
    );
  }
}
