import 'dart:convert';
/// status_code : 200
/// status : "success"
/// message : "Get news categories successfully!"
/// data : [{"id":4,"name":"Mùa lễ hội"},{"id":5,"name":"Bí quyết"}]
/// errors : ["",""]

BlogCategoriesOutput newsCategoriesOutputFromJson(String str) => BlogCategoriesOutput.fromJson(json.decode(str));
String newsCategoriesOutputToJson(BlogCategoriesOutput data) => json.encode(data.toJson());
class BlogCategoriesOutput {
  BlogCategoriesOutput({
      this.statusCode, 
      this.status, 
      this.message, 
      this.data, 
      this.errors,});

  BlogCategoriesOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DataNewsCategory.fromJson(v));
      });
    }
    errors = json['errors'] != null ? json['errors'].cast<String>() : [];
  }
  num? statusCode;
  String? status;
  String? message;
  List<DataNewsCategory>? data;
  List<String>? errors;
BlogCategoriesOutput copyWith({  num? statusCode,
  String? status,
  String? message,
  List<DataNewsCategory>? data,
  List<String>? errors,
}) => BlogCategoriesOutput(  statusCode: statusCode ?? this.statusCode,
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

/// id : 4
/// name : "Mùa lễ hội"


class DataNewsCategory {
  DataNewsCategory({
      this.slug, 
      this.name,});

  DataNewsCategory.fromJson(dynamic json) {
    slug = json['slug'];
    name = json['name'];
  }
  String? slug;
  String? name;
  DataNewsCategory copyWith({  String? id,
  String? name,
}) => DataNewsCategory(  slug: id ?? this.slug,
  name: name ?? this.name,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['slug'] = slug;
    map['name'] = name;
    return map;
  }

}