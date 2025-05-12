import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myutils/config/local_stream.dart';

abstract class BaseStatefulScreenV2 extends StatefulWidget {
  final String? title;
  final double? appBarHeight;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final bool? hasAppbar;

  const BaseStatefulScreenV2({
    super.key,
    this.title,
    this.appBarHeight = kToolbarHeight,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.hasAppbar = true,
  });

  @override
  BaseStatefulScreenV2State createState() => BaseStatefulScreenV2State();

  Widget buildBody(BuildContext context);
  Color? get backgroundColor => Colors.white;
}

class BaseStatefulScreenV2State<T extends BaseStatefulScreenV2> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: EventBus.shared.localeStream,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: widget.backgroundColor,
          appBar: (widget.hasAppbar ?? true)
              ? PreferredSize(
            preferredSize: Size.fromHeight(widget.appBarHeight ?? kToolbarHeight),
            child: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              ),
              elevation: 2,
              backgroundColor: Colors.white,
              shadowColor: Colors.grey.withOpacity(0.5),
              automaticallyImplyLeading: widget.automaticallyImplyLeading,
              actions: widget.actions,
              title: widget.title != null
                  ? Text(
                widget.title!,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : null,
            ),
          )
              : null,
          body: widget.buildBody(context),
        );
      }
    );
  }
}