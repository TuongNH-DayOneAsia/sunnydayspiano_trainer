import 'package:dayoneasia/screen/blog/blog_detail/blog_detail_screen.dart';
import 'package:dayoneasia/screen/blog/blog_detail/cubit/blog_detail_cubit.dart';
import 'package:dayoneasia/screen/dashboard/home/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/data/network/model/output/news_categories_output.dart';
import 'package:myutils/data/network/model/output/news_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/image_extension.dart';
import 'package:myutils/utils/tab/my_tab_bar.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';

import '../../dashboard/home/widget/section_title_widget.dart';
import 'cubit/blog_all_cubit.dart';

/// A screen that displays all blog posts.
class BlogAllScreen extends BaseStatelessScreenV2 {
  /// The route name for navigation.
  static const String route = '/blog-all';
  final ScrollController blogScrollController;

  /// Creates a [BlogAllScreen] widget.

  const BlogAllScreen({super.key, super.automaticallyImplyLeading = false, required this.blogScrollController});

  @override
  String? get title => 'Bài viết';

  @override
  Color? get backgroundColor => MyColors.backgroundColor;



  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocBuilder<BlogAllCubit, BlogAllState>(
      builder: (context, state) {
        if (state.isInitialLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.promotions?.isEmpty == true && state.listBlog?.isEmpty == true) {
          return const Center(child: Text('Không có dữ liệu'));
        }
        return _BuildContentWidget(blogScrollController: blogScrollController);
      },
    );
  }
}

/// A widget that builds the content of the blog screen.
class _BuildContentWidget extends StatefulWidget {
  final ScrollController blogScrollController;

  /// Creates a [_BuildContentWidget] widget.
  const _BuildContentWidget({required this.blogScrollController});

  @override
  State<_BuildContentWidget> createState() => _BuildContentWidgetState();
}

/// The state for the [_BuildContentWidget].
class _BuildContentWidgetState extends State<_BuildContentWidget> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.blogScrollController;
  }

  /// Scrolls to the top of the list if it is not empty.
  void _scrollToTop(List<DataBlog>? list) {
    if (list?.isEmpty == true) {
      return;
    }
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogAllCubit, BlogAllState>(
      builder: (context, state) {
        return RefreshIndicator(
          color: MyColors.mainColor,
          onRefresh: () async {
            await context.read<BlogAllCubit>().refreshData();
            _scrollToTop(state.listBlog);
            return Future.delayed(const Duration(milliseconds: 1000));
          },
          child: IgnorePointer(
            ignoring: state.isLoading || state.isLoadingMore,
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo is ScrollEndNotification) {
                  final metrics = scrollInfo.metrics;
                  final itemCount = state.listBlog?.length ?? 0;
                  if (itemCount == 0) return false;
                  final itemExtent = metrics.maxScrollExtent / itemCount;
                  final lastItemIndex = itemCount - 1;
                  final lastItemPosition = lastItemIndex * itemExtent;
                  if (metrics.pixels >= lastItemPosition && !state.isLoadingMore) {
                    if (kDebugMode) {
                      print('load more');
                    }
                    context.read<BlogAllCubit>().loadMore(false);
                  }
                }
                return state.isLoadingMore; // Prevent scroll if loading more
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (state.promotions?.isNotEmpty == true) ...[
                        const BuildSectionTitle(text: 'Thông báo chương trình'),
                        SizedBox(height: 14.h),
                        const ListPromotionWidget(),
                        SizedBox(height: 20.h),
                      ],
                      const BuildSectionTitle(text: 'Bài viết'),
                      SizedBox(height: 14.h),
                      _buildDivider(),
                      SizedBox(height: 14.h),
                      if (state.blogCategoriesOutput?.data?.isNotEmpty == true) ...[_buildTabbedPage()],
                      SizedBox(height: 16.h),
                      ListBlogWidget(scrollController: _scrollController),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds a divider widget.
  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: const Divider(
        color: Color(0x1A000000),
        thickness: 1,
      ),
    );
  }

  /// Builds a tabbed page widget.
  Widget _buildTabbedPage() {
    return BlocBuilder<BlogAllCubit, BlogAllState>(
      builder: (context, state) {
        final list = state.blogCategoriesOutput?.data ?? [];
        if (kDebugMode) {
          print('state.currentTabIndex  ${state.currentTabIndex}');
        }
        return MyTabbedPage2<DataNewsCategory>(
          fontSize: 12.sp,
          currentIndex: state.currentTabIndex ?? 0,
          useCustomTabStyle: true,
          items: list,
          titleBuilder: (item) => item.name ?? '',
          onTap: (index) {
            _scrollToTop(state.listBlog);
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                context.read<BlogAllCubit>().filterNews(indexTab: index);
              }
            });
          },
        );
      },
    );
  }
}

/// A widget that displays a list of promotions.
class ListPromotionWidget extends StatelessWidget {
  /// Creates a [ListPromotionWidget] widget.
  const ListPromotionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogAllCubit, BlogAllState>(
      builder: (context, state) {
        final promotions = state.promotions ?? [];
        if (promotions.isEmpty) {
          return const SizedBox();
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ...promotions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final e = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == promotions.length - 1 ? 0 : 16.w,
                    ),
                    child: ItemPromotionWidget(dataPromotion: e),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A widget that displays a single promotion item.
class ItemPromotionWidget extends StatelessWidget {
  /// The data for the promotion.
  final DataBlog dataPromotion;

  /// Creates an [ItemPromotionWidget] widget.
  const ItemPromotionWidget({super.key, required this.dataPromotion});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (dataPromotion.slug?.isNotEmpty == true) {
          context.push(
            BlogDetailScreen.route,
            extra: {
              'blogSlug': dataPromotion.slug,
              'blogType': BlogDetailScreenType.PROMOTION,
            },
          );
        }
      },
      child: SizedBox(
        width: 240.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: MyImage.cachedImgFromUrl(
                    hasPlaceholder: false,
                    url: dataPromotion.avatar ?? '',
                    height: 180.h,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  right: 10.w,
                  top: 9.w,
                  child: Container(
                    width: 26.w,
                    height: 26.w,
                    decoration: ShapeDecoration(
                      color: Colors.black.withOpacity(0.2),
                      shape: const CircleBorder(),
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              dataPromotion.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF2A2A2A),
                fontSize: 14.sp,
                fontFamily: 'Be Vietnam Pro',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              dataPromotion.description ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF3B3B3B),
                fontSize: 12.sp,
                fontFamily: 'Be Vietnam Pro',
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget that displays a list of blog posts.
class ListBlogWidget extends StatefulWidget {
  /// The scroll controller for the list.
  final ScrollController scrollController;

  /// Creates a [ListBlogWidget] widget.
  const ListBlogWidget({
    super.key,
    required this.scrollController,
  });

  @override
  State<ListBlogWidget> createState() => _ListBlogWidgetState();
}

/// The state for the [ListBlogWidget].
class _ListBlogWidgetState extends State<ListBlogWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogAllCubit, BlogAllState>(
      builder: (context, state) {
        final list = state.listBlog ?? [];
        if (list.isEmpty) {
          return const Center(child: Text('Không có dữ liệu bài viết'));
        }
        return Stack(
          children: [
            ListView.separated(
              shrinkWrap: true,
              // controller: widget.scrollController,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.listBlog?.length ?? 0,
              itemBuilder: (context, index) {
                final data = list[index];

                return InkWell(
                  onTap: () => data.slug?.isNotEmpty == true
                      ? context.push(
                          BlogDetailScreen.route,
                          extra: {
                            'blogSlug': data.slug,
                            'blogType': BlogDetailScreenType.BLOG,
                          },
                        )
                      : null,
                  child: ItemBlogWidget(data),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 16);
              },
            ),
            if (state.isLoadingMore)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.white.withOpacity(0.8),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
