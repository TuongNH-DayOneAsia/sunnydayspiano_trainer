import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingSeatSelectionLegend extends StatelessWidget {
  const BookingSeatSelectionLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendItem(const Color(0xFF3BA771), 'bookingPractice.selectedPiano'.tr()),
          SizedBox(width: 10.w),
          _buildLegendItem(const Color(0xFFFFE0E0), 'bookingPractice.selected'.tr()),
          SizedBox(width: 10.w),
          _buildLegendItem(Colors.white, 'bookingPractice.emptyPiano'.tr()),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 5.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF6A6A6A),
          ),
        ),
      ],
    );
  }
}
