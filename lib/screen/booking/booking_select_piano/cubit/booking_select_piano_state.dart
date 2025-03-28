part of 'booking_select_piano_cubit.dart';

class BookingSelectPianoState extends Equatable {
  final int? crossAxisCount;
  final List<DataPiano>? pianos;
  final DataPiano? selectedPiano;

  const BookingSelectPianoState({this.crossAxisCount, this.pianos, this.selectedPiano});

  BookingSelectPianoState copyWith({int? crossAxisCount, List<DataPiano>? pianos, DataPiano? selectedPiano}) {
    return BookingSelectPianoState(
      crossAxisCount: crossAxisCount ?? this.crossAxisCount,
      pianos: pianos ?? this.pianos,
      selectedPiano: selectedPiano,
    );
  }

  @override
  List<Object?> get props => [crossAxisCount, pianos, selectedPiano];
}
