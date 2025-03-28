import 'package:dayoneasia/screen/booking/booking_class/booking_class_detail/booking_class_detail_screen.dart';
import 'package:dayoneasia/screen/booking/booking_class/class_detail/cubit/booking_class_detail_cubit.dart';
import 'package:dayoneasia/screen/booking/booking_practice/practice_detail/booking_practice_detail_screen.dart';
import 'package:dayoneasia/screen/dashboard/booking_history/widget/booking_history_card.dart';
import 'package:dayoneasia/screen/dashboard/booking_history/widget/shimmer/booking_history_list_shimmer_widget.dart';
import 'package:dayoneasia/screen/dashboard/booking_history/widget/shimmer/booking_history_tab_shimmer_widget.dart';
import 'package:dayoneasia/screen/main/main_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/data/network/model/output/history_booking_output.dart';
import 'package:myutils/data/network/model/output/status_history_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/utils/tab/my_tab_bar.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:myutils/utils/widgets/my_button.dart';
import 'package:myutils/utils/widgets/my_listview_loadmore_widget.dart';

import '../../booking/booking_11/detail/booking_11_detail_screen.dart';
import 'cubit/booking_history_cubit.dart';

class BookingHistoryScreen extends BaseStatelessScreenV2 {
  static const String route = '/booking-history';
  final ScrollController? historyScrollController;

  // const BookingHistoryScreen({super.key}) : super(automaticallyImplyLeading: false);
  const BookingHistoryScreen(
      {super.key,
      super.automaticallyImplyLeading = false,
      this.historyScrollController});

  @override
  String? get title => 'global.history'.tr();

  @override
  Color? get backgroundColor => MyColors.backgroundColor;

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocBuilder<BookingHistoryCubit, BookingHistoryState>(
      builder: (context, state) {
        if (state.isInitialLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.error?.isNotEmpty == true) {
          return Center(child: Text(state.error ?? ''));
        }
        return _BuildBody(historyScrollController: historyScrollController);
      },
    );
  }
}

class _BuildBody extends StatefulWidget {
  final ScrollController? historyScrollController;

  const _BuildBody({this.historyScrollController});

  @override
  State<_BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends State<_BuildBody> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.historyScrollController ?? ScrollController();
    LocalStream.shared.refreshHistory = () {
      print('refreshHistory');
      context.read<BookingHistoryCubit>().filter(showLoading: false);
      _scrollToTop(
          context.read<BookingHistoryCubit>().state.listHistoryBooking);
    };
  }

  @override
  void dispose() {
    if (widget.historyScrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _scrollToTop(List<DataHistoryMain>? list) {
    if (list?.isEmpty == true) {
      return;
    }
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _bodyV2Widget();
  }

  _bodyV1Widget() {
    return BlocBuilder<BookingHistoryCubit, BookingHistoryState>(
      builder: (context, state) {
        return RefreshIndicator(
          color: MyColors.mainColor,
          onRefresh: () async {
            await context
                .read<BookingHistoryCubit>()
                .filter(showLoading: false);
            _scrollToTop(state.listHistoryBooking);
            return Future.delayed(const Duration(milliseconds: 1000));
          },
          child: IgnorePointer(
            ignoring: state.isLoading || state.isLoadingMore,
            child: Column(
              children: [
                if (state.listHistoryStatus?.isNotEmpty == true)
                  MyTabbedPage2<DataHistoryStatus>(
                    fontSize: 12.sp,
                    items: state.listHistoryStatus ?? [],
                    titleBuilder: (item) => item.name ?? '',
                    onTap: (index) {
                      context.read<BookingHistoryCubit>().filter(
                          status: state.listHistoryStatus?[index].status ?? 1,
                          showLoading: true);
                      _scrollToTop(state.listHistoryBooking);
                    },
                  ),
                state.listHistoryBooking?.isNotEmpty == true
                    ? Expanded(
                        child: CustomListView<DataHistoryMain>(
                          items: state.listHistoryBooking ?? [],
                          // scrollController: yourScrollController,
                          isLoadingMore: state.isLoadingMore,
                          scrollController: _scrollController,
                          itemBuilder: (context, item) => Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DateHeader(title: item.header ?? ''),
                              ListSubItem(
                                listSub: item.listSub ?? [],
                                onPressed: () {},
                              ),
                            ],
                          ),
                          onItemPressed: (item) {
                            // Handle item press
                          },
                          onLoadMore: () {
                            context.read<BookingHistoryCubit>().loadMore();
                          },
                          reloadWidget: () {},
                          scrollToTop:
                              false, // Set this to true when you want to scroll to top
                        ),
                      )
                    : _DataEmptyHistoryWidget(
                        status: context
                                .read<BookingHistoryCubit>()
                                .listHistoryInput
                                .statusBooking ??
                            -1,
                        messageEmpty: state.msgEmpty ?? '',
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  _bodyV2Widget() {
    return BlocBuilder<BookingHistoryCubit, BookingHistoryState>(
      builder: (context, state) {
        return RefreshIndicator(
          color: MyColors.mainColor,
          onRefresh: () async {
            await context
                .read<BookingHistoryCubit>()
                .filter(showLoading: false);
            _scrollToTop(state.listHistoryBooking);
            return Future.delayed(const Duration(milliseconds: 1000));
          },
          child: IgnorePointer(
            ignoring: state.isLoading || state.isLoadingMore,
            child: NotificationListener(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo is ScrollEndNotification) {
                  if (_scrollController.position.pixels >=
                          _scrollController.position.maxScrollExtent &&
                      !state.isLoadingMore) {
                    context.read<BookingHistoryCubit>().loadMore();
                  }
                }
                return state.isLoadingMore;
              },
              child: _buildBody(
                state: state,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody({required BookingHistoryState state}) {
    return Column(
      children: [_tabBarWidget(state: state), _historiesWidget(state: state)],
    );
  }

  _tabBarWidget({required BookingHistoryState state}) {
    if (state.listHistoryStatus == null) {
      return const BookingHistoryTabShimmerWidget();
    }
    return state.listHistoryStatus?.isNotEmpty == true
        ? MyTabbedPage2<DataHistoryStatus>(
            fontSize: 12.sp,
            items: state.listHistoryStatus ?? [],
            titleBuilder: (item) => item.name ?? '',
            onTap: (index) {
              context.read<BookingHistoryCubit>().filter(
                    status: state.listHistoryStatus?[index].status ?? 1,
                    showLoading: true,
                  );
              _scrollToTop(state.listHistoryBooking);
            },
          )
        : const BookingHistoryListShimmerWidget();
  }

  _historiesWidget({required BookingHistoryState state}) {
    if (state.listHistoryBooking == null) {
      return const BookingHistoryListShimmerWidget();
    }
    return state.listHistoryBooking?.isNotEmpty == true
        ? Expanded(
            child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: [
                ListView.separated(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.0.w, vertical: 10.0.h),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.listHistoryBooking?.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = state.listHistoryBooking?[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DateHeader(title: item?.header ?? ''),
                        ListSubItem(
                          listSub: item?.listSub ?? [],
                          onPressed: () {},
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 8.h);
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
          ))
        : _DataEmptyHistoryWidget(
            messageEmpty: state.msgEmpty ?? '',
            status: context
                    .read<BookingHistoryCubit>()
                    .listHistoryInput
                    .statusBooking ??
                -1,
          );
  }
}

class _DataEmptyHistoryWidget extends StatelessWidget {
  final int status;
  final String messageEmpty;

  const _DataEmptyHistoryWidget({
    required this.status,
    required this.messageEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: status == bookingCancel
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyAppIcon.iconNamedCommon(
                      iconName: 'booking/booking_not_data.svg',
                      color: MyColors.mainColor),
                  SizedBox(height: 18.h),
                  Text(
                    messageEmpty ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF6A6A6A),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyAppIcon.iconNamedCommon(iconName: 'empty.svg'),
                  SizedBox(height: 18.h),
                  Text(
                    'Đặt lịch ngay hôm nay',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF3B3B3B),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    messageEmpty,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF6A6A6A),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 24),
                  MyButton(
                    text: 'Bắt đầu',
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    fontSize: 12,
                    onPressed: (v) {
                      final mainPageState =
                          (context.findAncestorStateOfType<MainPageState>()
                              as MainPageState);
                      mainPageState.onItemTapped(0);
                    },
                    colorText: MyColors.mainColor,
                    border: Border.all(color: MyColors.mainColor, width: 1),
                  ),
                ],
              ),
      ),
    );
  }
}

class ListSubItem extends StatelessWidget {
  final VoidCallback onPressed;
  final List<DataHistoryBooking> listSub;

  const ListSubItem(
      {super.key, required this.listSub, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listSub.length,
      itemBuilder: (context, index) {
        final data = listSub[index];
        return BookingHistoryCard(
          data: data,
          onPressed: () {
            _navigateToBookingDetails(context, data);
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 8,
        );
      },
    );
  }

  void _navigateToBookingDetails(
      BuildContext context, DataHistoryBooking? data) {
    if (data?.type == ClassType.CLASS_PRACTICE.name) {
      context.push(BookingPracticeDetailScreen.route, extra: {
        'bookingCode': data?.bookingCode ?? '',
        'refreshAction': RefreshAction.refreshDataInHome
      });
    } else if (data?.type == ClassType.CLASS.name) {
      context.push(
        BookingClassDetailScreen.route,
        extra: {
          'bookingCode': data?.bookingCode ?? '',
          'refreshAction': RefreshAction.refreshDataInHome,
        },
      );
    } else {
      context.push(Booking11DetailScreen.route, extra: {
        'mode': Booking11DetailScreenMode.detail,
        'bookingCode': data?.bookingCode ?? '',
        'refreshAction': RefreshAction.refreshDataInHome,
      });
    }
  }
}

class DateHeader extends StatelessWidget {
  final String title;

  const DateHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: MyColors.darkGrayColor,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
