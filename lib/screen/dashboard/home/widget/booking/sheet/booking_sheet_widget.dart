import 'package:flutter/material.dart';
import 'package:myutils/data/network/model/output/list_class_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/widgets/my_button.dart';

class BookingSheetWidget extends StatefulWidget {
  final Function(DataInfoNameBooking data)? onBranchSelected;
  final List<DataInfoNameBooking>? listBranch;
  const BookingSheetWidget({super.key, this.onBranchSelected, this.listBranch});

  @override
  _BookingSheetWidgetState createState() => _BookingSheetWidgetState();
}

class _BookingSheetWidgetState extends State<BookingSheetWidget> {
  var listBranch = <DataInfoNameBooking>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listBranch = widget.listBranch ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int index) {
              return _buildBranchItem(listBranch[index]);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox();
            },
            itemCount: listBranch.length,
          ),
        ),
        const SizedBox(height: 20),
        MyButton(
          width: Dimens.getProportionalScreenWidth(context, 295),
          fontSize: 14,
          text: 'Xác nhận',
          isEnable: true,
          color: MyColors.mainColor,
          height: 38,
          onPressed: (value) {
            DataInfoNameBooking? selectedBranch = listBranch.firstWhere(
              (branch) => branch.isSelected,
              orElse: () => DataInfoNameBooking(),
            );
            if (selectedBranch.name != null) {
              Navigator.of(context).pop();
              widget.onBranchSelected?.call(selectedBranch);
            } else {
              print('Chưa có chi nhánh nào được chọn');
            }
          },
        ),
      ],
    );
  }

  Widget _buildBranchItem(
    DataInfoNameBooking data,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          for (var branch in listBranch) {
            branch.isSelected = false;
          }
          data.isSelected = true;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.name ?? '',
              style: TextStyle(
                fontSize: 14,
                color: data.isSelected ? MyColors.mainColor : MyColors.darkGrayColor,
                fontWeight: data.isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.name ?? '',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: data.isSelected ? MyColors.mainColor : MyColors.lightGrayColor2,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(
              color: Color.fromRGBO(241, 241, 241, 1),
              height: 0,
            )
          ],
        ),
      ),
    );
  }
}
