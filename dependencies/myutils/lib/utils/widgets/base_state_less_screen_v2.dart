import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:myutils/utils/widgets/my_button.dart';

import '../../helpers/extension/colors_extension.dart';
abstract class BaseStatefulScreenV2 extends StatefulWidget {
  final String? title;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final bool? hasAppbar;
  final bool? appColorTransparent;
  final double? sizeButtonBack;

  const BaseStatefulScreenV2({
    super.key,
    this.title,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.hasAppbar = true,
    this.appColorTransparent = false,
    this.sizeButtonBack,
  });

  @override
  BaseStatefulScreenStateV2 createState();
}

abstract class BaseStatefulScreenStateV2<T extends BaseStatefulScreenV2>
    extends State<T> {
  double? get elevation => 2;

  Color? get backgroundColor => Colors.white;

  void onBack({required BuildContext context, bool? value}) {
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: widget.appColorTransparent ?? false,
      backgroundColor: backgroundColor,
      appBar: (widget.hasAppbar ?? true)
          ? buildAppBar(context, widget.title ?? '---')
          : null,
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext pageContext);

  PreferredSizeWidget? buildAppBar(BuildContext context, String title) {
    return PreferredSize(
      preferredSize: Size.fromHeight(56.h),
      child: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light),
        elevation: (widget.appColorTransparent ?? false) ? 0 : elevation,
        backgroundColor: (widget.appColorTransparent ?? false)
            ? Colors.transparent
            : Colors.white,
        shadowColor: (widget.appColorTransparent ?? false)
            ? null
            : Colors.grey.withOpacity(0.5),
        automaticallyImplyLeading: widget.automaticallyImplyLeading,
        actions: widget.actions,
        leading: widget.automaticallyImplyLeading
            ? IconButton(
          icon: Icon(
            size: widget.sizeButtonBack ?? 18.sp,
            Icons.arrow_back_ios,
            color: (widget.appColorTransparent ?? false)
                ? Colors.white
                : Colors.black,
          ),
          onPressed: () {
            onBack(context: context);
          },
        )
            : null,
        title: buildTitle(context),
      ),
    );
  }

  Widget? buildTitle(BuildContext context) {
    return widget.title != null
        ? Text(
      widget.title!,
      style: GoogleFonts.beVietnamPro(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: (widget.appColorTransparent ?? false)
            ? Colors.white
            : Colors.black,
      ),
    )
        : null;
  }
}
abstract class BaseStatelessScreenV2 extends StatelessWidget {
  final String? title;

  // final double? appBarHeight;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final bool? hasAppbar;
  final bool? appColorTransparent;
  final double? sizeButtonBack;

  const BaseStatelessScreenV2(
      {super.key,
      this.title,
      // this.appBarHeight = kToolbarHeight,
      this.automaticallyImplyLeading = true,
      this.actions,
      this.hasAppbar = true,
      this.appColorTransparent = false,
      this.sizeButtonBack});

  double? get elevation => 2;

  Color? get backgroundColor => Colors.white;

  void onBack({required BuildContext context, bool? value}) {
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: appColorTransparent ?? false,
      backgroundColor: backgroundColor,
      appBar: (hasAppbar ?? true) ? buildAppBar(context, title ?? '---') : null,
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext pageContext);

  PreferredSizeWidget? buildAppBar(BuildContext context, String title) {
    return PreferredSize(
      preferredSize: Size.fromHeight(56.h),
      child: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light),
        elevation: (appColorTransparent ?? false) ? 0 : elevation,
        backgroundColor:
            (appColorTransparent ?? false) ? Colors.transparent : Colors.white,
        // backgroundColor: Colors.white,
        shadowColor: (appColorTransparent ?? false)
            ? null
            : Colors.grey.withOpacity(0.5),
        automaticallyImplyLeading: automaticallyImplyLeading,
        actions: actions,
        leading: automaticallyImplyLeading
            ? IconButton(
                icon: Icon(
                  size: sizeButtonBack ?? 18.sp,
                  Icons.arrow_back_ios,
                  color: (appColorTransparent ?? false)
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () {
                  onBack(context: context);
                },
              )
            : null,
        title: buildTitle(context),
      ),
    );
  }

  Widget? buildTitle(BuildContext context) {
    return title != null
        ? Text(
            title!,
            style: GoogleFonts.beVietnamPro(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color:
                  (appColorTransparent ?? false) ? Colors.white : Colors.black,
            ),
          )
        : null;
  }
}

class NoInternetWidget extends StatelessWidget {
  final Function()? onPressed;

  const NoInternetWidget({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 150.w,
            height: 150.w,
            child: const _AnimationWifiWidget(),
          ),
          Text(
            'Không có kết nối mạng',
            style: GoogleFonts.beVietnamPro(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          RippleTextButton(
            iconLeft: Icon(
              Icons.refresh,
              color: MyColors.mainColor,
              size: 18.sp,
            ),
            text: 'Nhấn để tại lại trang',
            onPressed: () {
              onPressed?.call();
            },
            color: MyColors.mainColor,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 16.w),
          )
        ],
      ),
    );
  }
}

class _AnimationWifiWidget extends StatefulWidget {
  const _AnimationWifiWidget({super.key});

  @override
  State<_AnimationWifiWidget> createState() => _AnimationWifiWidgetState();
}

class _AnimationWifiWidgetState extends State<_AnimationWifiWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedCircles() {
    return AnimatedBuilder(
      animation:
          CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(100 * _controller.value),
            _buildContainer(150 * _controller.value),
            _buildContainer(200 * _controller.value),
            child!,
          ],
        );
      },
      child: Icon(
        Icons.wifi_off_sharp,
        color: Colors.grey,
        size: 44.sp,
      ),
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius.clamp(0, 150), // Giới hạn kích thước tối đa
      height: radius.clamp(0, 150),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: MyColors.mainColor.withOpacity(1 - _controller.value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _buildAnimatedCircles(),
    );
  }
}
