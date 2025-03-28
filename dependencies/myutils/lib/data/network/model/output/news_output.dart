import 'dart:convert';

import 'package:myutils/data/network/model/output/list_class_output.dart';
/// status_code : 200
/// status : "success"
/// message : "Data has been received!"
/// data : [{"id":5,"news_category_id":5,"name":"Chia sẻ bí quyết học piano","slug":"chia-se-bi-quyet-hoc-piano-1","avatar":"https://staging-booking.sunnydays.vn/storage/news/news-5/news/avatar-20241010_093817-5.png","description":"","created_at":"10/10/2024"},{"id":6,"news_category_id":5,"name":"11 Ứng dụng đàn piano cho người mới học","slug":"11-ung-dung-dan-piano-cho-nguoi-moi-hoc-1","avatar":"https://staging-booking.sunnydays.vn/storage/news/news-6/news/avatar-20241010_093748-6.png","description":"","created_at":"10/10/2024"},{"id":7,"news_category_id":5,"name":"5 CÁCH BẢO DƯỠNG ĐÀN PIANO ĐIỆN ĐƠN GIẢN, DỄ THỰC HIỆN","slug":"5-cach-bao-duong-dan-piano-dien-don-gian-de-thuc-hien-1","avatar":"https://staging-booking.sunnydays.vn/storage/news/news-7/news/avatar-20241010_094048-7.png","description":"","created_at":"10/10/2024"}]
/// errors : ["",""]
/// pagination : {"totalPage":1,"perPage":10,"currentPage":1,"count":3}

BlogOutput newsOutputFromJson(String str) => BlogOutput.fromJson(json.decode(str));
String newsOutputToJson(BlogOutput data) => json.encode(data.toJson());
class BlogOutput {
  BlogOutput({
      this.statusCode, 
      this.status, 
      this.message, 
      this.data, 
      this.errors, 
      this.pagination,});

  BlogOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DataBlog.fromJson(v));
      });
    }
    errors = json['errors'] != null ? json['errors'].cast<String>() : [];
    pagination = json['pagination'] != null ? DataPagination.fromJson(json['pagination']) : null;
  }
  num? statusCode;
  String? status;
  String? message;
  List<DataBlog>? data;
  List<String>? errors;
  DataPagination? pagination;

BlogOutput copyWith({  num? statusCode,
  String? status,
  String? message,
  List<DataBlog>? data,
  List<String>? errors,
  DataPagination? pagination,
}) => BlogOutput(  statusCode: statusCode ?? this.statusCode,
  status: status ?? this.status,
  message: message ?? this.message,
  data: data ?? this.data,
  errors: errors ?? this.errors,
  pagination: pagination ?? this.pagination,
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
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    return map;
  }

}



/// id : 5
/// news_category_id : 5
/// name : "Chia sẻ bí quyết học piano"
/// slug : "chia-se-bi-quyet-hoc-piano-1"
/// avatar : "https://staging-booking.sunnydays.vn/storage/news/news-5/news/avatar-20241010_093817-5.png"
/// description : ""
/// created_at : "10/10/2024"


class DataBlog {
  DataBlog({
      this.id, 
      this.newsCategoryId, 
      this.name, 
      this.slug, 
      this.avatar, 
      this.description, 
      this.createdAt,});

  DataBlog.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    avatar = json['avatar'];
    description = json['description'];
    createdAt = json['created_at'];
  }
  num? id;
  num? newsCategoryId;
  String? name;
  String? slug;
  String? avatar;
  String? description;
  String? createdAt;
  DataBlog copyWith({  num? id,
  num? newsCategoryId,
  String? name,
  String? slug,
  String? avatar,
  String? description,
  String? createdAt,
}) => DataBlog(  id: id ?? this.id,
  newsCategoryId: newsCategoryId ?? this.newsCategoryId,
  name: name ?? this.name,
  slug: slug ?? this.slug,
  avatar: avatar ?? this.avatar,
  description: description ?? this.description,
  createdAt: createdAt ?? this.createdAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['slug'] = slug;
    map['avatar'] = avatar;
    map['description'] = description;
    map['created_at'] = createdAt;
    return map;
  }

}