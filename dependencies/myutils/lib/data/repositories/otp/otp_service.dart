import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
// phoneNumber: '+84949992539',// a Phong
// phoneNumber: '+84961900892',a Phong
// phoneNumber: '+84382960988', //Tuong
// phoneNumber: '+84909815498', // a Thang
// phoneNumber: '+84335492192',// c Lan
// phoneNumber: '+84366868830', // chic choe
// phoneNumber: '+84382960988',
// phoneNumber: '+84349974466',

class OtpService {


  Future<void> verifyOtp({
    required String numberPhone,
    required Function(String verificationId) codeSent,
    required Function(String message) verificationFailed,
  }) async {
    try {
      numberPhone = '+84${numberPhone.substring(1)}';
      await FirebaseAuth.instance.verifyPhoneNumber(

        phoneNumber: numberPhone,
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
          print('codeAutoRetrievalTimeout verificationId: $verificationId');
        },
        verificationCompleted: (PhoneAuthCredential credential) {
          print('verificationCompleted credential: $credential');
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            verificationFailed.call('Số điện thoại không hợp lệ.');
          } else if (e.code == 'too-many-requests') {
            verificationFailed.call('Quá số lần gửi mã OTP.');
          } else {
            print('error: $e');
            verificationFailed.call('Đã có lỗi xảy ra, vui lòng thử lại sau.');
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          codeSent.call(verificationId);
        },
      );
    } catch (e) {
      verificationFailed.call('Đã có lỗi xảy ra, vui lòng thử lại sau.');
      print('error: $e');
    }
  }

  Future<void> signInWithPhoneNumber(
      {required String verificationId,
      required String smsCode,
      required Function() onSuccess,
      required Function(String) onError}) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final user = await FirebaseAuth.instance.signInWithCredential(credential);

      if (user.user != null) {
        onSuccess.call();
      } else {
        onError.call('Đã có lỗi xảy ra, vui lòng thử lại sau.');
      }
    } catch (e) {
      if (e.toString().contains('invalid-verification-code')) {
        onError.call('Mã OTP không hợp lệ.');
      } else if (e.toString().contains('session-expired')) {
        onError.call('Mã OTP đã hết hạn.');
      } else {
        onError.call('Đã có lỗi xảy ra, vui lòng thử lại sau.');
      }

      print('error: $e');
    }
  }
}
