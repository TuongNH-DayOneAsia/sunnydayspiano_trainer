import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';

class MyTabbedPage2<T> extends StatefulWidget {
  final List<T> items;
  final Function(int index)? onTap;
  final String Function(T item) titleBuilder;
  final String Function(T item)? subtitleBuilder;
  final double? fontSize;
  final bool useCustomTabStyle;
  final int? currentIndex;

  const MyTabbedPage2({
    super.key,
    required this.items,
    this.onTap,
    required this.titleBuilder,
    this.subtitleBuilder,
    this.fontSize,
    this.useCustomTabStyle = false,
    this.currentIndex,
  });

  @override
  State<MyTabbedPage2<T>> createState() => _MyTabbedPageState2<T>();
}

class _MyTabbedPageState2<T> extends State<MyTabbedPage2<T>>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: widget.items.length,
        vsync: this,
        initialIndex: widget.currentIndex ?? 0);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MyTabbedPage2<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentIndex != oldWidget.currentIndex) {
      _tabController.animateTo(widget.currentIndex ?? 0);
    }

    if (widget.items.length != oldWidget.items.length) {
      _tabController.dispose();
      _tabController = TabController(
          length: widget.items.length,
          vsync: this,
          initialIndex: widget.currentIndex ?? 0);
      _tabController.addListener(_handleTabChange);
    }
  }

  void _handleTabChange() {
    setState(() {});
  }

  Widget _buildTabContent(String text, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            width: 0.5, color: isSelected ? MyColors.mainColor : Colors.white),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: isSelected ? MyColors.mainColor : MyColors.lightGrayColor2,
            fontSize: 14.sp),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    if (widget.useCustomTabStyle) {
      if (isTablet) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.items
                .asMap()
                .map((index, item) => MapEntry(
                      index,
                      InkWell(
                        onTap: () {
                          widget.onTap!(index);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              right: 16.w, left: index == 0 ? 16.w : 0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 6.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 0.5,
                                color: _tabController.index == index
                                    ? MyColors.mainColor
                                    : const Color(0xFFAAAAAA)),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Center(
                            child: Text(
                              widget.titleBuilder(item),
                              style: GoogleFonts.beVietnamPro(
                                  fontWeight: _tabController.index == index
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: _tabController.index == index
                                      ? MyColors.mainColor
                                      : MyColors.lightGrayColor2,
                                  fontSize: 14.sp),
                            ),
                          ),
                        ),
                      ),
                    ))
                .values
                .toList(),
          ),
        );
      }

      return SizedBox(
        child: TabBar(
          padding: EdgeInsets.zero,
          controller: _tabController,
          isScrollable: true,
          onTap: widget.onTap,
          labelPadding: EdgeInsets.only(left: 16.w),
          indicator: const BoxDecoration(),
          tabs: List.generate(widget.items.length, (index) {
            bool isSelected = _tabController.index == index;
            return Tab(
                child: _buildTabContent(
                    widget.titleBuilder(widget.items[index]), isSelected));
          }),
        ),
      );
    }
    return Container(
      height: (isTablet ? 100.h : null),
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 8.0.w : 4.0.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 2.0,
          ),
        ),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(8.0),
            topRight: const Radius.circular(8.0),
            bottomLeft: const Radius.circular(8.0),
            bottomRight: const Radius.circular(8.0)),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        onTap: widget.onTap,
        indicatorWeight: 1.5,
        isScrollable: widget.items.length >= 4 ? true : false,
        tabs: widget.items
            .asMap()
            .map((index, item) => MapEntry(
                  index,
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 20.0.w : 16.0.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.titleBuilder(item),
                            style: GoogleFonts.beVietnamPro(
                              fontSize: isTablet
                                  ? (widget.fontSize ?? 16.sp)
                                  : (widget.fontSize ?? 14.sp),
                              fontWeight: _tabController.index == index
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: MyColors.darkGrayColor,
                            ),
                          ),
                          if (widget.subtitleBuilder != null)
                            Text(
                              widget.subtitleBuilder!(item),
                              style: GoogleFonts.beVietnamPro(
                                fontSize: isTablet ? 14.sp : 12.sp,
                                fontWeight: FontWeight.w300,
                                color: MyColors.darkGrayColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ))
            .values
            .toList(),
      ),
    );
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        height: (isTablet ? 100.h : null),
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 8.0.w : 4.0.w),
        child: Stack(
          fit: StackFit.passthrough,
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom:
                      BorderSide(color: MyColors.lightGrayColor, width: 1.5),
                ),
              ),
            ),
            TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              onTap: widget.onTap,
              indicatorWeight: 1.5,
              isScrollable: widget.items.length >= 4 ? true : false,
              tabs: widget.items
                  .asMap()
                  .map((index, item) => MapEntry(
                        index,
                        Tab(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 20.0.w : 16.0.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.titleBuilder(item),
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: isTablet
                                        ? (widget.fontSize ?? 16.sp)
                                        : (widget.fontSize ?? 14.sp),
                                    fontWeight: _tabController.index == index
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: MyColors.darkGrayColor,
                                  ),
                                ),
                                if (widget.subtitleBuilder != null)
                                  Text(
                                    widget.subtitleBuilder!(item),
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: isTablet ? 14.sp : 12.sp,
                                      fontWeight: FontWeight.w300,
                                      color: MyColors.darkGrayColor,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ))
                  .values
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTabIndicator extends Decoration {
  final double radius;

  final Color color;

  final double indicatorHeight;

  const CustomTabIndicator({
    this.radius = 8,
    this.indicatorHeight = 4,
    this.color = Colors.blue,
  });

  @override
  _CustomPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(
      this,
      onChanged,
      radius,
      color,
      indicatorHeight,
    );
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;
  final double radius;
  final Color color;
  final double indicatorHeight;

  _CustomPainter(
    this.decoration,
    VoidCallback? onChanged,
    this.radius,
    this.color,
    this.indicatorHeight,
  ) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    final Paint paint = Paint();
    double xAxisPos = offset.dx + configuration.size!.width / 2;
    double yAxisPos =
        offset.dy + configuration.size!.height - indicatorHeight / 2;
    paint.color = color;

    RRect fullRect = RRect.fromRectAndCorners(
      Rect.fromCenter(
        center: Offset(xAxisPos, yAxisPos),
        width: configuration.size!.width / 3,
        height: indicatorHeight,
      ),
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
    );

    canvas.drawRRect(fullRect, paint);
  }
}
