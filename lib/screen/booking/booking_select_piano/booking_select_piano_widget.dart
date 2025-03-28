import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myutils/data/network/model/output/list_piano_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/utils/dimens.dart';

class PianoGridWidget extends StatefulWidget {
  final bool? hasHeight;
  final bool? isScroll;

  final List<DataPiano>? pianos;
   DataPiano? dataPianoSelected;
  final int? crossAxisCountFromApi;

  final Function(DataPiano? dataPianoSelected) onSelect;

   PianoGridWidget(
      {super.key,
      this.pianos,
      this.dataPianoSelected,
      required this.onSelect,
      this.hasHeight,
      this.crossAxisCountFromApi = 3,
      this.isScroll = false});

  @override
  State<PianoGridWidget> createState() => _PianoGridWidgetState();
}

class _PianoGridWidgetState extends State<PianoGridWidget> {
  double heightGridView() {
    switch (widget.crossAxisCountFromApi) {
      case 1:
        return Dimens.getScreenWidth(context) * 0.33; // 33%
      case 2:
        return Dimens.getScreenWidth(context) * 0.67; // ~67%
      case 3:
      case 4:
        return Dimens.getScreenWidth(context) * 0.91; // ~91%
      default:
        return Dimens.getScreenWidth(context) * 0.91;
    }
  }

  double mainAxisSpacing() {
    return widget.crossAxisCountFromApi == 4 ? 8 : 16;
  }

  double crossAxisSpacing() {
    switch (widget.crossAxisCountFromApi) {
      case 1:
      case 2:
        return 30;
      case 3:
        return 16;
      case 4:
        return 8;
      default:
        return 16;
    }
  }

  double childAspectRatio() {
    return widget.crossAxisCountFromApi == 4 ? 2.2 : 2.9;
  }

  void selectPiano(DataPiano data) {
    if (data.isBooking == false) return;

    setState(() {
      widget.dataPianoSelected = data;
    });
    widget.onSelect(data);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pianos?.isEmpty == true || widget.pianos == null) {
      return  const Center(child: Text('Hiện tại phòng học chưa có đàn!', style: TextStyle()));
    }
    return SizedBox(
      width: heightGridView(),
      height: widget.hasHeight == true
          ? MediaQuery.of(context).size.height * 0.45
          : null,
      child: Center(
        child: GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: widget.isScroll == true
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ((widget.crossAxisCountFromApi ?? 3) <= 4
                    ? widget.crossAxisCountFromApi
                    : 3) ??
                3,
            childAspectRatio: childAspectRatio(),
            mainAxisSpacing: mainAxisSpacing(),
            crossAxisSpacing: crossAxisSpacing(),
          ),
          itemCount: widget.pianos!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                selectPiano(widget.pianos![index]);
              },
              child: _PianoItemWidget(
                piano: widget.pianos![index],
                pianoSelected: widget.dataPianoSelected,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PianoItemWidget extends StatelessWidget {
  final DataPiano piano;
  final DataPiano? pianoSelected;

  const _PianoItemWidget({required this.piano, this.pianoSelected});

  @override
  Widget build(BuildContext context) {
    bool isSelected = piano.instrumentCode == pianoSelected?.instrumentCode;
    bool isBooked = (piano.isBooking ?? true);

    Color borderColor = isSelected
        ? MyColors.mainColor
        : (isBooked ? MyColors.mainColor : const Color(0xFFE1E1E1));
    Color textColor = isSelected
        ? Colors.white
        : (isBooked ? MyColors.mainColor : const Color(0xFFE1E1E1));
    Color? iconColor = isSelected
        ? Colors.white
        : (isBooked ? MyColors.mainColor : const Color(0xFFE1E1E1));

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(4),
        color: isSelected ? MyColors.mainColor : Colors.transparent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 4),
          Text(
            piano.instrumentCode ?? '',
            style: TextStyle(
                fontSize: 10.sp, fontWeight: FontWeight.bold, color: textColor),
          ),
          MyAppIcon.iconNamedCommon(
            color: iconColor,
            iconName: 'booking/piano_unselected.svg',
          ),
        ],
      ),
    );
  }
}
