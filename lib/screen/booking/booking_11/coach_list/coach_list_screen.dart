import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/data/network/model/output/booking_11/coaches_output.dart';
import 'package:myutils/data/network/model/output/booking_11/contracts_output.dart';
import 'package:myutils/data/network/model/output/contracts/booking_class_type_v5_output.dart';
import 'package:myutils/data/network/model/output/list_class_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:shimmer/shimmer.dart';

import '../booking/ui/item_coach_widget.dart';
import 'cubit/coach_list_cubit.dart';
import 'package:myutils/data/network/model/output/contracts/booking_class_type_v5_output.dart'
as DataContractV5;
class CoachListScreen extends BaseStatelessScreenV2 {
  static const String route = '/coach-list';

  final DataCoach? dataCoach;
  final DataCoach? dataCoachSelected;
  final DataInfoNameBooking? dataBranchSelected;
  final List<String>? coaches;
  final DataContractV5.Items? dataContractSelected;

  const CoachListScreen(
      {super.key,
      this.coaches,
      this.dataCoach,
      this.dataBranchSelected,
      this.dataContractSelected,
      this.dataCoachSelected});

  @override
  String get title => 'Chọn Huấn luyện viên';

  @override
  double get elevation => 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CoachListCubit(dataBranchSelected, dataContractSelected),
      child: super.build(context),
    );
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocBuilder<CoachListCubit, CoachListState>(
      builder: (context, state) {
        if (state.error != null) {
          return Center(child: Text(state.error!));
        }

        final coaches = state.coaches ?? [];
        final bool isLoading = coaches.isEmpty;

        return Container(
          color: MyColors.backgroundColor,
          height: double.infinity,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo is ScrollEndNotification) {
                if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 200 &&
                    !state.isLoadingMore) {
                  context.read<CoachListCubit>().loadMore();
                }
              }
              return state.isLoadingMore; // Prevent scroll if loading more
            },
            child: isLoading
                ? _buildShimmerCoachList()
                : _buildCoachList(state),
          ),
        );
      },
    );
  }
  Widget _buildCoachList(CoachListState state) {
    final coaches = state.coaches!;
    return  Stack(
      children: [
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.all(16.w),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                context.pop(coaches[index]);
              },
              child: _buildCoachItem(
                coaches[index],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 16.h);
          },
          itemCount: coaches.length,
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
    );
  }

  Widget _buildCoachItem(DataCoach data) {
    return Container(
      decoration: ShapeDecoration(
        gradient: data.slug == dataCoachSelected?.slug
            ? const LinearGradient(
                begin: Alignment(-0.94, 0.34),
                end: Alignment(0.94, -0.34),

                // begin: Alignment(0.94, -0.34),
                // end: Alignment(-0.94, 0.34),
                colors: [
                  Color(0xFFFFFAF6),
                  Color(0xFFFFF8F1),
                  Color(0xFFFFF9F3),
                  Color(0xFFFFE5CD)
                ],
              )
            : const LinearGradient(colors: [Colors.white, Colors.white]),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
      child: Padding(
        padding:
            EdgeInsets.only(top: 16.w, left: 16.w, bottom: 16.w, right: 8.w),
        child: ItemCoachWidget(
          coach: data,
          isItemForList: true,
          coachSelected: dataCoachSelected,
        ),
      ),
    );
  }

  Widget _buildShimmerCoachList() {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.all(16.w),
      itemBuilder: (BuildContext context, int index) {
        return _buildShimmerCoachItem();
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 16.h);
      },
      itemCount: 15, // Show 5 shimmer items
    );
  }

  Widget _buildShimmerCoachItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height:
            80.h, // Adjust height as needed to match your actual item height
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(top: 16.w, left: 16.w, bottom: 16.w, right: 8.w),
          child: Row(
            children: [
              // Coach avatar placeholder
              Container(
                width: 48.w,
                height: 48.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Coach name placeholder
                    Container(
                      width: 120.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Coach description placeholder
                    Container(
                      width: 200.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              // Selection indicator placeholder
              Container(
                width: 24.w,
                height: 24.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
