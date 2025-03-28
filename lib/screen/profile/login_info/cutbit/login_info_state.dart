part of 'login_info_cubit.dart';

final class LoginInfoState {
  final String? username;
  final String? phoneNumber;

  LoginInfoState({this.username, this.phoneNumber});
  //copyWith
  LoginInfoState copyWith({
    String? username,
    String? phoneNumber,
  }) {
    return LoginInfoState(
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
