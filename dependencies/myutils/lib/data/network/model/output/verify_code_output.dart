/// status_code : 200
/// status : "success"
/// message : "Verify code successfully!"
/// data : {"id":13,"name":"Tường Nguyễn","username":"tuongnguyen","email":"tuongnhps07603@gmail.com","phone":"0987654321","code_reset_password":"173307"}
/// errors : ["",""]

class VerifyCodeOutput {
  VerifyCodeOutput({
      num? statusCode, 
      String? status, 
      String? message,
    DataVerifyCode? data,
      List<String>? errors,}){
    _statusCode = statusCode;
    _status = status;
    _message = message;
    _data = data;
    _errors = errors;
}

  VerifyCodeOutput.fromJson(dynamic json) {
    _statusCode = json['status_code'];
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? DataVerifyCode.fromJson(json['data']) : null;
    _errors = json['errors'] != null ? json['errors'].cast<String>() : [];
  }
  num? _statusCode;
  String? _status;
  String? _message;
  DataVerifyCode? _data;
  List<String>? _errors;
VerifyCodeOutput copyWith({  num? statusCode,
  String? status,
  String? message,
  DataVerifyCode? data,
  List<String>? errors,
}) => VerifyCodeOutput(  statusCode: statusCode ?? _statusCode,
  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
  errors: errors ?? _errors,
);
  num? get statusCode => _statusCode;
  String? get status => _status;
  String? get message => _message;
  DataVerifyCode? get data => _data;
  List<String>? get errors => _errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status_code'] = _statusCode;
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['errors'] = _errors;
    return map;
  }

}

/// id : 13
/// name : "Tường Nguyễn"
/// username : "tuongnguyen"
/// email : "tuongnhps07603@gmail.com"
/// phone : "0987654321"
/// code_reset_password : "173307"

class DataVerifyCode {
  DataVerifyCode({
      num? id, 
      String? name, 
      String? username, 
      String? email, 
      String? phone, 
      String? codeResetPassword,}){
    _id = id;
    _name = name;
    _username = username;
    _email = email;
    _phone = phone;
    _codeResetPassword = codeResetPassword;
}

  DataVerifyCode.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _username = json['username'];
    _email = json['email'];
    _phone = json['phone'];
    _codeResetPassword = json['code_reset_password'];
  }
  num? _id;
  String? _name;
  String? _username;
  String? _email;
  String? _phone;
  String? _codeResetPassword;
  DataVerifyCode copyWith({  num? id,
  String? name,
  String? username,
  String? email,
  String? phone,
  String? codeResetPassword,
}) => DataVerifyCode(  id: id ?? _id,
  name: name ?? _name,
  username: username ?? _username,
  email: email ?? _email,
  phone: phone ?? _phone,
  codeResetPassword: codeResetPassword ?? _codeResetPassword,
);
  num? get id => _id;
  String? get name => _name;
  String? get username => _username;
  String? get email => _email;
  String? get phone => _phone;
  String? get codeResetPassword => _codeResetPassword;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['username'] = _username;
    map['email'] = _email;
    map['phone'] = _phone;
    map['code_reset_password'] = _codeResetPassword;
    return map;
  }

}