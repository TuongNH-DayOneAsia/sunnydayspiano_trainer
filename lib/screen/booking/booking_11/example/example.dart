// import 'package:dayoneasia/screen/booking/booking_11/booking/cubit/booking_11_cubit.dart';
// import 'package:dayoneasia/screen/booking/booking_11/booking/cubit/data/data_booking_11.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:myutils/config/local_stream.dart';
// import 'package:myutils/data/network/model/output/booking_11/list_time_11_output.dart';
// import 'package:myutils/helpers/extension/colors_extension.dart';
//
// class TimeGridView extends StatefulWidget {
//   const TimeGridView({super.key});
//
//   @override
//   _TimeGridViewState createState() => _TimeGridViewState();
// }
//
// class _TimeGridViewState extends State<TimeGridView> {
//   List<DataTimeSlot> timeSlots = [];
//   String? startTime;
//   String? endTime;
//   final ScrollController _scrollController = ScrollController();
//   late TimeSection selectedSection;
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     selectedSection = context.read<Booking11Cubit>().selectedSection;
//     timeSlots = [
//       "08:00",
//       "08:15",
//       "08:30",
//       "08:45",
//       "09:00",
//       "09:15",
//       "09:30",
//       "09:45",
//       "10:00",
//       "10:15",
//       "10:30",
//       "10:45",
//       "11:00",
//       "11:15",
//       "11:30",
//       "11:45",
//       "12:00",
//       "12:15",
//       "12:30",
//       "12:45",
//       "13:00",
//       "13:15",
//       "13:30",
//       "13:45",
//       "14:00",
//       "14:15",
//       "14:30",
//       "14:45",
//       "15:00",
//       "15:15",
//       "15:30",
//       "15:45",
//       "16:00",
//       "16:15",
//       "16:30",
//       "16:45",
//       "17:00",
//       "17:15",
//       "17:30",
//       "17:45",
//       "18:00",
//       "18:15",
//       "18:30",
//       "18:45",
//       "19:00",
//       "19:15",
//       "19:30",
//       "19:45",
//       "20:00",
//       "20:15",
//       "20:30",
//       "20:45",
//       "21:00",
//       "21:15",
//       "21:30",
//       "21:45",
//     ]
//         .asMap()
//         .map((index, time) {
//           // Set một số khung giờ cụ thể là đã được đặt
//           bool isBooked = time == "09:00" || // 9:00-10:00
//               time == "09:15" ||
//               time == "09:30" ||
//               time == "09:45" ||
//               time == "10:00" ||
//               time == "13:30" || // 13:30-14:30
//               time == "13:45" ||
//               time == "14:00" ||
//               time == "14:15" ||
//               time == "18:00" || // 18:00-19:00
//               time == "18:15" ||
//               time == "18:30" ||
//               time == "18:45";
//
//           return MapEntry(index, DataTimeSlot(time: time, isBooked: isBooked));
//         })
//         .values
//         .toList();
//   }
//
//   void handleTimeSelection(int index, BuildContext context) {
//     if (timeSlots[index].isBooked == true) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Thông báo'),
//             content: const Text(
//                 'Khung giờ này đã được đặt. Vui lòng chọn khung giờ khác.'),
//             actions: [
//               TextButton(
//                 child: const Text('Đóng'),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//             ],
//           );
//         },
//       );
//       return;
//     }
//
//     if (startTime == null) {
//       int startIndex = index;
//       int endIndex = startIndex + 4;
//
//       if (endIndex >= timeSlots.length) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('Thông báo'),
//               content: const Text(
//                   'Đã hết giờ cho ngày hôm nay. Vui lòng chọn thời gian khác.'),
//               actions: [
//                 TextButton(
//                   child: const Text('Đóng'),
//                   onPressed: () => Navigator.of(context).pop(),
//                 ),
//               ],
//             );
//           },
//         );
//         return;
//       }
//
//       bool hasBookedSlot = timeSlots
//           .getRange(startIndex, endIndex + 1)
//           .any((slot) => (slot.isBooked ?? true));
//
//       if (hasBookedSlot) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('Thông báo'),
//               content: const Text(
//                   'Khung giờ bạn chọn có thời gian đã được đặt. Vui lòng chọn khung giờ khác.'),
//               actions: [
//                 TextButton(
//                   child: const Text('Đóng'),
//                   onPressed: () => Navigator.of(context).pop(),
//                 ),
//               ],
//             );
//           },
//         );
//         return;
//       }
//
//       setState(() {
//         startTime = timeSlots[startIndex].time;
//         endTime = timeSlots[endIndex].time;
//
//         timeSlots = List.generate(
//           timeSlots.length,
//           (i) => DataTimeSlot(
//             time: timeSlots[i].time,
//             isSelected: i >= startIndex && i <= endIndex,
//             isBooked: timeSlots[i].isBooked,
//           ),
//         );
//       });
//
//       if (startTime != null && endTime != null) {
//         final selectedRange = SelectedTimeRange(
//           startTime: startTime!,
//           endTime: endTime!,
//         );
//         context
//             .read<Booking11Cubit>()
//             .emitSelectedTimeRange(data: selectedRange);
//       }
//     } else {
//       context.read<Booking11Cubit>().clearSelectedTimeRange();
//     }
//   }
//
//   void clearSelectedTimeRange() {
//     setState(
//       () {
//         startTime = null;
//         endTime = null;
//         timeSlots = timeSlots
//             .map((slot) => DataTimeSlot(
//                   time: slot.time,
//                   isSelected: false,
//                   isBooked: slot.isBooked,
//                 ))
//             .toList();
//       },
//     );
//   }
//
//   void scrollToSection(TimeSection section) {
//     setState(() {
//       selectedSection = section;
//     });
//     double offset;
//     switch (section) {
//       case TimeSection.morning:
//         offset = 0;
//         break;
//       case TimeSection.afternoon:
//         offset = _scrollController.position.maxScrollExtent / 2;
//         break;
//       case TimeSection.evening:
//         offset = _scrollController.position.maxScrollExtent;
//         break;
//     }
//
//     _scrollController.animateTo(
//       offset,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(color: Colors.grey[300]!, width: 1),
//         ),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.w),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _buildTitleSection(),
//           _buildDurationBadge(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTitleSection() {
//     return Row(
//       children: [
//         const Icon(Icons.access_time, color: Colors.black),
//         SizedBox(width: 14.w),
//         Text(
//           'Giờ học',
//           style: TextStyle(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTimeSelectionButtons() {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Row(
//         spacing: 2.w,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _buildSectionButton(
//             'Sáng',
//             const BorderRadius.only(
//               topLeft: Radius.circular(8),
//               bottomLeft: Radius.circular(8),
//             ),
//             TimeSection.morning,
//           ),
//           _buildSectionButton(
//             'Chiều',
//             BorderRadius.zero,
//             TimeSection.afternoon,
//           ),
//           _buildSectionButton(
//             'Tối',
//             const BorderRadius.only(
//               topRight: Radius.circular(8),
//               bottomRight: Radius.circular(8),
//             ),
//             TimeSection.evening,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDurationBadge() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.orange),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         'Thời lượng: 1 tiếng',
//         style: TextStyle(
//           color: Colors.orange[700],
//           fontSize: 14.sp,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionButton(
//       String text, BorderRadius borderRadius, TimeSection section) {
//     final isSelected = selectedSection == section;
//
//     return GestureDetector(
//       onTap: () {
//         scrollToSection(section);
//       },
//       child: Container(
//         width: 100,
//         height: 32,
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.orange[50] : const Color(0xFFF0F0F0),
//           borderRadius: borderRadius,
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: TextStyle(
//               color: isSelected ? Colors.orange[700] : Colors.grey,
//               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<Booking11Cubit, Booking11State>(
//       listenWhen: (previous, current) =>
//           previous.selectedTimeRange != current.selectedTimeRange,
//       listener: (context, state) {
//         try {
//           final timeRange = state.selectedTimeRange;
//           if (timeRange != null &&
//               timeRange.startTime.isEmpty &&
//               timeRange.endTime.isEmpty) {
//             setState(() {
//               startTime = null;
//               endTime = null;
//               timeSlots = List.generate(
//                 timeSlots.length,
//                 (index) => DataTimeSlot(
//                   time: timeSlots[index].time,
//                   isSelected: false,
//                   isBooked: timeSlots[index].isBooked,
//                 ),
//               );
//             });
//           }
//         } catch (e) {
//           debugPrint('time range listener: $e');
//         }
//       },
//       child: Card(
//         margin: EdgeInsets.zero,
//         child: Column(
//           children: [
//             _buildHeader(),
//             _buildTimeSelectionButtons(),
//             _buildTimeGrid(context),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTimeGrid(BuildContext context) {
//     return Expanded(
//       child: RawScrollbar(
//         thickness: 2,
//         thumbColor: MyColors.mainColor,
//         trackVisibility: true,
//         controller: _scrollController,
//         radius: const Radius.circular(20),
//         child: MediaQuery.removePadding(
//           context: context,
//           removeTop: true,
//           removeBottom: true,
//           child: GridView.builder(
//             shrinkWrap: true,
//             controller: _scrollController,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 4,
//               crossAxisSpacing: 0,
//               mainAxisSpacing: 4,
//               childAspectRatio: 1.9,
//             ),
//             itemCount: timeSlots.length,
//             itemBuilder: (context, index) => _buildTimeSlot(context, index),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTimeSlot(BuildContext context, int index) {
//     final bool isFirstSelected = (timeSlots[index].isSelected ?? false) &&
//         (index == 0 || !(timeSlots[index - 1].isSelected ?? false));
//     final bool isLastSelected = (timeSlots[index].isSelected ?? false) &&
//         (index == timeSlots.length - 1 ||
//             !(timeSlots[index + 1].isSelected ?? false));
//
//     return GestureDetector(
//       onTap: () {
//         handleTimeSelection(index, context);
//       },
//       child: Container(
//         alignment: Alignment.center,
//         decoration: _buildTimeSlotDecoration(
//           isFirstSelected,
//           isLastSelected,
//           (timeSlots[index].isSelected ?? false),
//         ),
//         child: Text(
//           timeSlots[index].time ?? '',
//           style: TextStyle(
//             fontSize: 16.sp,
//             color: (timeSlots[index].isBooked ?? false)
//                 ? Colors.grey
//                 : const Color(0xFF2A2A2A),
//           ),
//         ),
//       ),
//     );
//   }
//
//   BoxDecoration _buildTimeSlotDecoration(
//     bool isFirstSelected,
//     bool isLastSelected,
//     bool isSelected,
//   ) {
//     return BoxDecoration(
//       color: isSelected ? const Color(0x0CFF8B00) : null,
//       border: Border(
//         left: isFirstSelected
//             ? BorderSide(color: MyColors.mainColor, width: 4)
//             : BorderSide.none,
//         right: isLastSelected
//             ? BorderSide(color: MyColors.mainColor, width: 4)
//             : BorderSide.none,
//       ),
//       borderRadius: BorderRadius.only(
//         topLeft: isFirstSelected ? const Radius.circular(12) : Radius.zero,
//         bottomLeft: isFirstSelected ? const Radius.circular(12) : Radius.zero,
//         topRight: isLastSelected ? const Radius.circular(12) : Radius.zero,
//         bottomRight: isLastSelected ? const Radius.circular(12) : Radius.zero,
//       ),
//     );
//   }
// }
