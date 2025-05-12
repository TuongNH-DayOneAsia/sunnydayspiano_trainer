import 'dart:ui';

/// status_code : 200
/// status : "success"
/// message : "Truy vấn dữ liệu thành công"
/// data : {"key":"CLASS_PRACTICE","name":"Luyện đàn","active":true,"messages":"","items":[{"product_name":"1-1 riêng 56-80 buổi","slug_contract":"2699-50980e7a-c6e2-43b7-9c1d-a38c03559e08","total_learned":2,"total":30,"key":"CLASS_PRACTICE","is_booking":true,"total_day_remain":75,"status_contract":2,"messages":"","status_name":"Còn hạn","position":1},{"product_name":"1-1 Riêng 16-40 buổi","slug_contract":"2699-943784c4-ffc4-11ef-ad3f-fa163e9901b3","total_learned":1,"total":40,"key":"CLASS_PRACTICE","is_booking":true,"total_day_remain":546,"status_contract":2,"messages":"","status_name":"Còn hạn","position":1},{"product_name":"Mastery Plus","slug_contract":"2699-2050eec0-4f22-4977-bd39-25f7f7006905","total_learned":2,"total":20,"key":"CLASS_PRACTICE","is_booking":false,"total_day_remain":546,"status_contract":1,"messages":"HV vui lòng liên hệ TVV để được gia hạn và sử dụng tiếp tính năng","status_name":"Hết hạn","position":3}]}
/// errors : []

class BookingClassTypesV5Output {
  BookingClassTypesV5Output({
    this.statusCode,
    this.status,
    this.message,
    this.data,
  });

  BookingClassTypesV5Output.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null && json['data'] is Map) {
      data = Data.fromJson(json['data']);
    } else {
      data = null;
    }
  }
  int? statusCode;
  String? status;
  String? message;
  Data? data;
  BookingClassTypesV5Output copyWith({
    int? statusCode,
    String? status,
    String? message,
    Data? data,
  }) =>
      BookingClassTypesV5Output(
        statusCode: statusCode ?? this.statusCode,
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status_code'] = statusCode;
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }

    return map;
  }
}

/// key : "CLASS_PRACTICE"
/// name : "Luyện đàn"
/// active : true
/// messages : ""
/// items : [{"product_name":"1-1 riêng 56-80 buổi","slug_contract":"2699-50980e7a-c6e2-43b7-9c1d-a38c03559e08","total_learned":2,"total":30,"key":"CLASS_PRACTICE","is_booking":true,"total_day_remain":75,"status_contract":2,"messages":"","status_name":"Còn hạn","position":1},{"product_name":"1-1 Riêng 16-40 buổi","slug_contract":"2699-943784c4-ffc4-11ef-ad3f-fa163e9901b3","total_learned":1,"total":40,"key":"CLASS_PRACTICE","is_booking":true,"total_day_remain":546,"status_contract":2,"messages":"","status_name":"Còn hạn","position":1},{"product_name":"Mastery Plus","slug_contract":"2699-2050eec0-4f22-4977-bd39-25f7f7006905","total_learned":2,"total":20,"key":"CLASS_PRACTICE","is_booking":false,"total_day_remain":546,"status_contract":1,"messages":"HV vui lòng liên hệ TVV để được gia hạn và sử dụng tiếp tính năng","status_name":"Hết hạn","position":3}]

class Data {
  Data({
    this.key,
    this.name,
    this.active,
    this.messages,
    this.items,
  });

  Data.fromJson(dynamic json) {
    key = json['key'];
    name = json['name'];
    active = json['active'];
    messages = json['messages'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
      });
    }
  }
  String? key;
  String? name;
  bool? active;
  String? messages;
  List<Items>? items;
  Data copyWith({
    String? key,
    String? name,
    bool? active,
    String? messages,
    List<Items>? items,
  }) =>
      Data(
        key: key ?? this.key,
        name: name ?? this.name,
        active: active ?? this.active,
        messages: messages ?? this.messages,
        items: items ?? this.items,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['name'] = name;
    map['active'] = active;
    map['messages'] = messages;
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    return map;
  }
  String iconPath(){
    if(key == 'CLASS_PRACTICE'){
      return 'profile/practice.svg';
    }else if (key == 'CLASS') {
      return 'profile/class.svg';

    }else{
      return 'dashboard/hlv_private.svg';

    }
  }
}

/// product_name : "1-1 riêng 56-80 buổi"
/// slug_contract : "2699-50980e7a-c6e2-43b7-9c1d-a38c03559e08"
/// total_learned : 2
/// total : 30
/// key : "CLASS_PRACTICE"
/// is_booking : true
/// total_day_remain : 75
/// status_contract : 2
/// messages : ""
/// status_name : "Còn hạn"
/// position : 1

class Items {
  Items({
    this.productName,
    this.slugContract,
    this.totalLearned,
    this.total,
    this.key,
    this.isBooking,
    this.totalDayRemain,
    this.statusContract,
    this.messages,
    this.statusName,
    this.position,
    this.messageBlock
  });

  Items.fromJson(dynamic json) {
    productName = json['product_name'];
    slugContract = json['slug_contract'];
    totalLearned = json['total_learned'];
    total = json['total'];
    key = json['key'];
    isBooking = json['is_booking'];
    totalDayRemain = json['total_day_remain'];
    statusContract = json['status_contract'];
    messages = json['messages'];
    statusName = json['status_name'];
    position = json['position'];
    messageBlock = json['message_block'];
  }
  String? productName;
  String? slugContract;
  int? totalLearned;
  int? total;
  String? key;
  bool? isBooking;
  int? totalDayRemain;
  int? statusContract;
  String? messages;
  String? statusName;
  int? position;
  String? messageBlock;
  Items copyWith({
    String? productName,
    String? slugContract,
    int? totalLearned,
    int? total,
    String? key,
    bool? isBooking,
    int? totalDayRemain,
    int? statusContract,
    String? messages,
    String? statusName,
    int? position,
    String? messageBlock
  }) =>
      Items(
        productName: productName ?? this.productName,
        slugContract: slugContract ?? this.slugContract,
        totalLearned: totalLearned ?? this.totalLearned,
        total: total ?? this.total,
        key: key ?? this.key,
        isBooking: isBooking ?? this.isBooking,
        totalDayRemain: totalDayRemain ?? this.totalDayRemain,
        statusContract: statusContract ?? this.statusContract,
        messages: messages ?? this.messages,
        statusName: statusName ?? this.statusName,
        position: position ?? this.position,
        messageBlock: messageBlock ?? this.messageBlock
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product_name'] = productName;
    map['slug_contract'] = slugContract;
    map['total_learned'] = totalLearned;
    map['total'] = total;
    map['key'] = key;
    map['is_booking'] = isBooking;
    map['total_day_remain'] = totalDayRemain;
    map['status_contract'] = statusContract;
    map['messages'] = messages;
    map['status_name'] = statusName;
    map['position'] = position;
    map['messages_block'] = messageBlock;
    return map;
  }
  Color colorStatus() {
    //EXPIRED = 1, -> Hết hạn
    //   IN_PROGRESS = 2, -> Còn hạn
    //   NOT_STARTED = 3, -> Chưa kích hoạt
    //   NEAR_EXPIRATION = 4 -> Gần hết hạn
    switch (statusContract) {
      case 1:
        return const Color(0xFFFF4545);
      case 2:
        return const Color(0xFF07B25C);
      case 3:
        return const Color(0xFF6A6A6A);
      case 4:
        return const Color(0xFFFFA44B);
      default:
        return  const Color(0xFF07B25C);
    }

  }
}
