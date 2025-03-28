import '../list_class_output.dart';

/// status_code : 200
/// status : "success"
/// message : "Data has been received!"
/// data : [{"id":18,"name":"Xuân Mai","en_name":"Elis","slug":"0362554917","avatar":"","experience":"","expertise":"","full_name":"Xuân Mai (Elis)"},{"id":19,"name":"Cẩm Tiên","en_name":"Teresa","slug":"0345522717","avatar":"","experience":"","expertise":"","full_name":"Cẩm Tiên (Teresa)"},{"id":20,"name":"Tường Anh","en_name":"Juno","slug":"0363989762","avatar":"","experience":"","expertise":"","full_name":"Tường Anh (Juno)"},{"id":21,"name":"Nguyễn Kiên","en_name":"Kaii","slug":"0909069703","avatar":"","experience":"","expertise":"","full_name":"Nguyễn Kiên (Kaii)"},{"id":22,"name":"Minh Hiếu","en_name":"Tommy","slug":"0907867443","avatar":"","experience":"","expertise":"","full_name":"Minh Hiếu (Tommy)"},{"id":98,"name":"Thế Anh","en_name":"Gin","slug":"0888534579","avatar":"","experience":"","expertise":"","full_name":"Thế Anh (Gin)"},{"id":365,"name":"Hữu Tường","en_name":"Go","slug":"dwvx5th7r0d","avatar":"http://booking.test/storage/coaches/coach-107/avatar/avatar-20241225_152619-107.png","experience":"1-2 năm","expertise":"Cổ điển","full_name":"Hữu Tường (Go)"}]
/// errors : []
/// pagination : {"totalPage":1,"perPage":10,"currentPage":1,"count":7}

class CoachesOutput {
  CoachesOutput({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.errors,
    this.pagination,
  });

  CoachesOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DataCoach.fromJson(v));
      });
    }

    pagination = json['pagination'] != null
        ? DataPagination.fromJson(json['pagination'])
        : null;
  }
  int? statusCode;
  String? status;
  String? message;
  List<DataCoach>? data;
  List<dynamic>? errors;
  DataPagination? pagination;
  CoachesOutput copyWith({
    int? statusCode,
    String? status,
    String? message,
    List<DataCoach>? data,
    List<dynamic>? errors,
    DataPagination? pagination,
  }) =>
      CoachesOutput(
        statusCode: statusCode ?? this.statusCode,
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
    if (errors != null) {
      map['errors'] = errors?.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    return map;
  }
}

/// id : 18
/// name : "Xuân Mai"
/// en_name : "Elis"
/// slug : "0362554917"
/// avatar : ""
/// experience : ""
/// expertise : ""
/// full_name : "Xuân Mai (Elis)"

class DataCoach {
  DataCoach({
    this.id,
    this.name,
    this.enName,
    this.slug,
    this.avatar,
    this.experience,
    this.expertise,
    this.fullName,
    this.email,
    this.phone,
    this.quote,
    this.quoteTitle,
    this.title,
  });

  DataCoach.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    enName = json['en_name'] ?? '';
    slug = json['slug'] ?? '';
    avatar = json['avatar'] ?? '';
    experience = json['experience'] ?? '';
    expertise = json['expertise'] ?? '';
    fullName = json['full_name'] ?? '';
    //
    email = json['email'] ?? '';
    phone = json['phone'] ?? '';
    quote = json['quote'] ?? '';
    quoteTitle = json['quote_title'] ?? '';
    title = json['title'] ?? '';
  }
  int? id;
  String? name;
  String? enName;
  String? slug;
  String? avatar;
  String? experience;
  String? expertise;
  String? fullName;
  String? email, phone, quote, quoteTitle, title;

  DataCoach copyWith(
          {int? id,
          String? name,
          String? enName,
          String? slug,
          String? avatar,
          String? experience,
          String? expertise,
          String? fullName,
          String? email,
          phone,
          quote,
          quoteTitle,
          title}) =>
      DataCoach(
        id: id ?? this.id,
        name: name ?? this.name,
        enName: enName ?? this.enName,
        slug: slug ?? this.slug,
        avatar: avatar ?? this.avatar,
        experience: experience ?? this.experience,
        expertise: expertise ?? this.expertise,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        quote: quote ?? this.quote,
        quoteTitle: quoteTitle ?? this.quoteTitle,
        title: title ?? this.title,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['en_name'] = enName;
    map['slug'] = slug;
    map['avatar'] = avatar;
    map['experience'] = experience;
    map['expertise'] = expertise;
    map['full_name'] = fullName;
    map['email'] = email;
    map['phone'] = phone;
    map['quote'] = quote;
    map['quote_title'] = quoteTitle;
    map['title'] = title;
    return map;
  }
}
