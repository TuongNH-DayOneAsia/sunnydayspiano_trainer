import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/data/network/model/output/api_key_output.dart';
import 'package:myutils/data/network/model/output/list_piano_output.dart';
import 'package:myutils/data/network/network_manager.dart';
import 'package:myutils/data/repositories/authen_repository.dart';
import 'package:myutils/data/repositories/booking_repository.dart';

part 'booking_select_piano_state.dart';

class BookingSelectPianoCubit extends WidgetCubit<BookingSelectPianoState> {
  final String? keyType;

  BookingSelectPianoCubit({this.keyType})
      : super(
            widgetState: BookingSelectPianoState(
          crossAxisCount: 1,
          pianos: List.generate(
            12,
            (index) => DataPiano(
              instrumentCode: "CA${index + 1}",
              isBooking: index % 2 == 0,
            ),
          ),
        ));

  final BookingRepository _bookingRepository = injector();

  final NetworkManager _networkManager = injector();

  AuthenRepository authenRepository = injector();
  String get noteBookingClass =>
      localeManager
          .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
          ?.noteBookingClass ??
          '';

  bool isEnableButtonBook() {
    return state.selectedPiano != null;
  }

  Future<void> refresh() async {
    emit(state.copyWith(selectedPiano: null));
  }

  @override
  void onWidgetCreated() {
    // TODO: implement onWidgetCreated
  }

  void selectPiano(DataPiano? data) {
    if (data!.isBooking == false) return;

    // final updatedPianos = state.pianos!.map((piano) {
    //   return piano.copyWith(selected: piano.name == data.name);
    // }).toList();

    emit(state.copyWith( selectedPiano: data));
  }
}
