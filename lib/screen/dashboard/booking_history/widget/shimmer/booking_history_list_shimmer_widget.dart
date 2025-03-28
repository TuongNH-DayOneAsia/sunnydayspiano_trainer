import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class BookingHistoryListShimmerWidget extends StatelessWidget {
  const BookingHistoryListShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShimmerDateHeader(),
          _buildShimmerBookingCard(),
        ],
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );}

  Widget _buildShimmerDateHeader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: 8.0.w,),
        child: Container(
          width: 120.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerBookingCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShimmerBox(width: 120, height: 12),
                        const SizedBox(height: 16),
                        _buildShimmerBox(width: 150, height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 70,
                    child: VerticalDivider(
                      color: Colors.grey[300],
                      thickness: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShimmerBox(width: 100, height: 12),
                        const SizedBox(height: 5),
                        _buildShimmerBox(width: 120, height: 12),
                        const SizedBox(height: 5),
                        _buildShimmerBox(width: 140, height: 12),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildShimmerBox(width: 80, height: 12),
                      const SizedBox(height: 4),
                      _buildShimmerBox(width: 60, height: 12),
                    ],
                  ),
                  _buildShimmerButton(width: 100, height: 35),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerBox({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildShimmerButton({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
    );
  }
}
