import 'package:myutils/data/network/model/base_output.dart';

/// status_code : 200
/// status : "success"
/// message : "Get class types successfully!"
/// data : {"arrayMenu":[{"key":"CLASS_PRACTICE","name":"Phòng luyện đàn","icon":"CLASS_PRACTICE","router":"/booking-practice","is_booking":true,"text_block_booking":"","image":"http://booking.test/storage/systems/background-btn-practice/background-btn-practice/background-btn-practice-20250107_182500.png","is_active":true,"slugContract":"2677-427ef5be-84b8-4684-818c-104aa399c5bf","message":"Kích hoạt hợp đồng để đặt chỗ","is_not_started":true},{"key":"CLASS","name":"Lớp nhóm","icon":"CLASS","router":"/booking-class","is_booking":false,"text_block_booking":"Hết số buổi lớp nhóm","image":"http://booking.test/storage/systems/menu-private-coach/background-btn-general/background-btn-general-20250107_182500.png","is_active":true,"slugContract":"2677-427ef5be-84b8-4684-818c-104aa399c5bf","message":"Để sử dụng tính năng, học viên vui lòng liên hệ Tư vấn viên để được hỗ trợ kích hoạt","is_not_started":true},{"key":"1-1","name":"Đặt lịch HLV 1:1","icon":"ONE_ONE","router":"","is_booking":true,"text_block_booking":"","image":"","is_active":true,"slugContract":"","message":""}],"arrayMenuGroup":[{"key":"ONE_GERENAL","name":"Lớp 1:1 không gian chung","icon":"ONE_GERENAL","router":"/booking-one-gerenal","is_booking":true,"text_block_booking":"","image":"http://booking.test/storage/systems/menu-private-coach/background-btn-general/background-btn-general-20250107_182500.png","is_active":true,"slugContract":"2677-427ef5be-84b8-4684-818c-104aa399c5bf","message":"Kích hoạt hợp đồng để đặt chỗ","is_not_started":true},{"key":"ONE_PRIVATE","name":"Lớp 1:1 không gian riêng","icon":"ONE_PRIVATE","router":"/booking-one-private","is_booking":false,"text_block_booking":"Chưa đăng ký tính năng","image":"http://booking.test/storage/systems/background-menu-coach/background-btn-private/background-btn-private-20250107_182500.png","is_active":false,"slugContract":"","message":"Để sử dụng tính năng, học viên vui lòng liên hệ Tư vấn viên để được hỗ trợ kích hoạt","is_not_started":false},{"key":"P1P2","name":"Trải nghiệm HLV","icon":"P1P2","router":"/booking-p1p2","is_booking":true,"text_block_booking":"","image":"http://booking.test/storage/systems/menu-private-coach/background-btn-general/background-btn-general-20250107_182500.png","is_active":true,"slugContract":"2677-427ef5be-84b8-4684-818c-104aa399c5bf","message":"Kích hoạt hợp đồng để đặt chỗ","is_not_started":true}]}
/// errors : ["",""]

class MenuInHomeOutput extends BaseOutput {
  MenuInHomeOutput({
    super.statusCode,
    super.status,
    super.message,
    this.data,
  });

  MenuInHomeOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataListMenu.fromJson(json['data']) : null;
    errors = json['errors'] != null ? json['errors'].cast<String>() : [];
  }
  DataListMenu? data;
  MenuInHomeOutput copyWith({
    int? statusCode,
    String? status,
    String? message,
    DataListMenu? data,
    List<String>? errors,
  }) =>
      MenuInHomeOutput(
        statusCode: statusCode ?? super.statusCode,
        status: status ?? super.status,
        message: message ?? super.message,
        data: data ?? this.data,
      );
}
/// arrayMenu : [{"key":"CLASS_PRACTICE","name":"Phòng luyện đàn","icon":"CLASS_PRACTICE","router":"/booking-practice","is_booking":true,"text_block_booking":"","image":"http://booking.test/storage/systems/background-btn-practice/background-btn-practice/background-btn-practice-20250107_182500.png","is_active":true,"slugContract":"2677-427ef5be-84b8-4684-818c-104aa399c5bf","message":"Kích hoạt hợp đồng để đặt chỗ","is_not_started":true},{"key":"CLASS","name":"Lớp nhóm","icon":"CLASS","router":"/booking-class","is_booking":false,"text_block_booking":"Hết số buổi lớp nhóm","image":"http://booking.test/storage/systems/menu-private-coach/background-btn-general/background-btn-general-20250107_182500.png","is_active":true,"slugContract":"2677-427ef5be-84b8-4684-818c-104aa399c5bf","message":"Để sử dụng tính năng, học viên vui lòng liên hệ Tư vấn viên để được hỗ trợ kích hoạt","is_not_started":true},{"key":"1-1","name":"Đặt lịch HLV 1:1","icon":"ONE_ONE","router":"","is_booking":true,"text_block_booking":"","image":"","is_active":true,"slugContract":"","message":""}]
/// arrayMenuGroup : [{"key":"ONE_GERENAL","name":"Lớp 1:1 không gian chung","icon":"ONE_GERENAL","router":"/booking-one-gerenal","is_booking":true,"text_block_booking":"","image":"http://booking.test/storage/systems/menu-private-coach/background-btn-general/background-btn-general-20250107_182500.png","is_active":true,"slugContract":"2677-427ef5be-84b8-4684-818c-104aa399c5bf","message":"Kích hoạt hợp đồng để đặt chỗ","is_not_started":true},{"key":"ONE_PRIVATE","name":"Lớp 1:1 không gian riêng","icon":"ONE_PRIVATE","router":"/booking-one-private","is_booking":false,"text_block_booking":"Chưa đăng ký tính năng","image":"http://booking.test/storage/systems/background-menu-coach/background-btn-private/background-btn-private-20250107_182500.png","is_active":false,"slugContract":"","message":"Để sử dụng tính năng, học viên vui lòng liên hệ Tư vấn viên để được hỗ trợ kích hoạt","is_not_started":false},{"key":"P1P2","name":"Trải nghiệm HLV","icon":"P1P2","router":"/booking-p1p2","is_booking":true,"text_block_booking":"","image":"http://booking.test/storage/systems/menu-private-coach/background-btn-general/background-btn-general-20250107_182500.png","is_active":true,"slugContract":"2677-427ef5be-84b8-4684-818c-104aa399c5bf","message":"Kích hoạt hợp đồng để đặt chỗ","is_not_started":true}]

class DataListMenu {
  DataListMenu({
    this.arrayMenu,
    this.arrayMenuGroup,
  });

  DataListMenu.fromJson(dynamic json) {
    if (json['arrayMenu'] != null) {
      arrayMenu = [];
      json['arrayMenu'].forEach((v) {
        arrayMenu?.add(DataMenuV3.fromJson(v));
      });
    }
    if (json['arrayMenuGroup'] != null) {
      arrayMenuGroup = [];
      json['arrayMenuGroup'].forEach((v) {
        arrayMenuGroup?.add(DataMenuV3.fromJson(v));
      });
    }
  }
  List<DataMenuV3>? arrayMenu;
  List<DataMenuV3>? arrayMenuGroup;
  DataListMenu copyWith({
    List<DataMenuV3>? arrayMenu,
    List<DataMenuV3>? arrayMenuGroup,
  }) =>
      DataListMenu(
        arrayMenu: arrayMenu ?? this.arrayMenu,
        arrayMenuGroup: arrayMenuGroup ?? this.arrayMenuGroup,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (arrayMenu != null) {
      map['arrayMenu'] = arrayMenu?.map((v) => v.toJson()).toList();
    }
    if (arrayMenuGroup != null) {
      map['arrayMenuGroup'] = arrayMenuGroup?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// key : "ONE_GERENAL"
/// name : "Lớp 1:1 không gian chung"
/// icon : "ONE_GERENAL"
/// router : "/booking-one-gerenal"
/// is_booking : true
/// text_block_booking : ""
/// image : "http://booking.test/storage/systems/menu-private-coach/background-btn-general/background-btn-general-20250107_182500.png"
/// is_active : true
/// slugContract : "2677-427ef5be-84b8-4684-818c-104aa399c5bf"
/// message : "Kích hoạt hợp đồng để đặt chỗ"
/// is_not_started : true

class DataMenuV3 {
  DataMenuV3({
    this.key,
    this.name,
    this.icon,
    this.router,
    this.isBooking,
    this.textBlockBooking,
    this.image,
    this.isActive,
    this.slugContract,
    this.message,
    this.isNotStarted,
  });

  DataMenuV3.fromJson(dynamic json) {
    key = json['key'];
    name = json['name'];
    icon = json['icon'];
    router = json['router'];
    isBooking = json['is_booking'];
    textBlockBooking = json['text_block_booking'];
    image = json['image'];
    isActive = json['is_active'];
    slugContract = json['slugContract'];
    message = json['message'];
    isNotStarted = json['is_not_started'];
  }
  String? key;
  String? name;
  String? icon;
  String? router;
  bool? isBooking;
  String? textBlockBooking;
  String? image;
  bool? isActive;
  String? slugContract;
  String? message;
  bool? isNotStarted;
  DataMenuV3 copyWith({
    String? key,
    String? name,
    String? icon,
    String? router,
    bool? isBooking,
    String? textBlockBooking,
    String? image,
    bool? isActive,
    String? slugContract,
    String? message,
    bool? isNotStarted,
  }) =>
      DataMenuV3(
        key: key ?? this.key,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        router: router ?? this.router,
        isBooking: isBooking ?? this.isBooking,
        textBlockBooking: textBlockBooking ?? this.textBlockBooking,
        image: image ?? this.image,
        isActive: isActive ?? this.isActive,
        slugContract: slugContract ?? this.slugContract,
        message: message ?? this.message,
        isNotStarted: isNotStarted ?? this.isNotStarted,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['name'] = name;
    map['icon'] = icon;
    map['router'] = router;
    map['is_booking'] = isBooking;
    map['text_block_booking'] = textBlockBooking;
    map['image'] = image;
    map['is_active'] = isActive;
    map['slugContract'] = slugContract;
    map['message'] = message;
    map['is_not_started'] = isNotStarted;
    return map;
  }
}
