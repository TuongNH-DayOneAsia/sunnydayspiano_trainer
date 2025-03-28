part of 'booking_11_detail_cubit.dart';

class Booking11DetailState extends Equatable {
  final DataBooking11Detail? dataBooking11Detail;
  const Booking11DetailState({
    this.dataBooking11Detail,
  });
  @override
  List<Object?> get props => [dataBooking11Detail];
  //copyWith
  Booking11DetailState copyWith({
    DataBooking11Detail? dataBooking11Detail,
  }) {
    return Booking11DetailState(
      dataBooking11Detail: dataBooking11Detail ?? this.dataBooking11Detail,
    );
  }
}
