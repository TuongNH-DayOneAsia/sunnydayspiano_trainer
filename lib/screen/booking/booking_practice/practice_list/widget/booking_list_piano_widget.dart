import 'package:dayoneasia/screen/booking/booking_practice/practice_list/cubit/booking_practice_list_cubit.dart';
import 'package:dayoneasia/screen/booking/booking_select_piano/booking_select_piano_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myutils/data/network/model/output/list_piano_output.dart';

class BookingListPianoWidget extends StatelessWidget {
  const BookingListPianoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingPracticeListCubit, BookingPracticeListState>(
      builder: (context, state) {
        // return Padding(
        //   padding:  EdgeInsets.symmetric(vertical: 16.w),
        //   child: PianoGridWidget(
        //       crossAxisCountFromApi: 3,
        //       onSelect: (dataPianoSelected) {
        //         if (dataPianoSelected?.isBooking == false) return;
        //
        //         context
        //             .read<BookingPracticeListCubit>()
        //             .selectPiano(dataPianoSelected?.instrumentCode ?? '');
        //         },
        //       pianos: state.listPianoOutput?.data ?? [],
        //       dataPianoSelected: DataPiano(
        //           instrumentCode: state.listBookingInput.instrumentCode,
        //           isBooking: true)),
        // );

        return Container(
          constraints: const BoxConstraints(minHeight: 0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  context.read<BookingPracticeListCubit>().instrumentPracticeRow2(),
              mainAxisSpacing: 12.w,
              crossAxisSpacing: 12.w,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            itemCount: state.listPianoOutput?.data?.length ?? 0,
            itemBuilder: (context, index) {
              return _buildPianoCell2(context, state, index);
            },
          ),
        );
      },
    );
  }

  Widget _buildPianoCell2(
      BuildContext context, BookingPracticeListState state, int index) {
    DataPiano dataPiano = state.listPianoOutput?.data?[index] ?? DataPiano();
    Color cellColor;
    Color textColor;

    if (dataPiano.instrumentCode == state.listBookingInput.instrumentCode) {
      cellColor = const Color(0xFF3BA771);
      textColor = Colors.white;
    } else if (!(dataPiano.isBooking ?? false)) {
      cellColor = const Color(0xFFFFE0E0);
      textColor = const Color(0xFFFF5252);
    } else {
      cellColor = Colors.white;
      textColor = const Color(0xFF3B3B3B);
    }

    return GestureDetector(
      onTap: !(dataPiano.isBooking ?? false)
          ? null
          : () {
              context
                  .read<BookingPracticeListCubit>()
                  .selectPiano(dataPiano.instrumentCode ?? '');
            },
      child: Container(
        // width: 49.w,
        // height: 58.h,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
          margin: EdgeInsets.zero,
          color: cellColor,
          child: Center(
            child: Text(
              (index + 1).toString(),
              style: TextStyle(
                color: textColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
