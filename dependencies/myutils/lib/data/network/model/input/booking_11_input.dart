// import 'package:myutils/data/network/model/output/booking_11/coaches_output.dart';
// import 'package:myutils/data/network/model/output/list_class_output.dart';
//
// /// coach_slug : "ddymtpammgq"
// /// key : "ONE_GERENAL"
// /// branch_id : 1
// /// current_date : "2025-01-15"
// /// start_time : "16:00"
// /// end_time : "17:00"
// /// duration : 60
// /// ip : "HVB-CL-001-17:30-19:00-17102024"
// /// device_id : "HVB-CL-001-17:30-19:00-17102024"
// /// platform : "HVB-CL-001-17:30-19:00-17102024"
//
// class Booking11Input {
//   Booking11Input({
//     this.key,
//     this.currentDate,
//     this.startTime,
//     this.endTime,
//     this.duration,
//     this.ip,
//     this.deviceId,
//     this.platform,
//     this.dataCoachSelected,
//     this.dataBranchSelected,
//     this.durationString,
//     this.currentDateDisplay,
//   });
//
//   String? key;
//   String? currentDate;
//   String? startTime;
//   String? endTime;
//   int? duration;
//   String? ip;
//   String? deviceId;
//   String? platform;
//   DataCoach? dataCoachSelected;
//   DataInfoNameBooking? dataBranchSelected;
//   String? durationString;
//   String? currentDateDisplay;
//
//   Booking11Input copyWith({
//     String? coachSlug,
//     String? key,
//     int? branchId,
//     String? currentDate,
//     String? startTime,
//     String? endTime,
//     int? duration,
//     String? ip,
//     String? deviceId,
//     String? platform,
//     DataCoach? dataCoachSelected,
//     DataInfoNameBooking? dataBranchSelected,
//     String? durationString,
//     String? currentDateDisplay,
//   }) =>
//       Booking11Input(
//         key: key ?? this.key,
//         currentDate: currentDate ?? this.currentDate,
//         startTime: startTime ?? this.startTime,
//         endTime: endTime ?? this.endTime,
//         duration: duration ?? this.duration,
//         ip: ip ?? this.ip,
//         deviceId: deviceId ?? this.deviceId,
//         platform: platform ?? this.platform,
//         dataCoachSelected: dataCoachSelected ?? this.dataCoachSelected,
//         dataBranchSelected: dataBranchSelected ?? this.dataBranchSelected,
//         durationString: durationString ?? this.durationString,
//         currentDateDisplay: currentDateDisplay ?? this.currentDateDisplay,
//       );
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['coach_slug'] = dataCoachSelected?.slug ?? '';
//     map['key'] = key;
//     map['branch_id'] = dataBranchSelected?.id;
//     map['current_date'] = currentDate;
//     map['start_time'] = startTime;
//     map['end_time'] = endTime;
//     map['duration'] = duration;
//     map['ip'] = ip;
//     map['device_id'] = deviceId;
//     map['platform'] = platform;
//     return map;
//   }
// }
