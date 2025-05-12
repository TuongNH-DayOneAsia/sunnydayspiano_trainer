import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dayoneasia/screen/booking/branch_list_screen/branch_list_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/data/network/model/output/banner_class_type_output.dart';
import 'package:myutils/data/network/model/output/list_class_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/helpers/extension/image_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';

class BookingSelectBranchWidget extends StatelessWidget {
  final List<DataInfoNameBooking>? branches;
  final DataInfoNameBooking? dataSelected;
  final Function(DataInfoNameBooking)? onSelectBranch;
  final List<DataBannerClassType>? banners;

  const BookingSelectBranchWidget({
    super.key,
    this.branches,
    this.dataSelected,
    this.onSelectBranch,
    this.banners,
  });

  @override
  Widget build(BuildContext context) {
    // if (branches == null || branches!.isEmpty) {
    //   return const Center(child: Text('Không có chi nhánh nào'));
    // }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final coverHeight = max(screenHeight * 0.25, 180.0);
    final cardHeight = min(coverHeight * 0.4, 62.0);
    final top = coverHeight - cardHeight / 2;
    final bottom = cardHeight / 2;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        _buildBackgroundImage(coverHeight, bottom),
        Positioned(
          top: top,
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
          child: SizedBox(
            height: ToolHelper.isIpad() ? 60.h : cardHeight,
            child: _buildBranchSelectionCard(context),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundImage(double coverHeight, double bottom) {
    final localBanners = [
      'assets/images/background_booking.png',
      'assets/images/background_booking.png',
      'assets/images/background_booking.png',
      'assets/images/background_booking.png',
    ];

    if (banners?.isEmpty == true) {
      return Container(
        padding: EdgeInsets.only(top: 8.h),
        width: double.infinity,
        margin: EdgeInsets.only(bottom: bottom),
        height: coverHeight,
        child: CarouselSlider.builder(
          options: CarouselOptions(
            autoPlayInterval: const Duration(seconds: 5),
            autoPlay: true,
            height: coverHeight,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.91,
          ),
          itemCount: localBanners.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(
                    // right: index == localBanners.length - 1 ? 0 : 12.w,
                    // left: index == 0 ? 12.w : 0,
                    left: 6.w,
                    right: 6.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: MyImage.imgFromCommon(
                    assetName: localBanners[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(top: 8.h),
      width: double.infinity,
      margin: EdgeInsets.only(bottom: bottom),
      height: coverHeight,
      child: CarouselSlider.builder(
        options: CarouselOptions(
          autoPlayInterval: const Duration(seconds: 5),
          autoPlay: true,
          height: coverHeight,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction: 0.91,
        ),
        itemCount: banners!.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          return InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.only(
                  // right: index == banners!.length - 1 ? 0 : 12.w,
                  // left: index == 0 ? 12.w : 0,
                  left: 6.w,
                  right: 6.w),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: MyImage.cachedImgFromUrl(
                    url: banners?[index].path ?? '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorWidget: MyImage.imgFromCommon(
                      assetName: localBanners[index],
                      fit: BoxFit.fill,
                    ),
                    hasPlaceholder: false,
                  )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBranchSelectionCard(BuildContext context) {
    return InkWell(
      onTap: () => _onBranchCardTap(context),
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x07000000),
              blurRadius: 3.39,
              offset: Offset(0, 2.35),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 39,
              offset: Offset(0, 27),
              spreadRadius: 0,
            )
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyAppIcon.iconNamedCommon(
              width: 30.w,
              height: 30.w,
              iconName: 'booking/location.svg',
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                dataSelected?.name ?? '${'bookingClass.selectBranch'.tr()}...',
                style: TextStyle(
                  color: dataSelected?.name == null ? MyColors.lightGrayColor : MyColors.darkGrayColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBranchInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dataSelected?.name ?? '${'bookingClass.selectBranch'.tr()}...',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: dataSelected?.name == null ? MyColors.lightGrayColor : MyColors.darkGrayColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (dataSelected?.name == null) ...[
          SizedBox(height: 5.w),
          Text(
            'bookingClass.pleaseSelectBranch'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontSize: 10.sp,
            ),
          ),
        ]
      ],
    );
  }

  void _onBranchCardTap(BuildContext context) {
    if (branches != null && branches!.length > 1) {
      context.push(BranchListScreen.route, extra: {
        'dataBranchSelected': dataSelected,
        'branches': branches,
      }).then((value) {
        if (value != null && value is DataInfoNameBooking) {
          onSelectBranch?.call(value);
        }
      });
    }
  }
}
