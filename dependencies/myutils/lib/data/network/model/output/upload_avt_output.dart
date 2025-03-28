import 'dart:convert';
/// status_code : 200
/// status : "success"
/// message : "File uploaded successfully!"
/// data : {"filename":"avatar-20242129_2157-13.png","path":"/var/www/staging-booking.sunnydays.vn/public/storage/students/student-13/avatar/avatar-20242129_2157-13.png"}
/// errors : ["",""]

UploadAvtOutput uploadAvtOutputFromJson(String str) => UploadAvtOutput.fromJson(json.decode(str));
String uploadAvtOutputToJson(UploadAvtOutput data) => json.encode(data.toJson());
class UploadAvtOutput {
  UploadAvtOutput({
      num? statusCode, 
      String? status, 
      String? message, 
      Data? data, 
      List<String>? errors,}){
    _statusCode = statusCode;
    _status = status;
    _message = message;
    _data = data;
    _errors = errors;
}

  UploadAvtOutput.fromJson(dynamic json) {
    _statusCode = json['status_code'];
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _errors = json['errors'] != null ? json['errors'].cast<String>() : [];
  }
  num? _statusCode;
  String? _status;
  String? _message;
  Data? _data;
  List<String>? _errors;
UploadAvtOutput copyWith({  num? statusCode,
  String? status,
  String? message,
  Data? data,
  List<String>? errors,
}) => UploadAvtOutput(  statusCode: statusCode ?? _statusCode,
  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
  errors: errors ?? _errors,
);
  num? get statusCode => _statusCode;
  String? get status => _status;
  String? get message => _message;
  Data? get data => _data;
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

/// filename : "avatar-20242129_2157-13.png"
/// path : "/var/www/staging-booking.sunnydays.vn/public/storage/students/student-13/avatar/avatar-20242129_2157-13.png"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? filename, 
      String? path,}){
    _filename = filename;
    _path = path;
}

  Data.fromJson(dynamic json) {
    _filename = json['filename'];
    _path = json['path'];
  }
  String? _filename;
  String? _path;
Data copyWith({  String? filename,
  String? path,
}) => Data(  filename: filename ?? _filename,
  path: path ?? _path,
);
  String? get filename => _filename;
  String? get path => _path;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['filename'] = _filename;
    map['path'] = _path;
    return map;
  }

}