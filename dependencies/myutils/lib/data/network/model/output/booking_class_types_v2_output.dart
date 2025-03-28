import 'dart:convert';

import 'package:dayoneasia/screen/dashboard/booking_history/cubit/booking_history_cubit.dart';

/// status_code : 200
/// status : "success"
/// message : "Get class types successfully!"
/// data : {"firstMenu":{"key":"CLASS_PRACTICE","name":"Phòng luyện đàn","icon":"CLASS_PRACTICE","router":"/booking-practice","is_booking":true,"text_block_booking":"","image":"","is_show":true},"listMenu":[{"key":"CLASS","name":"Lớp nhóm","icon":"CLASS","router":"/booking-class","is_booking":true,"text_block_booking":"","image":"","is_show":true},{"key":"P1P2","name":"Trải nghiệm HLV","icon":"P1P2","router":"/booking-p1p2","is_booking":true,"text_block_booking":"","image":"","is_show":true}]}
/// errors : []

BookingClassTypesV2Output classTypeV2OutputFromJson(String str) =>
    BookingClassTypesV2Output.fromJson(json.decode(str));

String classTypeV2OutputToJson(BookingClassTypesV2Output data) =>
    json.encode(data.toJson());

class BookingClassTypesV2Output {
  BookingClassTypesV2Output({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  BookingClassTypesV2Output.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    if (json['status_code'] == 200) {
      data = json['data'] != null ? Data.fromJson(json['data']) : null;
    } else {
      data = null;
    }
  }

  num? statusCode;
  String? status;
  String? message;
  Data? data;
  List<dynamic>? errors;

  BookingClassTypesV2Output copyWith({
    num? statusCode,
    String? status,
    String? message,
    Data? data,
    List<dynamic>? errors,
  }) =>
      BookingClassTypesV2Output(
        statusCode: statusCode ?? this.statusCode,
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
      map['data'] = data?.toJson();
    }
    if (errors != null) {
      map['errors'] = errors?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// firstMenu : {"key":"CLASS_PRACTICE","name":"Phòng luyện đàn","icon":"CLASS_PRACTICE","router":"/booking-practice","is_booking":true,"text_block_booking":"","image":"","is_show":true}
/// listMenu : [{"key":"CLASS","name":"Lớp nhóm","icon":"CLASS","router":"/booking-class","is_booking":true,"text_block_booking":"","image":"","is_show":true},{"key":"P1P2","name":"Trải nghiệm HLV","icon":"P1P2","router":"/booking-p1p2","is_booking":true,"text_block_booking":"","image":"","is_show":true}]

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    this.firstMenu,
    this.listMenu,
  });

  Data.fromJson(dynamic json) {
    firstMenu =
        json['firstMenu'] != null ? ListMenu.fromJson(json['firstMenu']) : null;
    if (json['listMenu'] != null) {
      listMenu = [];
      json['listMenu'].forEach((v) {
        listMenu?.add(ListMenu.fromJson(v));
      });
    }
  }

  ListMenu? firstMenu;
  List<ListMenu>? listMenu;

  Data copyWith({
    ListMenu? firstMenu,
    List<ListMenu>? listMenu,
  }) =>
      Data(
        firstMenu: firstMenu ?? this.firstMenu,
        listMenu: listMenu ?? this.listMenu,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (firstMenu != null) {
      map['firstMenu'] = firstMenu?.toJson();
    }
    if (listMenu != null) {
      map['listMenu'] = listMenu?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// key : "CLASS"
/// name : "Lớp nhóm"
/// icon : "CLASS"
/// router : "/booking-class"
/// is_booking : true
/// text_block_booking : ""
/// image : ""
/// is_show : true

ListMenu listMenuFromJson(String str) => ListMenu.fromJson(json.decode(str));

String listMenuToJson(ListMenu data) => json.encode(data.toJson());

class ListMenu {
  ListMenu({
    this.key,
    this.name,
    this.icon,
    this.iconSub,
    this.router,
    this.isBooking,
    this.textBlockBooking,
    this.image,
    this.isShow,
  });

  ListMenu.fromJson(dynamic json) {
    key = json['key'];
    name = json['name'];
    router = json['router'];
    isBooking = json['is_booking'];
    textBlockBooking = json['text_block_booking'];
    image = json['image'];
    isShow = json['is_show'];
    try {
      final iconValue = json['icon'];
      if (iconValue is! String || iconValue.isEmpty) {
        icon = 'dashboard/hlv_private.svg';
        iconSub = 'dashboard/circle-free.svg';
      } else {
        ClassType? classType;
        try {
          classType = ClassType.values.firstWhere(
            (e) => e.name == iconValue,
          );
        } catch (_) {
          classType = null;
        }
        icon = switch (classType) {
          ClassType.CLASS_PRACTICE => 'dashboard/practice.svg',
          ClassType.CLASS => 'dashboard/practice.svg',
          ClassType.ONE_PRIVATE => 'dashboard/hlv_private.svg',
          ClassType.ONE_GENERAL => 'dashboard/hlv_general.svg',
          ClassType.P1P2 => 'dashboard/hlv_private.svg',
          null => 'dashboard/circle-free.svg',
          ClassType.TRIAL => 'dashboard/hlv_private.svg',
        };
        iconSub = switch (classType) {
          ClassType.CLASS_PRACTICE => 'dashboard/circle-practice.svg',
          ClassType.CLASS => 'dashboard/circle-class.svg',
          ClassType.ONE_PRIVATE => 'dashboard/circle-private.svg',
          ClassType.ONE_GENERAL => 'dashboard/circle-general.svg',
          ClassType.P1P2 => 'dashboard/circle-free.svg',
          null => 'dashboard/circle-free.svg',
          ClassType.TRIAL =>'dashboard/hlv_private.svg',
        };
      }
    } catch (e) {
      print('Error while processing icon: $e');
      icon = 'dashboard/hlv_private.svg';
      iconSub = 'dashboard/circle-free.svg';
    }

    print('icon FirstMenu: $icon');
  }

  String? key;
  String? name;
  String? icon;
  String? iconSub;
  String? router;
  bool? isBooking;
  String? textBlockBooking;
  String? image;
  bool? isShow;

  ListMenu copyWith({
    String? key,
    String? name,
    String? icon,
    String? iconSub,
    String? router,
    bool? isBooking,
    String? textBlockBooking,
    String? image,
    bool? isShow,
  }) =>
      ListMenu(
        key: key ?? this.key,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        iconSub: iconSub ?? this.iconSub,
        router: router ?? this.router,
        isBooking: isBooking ?? this.isBooking,
        textBlockBooking: textBlockBooking ?? this.textBlockBooking,
        image: image ?? this.image,
        isShow: isShow ?? this.isShow,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['name'] = name;
    map['icon'] = icon;
    map['iconSub'] = iconSub;
    map['router'] = router;
    map['is_booking'] = isBooking;
    map['text_block_booking'] = textBlockBooking;
    map['image'] = image;
    map['is_show'] = isShow;
    return map;
  }
}
