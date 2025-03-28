import 'dart:convert';

import 'package:myutils/config/injection.dart';
import 'package:myutils/data/network/network_manager.dart';

/// page : 1
/// limit : 10
/// branch_id : 1
/// class_start_date : "2024-08-13"

ListBookingInput listBookingInputFromJson(String str) => ListBookingInput.fromJson(json.decode(str));

String listBookingInputToJson(ListBookingInput data) => json.encode(data.toJson());

class ListBookingInput {
  ListBookingInput(
      {this.page,
      this.limit,
      this.branchId,
      this.classStartDate,
      this.startTime,
      this.instrumentCode,
      this.duration,
      this.ip,
      this.deviceId,
      this.platform});

  ListBookingInput.fromJson(dynamic json) {
    page = json['page'];
    limit = json['limit'];
    branchId = json['branch_id'];
    classStartDate = json['class_start_date'];
  }

  num? page;
  num? limit;
  num? branchId;
  String? classStartDate;
  String? startTime;
  String? instrumentCode;
  String? duration;
  String? ip;
  String? deviceId;
  String? platform;

  ListBookingInput copyWith({
    num? page,
    num? limit,
    num? branchId,
    String? classStartDate,
    String? startTime,
    String? instrumentCode,
    String? duration,
    String? ip,
    String? deviceId,
    String? platform,
  }) =>
      ListBookingInput(
        page: page ?? this.page,
        limit: limit ?? this.limit,
        branchId: branchId ?? this.branchId,
        classStartDate: classStartDate ?? this.classStartDate,
        startTime: startTime ?? this.startTime,
        instrumentCode: instrumentCode ?? this.instrumentCode,
        duration: duration ?? this.duration,
        ip: ip ?? this.ip,
        deviceId: deviceId ?? this.deviceId,
        platform: platform ?? this.platform,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = page;
    map['limit'] = limit;
    if (branchId != null) {
      map['branch_id'] = branchId;
    }
    map['class_start_date'] = classStartDate;
    print('map: $map');
    return map;
  }

  Map<String, dynamic> toJsonPiano() {
    final map = <String, dynamic>{};
    map['branch_id'] = branchId;
    map['current_date'] = classStartDate;
    map['start_time'] = startTime;
    map['duration'] = duration ?? '90';

    return map;
  }

  Map<String, dynamic> toJsonBookPractice() {
    final map = <String, dynamic>{};
    map['duration'] = duration ?? '90';
    map['instrument_code'] = instrumentCode;
    map['branch_id'] = branchId;
    map['current_date'] = classStartDate;
    map['start_time'] = startTime;

    map['ip'] = ip;
    map['device_id'] = deviceId;
    map['platform'] = platform;

    return map;
  }
}
