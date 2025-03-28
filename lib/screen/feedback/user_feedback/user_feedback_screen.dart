import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:myutils/utils/widgets/customt_textfield_widget.dart';
import 'package:myutils/utils/widgets/my_button.dart';

class UserFeedbackScreen extends BaseStatelessScreenV2 {
  static const String route = '/user-feedback';
  const UserFeedbackScreen({super.key}) : super(title: 'Đánh giá trung tâm');

  @override
  Widget buildBody(BuildContext pageContext) {
    return KeyboardDismisser(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mức độ hài lòng của bạn',
                      style: GoogleFonts.unbounded(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                        color: MyColors.darkGrayColor,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    EmotionRating(
                      onRatingChanged: (rating) {
                        print('Rating: $rating');
                      },
                    ),
                    SizedBox(height: 20.h),
                    RatingWidget(),
                    SizedBox(height: 20.h),
                    Text(
                      'Bạn thích điều gì nhất, chia sẻ với Sunny Days nhé:',
                      style: TextStyle(
                        color: MyColors.lightGrayColor2,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SelectableItemList(),
                    SizedBox(height: 15.h),
                    CustomTextField(
                      textStyle: TextStyle(
                        color: MyColors.darkGrayColor,
                        fontSize: 14.sp,
                      ),
                      hintStyle: TextStyle(
                        color: const Color(0xFF8D8D8D),
                        fontSize: 14.sp,
                      ),
                      maxLines: 4,
                      hintText: 'Hãy góp ý để chúng tôi cải thiện hơn!',
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: MyButton(
                width: Dimens.getProportionalScreenWidth(pageContext, 295),
                fontSize: 14.sp,
                text: 'Gửi đánh giá',
                color: MyColors.mainColor,
                height: 38.h,
                onPressed: (value) {
                  // pageContext.push(UserFeedbackScreen.route);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectableItemList extends StatefulWidget {
  const SelectableItemList({super.key});

  @override
  _SelectableItemListState createState() => _SelectableItemListState();
}

class _SelectableItemListState extends State<SelectableItemList> {
  List<int> selectedIndices = [];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(
        5,
        (index) => GestureDetector(
          onTap: () {
            setState(() {
              if (selectedIndices.contains(index)) {
                selectedIndices.remove(index);
              } else {
                selectedIndices.add(index);
              }
            });
          },
          child: Container(
            margin: EdgeInsets.only(right: 10.sp, top: 10.sp),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.w),
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: selectedIndices.contains(index) ? MyColors.mainColor : MyColors.lightGrayColor,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              'CT đầy đủng giờ',
              style: TextStyle(
                color: selectedIndices.contains(index) ? Colors.orange : const Color(0xFF8D8D8D),
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RatingWidget extends StatefulWidget {
  const RatingWidget({super.key});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  int _currentRating = 5;

  void _updateRating(int rating) {
    setState(() {
      _currentRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        return InkWell(
          child: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: index < _currentRating
                ? MyAppIcon.iconNamedCommon(
                    iconName: 'feedback/star_selected.png',
                    width: 24,
                    height: 24,
                  )
                : MyAppIcon.iconNamedCommon(
                    iconName: 'feedback/star_unselected.png',
                    width: 24,
                    height: 24,
                  ),
          ),
          onTap: () => _updateRating(index + 1),
        );
      }),
    );
  }

  Widget sentimentWidget(String urlIcon) {
    return MyAppIcon.iconNamedCommon(
      iconName: urlIcon,
      width: 24,
      height: 24,
    );
  }
}

class EmotionRating extends StatefulWidget {
  final Function(int) onRatingChanged;

  const EmotionRating({super.key, required this.onRatingChanged});

  @override
  _EmotionRatingState createState() => _EmotionRatingState();
}

class _EmotionRatingState extends State<EmotionRating> {
  int _selectedIndex = -1;

  final List<Map<String, String>> _emotions = [
    {'icon': 'feedback/sentiment_very_satisfied.png', 'label': 'Rất hài lòng'},
    {'icon': 'feedback/sentiment_satisfied.png', 'label': 'Hài lòng'},
    {'icon': 'feedback/sentiment_dissatisfied.png', 'label': 'Chưa hài lòng'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(_emotions.length, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
            widget.onRatingChanged(index);
          },
          child: Padding(
            padding: EdgeInsets.only(right: 30.sp),
            child: Column(
              children: [
                MyAppIcon.iconNamedCommon(
                  iconName: _emotions[index]['icon'] ?? '',
                  color: _selectedIndex == index ? Colors.orange : Colors.grey,
                  width: 40,
                  height: 40,
                ),
                SizedBox(height: 4.h),
                Text(
                  _emotions[index]['label'] ?? '',
                  style: TextStyle(
                    color: MyColors.lightGrayColor2,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
