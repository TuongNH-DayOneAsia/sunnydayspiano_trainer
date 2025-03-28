import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/model/input/blog_input.dart';
import 'package:myutils/data/network/model/output/list_class_output.dart';
import 'package:myutils/data/network/model/output/news_categories_output.dart';
import 'package:myutils/data/network/model/output/news_output.dart';
import 'package:myutils/data/repositories/booking_repository.dart';
import 'package:myutils/helpers/extension/string_extension.dart';

part 'blog_all_state.dart';

class BlogAllCubit extends WidgetCubit<BlogAllState> {
  BlogAllCubit() : super(widgetState: const BlogAllState());
  final BookingRepository _bookingRepository = injector();

  BlogInput? blogInput;
  BlogInput? promotionInput;

  @override
  void onWidgetCreated() {
    loadInitialData();
  }

  Future<void> refreshData() async {
    await loadInitialData();
  }

  Future<void> loadInitialData({bool? isRefresh}) async {
    await Future.wait([
      blogCategories(),
      promotionCategories(),
    ]);
  }

  Future<void> blogCategories() async {
    try {
      emit(state.copyWith(isInitialLoading: true));
      final blogCategoriesResult = await fetchApi(() => _bookingRepository.blogCategories(), showLoading: false);
      if (blogCategoriesResult?.statusCode == ApiStatusCode.success && blogCategoriesResult?.data?.isNotEmpty == true) {
        blogInput = BlogInput(page: 1, limit: 10, slug: blogCategoriesResult?.data?.first.slug ?? '');
        final newResult = await news(showLoading: false);

        emit(state.copyWith(
          blogCategoriesOutput: blogCategoriesResult,
          listBlog: newResult.data ?? [],
          currentTabIndex: 0,
          isLoading: false,
          isInitialLoading: false,
          pagination: newResult.pagination,
        ));
      } else {
        // _emitError(blogCategoriesResult?.message ?? '');
      }
    } catch (e) {
      // _emitError(e.toString());
    }
  }

  Future<void> promotionCategories() async {
    try {
      final promotionCategoriesResult = await fetchApi(() => _bookingRepository.promotionCategories(), showLoading: false);
      if (promotionCategoriesResult?.statusCode == ApiStatusCode.success && promotionCategoriesResult?.data?.isNotEmpty == true) {
        promotionInput = BlogInput(page: 1, limit: 10, slug: promotionCategoriesResult?.data?.first.slug ?? '');
        final promotionResult = await promotions(showLoading: false);
        emit(state.copyWith(
          promotionCategoriesOutput: promotionCategoriesResult,
          promotions: promotionResult.data ?? [],
        ));
      } else {
        // _emitError(promotionCategoriesResult?.message ?? '');
      }
    } catch (e) {
      // _emitError(e.toString());
    }
  }

  Future<BlogOutput> promotions({bool? showLoading, int? millisecondsDelay}) async {
    final result = await fetchApi(
        () => _bookingRepository.promotions(
              promotionInput!,
            ),
        showLoading: showLoading ?? true,
        millisecondsDelay: millisecondsDelay ?? 500);

    if (result?.statusCode == ApiStatusCode.success) {
      print('result news ${result?.pagination?.toJson().toString()}');
      return result!;
    }
    throw Exception(MyString.messageError);
  }

  Future<BlogOutput> news({bool? showLoading, int? millisecondsDelay}) async {
    print('newsInput ${blogInput?.toJson()}');

    final result = await fetchApi(
        () => _bookingRepository.blog(
              blogInput!,
            ),
        showLoading: showLoading ?? true,
        millisecondsDelay: millisecondsDelay ?? 500);

    if (result?.statusCode == ApiStatusCode.success) {
      print('result news ${result?.pagination?.toJson().toString()}');
      return result!;
    }
    throw Exception(MyString.messageError);
  }

  Future<void> filterNews({required int indexTab, bool? showLoading}) async {
    final list = state.blogCategoriesOutput?.data ?? [];
    if (list.isEmpty) return;
    final slug = list[indexTab].slug ?? '';
    blogInput = blogInput?.copyWith(
      slug: slug,
      limit: 10,
      page: 1,
    );
    emit(state.copyWith(isLoading: true));

    try {
      final newResult = await news(showLoading: showLoading, millisecondsDelay: 1000);
      emit(state.copyWith(
        listBlog: newResult.data ?? [],
        currentTabIndex: indexTab,
        pagination: newResult.pagination,
        isLoading: false,
      ));
    } catch (e) {
      _emitError(isDebug ? e.toString() : MyString.messageError);
    }
  }

  void _emitError(String error) {
    emit(state.copyWith(
      error: error,
      isLoading: false,
      isInitialLoading: false,
    ));
  }

  Future<void> loadMore(bool? showLoading) async {
    if (state.isLoadingMore) return;

    final numberCurrentPage = state.pagination?.currentPage ?? 0;
    final numberTotalPage = state.pagination?.totalPage ?? 0;

    if (numberCurrentPage < numberTotalPage) {
      emit(state.copyWith(isLoadingMore: true)); // Set isLoadingMore to true
      try {
        blogInput = blogInput?.copyWith(page: numberCurrentPage + 1);
        print('newsInput page ${blogInput?.page.toString()}');

        final newListResult = await news(showLoading: showLoading);

        if (newListResult.data != null && newListResult.data?.isNotEmpty == true) {
          final List<DataBlog> updatedList = [
            ...state.listBlog ?? [],
            ...newListResult.data ?? [],
          ];
          emit(
            state.copyWith(listBlog: updatedList, pagination: newListResult.pagination, isLoadingMore: false),
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
