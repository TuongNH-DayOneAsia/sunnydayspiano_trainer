import 'dart:convert';

import 'package:dayoneasia/screen/dashboard/booking_history/cubit/booking_history_cubit.dart';


/// page : 1
/// limit : 10
/// status_booking : "1\""

ListHistoryInput listHistoryInputFromJson(String str) => ListHistoryInput.fromJson(json.decode(str));

String listHistoryInputToJson(ListHistoryInput data) => json.encode(data.toJson());

class ListHistoryInput {
  ListHistoryInput({
    this.page,
    this.limit,
    this.statusBooking,
    this.classType,
  });

  ListHistoryInput.fromJson(dynamic json) {
    page = json['page'];
    limit = json['limit'];
    statusBooking = json['status_booking'];
    classType = ClassType.ONE_GENERAL;
  }

  num? page;
  num? limit;
  int? statusBooking;
  ClassType? classType;

  ListHistoryInput copyWith({num? page, num? limit, int? statusBooking, ClassType? classType}) => ListHistoryInput(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      statusBooking: statusBooking ?? this.statusBooking,
      classType: classType ?? this.classType);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = page;
    map['limit'] = limit;
    map['status_booking'] = statusBooking;
    // map['type'] = classType?.name;
    return map;
  }

  Map<String, dynamic> toJsonAll() {
    final map = <String, dynamic>{};
    map['page'] = page;
    map['limit'] = limit;
    // map['type'] = classType?.name;
    return map;
  }
}
