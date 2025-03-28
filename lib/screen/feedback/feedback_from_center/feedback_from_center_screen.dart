import 'package:dayoneasia/screen/feedback/feedback_from_center/widget/list_feedback_from_center_widget.dart';
import 'package:dayoneasia/screen/feedback/user_feedback/user_feedback_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/image_extension.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:myutils/utils/widgets/my_button.dart';

class FeedbackFromCenterWidget extends BaseStatelessScreenV2 {
  static String route = '/feedback_from_center';

  const FeedbackFromCenterWidget({super.key});

  @override
  // TODO: implement title
  String? get title => 'Đánh giá trung tâm';

  double? get elevation => 0;

  @override
  // TODO: implement backgroundColor
  Color? get backgroundColor => MyColors.backgroundColor;

  @override
  Widget buildBody(BuildContext pageContext) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              MyImage.cachedImgFromUrl(
                hasPlaceholder: false,
                url: "https://sunnydays.vn/userfiles/images/Config/Page/Banner-he-thong-trung-tam/hoc-piano-khong-can-dan.jpg",
                width: double.infinity,
                height: 191.h,
                fit: BoxFit.cover,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Sunny Days Võ Văn Tần',
                      style: TextStyle(
                        color: MyColors.darkGrayColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '449 Võ Văn Tần, phường 05, quận 03, tp.HCM',
                      style: TextStyle(
                        color: MyColors.lightGrayColor2,
                        fontSize: 14,
                        fontFamily: 'Be Vietnam Pro',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const ListFeedbackFromCenterScreen(),
              // itemEmpty(),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: MyButton(
            width: Dimens.getProportionalScreenWidth(pageContext, 295),
            fontSize: 14.sp,
            text: 'Đánh giá ngay',
            // isEnable: snapshot.data!,
            color: MyColors.mainColor,
            height: 38.h,
            onPressed: (value) {
              pageContext.push(UserFeedbackScreen.route);
            },
          ),
        ),
      ],
    );
  }

  Widget itemEmpty() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Bạn chưa có đánh giá nào',
                style: TextStyle(
                  color: MyColors.darkGrayColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'Hãy góp ý để chúng tôi cải thiện hơn!',
                style: TextStyle(
                  color: MyColors.lightGrayColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
