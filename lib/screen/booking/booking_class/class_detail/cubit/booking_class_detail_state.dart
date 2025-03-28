part of 'booking_class_detail_cubit.dart';

class BookingClassDetailState extends Equatable {
  final DataClass? dataClass;
  final String? messageError;
  final DataBooking? dataBooking;
  final bool isLoading;

  const BookingClassDetailState({this.dataClass, this.messageError, this.dataBooking, this.isLoading = false});

  @override
  List<Object?> get props => [dataClass, messageError, dataBooking, isLoading];

  //copy with
  BookingClassDetailState copyWith({
    DataClass? dataClass,
    String? messageError,
    DataBooking? dataBooking,
    bool? isLoading,
  }) {
    return BookingClassDetailState(
      dataClass: dataClass ?? this.dataClass,
      messageError: messageError ?? this.messageError,
      dataBooking: dataBooking ?? this.dataBooking,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
