part of 'blog_all_cubit.dart';

class BlogAllState extends Equatable {
  final String? error;
  final bool isInitialLoading;
  final bool isLoading;
  final bool isLoadingMore;

  final DataPagination? pagination;
  final BlogCategoriesOutput? blogCategoriesOutput;
  final List<DataBlog>? listBlog;
  final BlogInput? blogInput;
  final int? currentTabIndex;

  //
  final BlogCategoriesOutput? promotionCategoriesOutput;
  final List<DataBlog>? promotions;
  final BlogInput? promotionInput;

  const BlogAllState({
    this.blogCategoriesOutput,
    this.listBlog,
    this.blogInput,
    this.currentTabIndex,
    this.error,
    this.isLoading = false,
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.pagination,
    this.promotionCategoriesOutput,
    this.promotions,
    this.promotionInput,
  });

  @override
  List<Object?> get props => [
        blogCategoriesOutput,
        listBlog,
        blogInput,
        currentTabIndex,
        error,
        isLoading,
        isInitialLoading,
        isLoadingMore,
        pagination,
        promotionCategoriesOutput,
        promotions,
        promotionInput,
      ];

  //copyWith method
  BlogAllState copyWith({
    BlogCategoriesOutput? blogCategoriesOutput,
    List<DataBlog>? listBlog,
    BlogInput? blogInput,
    int? currentTabIndex,
    String? error,
    bool? isLoading,
    bool? isInitialLoading,
    bool? isLoadingMore,
    DataPagination? pagination,
    BlogCategoriesOutput? promotionCategoriesOutput,
    List<DataBlog>? promotions,
    BlogInput? promotionInput,
  }) {
    return BlogAllState(
      blogCategoriesOutput: blogCategoriesOutput ?? this.blogCategoriesOutput,
      listBlog: listBlog ?? this.listBlog,
      blogInput: blogInput ?? this.blogInput,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      pagination: pagination ?? this.pagination,
      promotionCategoriesOutput: promotionCategoriesOutput ?? this.promotionCategoriesOutput,
      promotions: promotions ?? this.promotions,
      promotionInput: promotionInput ?? this.promotionInput,
    );
  }
}
