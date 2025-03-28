import 'package:myutils/data/network/model/output/menus_in_home_output.dart';

/// status_code : 200
/// status : "success"
/// message : "Get class types successfully!"
/// data : {"arrayMenu":[{"key":"CLASS_PRACTICE","name":"Phòng luyện đàn","icon":"CLASS_PRACTICE","router":"/booking-practice","is_booking":true,"text_block_booking":"","image":"http://booking.test/storage/systems/background-btn-practice/background-btn-practice/background-btn-practice-20250107_182500.png","is_active":true,"slugContract":"2677-427ef5be-84b8-4684-818c-104aa399c5bf","message":"Kích hoạt hợp đồng để đặt chỗ","is_not_started":true},{"key":"CLASS","name":"Lớp nhóm","icon":"CLASS","router":"/booking-class","is_booking":false,"text_block_booking":"Hết số buổi lớp nhóm","image":"http://booking.test/storage/systems/menu-private-coach/background-btn-general/background-btn-general-20250107_182500.png","is_active":true,"slugContract":"2677-427ef5be-84b8-4684-818c-104aa399c5bf","message":"Để sử dụng tính năng, học viên vui lòng liên hệ Tư vấn viên để được hỗ trợ kích hoạt","is_not_started":true},{"key":"1-1","name":"Đặt lịch HLV 1:1","icon":"ONE_ONE","router":"","is_booking":true,"text_block_booking":"","image":"","is_active":true,"slugContract":"","message":""}],"arrayMenuGroup":[{"key":"ONE_GERENAL","name":"Lớp 1:1 không gian chung","icon":"ONE_GERENAL","router":"/booking-one-gerenal","is_booking":true,"text_block_booking":"","image":"http://booking.test/storage/systems/menu-private-coach/background-btn-general/background-btn-general-20250107_182500.png","is_active":true,"slugContract":"2677-427ef5be-84b8-4684-818c-104aa399c5bf","message":"Kích hoạt hợp đồng để đặt chỗ","is_not_started":true},{"key":"ONE_PRIVATE","name":"Lớp 1:1 không gian riêng","icon":"ONE_PRIVATE","router":"/booking-one-private","is_booking":false,"text_block_booking":"Chưa đăng ký tính năng","image":"http://booking.test/storage/systems/background-menu-coach/background-btn-private/background-btn-private-20250107_182500.png","is_active":false,"slugContract":"","message":"Để sử dụng tính năng, học viên vui lòng liên hệ Tư vấn viên để được hỗ trợ kích hoạt","is_not_started":false},{"key":"P1P2","name":"Trải nghiệm HLV","icon":"P1P2","router":"/booking-p1p2","is_booking":true,"text_block_booking":"","image":"http://booking.test/storage/systems/menu-private-coach/background-btn-general/background-btn-general-20250107_182500.png","is_active":true,"slugContract":"2677-427ef5be-84b8-4684-818c-104aa399c5bf","message":"Kích hoạt hợp đồng để đặt chỗ","is_not_started":true}]}
/// errors : ["",""]

class BookingClassTypesV4Output {
  BookingClassTypesV4Output({
      this.statusCode, 
      this.status, 
      this.message, 
      this.data, 
      this.errors,});

  BookingClassTypesV4Output.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DataMenuV3.fromJson(v));
      });
    }
    errors = json['errors'] != null ? json['errors'].cast<String>() : [];
  }
  int? statusCode;
  String? status;
  String? message;
 List<DataMenuV3>? data;
  List<String>? errors;
  BookingClassTypesV4Output copyWith({  int? statusCode,
  String? status,
  String? message,
  List<DataMenuV3>? data,
  List<String>? errors,
}) => BookingClassTypesV4Output(  statusCode: statusCode ?? this.statusCode,
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


