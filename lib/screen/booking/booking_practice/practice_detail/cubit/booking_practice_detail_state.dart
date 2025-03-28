part of 'booking_practice_detail_cubit.dart';

class BookingPracticeDetailState extends Equatable {
  final String? messageError;
  final bool isLoading;

  final BookingDetailPracticeOutput? bookingDetailPracticeOutput;

  const BookingPracticeDetailState({
    this.messageError,
    this.bookingDetailPracticeOutput,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [bookingDetailPracticeOutput, messageError, isLoading];

  //copy with
  BookingPracticeDetailState copyWith({
    BookingDetailPracticeOutput? dataDetail,
    String? messageError,
    bool? isLoading,
  }) {
    return BookingPracticeDetailState(
      bookingDetailPracticeOutput: dataDetail ?? this.bookingDetailPracticeOutput,
      messageError: messageError ?? this.messageError,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
