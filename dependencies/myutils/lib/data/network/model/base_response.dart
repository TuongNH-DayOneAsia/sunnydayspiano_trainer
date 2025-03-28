import 'package:myutils/data/network/model/base_model.dart';




class Response<T extends BaseModel> extends BaseModel {
  int? statusCode;
  String? status;
  String? message;
  List<String>? error;

  Response({this.statusCode, this.message,this.status,this.error}) : super.init();
  Response.init({this.statusCode, this.message,this.status,this.error}) : super.init();
  Response.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    error = json['error'] != null ? List<String>.from(json['error']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusCode'] = statusCode;
    map['status'] = status;
    map['message'] = message;
    map['error'] = error;
    return map;
  }

  Response<T> copyWith({
    int? statusCode,
    String? message,
    T? data,
  }) {
    return Response<T>(
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
    );
  }
}
