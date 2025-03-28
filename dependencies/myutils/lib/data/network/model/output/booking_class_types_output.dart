import 'dart:convert';
/// status_code : 200
/// status : "success"
/// message : "Get class types successfully!"
/// data : [{"id":5,"name":"Đặt lịch Lớp Nhóm","icon":"CLASS","router":"/booking-class","is_booking":true,"text_block_booking":""},{"id":7,"name":"Đặt lịch Lớp 1-1 Riêng","icon":"ONE_PRIVATE","router":"/booking-one-private","is_booking":false,"text_block_booking":"Bạn không có hợp đồng lớp 1-1 riêng."},{"id":8,"name":"Đặt lịch Lớp 1-1 Chung","icon":"ONE_GERENAL","router":"/booking-one-gerenal","is_booking":false,"text_block_booking":"Bạn không có hợp đồng lớp 1-1 chung."},{"id":11,"name":"Đặt lịch Luyện Đàn","icon":"CLASS_PRACTICE","router":"/booking-practice","is_booking":true,"text_block_booking":""}]
/// errors : ["",""]

BookingClassTypesOutput bookingClassTypesOutputFromJson(String str) => BookingClassTypesOutput.fromJson(json.decode(str));
String bookingClassTypesOutputToJson(BookingClassTypesOutput data) => json.encode(data.toJson());
class BookingClassTypesOutput {
  BookingClassTypesOutput({
      this.statusCode, 
      this.status, 
      this.message, 
      this.data, 
      this.errors,});

  BookingClassTypesOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    errors = json['errors'] != null ? json['errors'].cast<String>() : [];
  }
  num? statusCode;
  String? status;
  String? message;
  List<Data>? data;
  List<String>? errors;
BookingClassTypesOutput copyWith({  num? statusCode,
  String? status,
  String? message,
  List<Data>? data,
  List<String>? errors,
}) => BookingClassTypesOutput(  statusCode: statusCode ?? this.statusCode,
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

/// id : 5
/// name : "Đặt lịch Lớp Nhóm"
/// icon : "CLASS"
/// router : "/booking-class"
/// is_booking : true
/// text_block_booking : ""

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.key, 
      this.name, 
      this.icon, 
      this.router, 
      this.isBooking, 
      this.textBlockBooking,});

  Data.fromJson(dynamic json) {
    key = json['key'] ??"";
    name = json['name'] ?? '' ;
    icon = json['icon'] ?? '';
    router = json['router'] ?? '';
    isBooking = json['is_booking'] ?? false;
    textBlockBooking = json['text_block_booking'] ?? '';
  }
  String? key;
  String? name;
  String? icon;
  String? router;
  bool? isBooking;
  String? textBlockBooking;
Data copyWith({  String? key,
  String? name,
  String? icon,
  String? router,
  bool? isBooking,
  String? textBlockBooking,
}) => Data(  key: key ?? this.key,
  name: name ?? this.name,
  icon: icon ?? this.icon,
  router: router ?? this.router,
  isBooking: isBooking ?? this.isBooking,
  textBlockBooking: textBlockBooking ?? this.textBlockBooking,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['name'] = name;
    map['icon'] = icon;
    map['router'] = router;
    map['is_booking'] = isBooking;
    map['text_block_booking'] = textBlockBooking;
    return map;
  }

}