import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/data/network/model/output/new_detail_output.dart';
import 'package:myutils/data/repositories/booking_repository.dart';

part 'blog_detail_state.dart';

enum BlogDetailScreenType { PROMOTION, BLOG }

class BlocDetailCubit extends WidgetCubit<BlocDetailState> {
  BlocDetailCubit({required this.type, required this.blogSlug}) : super(widgetState: const BlocDetailState());
  final String blogSlug;
  final BlogDetailScreenType type;

  final BookingRepository _bookingRepository = injector();

  @override
  void onWidgetCreated() {
    getDetail();
  }

  Future<void> getDetail() async {
    // Emit loading state before fetching
    emit(state.copyWith(isLoading: true));

    try {
      var result = await fetchApi(
          () => type == BlogDetailScreenType.BLOG
              ? _bookingRepository.blogDetail(blogSlug)
              : _bookingRepository.promotionDetail(blogSlug),
          showLoading: false,
          millisecondsDelay: 1000);

      // Emit success state with data
      emit(state.copyWith(
        isLoading: false,
        newDetailOutput: result,
      ));
    } catch (error) {
      // Emit error state
      emit(state.copyWith(
        isLoading: false,
        error: error.toString(),
      ));
    }
  }
}
