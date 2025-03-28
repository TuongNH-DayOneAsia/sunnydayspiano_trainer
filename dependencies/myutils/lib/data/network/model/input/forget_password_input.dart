/// email : "huudev.work@gmail.com"
/// code_reset_password : "123456"
/// password : "12345"
/// confirm_password : "12345"

class ForgetPasswordInput {
  ForgetPasswordInput(
      {this.emailOrPhone,
      this.codeResetPassword,
      this.password,
      this.confirmPassword,
      this.verifyIdFirebase,
      });

  ForgetPasswordInput.fromJson(dynamic json) {
    emailOrPhone = json['email'];
    codeResetPassword = json['code_reset_password'];
    password = json['password'];
    confirmPassword = json['confirm_password'];
  }
  String? emailOrPhone;
  String? codeResetPassword;
  String? password;
  String? confirmPassword;
  String? verifyIdFirebase;

  Map<String, dynamic> toJsonResetEmail() {
    final map = <String, dynamic>{};
    map['email'] = emailOrPhone;
    map['code_reset_password'] = codeResetPassword;
    map['password'] = password;
    map['confirm_password'] = confirmPassword;
    return map;
  }

  Map<String, dynamic> toJsonResetPhone() {
    final map = <String, dynamic>{};
    map['phone'] = emailOrPhone;
    map['code_reset_password'] = codeResetPassword;
    map['password'] = password;
    map['confirm_password'] = confirmPassword;
    return map;
  }
}
