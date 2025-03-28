import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/widgets/my_button.dart';

class MyPopupMessage {
  late BuildContext context;

  MyPopupMessage(this.context);

  Future<void> showError(
      {String title = "",
      String? code,
      String error = "",
      Function()? onCancel,
      bool? hideCancelBtn = false,
      Function(bool b)? onConfirm}) async {
    //Show popup error and dismiss or callback handle if touch OK/ Cancel
    return await showDialog(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext builder) => AlertDialog(
        backgroundColor: Colors.white,
        elevation: 0.0,
        content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  child: Padding(
                padding: EdgeInsets.all(title.isEmpty ? 0.0 : 10.0),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )),
              SizedBox(
                  child: Padding(
                padding: EdgeInsets.all(error.isEmpty ? 0.0 : 10.0),
                child: Text(error),
              )),
              Row(
                children: [
                  hideCancelBtn == true
                      ? const SizedBox()
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MyButton(
                              text: "profile.cancel".tr(),
                              height: 40,
                              borderRadius: 10,
                              border: Border.all(
                                  color: Colors.grey.shade200, width: 2),
                              colorText: Colors.black,
                              onPressed: (a) {
                                Navigator.of(context).pop<bool>(false);
                                onCancel?.call();
                              },
                            ),
                          ),
                        ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyButton(
                        text: "bookingClass.confirm".tr(),
                        height: 40,
                        borderRadius: 10,
                        gradient: MyColors.appGradient(context),
                        onPressed: (a) {
                          Navigator.of(context).pop<bool>(true);
                          onConfirm?.call(a ?? false);
                        },
                      ),
                    ),
                  ),
                ],
              )
            ]),
      ),
    );
  }

  static void confirmPopUpHTML({
    required BuildContext context,
    required String title,
    required String description,
    Widget? subDescription,
    Color? colorIcon,
    double? width,
    FontWeight? fontWeight,
    Color? confirmColor,
    Color? cancelColor,
    required String htmlContent,
    required String cancelText,
    required String confirmText,
    bool? isTextTitleCenter,
    String? iconAssetPath,
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 0,
          contentPadding: EdgeInsets.all(26.w),
          // insetPadding: const EdgeInsets.symmetric(horizontal: 26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.w),
          ),
          content: SizedBox(
            width: width ?? MediaQuery.of(context).size.width * 0.6,
            child: Column(
              crossAxisAlignment: (isTextTitleCenter ?? false)
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              mainAxisAlignment: (isTextTitleCenter ?? false)
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (iconAssetPath?.isNotEmpty == true) ...[
                  MyAppIcon.iconNamedCommon(
                    // width: 30,
                    height: 30,
                    color: colorIcon ?? Colors.red,
                    iconName: iconAssetPath!,
                  ),
                  SizedBox(height: 10.h),
                ],
                if (title.isNotEmpty == true)
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                SizedBox(height: 10.h),
                HtmlWidget(
                  htmlContent,
                ),
                SizedBox(height: 16.h),
                onConfirm != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RippleTextButton(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                            text: cancelText,
                            color: cancelColor ?? MyColors.mainColor,
                          ),
                          const SizedBox(width: 8),
                          RippleTextButton(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              onConfirm.call();
                            },
                            text: confirmText,
                            color: confirmColor ?? MyColors.darkGrayColor,
                          ),
                        ],
                      )
                    : MyButton(
                        width: Dimens.getProportionalScreenWidth(context, 90),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        border: Border.all(color: MyColors.mainColor, width: 1),
                        text: cancelText,
                        color: MyColors.mainColor,
                        colorText: Colors.white,
                        height: 35.h,
                        onPressed: (_) {
                          Navigator.of(dialogContext).pop();
                        },
                      )
              ],
            ),
          ),
        );
      },
    );
  }

  static void confirmPopUp({
    required BuildContext context,
    required String title,
    required String description,
    Widget? subDescription,
    double? width,
    FontWeight? fontWeight,
    Color? confirmColor,
    Color? cancelColor,
    String? cancelText,
    required String confirmText,
    required VoidCallback onConfirm,
    bool barrierDismissible = true,
    bool isForceUpdate = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 0,
          contentPadding: EdgeInsets.all(26.w),
          // insetPadding: const EdgeInsets.symmetric(horizontal: 26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.w),
          ),
          content: SizedBox(
            width: width ?? MediaQuery.of(context).size.width * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: MyColors.lightGrayColor2,
                  ),
                ),
                if (subDescription != null) ...[
                  const SizedBox(height: 4),
                  subDescription,
                ],
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (cancelText?.isNotEmpty == true)
                      RippleTextButton(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        text: cancelText ?? 'Huỷ',
                        color: cancelColor ?? MyColors.mainColor,
                      ),
                    const SizedBox(width: 8),
                    RippleTextButton(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      onPressed: () {
                        if (!isForceUpdate) {
                          Navigator.of(dialogContext).pop();
                        }
                        onConfirm.call();
                      },
                      text: confirmText,
                      color: confirmColor ?? MyColors.darkGrayColor,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static void showPopUpWithIcon(
      {required BuildContext context,
      String? cancelText,
      String? confirmText,
      VoidCallback? onConfirm,
      VoidCallback? onCancel,
      required String iconAssetPath,
      String? title,
      String? description,
      String? subtitle,
      Widget? titleWidget,
      Widget? descriptionWidget,
      double? horizontalMargin,
      bool barrierDismissible = true,
      bool isFullWidthCancel = false,
      Color? cancelColor,
      Color? colorIcon}) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 0,
          // contentPadding:  EdgeInsets.all(26.w),
          // insetPadding:  EdgeInsets.symmetric(horizontal: 50.w),
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin ?? 1.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                title != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyAppIcon.iconNamedCommon(
                            // width: 30,
                            height: 30,
                            color: colorIcon,
                            iconName: iconAssetPath,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: MyColors.darkGrayColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : titleWidget ?? const SizedBox(),
                SizedBox(height: 4.h),
                description != null
                    ? Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: MyColors.lightGrayColor2,
                        ),
                      )
                    : descriptionWidget ?? const SizedBox(),
                SizedBox(height: 4.h),
                if (subtitle != null) ...[
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MyColors.mainColor,
                      fontSize: 12,
                      // fontWeight: FontWeight.bold,
                    ),
                  )
                ],
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (cancelText != null) ...[
                      isFullWidthCancel
                          ? Expanded(
                              child: MyButton(
                                text: cancelText,
                                // height: 40,
                                borderRadius: 20,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),

                                border: Border.all(
                                  color: cancelColor ?? Colors.grey.shade200,
                                  width: 1,
                                ),
                                colorText: cancelColor ?? Colors.grey,
                                onPressed: (_) {
                                  Navigator.of(dialogContext).pop();
                                  onCancel?.call();
                                },
                              ),
                            )
                          : MyButton(
                              text: cancelText,
                              // height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),

                              borderRadius: 20,
                              border: Border.all(
                                color: cancelColor ?? Colors.grey.shade200,
                                width: 1,
                              ),
                              colorText: cancelColor ?? Colors.grey,
                              onPressed: (_) {
                                Navigator.of(dialogContext).pop();
                                onCancel?.call();
                              },
                            ),
                      const SizedBox(width: 8),
                    ],
                    if (confirmText != null)
                      MyButton(
                        text: confirmText,
                        // height: 40,
                        color: MyColors.mainColor,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        // gradient: GtdColors.appGradient(context),
                        onPressed: (_) {
                          Navigator.of(dialogContext).pop();
                          onConfirm?.call();
                        },
                        border: Border.all(
                          color: MyColors.mainColor,
                          width: 0.5,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showPopUpPickDate({
    required BuildContext context,
    String? cancelText,
    String? confirmText,
    Function(DateTime selectedDateTime)? onConfirm,
    DateTime? initialDateTime,
    VoidCallback? onCancel,
    String? title,
    String? description,
    String? subtitle,
    Widget? titleWidget,
    Widget? descriptionWidget,
    double? horizontalMargin,
    bool barrierDismissible = true,
    bool isFullWidthCancel = false,
    Color? colorIcon,
  }) {
    initialDateTime = initialDateTime != null
        ? DateTime(
            initialDateTime.year, initialDateTime.month, initialDateTime.day)
        : DateTime.now();

    DateTime currentDate = DateTime.now();
    DateTime maximumDate =
        DateTime(currentDate.year - 4, currentDate.month, currentDate.day);
    var selectedDateTime = maximumDate;
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin ?? 1.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 150.h,
                  child: CupertinoDatePicker(
                    backgroundColor: Colors.white,
                    use24hFormat: true,
                    mode: CupertinoDatePickerMode.date,
                    // initialDateTime: maximumDate,
                    initialDateTime: initialDateTime,
                    // minimumDate: null,
                    // maximumDate: maximumDate,
                    onDateTimeChanged: (DateTime value) {
                      selectedDateTime = value;
                      print('value: $value');
                    },
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton(
                      text: cancelText ?? '',
                      color: Colors.grey,
                      borderColor: Colors.grey.shade200,
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        onCancel?.call();
                      },
                    ),
                    SizedBox(width: 10.w),
                    _buildButton(
                      backgroundColor: MyColors.mainColor,
                      text: confirmText ?? '',
                      color: MyColors.mainColor,
                      borderColor: MyColors.mainColor,
                      onPressed: () {
                        Navigator.of(dialogContext).pop();

                        // DateTime  selectedDateTime = DateFormat('dd/MM/yyyy').format(selectedDateTime);
                        onConfirm?.call(selectedDateTime);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showPopUpPickTime({
    required BuildContext context,
    String? cancelText,
    String? confirmText,
    Function(DateTime selectedDateTime)? onConfirm,
    VoidCallback? onCancel,
    required String iconAssetPath,
    Widget? titleWidget,
    Widget? descriptionWidget,
    double? horizontalMargin,
    bool barrierDismissible = true,
    bool isFullWidthCancel = false,
    Color? colorIcon,
    required DateTime classStartDate,
    required String minimumDateString,
    required String maximumDateString,
    required int minuteInterval,
  }) {
    DateTime _parseTimeString(String timeString, DateTime defaultDateTime) {
      final timePattern = RegExp(r'^\d{1,2}:\d{2}$');
      if (!timePattern.hasMatch(timeString)) {
        print("Invalid time format: $timeString");
        return defaultDateTime;
      }

      try {
        final parts = timeString.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return DateTime(defaultDateTime.year, defaultDateTime.month,
            defaultDateTime.day, hour, minute);
      } catch (e) {
        print("Error parsing time string: $e");
        return defaultDateTime;
      }
    }

    DateTime roundToNearestInterval(DateTime dateTime, int interval) {
      final minutes = dateTime.minute;
      final roundedMinutes = (minutes / interval).round() * interval;
      return dateTime.copyWith(minute: roundedMinutes);
    }

    final now = DateTime.now();
    final defaultMinimumDate = DateTime(now.year, now.month, now.day, 8, 0);
    final defaultMaximumDate = DateTime(now.year, now.month, now.day, 20, 25);

    final minimumDate = _parseTimeString(minimumDateString, defaultMinimumDate);
    final maximumDate = _parseTimeString(maximumDateString, defaultMaximumDate);

    DateTime selectedDateTime;
    if (classStartDate.year == now.year &&
        classStartDate.month == now.month &&
        classStartDate.day == now.day) {
      selectedDateTime = roundToNearestInterval(now, minuteInterval);
    } else {
      selectedDateTime = DateTime(now.year, now.month, now.day, 8, 0);
    }
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin ?? 1.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 150.h,
                  child: CupertinoDatePicker(
                    backgroundColor: Colors.white,
                    use24hFormat: true,
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: selectedDateTime,
                    minimumDate: minimumDate,
                    maximumDate: maximumDate,
                    minuteInterval: minuteInterval,
                    onDateTimeChanged: (DateTime value) {
                      selectedDateTime = value;
                    },
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton(
                      text: cancelText ?? '',
                      color: Colors.grey,
                      borderColor: Colors.grey.shade200,
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        onCancel?.call();
                      },
                    ),
                    SizedBox(width: 10.w),
                    _buildButton(
                      backgroundColor: MyColors.mainColor,
                      text: confirmText ?? '',
                      color: MyColors.mainColor,
                      borderColor: MyColors.mainColor,
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        onConfirm?.call(selectedDateTime);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showPopUpYears({
    required BuildContext context,
    String? cancelText,
    String? confirmText,
    Function(String dateSelected, String yearSelected)? onConfirm,
    VoidCallback? onCancel,
    required String iconAssetPath,
    String? title,
    String? description,
    String? subtitle,
    Widget? titleWidget,
    Widget? descriptionWidget,
    double? horizontalMargin,
    bool barrierDismissible = true,
    bool isFullWidthCancel = false,
    Color? colorIcon,
    String? dateSelected,
    String? yearSelected,
    required List<num> listYears,
  }) {
    final now = DateTime.now();
    final currentMonth = now.month;

    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        num currentYear = yearSelected != null
            ? int.parse(yearSelected)
            : listYears.last ?? now.year;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              elevation: 0,
              insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                margin:
                    EdgeInsets.symmetric(horizontal: horizontalMargin ?? 1.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              int currentIndex = listYears.indexOf(currentYear);
                              if (currentIndex > 0) {
                                currentYear = listYears[currentIndex - 1];
                              }
                            });
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                            color: listYears.indexOf(currentYear) > 0
                                ? const Color(0xFF797B86)
                                : const Color(0xFFB0B0B0),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$currentYear',
                          style: TextStyle(
                            color: const Color(0xFF0E0E0F),
                            fontSize: 15.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              int currentIndex = listYears.indexOf(currentYear);
                              if (currentIndex < listYears.length - 1) {
                                currentYear = listYears[currentIndex + 1];
                              }
                            });
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: listYears.indexOf(currentYear) <
                                    listYears.length - 1
                                ? const Color(0xFF797B86)
                                : const Color(0xFFB0B0B0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          childAspectRatio: 2,
                        ),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          final month = index + 1;

                          // Check if it's the current year and month selected
                          final isCurrentMonth = (currentYear ==
                                  int.parse(
                                      yearSelected ?? now.year.toString())) &&
                              (month.toString() == dateSelected);

                          // Check if the month is a past month only in the current year
                          final isPastMonth = currentYear == now.year
                              ? month <= currentMonth
                              : true;

                          return InkWell(
                            onTap: isPastMonth
                                ? () {
                                    Navigator.of(dialogContext).pop();
                                    print('currentYear: $currentYear');
                                    onConfirm?.call(month.toString(),
                                        currentYear.toString());
                                  }
                                : null,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Tháng $month',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: isPastMonth
                                      ? (isCurrentMonth
                                          ? MyColors.mainColor
                                          : const Color(0xFF3B3B3B))
                                      : const Color(0xFF9B9B9B),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildButton({
    required String text,
    required Color color,
    required Color borderColor,
    Color? backgroundColor,
    required VoidCallback onPressed,
  }) {
    return MyButton(
      text: text,
      borderRadius: 20,
      color: backgroundColor ?? null,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      border: Border.all(color: borderColor, width: 1),
      colorText: backgroundColor != null ? Colors.white : color,
      onPressed: (_) => onPressed(),
    );
  }
}
