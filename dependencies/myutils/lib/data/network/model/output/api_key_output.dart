import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:myutils/config/app_config.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/data/network/model/output/firebase_config_model.dart';

class ApiKeyOutput {
  ApiKeyOutput({
    this.statusCode,
    this.data,
    this.message,
    this.errors,
    this.status,
  });

  int? statusCode;
  DataKeyPrivate? data;
  String? message;
  List<String>? errors;
  String? status;

  ApiKeyOutput.fromJson(dynamic json) {
    statusCode = json['status_code'] ?? -1;
    message = json['message'] ?? '';
    status = json['status'] ?? '';
    data = json['data'] != null ? DataKeyPrivate.fromJson(json['data']) : null;
    if (json['errors'] != null) {
      errors = [];
      json['errors'].forEach((v) {
        errors?.add(v.toString());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status_code'] = statusCode;
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    if (errors != null) {
      map['errors'] = errors;
    }
    return map;
  }
}

class DataKeyPrivate {
  DataKeyPrivate({
    this.apiKeyPrivate,
    this.limitOtp,
    this.limitForget,
    this.logoApp,
    this.bannerApp,
    this.clauseLink,
    this.typeOtp,
    this.linkSupport,
    this.companyEmail,
    this.companyHotline,
    this.apiKeyBase,
    this.bookPracticeTimeStart,
    this.bookPracticeTimeEnd,
    this.bookPracticeTimeStep,
    this.instrumentPracticeRow,
    this.linkMessenger,
    this.isDeploy,
    this.isDeployVersion,
    this.isMaintenance,
    this.isMaintenanceMessage,
    this.appLastVersionAndroid,
    this.appLastVersioniOS,
    this.appLinkAndroid,
    this.appLinkiOS,
    this.isForceUpdate,
    this.isRequireForceUpdate,
    this.textRequestClassLesson,
    this.noteDetailBookingClass,
    this.noteDetailBookingClassPractice,
    this.noteBookingClass,
    this.noteBookingClassPractice,
    this.noteDetailBookingOneOneGeneral,
    this.noteDetailBookingOneOnePrivate,
    this.noteDetailBookingOneOneP1P2,
  });

  String? apiKeyPrivate;
  String? limitOtp;
  String? limitForget;
  String? logoApp;
  String? bannerApp;
  String? clauseLink;
  String? typeOtp;
  String? linkSupport;
  String? companyEmail;
  String? companyHotline;
  String? apiKeyBase;
  String? bookPracticeTimeStart;
  String? bookPracticeTimeEnd;
  String? bookPracticeTimeStep;
  String? instrumentPracticeRow;
  String? linkMessenger;
  String? isDeploy;
  String? isDeployVersion;
  bool? isMaintenance;
  String? isMaintenanceMessage;
  String? appLastVersionAndroid;
  String? appLastVersioniOS;
  String? appLinkAndroid;
  String? appLinkiOS;
  bool? isForceUpdate;
  String? noteDetailBookingClass;
  String? noteDetailBookingClassPractice;

  //app_is_require_force_update
  bool? isRequireForceUpdate;
  String? textRequestClassLesson;
  String? noteBookingClass;
  String? noteBookingClassPractice;
  String? noteDetailBookingOneOneGeneral;
  String? noteDetailBookingOneOnePrivate;
  String? noteDetailBookingOneOneP1P2;

  //"note_booking_class": null,
  // "note_booking_class_practice": "Aewweew",
  // "note_detail_booking_one_one_general":
  // "",
  // "note_detail_booking_one_one_private":
  // "",
  // "note_detail_booking_one_one_p1p2":

  factory DataKeyPrivate.fromJson(Map<dynamic, dynamic> json) => DataKeyPrivate(
        apiKeyPrivate: json["api_key_private"] ?? '',
        limitOtp: json["limit_otp"] ?? '',
        limitForget: json["limit_forget"] ?? '',
        logoApp: json["logo_app"] ?? '',
        bannerApp: json["banner_app"] ?? '',
        clauseLink: json["clause_link"] ?? '',
        typeOtp: json["type_otp"] ?? '2',
        linkSupport: json["link_support"] ?? '',
        companyEmail: json["company_email"] ?? '',
        companyHotline: json["company_hotline"] ?? '',
        apiKeyBase: json["api_key_base"] ?? '',
        bookPracticeTimeStart: json["book_practice_time_start"] ?? '',
        bookPracticeTimeEnd: json["book_practice_time_end"] ?? '',
        bookPracticeTimeStep: json["book_practice_time_step"] ?? '',
        instrumentPracticeRow: json["instrument_practice_row"] ?? '',
        linkMessenger: json["link_messenger"] ?? '',
        isDeploy: json["is_deploy"] ?? '',
        isDeployVersion: json["is_deploy_version"] ?? '',
        isMaintenance: json["is_maintenance"] ?? false,
        isMaintenanceMessage: json["is_maintenance_message"] ?? '',
        appLastVersionAndroid: json['app_last_version_android'] ?? '',
        appLastVersioniOS: json['app_last_version_ios'] ?? '',
        appLinkAndroid: json['app_link_android'] ?? '',
        appLinkiOS: json['app_link_ios'] ?? '',
        isForceUpdate: json['app_is_force_update'] ?? false,
        isRequireForceUpdate: json['app_is_require_force_update'] ?? false,
        textRequestClassLesson: json['text_request_confirmation'] ?? "",
        noteDetailBookingClass: json['note_detail_booking_class'] ?? "",
        noteDetailBookingClassPractice:
            json['note_detail_booking_class_practice'] ?? "",
        noteBookingClass: json['note_booking_class'] ?? "",
        noteBookingClassPractice: json['note_booking_class_practice'] ?? "",
        noteDetailBookingOneOneGeneral:
            json['note_detail_booking_one_one_general'] ?? "",
        noteDetailBookingOneOnePrivate:
            json['note_detail_booking_one_one_private'] ?? "",
        noteDetailBookingOneOneP1P2:
            json['note_detail_booking_one_one_p1p2'] ?? "",
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['api_key_private'] = apiKeyPrivate;
    map['limit_otp'] = limitOtp;
    map['limit_forget'] = limitForget;
    map['logo_app'] = logoApp;
    map['banner_app'] = bannerApp;
    map['clause_link'] = clauseLink;
    map['type_otp'] = typeOtp;
    map['link_support'] = linkSupport;
    map['company_email'] = companyEmail;
    map['company_hotline'] = companyHotline;
    map['api_key_base'] = apiKeyBase;
    map['book_practice_time_start'] = bookPracticeTimeStart;
    map['book_practice_time_end'] = bookPracticeTimeEnd;
    map['book_practice_time_step'] = bookPracticeTimeStep;
    map['instrument_practice_row'] = instrumentPracticeRow;
    map['link_messenger'] = linkMessenger;
    map['is_deploy'] = isDeploy;
    map['is_deploy_version'] = isDeployVersion;
    map['is_maintenance'] = isMaintenance;
    map['is_maintenance_message'] = isMaintenanceMessage;

    map['app_last_version_android'] = appLastVersionAndroid;
    map['app_last_version_ios'] = appLastVersioniOS;
    map['app_link_android'] = appLinkAndroid;
    map['app_link_ios'] = appLinkiOS;
    map['app_is_force_update'] = isForceUpdate;
    map['app_is_require_force_update'] = isRequireForceUpdate;

    map['text_request_confirmation'] = textRequestClassLesson;
    map['note_detail_booking_class'] = noteDetailBookingClass;
    map['note_detail_booking_class_practice'] = noteDetailBookingClassPractice;
    map['note_booking_class'] = noteBookingClass;
    map['note_booking_class_practice'] = noteBookingClassPractice;

    map['note_detail_booking_one_one_general'] = noteDetailBookingOneOneGeneral;
    map['note_detail_booking_one_one_private'] = noteDetailBookingOneOnePrivate;
    map['note_detail_booking_one_one_p1p2'] = noteDetailBookingOneOneP1P2;

    return map;
  }

  FirebaseConfigData get firebaseConfigData {
    final configVersion = injector<AppConfig>().firebaseConfigVersion;

    if (configVersion != isDeployVersion) {
      return FirebaseConfigData.defaultConfig();
    }

    try {
      return FirebaseConfigData.fromJson(json.decode(isDeploy ?? '{}'));
    } catch (_) {
      return FirebaseConfigData.defaultConfig();
    }
  }

  bool get isOtpFirebase => typeOtp == '1';
}
