import 'package:dayoneasia/screen/dashboard/booking_history/cubit/booking_history_cubit.dart';
import 'package:dayoneasia/screen/dashboard/home/cubit/home/home_cubit.dart';
import 'package:dayoneasia/screen/dashboard/home/cubit/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myutils/data/network/model/output/booking_class_types_output.dart';
import 'package:myutils/data/network/model/output/menus_in_home_output.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:shimmer/shimmer.dart';

class BookingClassTypesV3Screen extends StatelessWidget {
  final Function(DataMenuV3 data) onPressedItem;

  const BookingClassTypesV3Screen({super.key, required this.onPressedItem});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final listBookingClassTypes = state.menusInHome?.data?.arrayMenu ?? [];

        // Show shimmer loading when data is loading or empty
        if (listBookingClassTypes.isEmpty) {
          return _buildShimmerLoading(context);
        }

        double itemHeight = 30.h + 10.h + 40.h;
        double itemWidth =
            (MediaQuery.of(context).size.width - 32.w - 16.w * 2) / 3;

        return SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: listBookingClassTypes.map((bookingClassType) {
              final Map<String, String> iconMap = {
                ClassType.CLASS.name: 'dashboard/circle-class.svg',
                ClassType.CLASS_PRACTICE.name: 'dashboard/circle-practice.svg',
                ClassType.ONE_GENERAL.name: 'dashboard/circle-free.svg',
                ClassType.ONE_PRIVATE.name: 'dashboard/circle-free.svg',
                "ONE_ONE": 'dashboard/circle-private.svg',
              };

              var icon =
                  iconMap[bookingClassType.icon] ?? 'dashboard/circle-free.svg';
              final isLastItem = listBookingClassTypes.last == bookingClassType;

              return InkWell(
                onTap: () {
                  onPressedItem(bookingClassType);
                },
                child: _buildMenuItem(
                  context: context,
                  urlIcon: icon,
                  title: bookingClassType.name ?? '',
                  itemCount: listBookingClassTypes.length,
                  isLastItem: isLastItem,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required String urlIcon,
    required String title,
    required BuildContext context,
    required int itemCount,
    required bool isLastItem,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        MyAppIcon.iconNamedCommon(
          iconName: urlIcon,
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title.textBookingTypeInHome(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
              ),
            ),
            if (isLastItem)
              Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 8.h,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ],
    );
  }

  // Shimmer loading effect widget
  Widget _buildShimmerLoading(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 0.991,
        ),
        itemCount: 3,
        // Show 6 shimmer items by default
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Circle for icon
                Container(
                  width: 30.h,
                  height: 30.h,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 10.h),
                // Rectangle for text
                Container(
                  width: 60.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
