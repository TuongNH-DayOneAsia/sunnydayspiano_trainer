import 'package:dayoneasia/screen/booking/booking_class/class_detail/booking_class_detail_screen.dart';
import 'package:dayoneasia/screen/booking/booking_class/class_list/cubit/booking_class_list_cubit.dart';
import 'package:dayoneasia/screen/booking/booking_class/class_list/cubit/booking_class_list_state.dart';
import 'package:dayoneasia/screen/booking/booking_class/class_list/widget/booking_class_card_widget.dart';
import 'package:dayoneasia/screen/booking/booking_select_piano/booking_select_piano_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';

class BookingClassListWidget extends StatefulWidget {
  final Function() reloadWidget;
  final ScrollController scrollController;
  final String contractSlug;

  const BookingClassListWidget(
      {super.key,
      required this.scrollController,
      required this.reloadWidget,
      required this.contractSlug});

  @override
  State<BookingClassListWidget> createState() => _BookingClassListWidgetState();
}

class _BookingClassListWidgetState extends State<BookingClassListWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingClassListCubit, BookingClassListState>(
      builder: (context, state) {
        final bookings = state.listBookingOutput?.listClass ?? [];
        return bookings.isNotEmpty == true
            ? Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo is ScrollEndNotification) {
                      if (widget.scrollController.position.pixels >=
                              widget.scrollController.position.maxScrollExtent -
                                  200 &&
                          !state.isLoadingMore) {
                        context.read<BookingClassListCubit>().loadMore();
                      }
                    }
                    return state
                        .isLoadingMore; // Prevent scroll if loading more
                  },
                  child: Stack(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        controller: widget.scrollController,
                        physics: state.isLoadingMore
                            ? const NeverScrollableScrollPhysics()
                            : const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          return ClassCardV3(
                            data: bookings[index],
                            onRequest: () {
                              context
                                  .read<BookingClassListCubit>()
                                  .callApiClassLessonRequestChange(
                                      classLessonCode: bookings[index]
                                          .classLessonCode
                                          .toString(),
                                      onSuccess: () {
                                        MyPopupMessage.showPopUpWithIcon(
                                          title: 'Đã gửi yêu cầu thành công',
                                          context: context,
                                          barrierDismissible: true,
                                          description: context
                                              .read<BookingClassListCubit>()
                                              .textRequestClassLesson,
                                          colorIcon: MyColors.mainColor,
                                          iconAssetPath: 'booking/success.svg',
                                        );
                                      });
                            },
                            onPressed: () {
                              // context.push(BookingSelectPianoScreen.route, extra: bookings[index].classLessonCode.toString()).then(
                              //   (value) {
                              //     if (value != null && value is bool) {
                              //       widget.reloadWidget.call();
                              //     }
                              //   },
                              // );
                              //
                              // context.push(BookingClassDetailsScreen.route, extra: bookings[index].classLessonCode.toString()).then(
                              //   (value) {
                              //     if (value != null && value is bool) {
                              //       widget.reloadWidget.call();
                              //     }
                              //   },
                              // );
                              context.push(
                                BookingClassDetailsScreen.route,
                                extra: {
                                  'class_lesson_code': bookings[index]
                                          .classLessonCode
                                          .toString() ??
                                      '',
                                  'contract_slug': widget.contractSlug,
                                },
                              );
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 16.h);
                        },
                      ),
                      if (state.isLoadingMore)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            color: Colors.white.withOpacity(0.8),
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )
            : DataEmptyWidget(
                message: context.read<BookingClassListCubit>().textEmpty());
      },
    );
  }
}

class DataEmptyWidget extends StatelessWidget {
  final String message;

  const DataEmptyWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    //
    return Expanded(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            MyAppIcon.iconNamedCommon(
                iconName: 'booking/book_class.svg',
                color: MyColors.lightGrayColor,
                width: 42.w,
                height: 47.w),
            SizedBox(height: 22.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF8D8D8D),
                fontSize: 14.sp,
                fontFamily: 'Be Vietnam Pro',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
