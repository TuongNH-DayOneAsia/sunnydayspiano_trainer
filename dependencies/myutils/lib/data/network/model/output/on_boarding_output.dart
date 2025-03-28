

import 'package:myutils/data/network/model/base_output.dart';

/// statusCode : 1
/// message : "Thành công"
/// data : [{"title":"Nâng cấp giao diện mang đến trải nghiệm mới 1","content":"content 1","img":"https://fpt.vn/mypt/imgs/upload/thu_vien/welcome1-01_1.png"},{"title":"Nâng cấp giao diện mang đến trải nghiệm mới 2","content":"content 2","img":"https://fpt.vn/mypt/imgs/upload/thu_vien/welcome1-02_1.png"},{"title":"Nâng cấp giao diện mang đến trải nghiệm mới 3","content":"content 3","img":"https://fpt.vn/mypt/imgs/upload/thu_vien/welcome1-03_1.png"},{"title":"Nâng cấp giao diện mang đến trải nghiệm mới 4","content":"content 4","img":"https://fpt.vn/mypt/imgs/upload/thu_vien/welcome1-04_1.png"}]

class OnBoardingOutput extends BaseOutput {
  OnBoardingOutput({
    this.statusCode,
    this.message,
    this.data,
  });

  OnBoardingOutput.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  int? statusCode;
  String? message;
  List<Data>? data;
  OnBoardingOutput copyWith({
    int? statusCode,
    String? message,
    List<Data>? data,
  }) =>
      OnBoardingOutput(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusCode'] = statusCode;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// title : "Nâng cấp giao diện mang đến trải nghiệm mới 1"
/// content : "content 1"
/// img : "https://fpt.vn/mypt/imgs/upload/thu_vien/welcome1-01_1.png"

class Data {
  Data({
    this.title,
    this.content,
    this.img,
  });

  Data.fromJson(dynamic json) {
    title = json['title'];
    content = json['content'];
    img = json['img'];
  }
  String? title;
  String? content;
  String? img;
  Data copyWith({
    String? title,
    String? content,
    String? img,
  }) =>
      Data(
        title: title ?? this.title,
        content: content ?? this.content,
        img: img ?? this.img,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['content'] = content;
    map['img'] = img;
    return map;
  }
}
