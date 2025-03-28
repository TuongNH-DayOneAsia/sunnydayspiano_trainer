class ListClassOutput {
  ListClassOutput({
    this.statusCode,
    this.status,
    this.message,
    this.listClass,
    this.errors,
    this.pagination,
  });

  ListClassOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      listClass = [];
      json['data'].forEach((v) {
        listClass?.add(DataClass.fromJson(v));
      });
    }
    errors = json['errors'] != null ? json['errors'].cast<String>() : [];
    pagination = json['pagination'] != null
        ? DataPagination.fromJson(json['pagination'])
        : null;
  }

  num? statusCode;
  String? status;
  String? message;
  List<DataClass>? listClass;
  List<String>? errors;
  DataPagination? pagination;

  ListClassOutput copyWith({
    num? statusCode,
    String? status,
    String? message,
    List<DataClass>? listClass,
    List<String>? errors,
    DataPagination? pagination,
  }) =>
      ListClassOutput(
        statusCode: statusCode ?? this.statusCode,
        status: status ?? this.status,
        message: message ?? this.message,
        listClass: listClass ?? this.listClass,
        errors: errors ?? this.errors,
        pagination: pagination ?? this.pagination,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status_code'] = statusCode;
    map['status'] = status;
    map['message'] = message;
    if (listClass != null) {
      map['data'] = listClass?.map((v) => v.toJson()).toList();
    }
    map['errors'] = errors;
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    return map;
  }
}

class DataPagination {
  DataPagination({
    this.totalPage,
    this.perPage,
    this.currentPage,
    this.count,
  });

  DataPagination.fromJson(dynamic json) {
    totalPage = json['totalPage'] ?? 0;
    perPage = json['perPage'] ?? 0;
    currentPage = json['currentPage'] ?? 0;
    count = json['count'] ?? 0;
  }

  num? totalPage;
  num? perPage;
  num? currentPage;
  num? count;

  DataPagination copyWith({
    num? totalPage,
    num? perPage,
    num? currentPage,
    num? count,
  }) =>
      DataPagination(
        totalPage: totalPage ?? this.totalPage,
        perPage: perPage ?? this.perPage,
        currentPage: currentPage ?? this.currentPage,
        count: count ?? this.count,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalPage'] = totalPage;
    map['perPage'] = perPage;
    map['currentPage'] = currentPage;
    map['count'] = count;
    return map;
  }
}

class DataClass {
  DataClass({
    this.id,
    this.name,
    this.className,
    this.classCode,
    this.classLessonCode,
    this.classStartDate,
    this.classEndDate,
    this.classStartTime,
    this.classEndTime,
    this.instrumentsTotal,
    this.branch,
    this.classType,
    this.classData,
    this.classroom,
    this.coaches,
    this.instrumentsTotalActive,
    this.instrumentsTotalBooked,
    this.instrumentsTotalEmpty,
    this.classLessonName,
    this.classroomName,
    this.classLessonTimeStartToEnd,
    this.classLessonStartDate,
    this.createdAt,
    this.statusBooking,
    this.statusInClass,
    this.statusBookingText,
    this.statusBookingColor,
    this.statusInClassText,
    this.statusInClassColor,
    this.textIsBook,
    this.isFullSlot,
    this.textRequestClassLesson,
    this.isRequestClassLesson,
    this.isCancel,
    this.isBooking,
    this.bookNote,
    this.bookingCode,
    this.status,
    this.branchName,
    this.branchHisTory,
    this.productName,
    this.listCoaches
  });

  DataClass.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    className = json['class_name'] ?? '';
    classCode = json['class_code'] ?? '';
    classLessonCode = json['class_lesson_code'] ?? '';
    classStartDate = json['class_start_date'] ?? '';
    classEndDate = json['class_end_date'] ?? '';
    classStartTime = json['class_start_time'] ?? '';
    classEndTime = json['class_end_time'] ?? '';

    instrumentsTotal = json['instruments_total'] ?? 0;
    instrumentsTotalActive = json['instruments_total_active'] ?? 0;
    instrumentsTotalBooked = json['instruments_total_booked'] ?? 0;
    instrumentsTotalEmpty = json['instruments_total_empty'] ?? 0;
    branch = json['branch'] != null
        ? DataInfoNameBooking.fromJson(json['branch'])
        : null;
    branchName = json['branch_name'] ?? '';
    classType = json['class_type'] != null
        ? DataInfoNameBooking.fromJson(json['class_type'])
        : null;
    classData = json['class'] != null
        ? DataInfoNameBooking.fromJson(json['class'])
        : null;
    classroom = json['classroom'] != null
        ? DataInfoNameBooking.fromJson(json['classroom'])
        : null;
    coaches = json['coaches'] ?? '';

    classLessonName = json['class_lesson_name'] ?? '';
    classroomName = json['classroom_name'] ?? '';
    classLessonTimeStartToEnd = json['class_lesson_time_start_to_end'] ?? '';
    classLessonStartDate = json['class_lesson_start_date'] ?? '';
    createdAt = json['created_at'] ?? '';
    statusBooking = json['status_booking'];
    statusInClass = json['status_in_class'];
    statusBookingText = json['status_booking_text'] ?? '';
    statusBookingColor = json['status_booking_color'] ?? '';
    statusInClassText = json['status_in_class_text'] ?? '';
    statusInClassColor = json['status_in_class_color'] ?? '';
    branchHisTory =
        json['branch'] != null ? Branch.fromJson(json['branch']) : null;
    isCancel = json['is_cancel'] ?? false;
    isBooking = json['is_booking'] ?? false;
    bookNote = json['book_note'] ?? '';
    textIsBook = json['text_is_book'] ?? '';
    bookingCode = json['booking_code'] ?? '';
    isFullSlot = json['is_full_slot'] ?? false;
    // isFullSlot = true;
    status = json['status'] ?? 1;
    textRequestClassLesson = json['text_request_class_lesson'] ?? '';
    isRequestClassLesson = json['is_request_class_lesson'] ?? false;
    productName = json['product_name'] ?? '';
    if (json['list_coach'] != null) {
      listCoaches = [];
      json['list_coach'].forEach((v) {
        listCoaches?.add(DataCoaches.fromJson(v));
      });
    }
  }

  num? id;
  String? name;
  String? className;
  String? classCode;
  String? classLessonCode;
  String? classStartDate;
  String? classEndDate;
  String? classStartTime;
  String? classEndTime;
  num? instrumentsTotal;
  num? instrumentsTotalActive;
  num? instrumentsTotalBooked;
  num? instrumentsTotalEmpty;
  DataInfoNameBooking? branch;
  DataInfoNameBooking? classType;
  DataInfoNameBooking? classData;
  DataInfoNameBooking? classroom;
  String? coaches;
  String? bookingCode;
  int? status;

  String? classLessonName;
  String? classroomName;
  String? classLessonTimeStartToEnd;
  String? classLessonStartDate;
  Branch? branchHisTory;

  String? createdAt;
  num? statusBooking;
  num? statusInClass;
  String? statusBookingText;
  String? statusBookingColor;
  String? statusInClassText;
  String? statusInClassColor;
  String? bookNote;

  bool? isCancel;

  bool? isBooking;
  String? textIsBook;
  String? branchName;
  bool? isFullSlot;

  String? textRequestClassLesson;
  bool? isRequestClassLesson;
  String? productName;
  List<DataCoaches>? listCoaches;

  DataClass copyWith({
    num? id,
    String? name,
    String? className,
    String? classCode,
    String? classLessonCode,
    String? classStartDate,
    String? classEndDate,
    String? classStartTime,
    String? classEndTime,
    num? instrumentsTotal,
    num? instrumentsTotalActive,
    num? instrumentsTotalBooked,
    num? instrumentsTotalEmpty,
    DataInfoNameBooking? branch,
    String? branchName,
    DataInfoNameBooking? classType,
    DataInfoNameBooking? classData,
    DataInfoNameBooking? classroom,
    String? coaches,
    String? bookingCode,
    int? status,
    String? classLessonName,
    String? classroomName,
    String? classLessonTimeStartToEnd,
    String? classLessonStartDate,
    Branch? branchHisTory,
    String? createdAt,
    num? statusBooking,
    num? statusInClass,
    String? statusBookingText,
    String? statusBookingColor,
    String? statusInClassText,
    String? statusInClassColor,
    String? bookNote,
    bool? isCancel,
    bool? isBooking,
    String? textIsBook,
    bool? isFullSlot,
    String? textRequestClassLesson,
    bool? isRequestClassLesson,
    String? productName,
    List<DataCoaches>? listCoaches,
  }) =>
      DataClass(
        id: id ?? this.id,
        name: name ?? this.name,
        className: className ?? this.className,
        classCode: classCode ?? this.classCode,
        classLessonCode: classLessonCode ?? this.classLessonCode,
        classStartDate: classStartDate ?? this.classStartDate,
        classEndDate: classEndDate ?? this.classEndDate,
        classStartTime: classStartTime ?? this.classStartTime,
        classEndTime: classEndTime ?? this.classEndTime,
        instrumentsTotal: instrumentsTotal ?? this.instrumentsTotal,
        instrumentsTotalActive:
            instrumentsTotalActive ?? this.instrumentsTotalActive,
        instrumentsTotalBooked:
            instrumentsTotalBooked ?? this.instrumentsTotalBooked,
        instrumentsTotalEmpty:
            instrumentsTotalEmpty ?? this.instrumentsTotalEmpty,
        branch: branch ?? this.branch,
        branchName: branchName ?? this.branchName,
        classType: classType ?? this.classType,
        classData: classData ?? this.classData,
        classroom: classroom ?? this.classroom,
        coaches: coaches ?? this.coaches,
        bookingCode: bookingCode ?? this.bookingCode,
        status: status ?? this.status,
        classLessonName: classLessonName ?? this.classLessonName,
        classroomName: classroomName ?? this.classroomName,
        classLessonTimeStartToEnd:
            classLessonTimeStartToEnd ?? this.classLessonTimeStartToEnd,
        classLessonStartDate: classLessonStartDate ?? this.classLessonStartDate,
        branchHisTory: branchHisTory ?? this.branchHisTory,
        createdAt: createdAt ?? this.createdAt,
        statusBooking: statusBooking ?? this.statusBooking,
        statusInClass: statusInClass ?? this.statusInClass,
        statusBookingText: statusBookingText ?? this.statusBookingText,
        statusBookingColor: statusBookingColor ?? this.statusBookingColor,
        statusInClassText: statusInClassText ?? this.statusInClassText,
        statusInClassColor: statusInClassColor ?? this.statusInClassColor,
        bookNote: bookNote ?? this.bookNote,
        isCancel: isCancel ?? this.isCancel,
        isBooking: isBooking ?? this.isBooking,
        textIsBook: textIsBook ?? this.textIsBook,
        isFullSlot: isFullSlot ?? this.isFullSlot,
        textRequestClassLesson:
            textRequestClassLesson ?? this.textRequestClassLesson,
        isRequestClassLesson: isRequestClassLesson ?? this.isRequestClassLesson,
        productName: productName ?? this.productName,
        listCoaches: listCoaches ?? this.listCoaches,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['class_name'] = className;
    map['class_code'] = classCode;
    map['class_lesson_code'] = classLessonCode;
    map['class_start_date'] = classStartDate;
    map['class_end_date'] = classEndDate;
    map['class_start_time'] = classStartTime;
    map['class_end_time'] = classEndTime;
    map['total_instruments'] = instrumentsTotal;
    map['instruments_total_active'] = instrumentsTotalActive;
    map['instruments_total_booked'] = instrumentsTotalBooked;
    map['instruments_total_empty'] = instrumentsTotalEmpty;
    if (branch != null) {
      map['branch'] = branch?.toJson();
    }
    if (classType != null) {
      map['class_type'] = classType?.toJson();
    }
    if (classData != null) {
      map['class'] = classData?.toJson();
    }
    if (classroom != null) {
      map['classroom'] = classroom?.toJson();
    }
    //check coaches
    map['coaches'] = coaches;
    map['status'] = status;
    map['product_name'] = productName;
    if (listCoaches != null) {
      map['list_coach'] = listCoaches?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  String nameCoach() {
    return coaches ?? '---';
  }
}
class DataCoaches {
  DataCoaches({
    this.name,
    this.type
  });

  DataCoaches.fromJson(dynamic json) {
    name = json['name'];
    type = json['type'];
  }

  String? name;
  String? type;

  DataCoaches copyWith({
    String? name,
    String? type,
  }) =>
      DataCoaches(
        name: name ?? this.name,
        type: type ?? this.type,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['type'] = type;
    return map;
  }
}
// "avatar":"https://staging-booking.sunnydays.vn/storage/branches/branch-5/avatar/avatar-20240819_145821-5.png",
// "full_address":"270 Huỳnh Văn Bánh, Phường 11, Quận Phú Nhuận, Thành phố Hồ Chí Minh",
// "branch_name_sunny_day":"Sunny Days SND Huỳnh Văn Bánh"
class DataInfoNameBooking {
  DataInfoNameBooking({
    this.id,
    this.name,
    this.isSelected = false,
    this.avatar,
    this.fullAddress,
    this.branchNameSunnyDay,
    this.haveRoom,
    this.message
  });

  DataInfoNameBooking.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    isSelected = false;
    avatar = json['avatar'] ?? '';
    fullAddress = json['full_address'] ?? '';
    haveRoom = json['have_room'] ?? true;
    branchNameSunnyDay = json['branch_name_sunny_day'] ?? '';
    message = json['message'] ?? '';
  }

  int? id;
  String? name;
  bool isSelected = false;
  String? avatar;
  bool? haveRoom;
  String? message;
  String? fullAddress;
  String? branchNameSunnyDay;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['avatar'] = avatar;
    map['full_address'] = fullAddress;
    map['branch_name_sunny_day'] = branchNameSunnyDay;
    map['have_room'] = haveRoom;
    map['message'] = message;

    return map;
  }
}

class Branch {
  Branch({
    this.fullAddress,
  });

  Branch.fromJson(dynamic json) {
    fullAddress = json['full_address'];
  }

  String? fullAddress;

  Branch copyWith({
    String? fullAddress,
  }) =>
      Branch(
        fullAddress: fullAddress ?? this.fullAddress,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['full_address'] = fullAddress;
    return map;
  }
}
