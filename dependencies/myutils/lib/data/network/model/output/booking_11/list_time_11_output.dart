import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../helpers/extension/colors_extension.dart';

/// status_code : 200
/// status : "success"
/// message : "Get time booking successfully!"
/// data : [{"time":"08:00","active":false},{"time":"08:15","active":false},{"time":"08:30","active":false},{"time":"08:45","active":false},{"time":"09:00","active":false},{"time":"09:15","active":false},{"time":"09:30","active":false},{"time":"09:45","active":false},{"time":"10:00","active":false},{"time":"10:15","active":false},{"time":"10:30","active":false},{"time":"10:45","active":false},{"time":"11:00","active":false},{"time":"11:15","active":false},{"time":"11:30","active":false},{"time":"11:45","active":false},{"time":"12:00","active":false},{"time":"12:15","active":false},{"time":"12:30","active":false},{"time":"12:45","active":false},{"time":"13:00","active":true},{"time":"13:15","active":false},{"time":"13:30","active":false},{"time":"13:45","active":false},{"time":"14:00","active":false},{"time":"14:15","active":false},{"time":"14:30","active":false},{"time":"14:45","active":false},{"time":"15:00","active":true},{"time":"15:15","active":false},{"time":"15:30","active":false},{"time":"15:45","active":false},{"time":"16:00","active":false},{"time":"16:15","active":false},{"time":"16:30","active":false},{"time":"16:45","active":false},{"time":"17:00","active":false},{"time":"17:15","active":false},{"time":"17:30","active":false},{"time":"17:45","active":false},{"time":"18:00","active":false},{"time":"18:15","active":false},{"time":"18:30","active":false},{"time":"18:45","active":false},{"time":"19:00","active":false},{"time":"19:15","active":false},{"time":"19:30","active":false},{"time":"19:45","active":false},{"time":"20:00","active":true},{"time":"20:15","active":true},{"time":"20:30","active":true},{"time":"20:45","active":true},{"time":"21:00","active":true},{"time":"21:15","active":true},{"time":"21:30","active":true},{"time":"21:45","active":true},{"time":"22:00","active":true}]
/// errors : []

class ListTime11Output {
  ListTime11Output({
    this.statusCode,
    this.status,
    this.message,
    this.data,
  });

  ListTime11Output.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DataTimeSlot.fromJson(v));
      });
    }
  }

  int? statusCode;
  String? status;
  String? message;
  List<DataTimeSlot>? data;

  ListTime11Output copyWith({
    int? statusCode,
    String? status,
    String? message,
    List<DataTimeSlot>? data,
  }) =>
      ListTime11Output(
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
      map['data'] = data?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}

/// time : "08:00"
/// active : false

class DataTimeSlot {
  DataTimeSlot({
    this.time,
    this.isActive,
    this.isSelected,
    this.isBooked,
    this.textColor,
    this.backgroundColor,
  });

  DataTimeSlot.fromJson(dynamic json) {
    time = json['time'] ?? "---";
    isActive = json['active'] ?? false;
    isSelected = false;
    isBooked = json['is_booked'] ?? false;
    // textColor = isBooked == true ? Colors.white
    //     : isActive == false ? Colors.grey
    //     : isSelected == true ? MyColors.mainColor
    //     : const Color(0xFF2A2A2A);
    // backgroundColor = isSelected == true ? Colors.orange.withOpacity(0.2)
    //     : isBooked == true ? MyColors.lightGrayColor.withOpacity(0.5)
    //     : isActive == false ? null
    //     : Colors.white;
  }

  String? time;
  bool? isActive;
  bool? isSelected;
  bool? isBooked;
  Color? textColor;
  Color? backgroundColor;
  DataTimeSlot copyWith({
    String? time,
    bool? active,
    bool? isSelected,
    bool? isBooked,
    Color? textColor,
    Color? backgroundColor,
  }) =>
      DataTimeSlot(
        time: time ?? this.time,
        isActive: active ?? this.isActive,
        isSelected: isSelected ?? this.isSelected,
        isBooked: isBooked ?? this.isBooked,
        textColor: textColor ?? this.textColor,
        backgroundColor: backgroundColor ?? this.backgroundColor,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['time'] = time;
    map['active'] = isActive;
    map['isSelected'] = isSelected;
    map['isBooked'] = isBooked;
    map['textColor'] = textColor;
    map['backgroundColor'] = backgroundColor;
    return map;
  }
}
