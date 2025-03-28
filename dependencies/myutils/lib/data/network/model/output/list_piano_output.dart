import 'dart:convert';
/// status_code : 200
/// status : "success"
/// message : "Get list piano successfully!"
/// data : [{"instrument_code":"HVB_Đàn1","is_booking":false},{"instrument_code":"HVB_Đàn4","is_booking":true},{"instrument_code":"HVB_Đàn2","is_booking":true},{"instrument_code":"HVB_Đàn3","is_booking":true},{"instrument_code":"HVB_Đàn5","is_booking":true}]
/// errors : []

ListPianoOutput listPianoOutputFromJson(String str) => ListPianoOutput.fromJson(json.decode(str));
String listPianoOutputToJson(ListPianoOutput data) => json.encode(data.toJson());
class ListPianoOutput {
  ListPianoOutput({
      this.statusCode, 
      this.status, 
      this.message, 
      this.data, 
      });

  ListPianoOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DataPiano.fromJson(v));
      });
    }

  }
  num? statusCode;
  String? status;
  String? message;
  List<DataPiano>? data;
ListPianoOutput copyWith({  num? statusCode,
  String? status,
  String? message,
  List<DataPiano>? data,
}) => ListPianoOutput(  statusCode: statusCode ?? this.statusCode,
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

/// instrument_code : "HVB_Đàn1"
/// is_booking : false


class DataPiano {
  DataPiano({
      this.instrumentCode, 
      this.isBooking,});

  DataPiano.fromJson(dynamic json) {
    instrumentCode = json['instrument_code'];
    isBooking = json['is_booking'];
  }
  String? instrumentCode;
  bool? isBooking;
  DataPiano copyWith({  String? instrumentCode,
  bool? isBooking,
}) => DataPiano(  instrumentCode: instrumentCode ?? this.instrumentCode,
  isBooking: isBooking ?? this.isBooking,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['instrument_code'] = instrumentCode;
    map['is_booking'] = isBooking;
    return map;
  }

}