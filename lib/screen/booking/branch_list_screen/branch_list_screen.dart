import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/data/network/model/output/list_class_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';

class BranchListScreen extends BaseStatelessScreenV2 {
  static const String route = '/branch-list';

  final DataInfoNameBooking? dataBranchSelected;
  final List<DataInfoNameBooking>? branches;

  const BranchListScreen({super.key, this.branches, this.dataBranchSelected});

  @override
  String get title => 'bookingClass.selectBranch'.tr();

  @override
  double get elevation => 0;

  @override
  Widget buildBody(BuildContext pageContext) {
    if (branches == null || branches!.isEmpty) {
      return const Center(child: Text('Không có chi nhánh nào'));
    }
    return SizedBox(
      height: double.infinity,
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              if( branches?[index].haveRoom == false){
                return;
              }
              context.pop(branches![index]);
            },
            child: _buildBranchItem(
              branches![index],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox();
        },
        itemCount: branches?.length ?? 0,
      ),
    );
  }

  Widget _buildBranchItem(DataInfoNameBooking branch) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            branch.name ?? '',
            style: TextStyle(

              color: branch.haveRoom == false
                  ? Colors.grey
                  : (dataBranchSelected?.name == branch.name
                      ? MyColors.mainColor // Orange color
                      : Colors.black),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 20.w),
          const Divider(
            color: Color(0xFFE1E1E1),
            height: 0.5,
          )
        ],
      ),
    );
  }
}
