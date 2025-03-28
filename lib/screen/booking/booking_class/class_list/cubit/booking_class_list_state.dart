import 'package:equatable/equatable.dart';
import 'package:myutils/data/network/model/output/banner_class_type_output.dart';
import 'package:myutils/data/network/model/output/branches_output.dart';
import 'package:myutils/data/network/model/output/currrent_week_output.dart';
import 'package:myutils/data/network/model/output/list_class_output.dart';

class BookingClassListState extends Equatable {
  final String? error;
  final bool isInitialLoading;
  final bool isLoading;
  final bool isLoadingMore;
  final DataInfoNameBooking? dataBranchSelected;
  final BranchesOutput? branchesOutput;
  final List<DataCalendar>? currentWeek;
  final ListClassOutput? listBookingOutput;
  final BannerClassTypeOutput? bannerClassTypeOutput;

  const BookingClassListState(
      {this.branchesOutput,
      this.currentWeek,
      this.error,
      this.isLoading = false,
      this.isInitialLoading = false,
      this.isLoadingMore = false,
      this.listBookingOutput,
      this.dataBranchSelected,
      this.bannerClassTypeOutput});

  BookingClassListState copyWith(
      {BranchesOutput? branchesOutput,
      List<DataCalendar>? currentWeek,
      String? error,
      bool? isLoading,
      bool? isInitialLoading,
      bool? isLoadingMore,
      ListClassOutput? listBookingOutput,
      DataInfoNameBooking? dataBranchSelected,
      BannerClassTypeOutput? bannerClassTypeOutput}) {
    return BookingClassListState(
      branchesOutput: branchesOutput ?? this.branchesOutput,
      currentWeek: currentWeek ?? this.currentWeek,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      listBookingOutput: listBookingOutput ?? this.listBookingOutput,
      dataBranchSelected: dataBranchSelected ?? this.dataBranchSelected,
      bannerClassTypeOutput: bannerClassTypeOutput ?? this.bannerClassTypeOutput,
    );
  }

  @override
  List<Object?> get props => [
        branchesOutput,
        currentWeek,
        error,
        isLoading,
        isInitialLoading,
        isLoadingMore,
        listBookingOutput,
        dataBranchSelected,
        bannerClassTypeOutput
      ];
}
