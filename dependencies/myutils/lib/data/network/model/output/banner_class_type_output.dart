import 'dart:convert';
/// status_code : 200
/// status : "success"
/// message : "Get list banners successfully!"
/// data : [{"id":1,"path":"https://staging-booking.sunnydays.vn/storage/news/news-5/news/avatar-20241010_093817-5.png"}]
/// errors : ["",""]

BannerClassTypeOutput bannerClassTypeOutputFromJson(String str) => BannerClassTypeOutput.fromJson(json.decode(str));
String bannerClassTypeOutputToJson(BannerClassTypeOutput data) => json.encode(data.toJson());
class BannerClassTypeOutput {
  BannerClassTypeOutput({
      this.statusCode, 
      this.status, 
      this.message, 
      this.data, 
      this.errors,});

  BannerClassTypeOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DataBannerClassType.fromJson(v));
      });
    }
    errors = json['errors'] != null ? json['errors'].cast<String>() : [];
  }
  num? statusCode;
  String? status;
  String? message;
  List<DataBannerClassType>? data;
  List<String>? errors;
BannerClassTypeOutput copyWith({  num? statusCode,
  String? status,
  String? message,
  List<DataBannerClassType>? data,
  List<String>? errors,
}) => BannerClassTypeOutput(  statusCode: statusCode ?? this.statusCode,
  status: status ?? this.status,
  message: message ?? this.message,
  data: data ?? this.data,
  errors: errors ?? this.errors,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status_code'] = statusCode;
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['errors'] = errors;
    return map;
  }

}

/// id : 1
/// path : "https://staging-booking.sunnydays.vn/storage/news/news-5/news/avatar-20241010_093817-5.png"


class DataBannerClassType {
  DataBannerClassType({
      this.id, 
      this.path,});

  DataBannerClassType.fromJson(dynamic json) {
    id = json['id'];
    path = json['path'];
  }
  num? id;
  String? path;
  DataBannerClassType copyWith({  num? id,
  String? path,
}) => DataBannerClassType(  id: id ?? this.id,
  path: path ?? this.path,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['path'] = path;
    return map;
  }

}