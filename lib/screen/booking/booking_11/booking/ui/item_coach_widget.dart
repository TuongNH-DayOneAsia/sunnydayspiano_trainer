import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myutils/data/network/model/output/booking_11/coaches_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/popup/my_present_view_helper.dart';
import 'package:myutils/utils/widgets/my_button.dart';

class ItemCoachWidget extends StatelessWidget {
  final bool isItemForList;
  final DataCoach? coach;
  final DataCoach? coachSelected;

  const ItemCoachWidget({
    super.key,
    this.coach,
    this.isItemForList = false,
    this.coachSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        CircleAvatar(
          radius: isItemForList == true ? 24.w : 18.w,
          backgroundImage:
              coach?.avatar != null && coach!.avatar?.isNotEmpty == true
                  ? NetworkImage(coach!.avatar!)
                  : null,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: coach?.slug == coachSelected?.slug
                ? const ShapeDecoration(
                    shape: OvalBorder(
                      side: BorderSide(width: 2, color: Color(0xFFFFA63D)),
                    ),
                  )
                : null,
            child: coach?.avatar == null || coach!.avatar?.isEmpty == true
                ? Center(
                  child: Container(

                      // padding:isItemForList == true ? EdgeInsets.all(8.0) : EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.person,

                        size: isItemForList == true ? 30 : 40,
                        color: Color(0xFFFFA63D),
                      ),
                    ),
                )
                : null,
          ),
        ),
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(100),
        //   child: Image.network(
        //     coach?.avatar ?? '',
        //     width: isItemForList == true ? 60.w : 33.w,
        //     height: isItemForList == true ? 60.w : 33.w,
        //     fit: BoxFit.cover,
        //     errorBuilder: (context, error, stackTrace) {
        //       return Icon(
        //         Icons.person,
        //         size: isItemForList == true ? 60.w : 33.w,
        //         color: Colors.grey,
        //       );
        //     },
        //   ),
        // ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                coach?.name ?? '---',
                style: TextStyle(
                  fontWeight: coach?.slug == coachSelected?.slug
                      ? FontWeight.w600
                      : FontWeight.w500,
                  fontSize: 14.sp,
                  color: coach?.slug == coachSelected?.slug
                      ? MyColors.mainColor
                      : const Color(0xFF2A2A2A),
                ),
              ),
              Text(
                coach?.enName ?? '---',
                style: TextStyle(
                  fontWeight: coach?.slug == coachSelected?.slug
                      ? FontWeight.w600
                      : FontWeight.w500,
                  fontSize: 12.sp,
                  color: coach?.slug == coachSelected?.slug
                      ? MyColors.mainColor
                      : const Color(0xFF2A2A2A),
                ),
              ),
            ],
          ),
        ),
        if (!isItemForList)
          const Icon(Icons.chevron_right, size: 24.0, color: Colors.black54),
        if (isItemForList)
          Container(
            height: 60.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RippleTextButton(
                  onPressed: () {
                    MyPresentViewHelper.presentSheet<String?>(
                      title: 'OK',
                      context: context,
                      builder: Builder(
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: CoachProfileCard(
                              coach: coach,
                              onClose: () {
                                // Handle close
                              },
                              onSelect: (data) {
                                context.pop(data);
                                // Handle coach selection
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
                  fontSize: 12.sp,
                  text: 'Chi tiết',
                  color: MyColors.mainColor,
                ),
              ],
            ),
          ),
      ],
    );

    // return Column(
    //   children: [
    //     // Instructor Info
    //     Padding(
    //       padding: const EdgeInsets.all(10.0),
    //       child: Row(
    //         children: [
    //           // Profile Image
    //           ClipRRect(
    //             borderRadius: BorderRadius.circular(12),
    //             child: Image.network(
    //               'https://phanmemmkt.vn/wp-content/uploads/2024/09/avt-Facebook-hai-huoc.jpg',
    //               width: 90,
    //               height: 90,
    //               fit: BoxFit.cover,
    //               errorBuilder: (context, error, stackTrace) {
    //                 return const Icon(Icons.person,
    //                     size: 80, color: Colors.grey);
    //               },
    //             ),
    //           ),
    //
    //           const SizedBox(width: 16),
    //
    //           // Info Section
    //           Expanded(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   'Đào Quỳnh (Quinn)',
    //                   style: TextStyle(
    //                     fontWeight: FontWeight.w600,
    //                     fontSize: 14.sp,
    //                     color: const Color(0xFF2A2A2A),
    //                   ),
    //                 ),
    //                 SizedBox(height: 4.h),
    //                 Text(
    //                   'Kinh nghiệm: 3 năm',
    //                   style: TextStyle(
    //                     color: Colors.black54,
    //                     fontSize: 12.sp,
    //                   ),
    //                 ),
    //                 Text(
    //                   'Chuyên môn: nhạc cổ điển',
    //                   style: TextStyle(
    //                     color: Colors.black54,
    //                     fontSize: 12.sp,
    //                   ),
    //                 ),
    //                 const SizedBox(height: 4),
    //                 Row(
    //                   children: [
    //                     const Icon(Icons.star, color: Colors.orange, size: 20),
    //                     const SizedBox(width: 4),
    //                     Text(
    //                       '5.0',
    //                       textAlign: TextAlign.center,
    //                       style: TextStyle(
    //                         color: const Color(0xFF6A6A6A),
    //                         fontSize: 12.sp,
    //                         fontWeight: FontWeight.w400,
    //                       ),
    //                     ),
    //                     const SizedBox(width: 8),
    //                     Text(
    //                       'Thân thiện',
    //                       textAlign: TextAlign.center,
    //                       style: TextStyle(
    //                         color: const Color(0xFFFFA44B),
    //                         fontSize: 10.sp,
    //                         fontWeight: FontWeight.w400,
    //                       ),
    //                     ),
    //                     const SizedBox(width: 8),
    //                     Text(
    //                       'Thân thiện',
    //                       textAlign: TextAlign.center,
    //                       style: TextStyle(
    //                         color: const Color(0xFFFFA44B),
    //                         fontSize: 10.sp,
    //                         fontWeight: FontWeight.w400,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}

class CoachProfileCard extends StatelessWidget {
  final Function()? onClose;
  final Function(DataCoach data)? onSelect;
  final DataCoach? coach;

  const CoachProfileCard({
    super.key,
    this.coach,
    this.onClose,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 90.w,
            backgroundImage:
                coach?.avatar != null && coach!.avatar?.isNotEmpty == true
                    ? NetworkImage(coach!.avatar!)
                    : null,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: const ShapeDecoration(
                shape: OvalBorder(
                  side: BorderSide(width: 1.97, color: Color(0xFFFFA63D)),
                ),
              ),
              child: coach?.avatar == null || coach!.avatar?.isEmpty == true
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.person,
                        size: 160,
                        color: Color(0xFFFFA63D),
                      ),
                    )
                  : null,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            coach?.title ?? coach?.enName ?? "",
            style: GoogleFonts.unbounded(
              fontSize: 24.sp,
              fontWeight: FontWeight.w500,
              color: MyColors.mainColor,
            ),
          ),
          Text(
            coach?.name ?? '---',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.black87,
            ),
          ),
          Text(
            'Huấn Luyện Viên Piano',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 20.h),
          if (coach?.quoteTitle?.isNotEmpty == true ||
              coach?.quote?.isNotEmpty == true)
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                spacing: 10.h,
                children: [
                  if (coach?.quoteTitle?.isNotEmpty ?? false)
                    Text(
                      coach?.quoteTitle ?? '---',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14.sp,
                      ),
                    ),
                  if (coach?.quote?.isNotEmpty ?? false)
                    Text(
                      '"${coach?.quote ?? '---'}"',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                ],
              ),
            ),
          SizedBox(height: 20.h),
          MyButton(
            width: Dimens.getProportionalScreenWidth(context, 295),
            fontSize: 14.sp,
            text: 'Chọn HLV',
            color: MyColors.mainColor,
            colorText: Colors.white,
            height: 38.h,
            onPressed: (value) {
              // pop
              Navigator.of(context).pop();
              if (coach != null && onSelect != null) {
                onSelect!(coach!);
              }
            },
          ),
        ],
      ),
    );
  }
}
