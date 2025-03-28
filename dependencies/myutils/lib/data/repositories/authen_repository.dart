import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/base_repository.dart';
import 'package:myutils/data/network/model/base_output.dart';
import 'package:myutils/data/network/model/input/api_key_input.dart';
import 'package:myutils/data/network/model/input/apple_register_account_input.dart';
import 'package:myutils/data/network/model/input/forget_password_input.dart';
import 'package:myutils/data/network/model/output/apple_send_otp_output.dart';
import 'package:myutils/data/network/model/output/data_success_output.dart';
import 'package:myutils/data/network/model/output/login_output.dart';
import 'package:myutils/data/network/model/output/send_code_change_password_output.dart';
import 'package:myutils/data/network/model/output/otp_verify_output.dart';
import 'package:myutils/data/network/model/output/verify_code_output.dart';
import '../network/model/output/api_key_output.dart';

class AuthenRepository extends BaseRepository {
  AuthenRepository() : super('');

  Future<ApiKeyOutput> keyPrivate(ApiKeyInput data) async {
    return ApiKeyOutput.fromJson(await request(method: RequestMethod.post, path: 'api/systems/key-private', data: data));
  }

  Future<BaseOutput> sendCodeVerify(Map<String, String> data) async {
    return BaseOutput.fromJson(await request(method: RequestMethod.post, path: 'api/students/send-code-verify', data: data));
  }

  Future<VerifyCodeOutput> verifyCode(Map<String, String> data) async {
    return VerifyCodeOutput.fromJson(await request(method: RequestMethod.post, path: 'api/students/verify-code', data: data));
  }

  Future<BaseOutput> resetPassword(Map<String, dynamic> data) async {
    return BaseOutput.fromJson(await request(method: RequestMethod.put, path: 'api/students/reset-password', data: data));
  }

  Future<LoginOutput> loginWithPhone(Map<String, String> data) async {
    return LoginOutput.fromJson(await request(method: RequestMethod.post, path: 'api/students/login', data: data));
  }

  Future<LoginOutput> loginWithEmail(Map<String, String> data) async {
    return LoginOutput.fromJson(await request(method: RequestMethod.post, path: 'api/accounts/login', data: data));
  }

  Future<BaseOutput> logout(Map<String, String> data) async {
    return BaseOutput.fromJson(await request(method: RequestMethod.post, path: 'api/students/logout', data: data));
  }
  //
  // Future<OtpVerifyOutput> verifyOtp(Map<String, String> data) async {
  //   return OtpVerifyOutput.fromJson(await request(method: RequestMethod.post, path: 'api/students/otp/verify', data: data));
  // }

  Future<VerifyCodeOutput> verifyCodeOtp(Map<String, String> data) async {
    return VerifyCodeOutput.fromJson(
        await request(method: RequestMethod.post, path: 'api/students/otp/send-code-verify', data: data));
  }

  Future<BaseOutput> resetPasswordOtp(ForgetPasswordInput? forgetPasswordInput) async {
    return BaseOutput.fromJson(await request(
        method: RequestMethod.put, path: 'api/students/otp/reset-password', data: forgetPasswordInput?.toJsonResetPhone()));
  }

  // api/students/send-code-change-password
  Future<SendCodeChangePasswordOutput> sendCodeChangePassword(Map<String, String> data) async {
    return SendCodeChangePasswordOutput.fromJson(
        await request(method: RequestMethod.post, path: 'api/students/send-code-change-password', data: data));
  }

  Future<DataSuccessOutput> changePasswordInHome(Map<String, String> data) async {
    return DataSuccessOutput.fromJson(await request(method: RequestMethod.put, path: 'api/students/change-password', data: data));
  }

  Future<BaseOutput> appleRegisterAccount(AppleRegisterAccountInput data) async {
    return BaseOutput.fromJson(await request(method: RequestMethod.post, path: 'api/accounts/register', data: data.toJson()));
  }

  Future<AppleSendOtpOutput> appleSendOtp(Map<String, String> data) async {
    return AppleSendOtpOutput.fromJson(await request(method: RequestMethod.post, path: 'api/accounts/send-otp', data: data));
  }

  Future<BaseOutput> appDeleteAccount(String slug) async {
    return BaseOutput.fromJson(await request(
      method: RequestMethod.delete,
      path: 'api/accounts/delete/$slug',
    ));
  }
  //accounts/validate-account
  Future<BaseOutput> appleValidateAccount(Map<String, String> data) async {
    return BaseOutput.fromJson(await request(method: RequestMethod.post, path: 'api/accounts/validate-account', data: data));
  }

  //students/check-phone-exists
  Future<OtpVerifyOutput> checkPhoneExists(Map<String, String> data) async {
    return OtpVerifyOutput.fromJson(await request(method: RequestMethod.post, path: 'api/students/check-phone-exists', data: data));
  }

 //students/send-code-verify-sms
  Future<BaseOutput> sendCodeVerifySms(Map<String, String> data) async {
    return BaseOutput.fromJson(await request(method: RequestMethod.post, path: 'api/students/send-code-verify-sms', data: data));
  }
}
