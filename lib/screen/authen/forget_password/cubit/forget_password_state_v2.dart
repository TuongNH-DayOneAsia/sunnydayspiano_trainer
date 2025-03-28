
abstract class ForgetPasswordStateV2 {}

class ForgetPasswordInitialV2 extends ForgetPasswordStateV2 {}

class ForgetPasswordLoadingV2 extends ForgetPasswordStateV2 {}

class ForgetPasswordSuccessV2 extends ForgetPasswordStateV2 {
  String? verificationId;
  ForgetPasswordSuccessV2({this.verificationId});
}

class ForgetPasswordErrorV2 extends ForgetPasswordStateV2 {
  final String error;
  ForgetPasswordErrorV2(this.error);
}
