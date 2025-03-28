import '../list_class_output.dart';
import 'coaches_output.dart';

/// status_code : 200
/// status : "success"
/// message : "Get detail booking practice successfully!"
/// data : {"booking_code":"1-1GE-17375174761","classroom":"General-1 ĐD","time":"08:00-09:00","start_time":"08:00","end_time":"09:00","instrument_start_date":"22/01/2025","branch_name":"21 Đặng Dung, Phường Tân Định, Quận 1, Thành phố Hồ Chí Minh","instrument_duration":"60 phút","instrument_code":"DAN002","created_at":"22/01/2025","cancel_date":"22/01/2025","book_note":"","status_booking":1,"status_in_class":1,"status_booking_text":"Thành công","status_booking_color":"0xFF28A745","status_in_class_text":"Chưa đến lớp","status_in_class_color":"0xFFFF4545","is_cancel":false,"product_name":"Mastery Plus","type":"ONE_GERENAL","class_type":"Lớp 1:1 không gian chung","coach_name":"Hữu Tường (Go)","booking_by":"Học viên","cancel_by":"SunnyDays"}

class Booking11DetailOutput {
  Booking11DetailOutput({
    this.statusCode,
    this.status,
    this.message,
    this.data,
  });

  Booking11DetailOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataBooking11Detail.fromJson(json['data']) : null;
  }
  int? statusCode;
  String? status;
  String? message;
  DataBooking11Detail? data;
  Booking11DetailOutput copyWith({
    int? statusCode,
    String? status,
    String? message,
    DataBooking11Detail? data,
  }) =>
      Booking11DetailOutput(
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
      map['data'] = data?.toJson();
    }
    return map;
  }
}

/// booking_code : "1-1GE-17375174761"
/// classroom : "General-1 ĐD"
/// time : "08:00-09:00"
/// start_time : "08:00"
/// end_time : "09:00"
/// instrument_start_date : "22/01/2025"
/// branch_name : "21 Đặng Dung, Phường Tân Định, Quận 1, Thành phố Hồ Chí Minh"
/// instrument_duration : "60 phút"
/// instrument_code : "DAN002"
/// created_at : "22/01/2025"
/// cancel_date : "22/01/2025"
/// book_note : ""
/// status_booking : 1
/// status_in_class : 1
/// status_booking_text : "Thành công"
/// status_booking_color : "0xFF28A745"
/// status_in_class_text : "Chưa đến lớp"
/// status_in_class_color : "0xFFFF4545"
/// is_cancel : false
/// product_name : "Mastery Plus"
/// type : "ONE_GERENAL"
/// class_type : "Lớp 1:1 không gian chung"
/// coach_name : "Hữu Tường (Go)"
/// booking_by : "Học viên"
/// cancel_by : "SunnyDays"

class DataBooking11Detail {
  DataBooking11Detail({
    this.bookingCode,
    this.classroom,
    this.time,
    this.startTime,
    this.endTime,
    this.instrumentStartDate,
    this.branchName,
    this.instrumentDuration,
    this.instrumentCode,
    this.createdAt,
    this.cancelDate,
    this.bookNote,
    this.statusBooking,
    this.statusInClass,
    this.statusBookingText,
    this.statusBookingColor,
    this.statusInClassText,
    this.statusInClassColor,
    this.isCancel,
    this.productName,
    this.type,
    this.classType,
    this.coachName,
    this.bookingBy,
    this.cancelBy,
    this.key,
    this.currentDate,
    this.duration,
    this.ip,
    this.deviceId,
    this.platform,
    this.dataCoachSelected,
    this.dataBranchSelected,
    this.durationString,
    this.currentDateDisplay,
    this.bookingNote,
    this.contractSlug
  });

  DataBooking11Detail.fromJson(dynamic json) {
    bookingCode = json['booking_code'];
    classroom = json['classroom'];
    time = json['time'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    instrumentStartDate = json['instrument_start_date'];
    branchName = json['branch_name'];
    instrumentDuration = json['instrument_duration'];
    instrumentCode = json['instrument_code'];
    createdAt = json['created_at'];
    cancelDate = json['cancel_date'];
    bookNote = json['book_note'];
    statusBooking = json['status_booking'];
    statusInClass = json['status_in_class'];
    statusBookingText = json['status_booking_text'];
    statusBookingColor = json['status_booking_color'];
    statusInClassText = json['status_in_class_text'];
    statusInClassColor = json['status_in_class_color'];
    isCancel = json['is_cancel'];
    productName = json['product_name'];
    type = json['type'];
    classType = json['class_type'];
    coachName = json['coach_name'];
    bookingBy = json['booking_by'];
    cancelBy = json['cancel_by'];

    dataCoachSelected = DataCoach(
      fullName: coachName  ?? '---',
    );
    dataBranchSelected = DataInfoNameBooking(
      name: branchName ?? '---',
    );
    currentDateDisplay = instrumentStartDate ?? '---';
    durationString = instrumentDuration ?? '---';
    bookingNote = json['booking_note'];
  }
  String? bookingCode;
  String? classroom;
  String? time;
  String? startTime;
  String? endTime;
  String? instrumentStartDate;
  String? branchName;
  String? instrumentDuration;
  String? instrumentCode;
  String? createdAt;
  String? cancelDate;
  String? bookNote;
  int? statusBooking;
  int? statusInClass;
  String? statusBookingText;
  String? statusBookingColor;
  String? statusInClassText;
  String? statusInClassColor;
  bool? isCancel;
  String? productName;
  String? type;
  String? classType;
  String? coachName;
  String? bookingBy;
  String? cancelBy;
  String? key;
  String? currentDate;
  int? duration;
  String? ip;
  String? deviceId;
  String? platform;
  DataCoach? dataCoachSelected;
  DataInfoNameBooking? dataBranchSelected;

  String? durationString;
  String? currentDateDisplay;
  String? bookingNote;
  String? contractSlug;

  DataBooking11Detail copyWith({
    String? bookingCode,
    String? classroom,
    String? time,
    String? startTime,
    String? endTime,
    String? instrumentStartDate,
    String? branchName,
    String? instrumentDuration,
    String? instrumentCode,
    String? createdAt,
    String? cancelDate,
    String? bookNote,
    int? statusBooking,
    int? statusInClass,
    String? statusBookingText,
    String? statusBookingColor,
    String? statusInClassText,
    String? statusInClassColor,
    bool? isCancel,
    String? productName,
    String? type,
    String? classType,
    String? coachName,
    String? bookingBy,
    String? cancelBy,
    String? bookingNote,
    String? contractSlug
  }) =>
      DataBooking11Detail(
        bookingCode: bookingCode ?? this.bookingCode,
        classroom: classroom ?? this.classroom,
        time: time ?? this.time,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        instrumentStartDate: instrumentStartDate ?? this.instrumentStartDate,
        branchName: branchName ?? this.branchName,
        instrumentDuration: instrumentDuration ?? this.instrumentDuration,
        instrumentCode: instrumentCode ?? this.instrumentCode,
        createdAt: createdAt ?? this.createdAt,
        cancelDate: cancelDate ?? this.cancelDate,
        bookNote: bookNote ?? this.bookNote,
        statusBooking: statusBooking ?? this.statusBooking,
        statusInClass: statusInClass ?? this.statusInClass,
        statusBookingText: statusBookingText ?? this.statusBookingText,
        statusBookingColor: statusBookingColor ?? this.statusBookingColor,
        statusInClassText: statusInClassText ?? this.statusInClassText,
        statusInClassColor: statusInClassColor ?? this.statusInClassColor,
        isCancel: isCancel ?? this.isCancel,
        productName: productName ?? this.productName,
        type: type ?? this.type,
        classType: classType ?? this.classType,
        coachName: coachName ?? this.coachName,
        bookingBy: bookingBy ?? this.bookingBy,
        cancelBy: cancelBy ?? this.cancelBy,
        bookingNote: bookingNote ?? this.bookingNote,
        contractSlug: contractSlug ?? this.contractSlug
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['booking_code'] = bookingCode;
    map['classroom'] = classroom;
    map['time'] = time;
    map['start_time'] = startTime;
    map['end_time'] = endTime;
    map['instrument_start_date'] = instrumentStartDate;
    map['branch_name'] = branchName;
    map['instrument_duration'] = instrumentDuration;
    map['instrument_code'] = instrumentCode;
    map['created_at'] = createdAt;
    map['cancel_date'] = cancelDate;
    map['book_note'] = bookNote;
    map['status_booking'] = statusBooking;
    map['status_in_class'] = statusInClass;
    map['status_booking_text'] = statusBookingText;
    map['status_booking_color'] = statusBookingColor;
    map['status_in_class_text'] = statusInClassText;
    map['status_in_class_color'] = statusInClassColor;
    map['is_cancel'] = isCancel;
    map['product_name'] = productName;
    map['type'] = type;
    map['class_type'] = classType;
    map['coach_name'] = coachName;
    map['booking_by'] = bookingBy;
    map['cancel_by'] = cancelBy;
    map['contract_slug'] = contractSlug;
    return map;
  }

  Map<String, dynamic> bookingToJson() {
    final map = <String, dynamic>{};
    map['coach_slug'] = dataCoachSelected?.slug ?? '';
    map['key'] = key;
    map['branch_id'] = dataBranchSelected?.id;
    map['current_date'] = currentDate;
    map['start_time'] = startTime;
    map['end_time'] = endTime;
    map['duration'] = duration;
    map['ip'] = ip;
    map['device_id'] = deviceId;
    map['platform'] = platform;
    map['contract_slug'] = contractSlug;

    return map;
  }
}
