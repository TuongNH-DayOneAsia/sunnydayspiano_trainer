import 'package:dayoneasia/screen/blog/blog_detail/cubit/blog_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/image_extension.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';

class BlogDetailScreen extends BaseStatelessScreenV2 {
  final String slug;
  final BlogDetailScreenType type;
  static String route = '/blog-detail';

  const BlogDetailScreen({
    super.key,
    required this.slug,
    required this.type,
  });

  @override
  String? get title => type == BlogDetailScreenType.BLOG ? 'Chi tiết bài viết' : 'Chi tiết chương trình';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlocDetailCubit(blogSlug: slug, type: type),
      child: super.build(context),
    );
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocBuilder<BlocDetailCubit, BlocDetailState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.newDetailOutput?.statusCode != ApiStatusCode.success) {
          return Center(child: Text(state.newDetailOutput?.message ?? ''));
        }
        return _bodyV2();
        return _bodyV1();
      },
    );
  }

  Widget _bodyV1() {
    return BlocBuilder<BlocDetailCubit, BlocDetailState>(
      builder: (context, state) {
        return CustomScrollView(slivers: [
          SliverAppBar(
            leading: Container(),
            floating: true,
            stretch: true,
            pinned: true,
            // snap: false,
            expandedHeight: MediaQuery.of(context).size.height * 0.25,
            title: Container(),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              background: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: MyImage.cachedImgFromUrl(
                    hasPlaceholder: false,
                    width: double.infinity,
                    url: state.newDetailOutput?.data?.avatar ?? '',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            // bottom: buildTabBar(state, context),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24.0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text(
                      state.newDetailOutput?.data?.publishTime ?? '',
                      style: TextStyle(
                        color: const Color(0xFF6A6A6A),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  if (state.newDetailOutput?.data?.categoryName?.isNotEmpty == true)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.w),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 0.50, color: Color(0xFFFF8B00)),
                          borderRadius: BorderRadius.circular(1000),
                        ),
                      ),
                      child: Text(
                        state.newDetailOutput?.data?.categoryName ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MyColors.mainColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    state.newDetailOutput?.data?.name ?? '',
                    style: TextStyle(
                      color: const Color(0xFF2A2A2A),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    state.newDetailOutput?.data?.description ?? '',
                    style: TextStyle(
                      color: const Color(0xFF2A2A2A),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  HtmlWidget(state.newDetailOutput?.data?.content ?? '')
                ],
              ),
            ),
          ),
        ]);
      },
    );
  }

  Widget _bodyV2() {
    return BlocBuilder<BlocDetailCubit, BlocDetailState>(
      builder: (context, state) {
        return ListView(children: [
          SizedBox(
            width: double.infinity,
            child: MyImage.cachedImgFromUrl(
              hasPlaceholder: false,
              width: double.infinity,
              url: state.newDetailOutput?.data?.avatar ?? '',
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height * 0.2618,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Text(
                    state.newDetailOutput?.data?.publishTime ?? '',
                    style: TextStyle(
                      color: const Color(0xFF6A6A6A),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                if (state.newDetailOutput?.data?.categoryName?.isNotEmpty == true)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.w),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 0.50, color: Color(0xFFFF8B00)),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                    ),
                    child: Text(
                      state.newDetailOutput?.data?.categoryName ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MyColors.mainColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  state.newDetailOutput?.data?.name ?? '',
                  style: TextStyle(
                    color: const Color(0xFF2A2A2A),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  state.newDetailOutput?.data?.description ?? '',
                  style: TextStyle(
                    color: const Color(0xFF2A2A2A),
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                HtmlWidget(state.newDetailOutput?.data?.content ?? '')
              ],
            ),
          )
        ]);
      },
    );
  }
}
