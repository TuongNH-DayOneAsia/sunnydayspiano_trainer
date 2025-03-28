part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  final bool isLoading;
  final String? error;
  final bool isLoadingMore;
  final NotificationsOutput? notificationsOutput;
  final bool switchValue;


  const NotificationsState(
      {this.notificationsOutput, this.isLoading = false, this.error, this.isLoadingMore = false,

      this.switchValue = false,
      });

  @override
  List<Object?> get props => [notificationsOutput, isLoading, error, isLoadingMore,switchValue ];

  //copyWith
  NotificationsState copyWith({
    NotificationsOutput? notificationsOutput,
    bool? isLoading,
    String? error,
    bool? isLoadingMore,
    bool? isSeen,
    bool? switchValue,

  }) {
    return NotificationsState(
      notificationsOutput: notificationsOutput ?? this.notificationsOutput,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      switchValue: switchValue ?? this.switchValue,

    );
  }
}
