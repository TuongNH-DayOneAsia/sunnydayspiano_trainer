import 'package:dayoneasia/screen/booking/booking_class/class_list/cubit/booking_class_list_cubit.dart';
import 'package:dayoneasia/screen/booking/booking_class/class_list/cubit/booking_class_list_state.dart';
import 'package:dayoneasia/screen/booking/booking_class/class_list/widget/booking_class_list_widget.dart';
import 'package:dayoneasia/screen/booking/booking_class/class_list/widget/booking_select_branch_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myutils/data/network/model/output/contracts/booking_class_type_v5_output.dart';
import 'package:myutils/data/network/model/output/currrent_week_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/utils/tab/my_tab_bar.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';

class BookingClassListScreen extends BaseStatelessScreenV2 {
  final Items? data;
  static const String route = '/booking-class';

  const BookingClassListScreen({
    super.key,
    this.data,
  });

  @override
  String get title => 'bookingClass.bookClass'.tr();

  @override
  bool get automaticallyImplyLeading => true;

  @override
  // TODO: implement backgroundColor
  Color? get backgroundColor => MyColors.backgroundColor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingClassListCubit(data)
        ..loadInitialDataV2()
        ..callApiBannerClass(),
      child: super.build(context),
    );
  }

  @override
  Future<void> onRetry(BuildContext context) async {
    // TODO: implement onRetry
    context.read<BookingClassListCubit>().refreshListClass().then((value) {});
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocBuilder<BookingClassListCubit, BookingClassListState>(
      builder: (context, state) {
        if (state.isInitialLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.error != null) {
          return Center(child: Text(state.error!));
        }
        return _BodyWidget(state: state, contractSlug: data?.slugContract ?? '');
      },
    );
  }
}

class _BodyWidget extends StatefulWidget {
  final BookingClassListState state;
  final String contractSlug;

  const _BodyWidget({required this.state,required this.contractSlug});

  @override
  State<_BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<_BodyWidget> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    context.read<BookingClassListCubit>().refreshListClass().then((value) {
      _scrollToTop();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: MyColors.mainColor,
      onRefresh: () async {
        await context.read<BookingClassListCubit>().filter(showLoading: false);
        _scrollToTop();
        return Future.delayed(const Duration(milliseconds: 1000));
      },
      child: IgnorePointer(
        ignoring: widget.state.isLoading || widget.state.isLoadingMore,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            _buildBranchesList(context),
            SizedBox(height: 26.h),
            _buildCurrentWeekTab(context),
            SizedBox(height: 24.h),
            BookingClassListWidget(
              contractSlug: widget.contractSlug,
              scrollController: _scrollController,
              reloadWidget: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentWeekTab(BuildContext context) {
    return widget.state.currentWeek == null
        ? const SizedBox.shrink()
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: MyTabbedPage2<DataCalendar>(
              items: widget.state.currentWeek!,
              titleBuilder: (date) => date.day.toString(),
              subtitleBuilder: (date) => date.date.toString(),
              onTap: (index) {
                context.read<BookingClassListCubit>().filter(
                    dateSelected:
                        widget.state.currentWeek![index].fullDate ?? '');
                _scrollToTop();
              },
            ),
          );
  }

  Widget _buildBranchesList(BuildContext context) {
    return widget.state.branchesOutput == null
        ? const SizedBox.shrink()
        : BookingSelectBranchWidget(
            banners: widget.state.bannerClassTypeOutput?.data ?? [],
            branches: widget.state.branchesOutput?.data ?? [],
            dataSelected: widget.state.dataBranchSelected,
            onSelectBranch: (value) {
              context
                  .read<BookingClassListCubit>()
                  .emitIndexBranchSelected(value)
                  .then((value) {
                _scrollToTop();
              });
            },
          );
  }

  void _scrollToTop() {
    if (widget.state.listBookingOutput?.listClass?.isEmpty == true ||
        widget.state.listBookingOutput?.listClass == null) {
      return;
    }
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

class WhiteSpaceDivider extends StatelessWidget {
  const WhiteSpaceDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 10,
    );
  }
}
