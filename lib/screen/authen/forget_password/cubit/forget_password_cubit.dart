// import 'package:dayoneasia/config/widget_cubit.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:myutils/config/injection.dart';
// import 'package:myutils/constants/api_constant.dart';
// import 'package:myutils/constants/locale_keys_enum.dart';
// import 'package:myutils/data/network/model/output/api_key_output.dart';
// import 'package:myutils/data/repositories/authen_repository.dart';
// import 'package:myutils/data/repositories/otp/otp_service.dart';
// import 'package:myutils/helpers/extension/string_extension.dart';
// import 'package:myutils/helpers/tools/tool_helper.dart';
// import 'package:rxdart/rxdart.dart';
//
// part 'forget_password_state.dart';
//
// class ForgetPasswordCubit extends WidgetCubit<ForgetPasswordState> {
//   ForgetPasswordCubit() : super(widgetState: ForgetPasswordInitial()) {
//     isValidStream = phoneOrEmailSubject.stream.map((phone) => ''.validatePhone(phone).isEmpty);
//     // isValidStream = phoneOrEmailSubject.stream
//     //     .map((phone) => inReleaseIOS ? ''.validateEmail(phone).isEmpty : ''.validatePhone(phone).isEmpty);
//   }
//
//   final AuthenRepository authenRepository = injector();
//   final OtpService otpService = injector();
//
//   final phoneOrEmailSubject = BehaviorSubject<String>.seeded('');
//   late Stream<bool> isValidStream;
//
//   void onPhoneOrEmailChanged(String email) {
//     phoneOrEmailSubject.add(email);
//   }
//
//   String titleTextField() {
//     return 'authentication.phoneNumber'.tr();
//   }
//
//   String validateInput(String value) {
//     return ''.validatePhone(value);
//   }
//
//   Future<void> callApiSendCodeVerify() async {
//     _handleApiOtpV2();
//
//     if (isOtpFirebase) {
//       await _handleFirebaseOtp();
//     } else {
//       await _handleApiOtp();
//     }
//   }
//
//   Future<void> _handleFirebaseOtp() async {
//     showEasyLoading();
//     if (!await checkPhoneExists()) return;
//     await otpService.verifyOtp(
//         numberPhone: phoneOrEmailSubject.value, codeSent: _onCodeSent, verificationFailed: _onVerificationFailed);
//   }
//
//   Future<void> _onCodeSent(String value) async {
//     final isOk = await verifyOtpLimit();
//     if (!isOk) return;
//     emit(ForgetPasswordSuccess(verificationId: value));
//     hideEasyLoading();
//   }
//
//   void _onVerificationFailed(String message) {
//     hideEasyLoading();
//     emit(ForgetPasswordError(message));
//   }
//
//   Future<void> _handleApiOtp() async {
//     if (!await checkPhoneExists()) return;
//     emit(ForgetPasswordLoading());
//
//     try {
//       final request = await fetchApi(() => authenRepository.sendCodeVerify({
//             'email': isOtpFirebase ? phoneOrEmailSubject.value : '',
//             'phone': isOtpFirebase ? '' : phoneOrEmailSubject.value,
//           }));
//       if (request?.statusCode == ApiStatusCode.success) {
//         emit(ForgetPasswordSuccess());
//       } else {
//         if (language == 'en') {
//           final translatedMessage = await ToolHelper.translateText(request?.message ?? '');
//           emit(ForgetPasswordError(translatedMessage));
//         } else {
//           emit(ForgetPasswordError(request?.message ?? ''));
//         }
//       }
//     } catch (e) {
//       _handleError(e);
//     }
//   }
//
//   Future<void> _handleApiOtpV2() async {
//     // if (!await checkPhoneExists()) return;
//     // emit(ForgetPasswordLoading());
//
//     try {
//       final request = await fetchApi(
//           () => authenRepository.sendCodeVerifySms({
//                 'phone': phoneOrEmailSubject.value,
//               }),
//           showLoading: true);
//       if (request?.statusCode == ApiStatusCode.success) {
//         emit(ForgetPasswordSuccess());
//       } else {
//         if (language == 'en') {
//           final translatedMessage = await ToolHelper.translateText(request?.message ?? '');
//           emit(ForgetPasswordError(translatedMessage));
//         } else {
//           emit(ForgetPasswordError(request?.message ?? ''));
//         }
//       }
//     } catch (e) {
//       _handleError(e);
//     }
//   }
//
//   void _handleError(dynamic error) {
//     emit(ForgetPasswordError(MyString.messageError));
//     hideEasyLoading();
//   }
//
//   Future<bool> checkPhoneExists() async {
//     var data = {
//       'device_id': await deviceIdApp(),
//       'phone': phoneOrEmailSubject.value,
//     };
//     try {
//       final request = await fetchApi(() => authenRepository.checkPhoneExists(data));
//       if (request?.statusCode == ApiStatusCode.success && request?.data == true) {
//         return request?.data ?? false;
//       } else {
//         emit(ForgetPasswordError(request?.message ?? ''));
//         return false;
//       }
//     } catch (e) {
//       emit(ForgetPasswordError(MyString.messageError));
//       return false;
//     }
//   }
//
//   Future<bool> verifyOtpLimit() async {
//     var data = {
//       'device_id': await deviceIdApp(),
//       'phone': phoneOrEmailSubject.value,
//     };
//     try {
//       final request = await fetchApi(() => authenRepository.verifyOtp(data));
//       if (request?.statusCode == ApiStatusCode.success && request?.data == true) {
//         return request?.data ?? false;
//       } else {
//         if (language == 'en') {
//           final translatedMessage = await ToolHelper.translateText(request?.message ?? '');
//           emit(ForgetPasswordError(translatedMessage));
//         } else {
//           emit(ForgetPasswordError(request?.message ?? ''));
//         }
//         return false;
//       }
//     } catch (e) {
//       emit(ForgetPasswordError(MyString.messageError));
//       return false;
//     }
//   }
//
//   @override
//   Future<void> close() {
//     // TODO: implement close
//     phoneOrEmailSubject.close();
//     return super.close();
//   }
//
//   @override
//   void onWidgetCreated() {
//     // TODO: implement onWidgetCreated
//   }
// }
