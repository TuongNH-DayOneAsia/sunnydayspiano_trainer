part of 'apple_forget_password_cubit.dart';

abstract class AppleForgetPasswordState {}

class AppleForgetPasswordInitial extends AppleForgetPasswordState {}

class AppleForgetPasswordLoading extends AppleForgetPasswordState {}

class AppleForgetPasswordSuccess extends AppleForgetPasswordState {
  String? verificationId;
  AppleForgetPasswordSuccess({this.verificationId});
}

class AppleForgetPasswordError extends AppleForgetPasswordState {
  final String error;
  AppleForgetPasswordError(this.error);
}
