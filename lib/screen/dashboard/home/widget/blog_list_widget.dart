import 'package:dayoneasia/screen/blog/blog_detail/blog_detail_screen.dart';
import 'package:dayoneasia/screen/blog/blog_detail/cubit/blog_detail_cubit.dart';
import 'package:dayoneasia/screen/dashboard/home/cubit/home/home_cubit.dart';
import 'package:dayoneasia/screen/dashboard/home/cubit/home/home_state.dart';
import 'package:dayoneasia/screen/dashboard/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class BlogListWidget extends StatefulWidget {
  const BlogListWidget({super.key});

  @override
  State<BlogListWidget> createState() => _BlogListWidgetState();
}

class _BlogListWidgetState extends State<BlogListWidget> {
  double spaceBetween = 14.h;
  final _duration = const Duration(milliseconds: 200);

  _onStartScroll(ScrollMetrics metrics) {
    // if you need to do something at the start
  }

  _onUpdateScroll(ScrollMetrics metrics) {
    // do your magic here to change the value
    if (spaceBetween == 30.0) return;
    spaceBetween = 30.0;
    setState(() {});
  }

  _onEndScroll(ScrollMetrics metrics) {
    // do your magic here to return the value to normal
    spaceBetween = 14.h;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final list = state.newsOutput?.data ?? [];

        if(list.isEmpty == true){
          return buildShimmerList();
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: list.length,
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
          separatorBuilder: (BuildContext context, int index) => AnimatedContainer(duration: _duration, height: spaceBetween),
        );
      },
    );
    ;
  }
  Widget buildShimmerList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 3, // 3 shimmer items
      itemBuilder: (context, index) {
        return buildShimmerBlogItem(context);
      },
      separatorBuilder: (BuildContext context, int index) =>
          AnimatedContainer(duration: _duration, height: spaceBetween),
    );
  }

  Widget buildShimmerBlogItem(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.2618,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
            ),
            // Content container
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  right: BorderSide(
                    color: Color(0xFFE5E5E5),
                    width: 1,
                  ),
                  left: BorderSide(
                    color: Color(0xFFE5E5E5),
                    width: 1,
                  ),
                  bottom: BorderSide(
                    color: Color(0xFFE5E5E5),
                    width: 1,
                  ),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title placeholder
                  Container(
                    width: double.infinity,
                    height: 14.sp,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Description placeholder - first line
                  Container(
                    width: double.infinity,
                    height: 12.sp,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Description placeholder - second line
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 12.sp,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
