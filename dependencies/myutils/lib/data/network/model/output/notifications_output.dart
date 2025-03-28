import 'dart:convert';

import 'package:myutils/data/network/model/output/list_class_output.dart';

/// status_code : 200
/// status : "success"
/// message : "Notifications retrieved successfully"
/// data : {"notifications":[{"id":147,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173104167611","request_json":"{\"message\":{\"token\":\"efXQ-sdpQKWylbGBzycCGJ:APA91bEdIwIa48LRhWuZjxy29pwXZl9uVuQDMT1jWfcnN1EQqQCPoA8FdUxXL5kFeMFFn1cgrdVPZA4DG5z23RF3PW8pE5WX0udtrNnEnB5NJKAzB2xP8KM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173104167611\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173104167611\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\n  \"name\": \"projects/sunnydayspiano/messages/0:1731063602399781%33a9f2dc33a9f2dc\"\n}\n","status":1,"fcm_token":"efXQ-sdpQKWylbGBzycCGJ:APA91bEdIwIa48LRhWuZjxy29pwXZl9uVuQDMT1jWfcnN1EQqQCPoA8FdUxXL5kFeMFFn1cgrdVPZA4DG5z23RF3PW8pE5WX0udtrNnEnB5NJKAzB2xP8KM","seen":0,"sent_at":"2024-11-08","created_at":"2024-11-08T18:00:02.000Z","updated_at":"2024-11-08T18:00:02.000Z"},{"id":148,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173104167611","request_json":"{\"message\":{\"token\":\"efXQ-sdpQKWylbGBzycCGJ:APA91bEdIwIa48LRhWuZjxy29pwXZl9uVuQDMT1jWfcnN1EQqQCPoA8FdUxXL5kFeMFFn1cgrdVPZA4DG5z23RF3PW8pE5WX0udtrNnEnB5NJKAzB2xP8KM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173104167611\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173104167611\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\n  \"name\": \"projects/sunnydayspiano/messages/0:1731064502034388%33a9f2dc33a9f2dc\"\n}\n","status":1,"fcm_token":"efXQ-sdpQKWylbGBzycCGJ:APA91bEdIwIa48LRhWuZjxy29pwXZl9uVuQDMT1jWfcnN1EQqQCPoA8FdUxXL5kFeMFFn1cgrdVPZA4DG5z23RF3PW8pE5WX0udtrNnEnB5NJKAzB2xP8KM","seen":0,"sent_at":"2024-11-08","created_at":"2024-11-08T18:15:02.000Z","updated_at":"2024-11-08T18:15:02.000Z"},{"id":149,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173123005412","request_json":"{\"message\":{\"token\":\"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173123005412\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173123005412\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\n  \"name\": \"projects/sunnydayspiano/messages/1731214802564199\"\n}\n","status":1,"fcm_token":"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM","seen":0,"sent_at":"Hôm qua","created_at":"2024-11-10T12:00:02.000Z","updated_at":"2024-11-10T12:00:02.000Z"},{"id":150,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173123005412","request_json":"{\"message\":{\"token\":\"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173123005412\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173123005412\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\n  \"name\": \"projects/sunnydayspiano/messages/1731215702430096\"\n}\n","status":1,"fcm_token":"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM","seen":0,"sent_at":"Hôm qua","created_at":"2024-11-10T12:15:02.000Z","updated_at":"2024-11-10T12:15:02.000Z"},{"id":151,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173123005412","request_json":"{\"message\":{\"token\":\"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173123005412\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173123005412\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\n  \"name\": \"projects/sunnydayspiano/messages/1731216602341989\"\n}\n","status":1,"fcm_token":"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM","seen":0,"sent_at":"Hôm qua","created_at":"2024-11-10T12:30:02.000Z","updated_at":"2024-11-10T12:30:02.000Z"},{"id":152,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173123005412","request_json":"{\"message\":{\"token\":\"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173123005412\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173123005412\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\n  \"name\": \"projects/sunnydayspiano/messages/1731217502334084\"\n}\n","status":1,"fcm_token":"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM","seen":0,"sent_at":"Hôm qua","created_at":"2024-11-10T12:45:02.000Z","updated_at":"2024-11-10T12:45:02.000Z"},{"id":153,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173123005412","request_json":"{\"message\":{\"token\":\"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173123005412\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173123005412\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\"error\":\"Client error: `POST https:\\/\\/fcm.googleapis.com\\/v1\\/projects\\/sunnydayspiano\\/messages:send` resulted in a `401 Unauthorized` response:\\n{\\n  \\\"error\\\": {\\n    \\\"code\\\": 401,\\n    \\\"message\\\": \\\"Request had invalid authentication credentials. Expected OAuth 2 access  (truncated...)\\n\"}","status":0,"fcm_token":"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM","seen":0,"sent_at":"Hôm qua","created_at":"2024-11-10T13:00:02.000Z","updated_at":"2024-11-10T13:00:02.000Z"},{"id":154,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173123005412","request_json":"{\"message\":{\"token\":\"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173123005412\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173123005412\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\n  \"name\": \"projects/sunnydayspiano/messages/1731219302882038\"\n}\n","status":1,"fcm_token":"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM","seen":0,"sent_at":"Hôm qua","created_at":"2024-11-10T13:15:03.000Z","updated_at":"2024-11-10T13:15:03.000Z"},{"id":155,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173123005412","request_json":"{\"message\":{\"token\":\"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173123005412\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173123005412\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\n  \"name\": \"projects/sunnydayspiano/messages/1731220201969450\"\n}\n","status":1,"fcm_token":"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM","seen":0,"sent_at":"Hôm qua","created_at":"2024-11-10T13:30:02.000Z","updated_at":"2024-11-10T13:30:02.000Z"},{"id":156,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173123005412","request_json":"{\"message\":{\"token\":\"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173123005412\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173123005412\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\n  \"name\": \"projects/sunnydayspiano/messages/1731221102842770\"\n}\n","status":1,"fcm_token":"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM","seen":0,"sent_at":"Hôm qua","created_at":"2024-11-10T13:45:03.000Z","updated_at":"2024-11-10T13:45:03.000Z"}],"pagination":{"totalPage":5,"perPage":10,"currentPage":1,"count":50}}
/// errors : ["",""]

NotificationsOutput notificationsOutputFromJson(String str) =>
    NotificationsOutput.fromJson(json.decode(str));

String notificationsOutputToJson(NotificationsOutput data) =>
    json.encode(data.toJson());

class NotificationsOutput {
  NotificationsOutput({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  NotificationsOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    errors = json['errors'] != null ? json['errors'].cast<String>() : [];
  }

  num? statusCode;
  String? status;
  String? message;
  Data? data;
  List<String>? errors;

  NotificationsOutput copyWith({
    num? statusCode,
    String? status,
    String? message,
    Data? data,
    List<String>? errors,
  }) =>
      NotificationsOutput(
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
    map['errors'] = errors;
    return map;
  }
}

/// notifications : [{"id":147,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173104167611","request_json":"{\"message\":{\"token\":\"efXQ-sdpQKWylbGBzycCGJ:APA91bEdIwIa48LRhWuZjxy29pwXZl9uVuQDMT1jWfcnN1EQqQCPoA8FdUxXL5kFeMFFn1cgrdVPZA4DG5z23RF3PW8pE5WX0udtrNnEnB5NJKAzB2xP8KM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173104167611\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173104167611\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\n  \"name\": \"projects/sunnydayspiano/messages/0:1731063602399781%33a9f2dc33a9f2dc\"\n}\n","status":1,"fcm_token":"efXQ-sdpQKWylbGBzycCGJ:APA91bEdIwIa48LRhWuZjxy29pwXZl9uVuQDMT1jWfcnN1EQqQCPoA8FdUxXL5kFeMFFn1cgrdVPZA4DG5z23RF3PW8pE5WX0udtrNnEnB5NJKAzB2xP8KM","seen":0,"sent_at":"2024-11-08","created_at":"2024-11-08T18:00:02.000Z","updated_at":"2024-11-08T18:00:02.000Z"},{"id":148,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173104167611","request_json":"{\"message\":{\"token\":\"efXQ-sdpQKWylbGBzycCGJ:APA91bEdIwIa48LRhWuZjxy29pwXZl9uVuQDMT1jWfcnN1EQqQCPoA8FdUxXL5kFeMFFn1cgrdVPZA4DG5z23RF3PW8pE5WX0udtrNnEnB5NJKAzB2xP8KM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173104167611\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173104167611\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\n  \"name\": \"projects/sunnydayspiano/messages/0:1731064502034388%33a9f2dc33a9f2dc\"\n}\n","status":1,"fcm_token":"efXQ-sdpQKWylbGBzycCGJ:APA91bEdIwIa48LRhWuZjxy29pwXZl9uVuQDMT1jWfcnN1EQqQCPoA8FdUxXL5kFeMFFn1cgrdVPZA4DG5z23RF3PW8pE5WX0udtrNnEnB5NJKAzB2xP8KM","seen":0,"sent_at":"2024-11-08","created_at":"2024-11-08T18:15:02.000Z","updated_at":"2024-11-08T18:15:02.000Z"},{"id":149,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173123005412","request_json":"{\"message\":{\"token\":\"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173123005412\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173123005412\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\n  \"name\": \"projects/sunnydayspiano/messages/1731214802564199\"\n}\n","status":1,"fcm_token":"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM","seen":0,"sent_at":"Hôm qua","created_at":"2024-11-10T12:00:02.000Z","updated_at":"2024-11-10T12:00:02.000Z"},{"id":150,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173123005412","request_json":"{\"message\":{\"token\":\"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173123005412\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173123005412\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\n  \"name\": \"projects/sunnydayspiano/messages/1731215702430096\"\n}\n","status":1,"fcm_token":"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM","seen":0,"sent_at":"Hôm qua","created_at":"2024-11-10T12:15:02.000Z","updated_at":"2024-11-10T12:15:02.000Z"},{"id":151,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173123005412","request_json":"{\"message\":{\"token\":\"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173123005412\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173123005412\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\n  \"name\": \"projects/sunnydayspiano/messages/1731216602341989\"\n}\n","status":1,"fcm_token":"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM","seen":0,"sent_at":"Hôm qua","created_at":"2024-11-10T12:30:02.000Z","updated_at":"2024-11-10T12:30:02.000Z"},{"id":152,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173123005412","request_json":"{\"message\":{\"token\":\"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173123005412\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173123005412\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\n  \"name\": \"projects/sunnydayspiano/messages/1731217502334084\"\n}\n","status":1,"fcm_token":"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM","seen":0,"sent_at":"Hôm qua","created_at":"2024-11-10T12:45:02.000Z","updated_at":"2024-11-10T12:45:02.000Z"},{"id":153,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173123005412","request_json":"{\"message\":{\"token\":\"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173123005412\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173123005412\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\"error\":\"Client error: `POST https:\\/\\/fcm.googleapis.com\\/v1\\/projects\\/sunnydayspiano\\/messages:send` resulted in a `401 Unauthorized` response:\\n{\\n  \\\"error\\\": {\\n    \\\"code\\\": 401,\\n    \\\"message\\\": \\\"Request had invalid authentication credentials. Expected OAuth 2 access  (truncated...)\\n\"}","status":0,"fcm_token":"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM","seen":0,"sent_at":"Hôm qua","created_at":"2024-11-10T13:00:02.000Z","updated_at":"2024-11-10T13:00:02.000Z"},{"id":154,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173123005412","request_json":"{\"message\":{\"token\":\"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173123005412\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173123005412\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\n  \"name\": \"projects/sunnydayspiano/messages/1731219302882038\"\n}\n","status":1,"fcm_token":"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM","seen":0,"sent_at":"Hôm qua","created_at":"2024-11-10T13:15:03.000Z","updated_at":"2024-11-10T13:15:03.000Z"},{"id":155,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173123005412","request_json":"{\"message\":{\"token\":\"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173123005412\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173123005412\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\n  \"name\": \"projects/sunnydayspiano/messages/1731220201969450\"\n}\n","status":1,"fcm_token":"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM","seen":0,"sent_at":"Hôm qua","created_at":"2024-11-10T13:30:02.000Z","updated_at":"2024-11-10T13:30:02.000Z"},{"id":156,"title":"Thông tin buổi học Piano","body":"Chi tiết lịch học #PR-173123005412","request_json":"{\"message\":{\"token\":\"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173123005412\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173123005412\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}","response_json":"{\n  \"name\": \"projects/sunnydayspiano/messages/1731221102842770\"\n}\n","status":1,"fcm_token":"eoJQpn3cu071oSOUI5iCAW:APA91bFiNN6C6iRDfa097L27EOwB3ilpKBZM3w_3R6dZ04Uu-P5Bnxwa6jbCCKsEblXcu5HbKufZCY8PB8G1Lye5O4w8ubKTiYCB5HlrKDcDDwBXcIZCneM","seen":0,"sent_at":"Hôm qua","created_at":"2024-11-10T13:45:03.000Z","updated_at":"2024-11-10T13:45:03.000Z"}]
/// pagination : {"totalPage":5,"perPage":10,"currentPage":1,"count":50}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    this.notifications,
    this.pagination,
  });

  Data.fromJson(dynamic json) {
    if (json['notifications'] != null) {
      notifications = [];
      json['notifications'].forEach((v) {
        notifications?.add(DataNotifications.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? DataPagination.fromJson(json['pagination'])
        : null;
  }

  List<DataNotifications>? notifications;
  DataPagination? pagination;

  Data copyWith({
    List<DataNotifications>? notifications,
    DataPagination? pagination,
  }) =>
      Data(
        notifications: notifications ?? this.notifications,
        pagination: pagination ?? this.pagination,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (notifications != null) {
      map['notifications'] = notifications?.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    return map;
  }
}

/// id : 147
/// title : "Thông tin buổi học Piano"
/// body : "Chi tiết lịch học #PR-173104167611"
/// request_json : "{\"message\":{\"token\":\"efXQ-sdpQKWylbGBzycCGJ:APA91bEdIwIa48LRhWuZjxy29pwXZl9uVuQDMT1jWfcnN1EQqQCPoA8FdUxXL5kFeMFFn1cgrdVPZA4DG5z23RF3PW8pE5WX0udtrNnEnB5NJKAzB2xP8KM\",\"data\":{\"path\":\"\\/booking-practice-detail\",\"booking_code\":\"PR-173104167611\",\"booking_key_type\":\"CLASS_PRACTICE\"},\"notification\":{\"title\":\"Th\\u00f4ng tin bu\\u1ed5i h\\u1ecdc Piano\",\"body\":\"Chi ti\\u1ebft l\\u1ecbch h\\u1ecdc #PR-173104167611\"},\"android\":{\"notification\":{\"sound\":\"default\",\"click_action\":\"FLUTTER_NOTIFICATION_CLICK\",\"visibility\":\"public\"},\"priority\":\"high\"},\"apns\":{\"payload\":{\"aps\":{\"sound\":\"default\",\"category\":\"LESSON_DETAIL\"}}}}}"
/// response_json : "{\n  \"name\": \"projects/sunnydayspiano/messages/0:1731063602399781%33a9f2dc33a9f2dc\"\n}\n"
/// status : 1
/// fcm_token : "efXQ-sdpQKWylbGBzycCGJ:APA91bEdIwIa48LRhWuZjxy29pwXZl9uVuQDMT1jWfcnN1EQqQCPoA8FdUxXL5kFeMFFn1cgrdVPZA4DG5z23RF3PW8pE5WX0udtrNnEnB5NJKAzB2xP8KM"
/// seen : 0
/// sent_at : "2024-11-08"
/// created_at : "2024-11-08T18:00:02.000Z"
/// updated_at : "2024-11-08T18:00:02.000Z"

class DataNotifications {
  DataNotifications(
      {this.id,
      this.title,
      this.body,
      this.requestJson,
      this.responseJson,
      this.status,
      this.fcmToken,
      this.seen,
      this.sentAt,
      this.createdAt,
      this.updatedAt,
      this.bookingCode,
      this.slug,
      this.booking,
      this.content,
      this.objectType});

  DataNotifications.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    requestJson = json['request_json'];
    responseJson = json['response_json'];
    status = json['status'];
    fcmToken = json['fcm_token'];
    seen = json['seen'];
    sentAt = json['sent_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bookingCode = json['booking_code'];
    slug = json['slug'];
    booking =
        json['booking'] != null ? Booking.fromJson(json['booking']) : null;
    content = json['content'] ?? '';
    objectType = json['object_type'] ?? '';
  }

  num? id;
  String? title;
  String? body;
  String? requestJson;
  String? responseJson;
  num? status;
  String? fcmToken;
  num? seen;
  String? sentAt;
  String? createdAt;
  String? updatedAt;
  String? bookingCode;
  String? slug;
  String? objectType;
  Booking? booking;
  String? content;

  DataNotifications copyWith(
          {num? id,
          String? title,
          String? body,
          String? requestJson,
          String? responseJson,
          num? status,
          String? fcmToken,
          num? seen,
          String? sentAt,
          String? createdAt,
          String? updatedAt,
          String? bookingCode,
          String? slug,
          Booking? booking,
          String? objectType,
          String? content}) =>
      DataNotifications(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        requestJson: requestJson ?? this.requestJson,
        responseJson: responseJson ?? this.responseJson,
        status: status ?? this.status,
        fcmToken: fcmToken ?? this.fcmToken,
        seen: seen ?? this.seen,
        sentAt: sentAt ?? this.sentAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        objectType: objectType ?? this.objectType,
        bookingCode: bookingCode ?? this.bookingCode,
        slug: slug ?? this.slug,
        booking: booking ?? this.booking,
        content: content ?? this.content,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['body'] = body;
    map['request_json'] = requestJson;
    map['response_json'] = responseJson;
    map['status'] = status;
    map['fcm_token'] = fcmToken;
    map['seen'] = seen;
    map['sent_at'] = sentAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['booking_code'] = bookingCode;
    map['slug'] = slug;
    map['object_type'] = objectType;
    return map;
  }

  bool get isSeen => seen == 1;
}

/// booking_code : "PR-17308034999"
/// type : "CLASS_PRACTICE"

class Booking {
  Booking({
    this.bookingCode,
    this.type,
  });

  Booking.fromJson(dynamic json) {
    bookingCode = json['booking_code'];
    type = json['type'];
  }

  String? bookingCode;
  String? type;

  Booking copyWith({
    String? bookingCode,
    String? type,
  }) =>
      Booking(
        bookingCode: bookingCode ?? this.bookingCode,
        type: type ?? this.type,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['booking_code'] = bookingCode;
    map['type'] = type;
    return map;
  }
}
