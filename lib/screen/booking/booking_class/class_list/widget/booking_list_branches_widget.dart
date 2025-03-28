import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myutils/data/network/model/output/list_class_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';

class BookingListBranchesWidget extends StatefulWidget {
  final Function(int idBranch) onBranchSelected;
  final List<DataInfoNameBooking> branches;
  const BookingListBranchesWidget({super.key, required this.branches, required this.onBranchSelected});

  @override
  State<BookingListBranchesWidget> createState() => _BookingListBranchesWidgetState();
}

class _BookingListBranchesWidgetState extends State<BookingListBranchesWidget> {
  int selectedIndex = 0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedItem(int itemCount) {
    if (selectedIndex == itemCount - 1) {
      return;
    }
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final double itemWidth = renderBox.size.width / itemCount;
    final double position = selectedIndex * itemWidth;

    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBookingSuccess(listBranches: widget.branches);
  }

  Widget _buildBookingSuccess({List<DataInfoNameBooking>? listBranches}) {
    return Card(
      // elevation: 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      margin: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10.0.w),
        height: 30,
        child: ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemCount: listBranches?.length ?? 0,
          itemBuilder: (context, index) {
            bool isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                _scrollToSelectedItem(listBranches?.length ?? 0);
                widget.onBranchSelected.call(listBranches?[index].id ?? 0);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 3.0.w),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : MyColors.lightGrayColor3,
                    border: Border.all(
                      width: 0.5,
                      color: isSelected ? Colors.orange : MyColors.lightGrayColor3,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16.0,
                        color: isSelected ? MyColors.mainColor : MyColors.lightGrayColor2,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        listBranches?[index].name ?? '',
                        style: TextStyle(
                            color: isSelected ? MyColors.mainColor : MyColors.darkGrayColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
