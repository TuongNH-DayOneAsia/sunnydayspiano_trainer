import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/utils/widgets/my_button.dart';

class ListFeedbackFromCenterScreen extends StatefulWidget {
  const ListFeedbackFromCenterScreen({super.key});

  @override
  _ListFeedbackFromCenterScreenState createState() => _ListFeedbackFromCenterScreenState();
}

class _ListFeedbackFromCenterScreenState extends State<ListFeedbackFromCenterScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.all(16.w),
        itemCount: listFeedbackCenter.length,
        itemBuilder: (context, index) {
          DataFeedbackCenter data = listFeedbackCenter[index];
          return _item(data);
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 16.h,
          );
        },
      ),
    );
  }

  Widget _item(DataFeedbackCenter data) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.name ?? '',
                  style: TextStyle(
                    color: MyColors.darkGrayColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  data.date ?? '',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: const Color(0xFFA9A9A9),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                MyAppIcon.iconNamedCommon(
                  iconName: 'feedback/sentiment_very_satisfied.png',
                  width: 24,
                  height: 24,
                  color: MyColors.mainColor,
                ),
                SizedBox(
                  width: 6.w,
                ),
                Text(
                  data.content ?? '',
                  style: TextStyle(
                    color: MyColors.darkGrayColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 6.h,
            ),
            Wrap(
              children: data.listFeedback!
                  .map((e) => Container(
                        margin: EdgeInsets.only(right: 8.w, top: 8.h),
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                            color: MyColors.mainColor,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          e,
                          style: TextStyle(
                            color: MyColors.mainColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(
              height: 6.h,
            ),
            _listSub(data),
            RippleTextButton(
              onPressed: () {
                setState(() {
                  data.showAllSubItems = !data.showAllSubItems;
                });
              },
              padding: EdgeInsets.symmetric(vertical: 10.h),
              fontSize: 12.sp,
              text: data.showAllSubItems ? 'Đóng phản hồi' : 'Hiển thị phản hồi (${(data.listSubFeedback?.length ?? 0) - 1})',
              color: MyColors.mainColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _listSub(DataFeedbackCenter data) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: data.showAllSubItems ? (data.listSubFeedback?.length ?? 0) : 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildInitialFeedback(data.listSubFeedback?[index]);
        } else {
          final feedback = data.listSubFeedback?[index];
          return feedback?.isMyFeedback == true ? _buildMyFeedback(feedback) : _buildAdminFeedback(feedback);
        }
      },
      separatorBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            SizedBox(height: 16.h),
            Divider(
              color: MyColors.lightGrayColor3,
              thickness: 1,
            ),
            SizedBox(height: 16.h),
          ],
        );
      },
    );
  }

  Widget _buildInitialFeedback(DataSubFeedback? feedback) {
    return Text(
      feedback?.value ?? '',
      style: TextStyle(
        color: MyColors.lightGrayColor2,
        fontSize: 12.sp,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _buildMyFeedback(DataSubFeedback? feedback) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ngoc Lan',
              style: TextStyle(
                color: MyColors.darkGrayColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '06/08/2024',
              style: TextStyle(
                color: Color(0xFFA9A9A9),
                fontSize: 12.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          feedback?.value ?? '',
          style: TextStyle(
            color: MyColors.lightGrayColor2,
            fontSize: 12.sp,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildAdminFeedback(DataSubFeedback? feedback) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '06/08/2024',
              style: TextStyle(
                color: Color(0xFFA9A9A9),
                fontSize: 12.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              'Quan tri vien',
              style: TextStyle(
                color: Color(0xFF3B3B3B),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          feedback?.value ?? '',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: MyColors.lightGrayColor2,
            fontSize: 12.sp,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

class DataSubFeedback {
  final bool? isMyFeedback;
  final String? value;
  DataSubFeedback({
    this.isMyFeedback,
    this.value,
  });
}

class DataFeedbackCenter {
  final String? name;
  final String? date;
  final String? content;
  final List<String>? listFeedback;
  final List<DataSubFeedback>? listSubFeedback;
  bool showAllSubItems;

  DataFeedbackCenter({
    this.name,
    this.date,
    this.content,
    this.listFeedback,
    this.listSubFeedback,
    this.showAllSubItems = false,
  });
}

var listFeedbackCenter = [
  DataFeedbackCenter(name: 'Phan Thị Ngọc Lan', date: '06/08/2024', content: 'Rất hài lòng', listFeedback: [
    "Chất lượng dịch vụ tốt",
    "Nhân viên thân thiện",
  ], listSubFeedback: [
    DataSubFeedback(
        isMyFeedback: true,
        value:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."),
    DataSubFeedback(
        isMyFeedback: false,
        value:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."),
    DataSubFeedback(
        isMyFeedback: true,
        value:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."),
  ]),
  DataFeedbackCenter(name: 'Phan Thị Ngọc Lan', date: '06/08/2024', content: 'Rất hài lòng', listFeedback: [
    "Chất lượng dịch vụ tốt",
    "Nhân viên thân thiện",
  ], listSubFeedback: [
    DataSubFeedback(
        isMyFeedback: true,
        value:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."),
    DataSubFeedback(
        isMyFeedback: false,
        value:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."),
    DataSubFeedback(
        isMyFeedback: true,
        value:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."),
  ]),
];
