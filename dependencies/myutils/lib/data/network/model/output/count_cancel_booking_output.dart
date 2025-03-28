import 'dart:convert';

/// status_code : 200
/// status : "success"
/// message : "Count of successfully canceled bookings!"
/// data : {"canceled":2,"limit":4,"remaining":2}
/// errors : ["",""]

class CountCancelBookingOutput {
  CountCancelBookingOutput({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  CountCancelBookingOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataCancelBooking.fromJson(json['data']) : null;
    errors = json['errors'] != null ? json['errors'].cast<String>() : [];
  }

  num? statusCode;
  String? status;
  String? message;
  DataCancelBooking? data;
  List<String>? errors;

  CountCancelBookingOutput copyWith({
    num? statusCode,
    String? status,
    String? message,
    DataCancelBooking? data,
    List<String>? errors,
  }) =>
      CountCancelBookingOutput(
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

/// canceled : 2
/// limit : 4
/// remaining : 2

class DataCancelBooking {
  DataCancelBooking({
    this.canceled,
    this.limit,
    this.remaining,
    this.messageNote,
    this.blockUserBooking,
  });

  DataCancelBooking.fromJson(dynamic json) {
    canceled = json['canceled'] ?? 0;
    limit = json['limit'] ?? 0;
    remaining = json['remaining'] ?? 0;
    messageNote = json['message_note'] ?? '';
    blockUserBooking = json['block_user_booking'] ?? false;
  }

  num? canceled;
  num? limit;
  num? remaining;
  String? messageNote;
  bool? blockUserBooking;

  DataCancelBooking copyWith({num? canceled, num? limit, num? remaining, String? messageNote,
  bool? blockUserBooking

  }) => DataCancelBooking(
        canceled: canceled ?? this.canceled,
        limit: limit ?? this.limit,
        remaining: remaining ?? this.remaining,
        messageNote: messageNote ?? this.messageNote,
        blockUserBooking: blockUserBooking ?? this.blockUserBooking,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['canceled'] = canceled;
    map['limit'] = limit;
    map['remaining'] = remaining;
    map['messageNote'] = messageNote;
    map['blockUserBooking'] = blockUserBooking;
    return map;
  }
}
