import 'dart:convert';
/// first_name : "Apple"
/// last_name : "Test"
/// birthday : "2024-10-01"
/// gender : 1
/// phone : "0123456789"
/// email : "apple@gmail.com"
/// code_confirm_apple : "123456"
/// password : "Apple@123"
/// confirm_password : "Apple@123"

AppleRegisterAccountInput appleRegisterAccountInputFromJson(String str) => AppleRegisterAccountInput.fromJson(json.decode(str));
String appleRegisterAccountInputToJson(AppleRegisterAccountInput data) => json.encode(data.toJson());
class AppleRegisterAccountInput {
  AppleRegisterAccountInput({
      this.firstName, 
      this.lastName, 
      this.birthday, 
      this.gender, 
      this.phone, 
      this.email, 
      this.codeConfirmApple, 
      this.password, 
      this.confirmPassword,
    this.verifyIdFirebase
  });

  AppleRegisterAccountInput.fromJson(dynamic json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    birthday = json['birthday'];
    gender = json['gender'];
    phone = json['phone'];
    email = json['email'];
    codeConfirmApple = json['code_confirm_apple'];
    password = json['password'];
    confirmPassword = json['confirm_password'];
  }
  String? firstName;
  String? lastName;
  String? birthday;
  String? gender;
  String? phone;
  String? email;
  String? codeConfirmApple;
  String? password;
  String? confirmPassword;
  String? verifyIdFirebase;

AppleRegisterAccountInput copyWith({  String? firstName,
  String? lastName,
  String? birthday,
  String? gender,
  String? phone,
  String? email,
  String? codeConfirmApple,
  String? password,
  String? confirmPassword,
  String? verifyIdFirebase,
}) => AppleRegisterAccountInput(  firstName: firstName ?? this.firstName,
  lastName: lastName ?? this.lastName,
  birthday: birthday ?? this.birthday,
  gender: gender ?? this.gender,
  phone: phone ?? this.phone,
  email: email ?? this.email,
  codeConfirmApple: codeConfirmApple ?? this.codeConfirmApple,
  password: password ?? this.password,
  confirmPassword: confirmPassword ?? this.confirmPassword,
  verifyIdFirebase: verifyIdFirebase ?? this.verifyIdFirebase,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['birthday'] = birthday;
    map['gender'] = gender;
    map['phone'] = phone;
    map['email'] = email;
    map['code_confirm_apple'] = codeConfirmApple;
    map['password'] = password;
    map['confirm_password'] = confirmPassword;
    return map;
  }

}