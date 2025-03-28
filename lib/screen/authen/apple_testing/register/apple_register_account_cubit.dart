import 'dart:math';

import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/model/input/apple_register_account_input.dart';
import 'package:myutils/data/repositories/authen_repository.dart';
import 'package:myutils/data/repositories/otp/otp_service.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:rxdart/rxdart.dart';

part 'apple_regiser_account_state.dart';

class AppleRegisterAccountCubit extends WidgetCubit<AppleRegisterAccountState> {
  AppleRegisterAccountCubit() : super(widgetState: const AppleRegisterAccountState()) {
    isValidStream = Rx.combineLatest3(
      firstNameSubject.stream,
      lastNameSubject.stream,
      phoneOrEmailSubject.stream,
      (firstName, lastName, phoneOrEmail) {
        return firstName.isNotEmpty && lastName.isNotEmpty && ''.validateEmail(phoneOrEmail).isEmpty;
      },
    );
  }

  final AuthenRepository authenRepository = injector();

  final firstNameSubject = BehaviorSubject<String>.seeded('');
  final lastNameSubject = BehaviorSubject<String>.seeded('');
  var birthday = '';
  final phoneOrEmailSubject = BehaviorSubject<String>.seeded('');
  var gender = '';
  final OtpService otpService = injector();

  late Stream<bool> isValidStream;

  final AuthenRepository _authenRepository = injector();

  Future<void> handleFirebaseOtp(
      {Function(AppleRegisterAccountInput data)? onSuccess, required Function(String message) onError}) async {
    await otpService.verifyOtp(
      numberPhone: phoneOrEmailSubject.value,
      codeSent: (v) {
        final data = AppleRegisterAccountInput(
            firstName: firstNameSubject.value,
            lastName: lastNameSubject.value,
            phone: phoneOrEmailSubject.value,
            birthday: birthday,
            verifyIdFirebase: v,
            gender: gender);
        onSuccess?.call(data);
        print('value: $v');
      },
      verificationFailed: (e) {
        onError(e);
      },
    );
  }

  String generateRandomPhoneNumber() {
    final random = Random();
    String phoneNumber = '03';
    for (int i = 0; i < 8; i++) {
      phoneNumber += random.nextInt(10).toString();
    }
    return phoneNumber;
  }

  //send code verify
  Future<void> sendCodeVerify(
      {required Function(AppleRegisterAccountInput data) onSuccess, required Function(String message) onError}) async {
    try {
      final request = await fetchApi(() => authenRepository.appleValidateAccount({
            'email': phoneOrEmailSubject.value,
          }));
      if (request?.statusCode == ApiStatusCode.success) {
        final data = AppleRegisterAccountInput(
            firstName: firstNameSubject.value,
            lastName: lastNameSubject.value,
            email: phoneOrEmailSubject.value,
            birthday: birthday,
            verifyIdFirebase: '',
            phone: generateRandomPhoneNumber(),
            gender: gender);

        onSuccess(data);
      } else {
        onError(request?.message ?? '');
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  @override
  void onWidgetCreated() {
    // TODO: implement onWidgetCreated
  }

  @override
  Future<void> close() async {
    firstNameSubject.close();
    lastNameSubject.close();
    phoneOrEmailSubject.close();
    super.close();
  }
}
