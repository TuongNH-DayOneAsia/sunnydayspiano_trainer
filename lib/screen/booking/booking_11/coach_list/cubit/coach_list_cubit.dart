import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/model/input/coaches_input.dart';
import 'package:myutils/data/network/model/output/booking_11/coaches_output.dart';
import 'package:myutils/data/network/model/output/booking_11/contracts_output.dart';
import 'package:myutils/data/network/model/output/list_class_output.dart';
import 'package:myutils/data/repositories/booking_repository.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/data/network/model/output/contracts/booking_class_type_v5_output.dart'
as DataContractV5;
part 'coach_list_state.dart';

class CoachListCubit extends WidgetCubit<CoachListState> {
  CoachListCubit(this.dataBranchSelected,this.dataContractSelected)
      : super(widgetState: const CoachListState()) {
    coachesInput =
        CoachesInput(page: 1, limit: 10, branchId: dataBranchSelected?.id ?? 0,key: dataContractSelected?.key ?? '');
  }

  final BookingRepository _bookingRepository = injector();
  final DataInfoNameBooking? dataBranchSelected;

  CoachesInput? coachesInput;
  final DataContractV5.Items? dataContractSelected;

  @override
  void onWidgetCreated() {
    initData();
  }

  initData() async {
    try {
      emit(state.copyWith(isInitialLoading: true));
      final result = await coaches(showLoading: false);
      emit(state.copyWith(
          isInitialLoading: false,
          coaches: result.data ?? [],
          pagination: result.pagination));
    } catch (e) {
      emit(state.copyWith(isInitialLoading: false, error: e.toString()));
    }
  }

  Future<CoachesOutput> coaches(
      {bool? showLoading, int? millisecondsDelay}) async {
    final result = await fetchApi(
        () => _bookingRepository.coaches(
              coachesInput!,
            ),
        showLoading: showLoading ?? true,
        millisecondsDelay: millisecondsDelay ?? 500);

    if (result?.statusCode == ApiStatusCode.success) {
      print('result  ${result?.pagination?.toJson().toString()}');
      return result!;
    }
    throw Exception(MyString.messageError);
  }
  Future<void> loadMore({bool? showLoading}) async {
    if (state.isLoadingMore) return;

    final numberCurrentPage = state.pagination?.currentPage ?? 0;
    final numberTotalPage = state.pagination?.totalPage ?? 0;

    if (numberCurrentPage < numberTotalPage) {
      emit(state.copyWith(isLoadingMore: true)); // Set isLoadingMore to true
      try {
        coachesInput = coachesInput?.copyWith(page: numberCurrentPage.toInt() + 1);
        print('newsInput coachesInput ${coachesInput?.page.toString()}');

        final newListResult = await coaches(showLoading: false);

        if (newListResult.data != null && newListResult.data?.isNotEmpty == true) {
          final List<DataCoach>  updatedList = [
            ...state.coaches ?? [],
            ...newListResult.data ?? [],
          ];
          emit(
            state.copyWith(coaches: updatedList, pagination: newListResult.pagination, isLoadingMore: false),
          ); // Set isLoadingMore back to false);
        } else {
          emit(state.copyWith(isLoadingMore: false)); // Set isLoadingMore back to false
        }
      } catch (e) {
        emit(
          state.copyWith(
              error: isDebug ? e.toString() : MyString.messageError,
              isLoadingMore: false // Set isLoadingMore back to false even on error
          ),
        );
      }
    }
  }



}
