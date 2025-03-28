import 'package:dayoneasia/config/widget_cubit.dart';

part 'login_info_state.dart';

class LoginInfoCubit extends WidgetCubit<LoginInfoState> {
  LoginInfoCubit() : super(widgetState: LoginInfoState());

  @override
  void onWidgetCreated() {
    // TODO: implement onWidgetCreated
  }

  void emitUsernameAndPhoneNumber(String username, String phoneNumber) {
    emit(state.copyWith(username: username, phoneNumber: phoneNumber));
  }

  @override
  Future<void> close() async {
    //cancel streams

    super.close();
  }
}
