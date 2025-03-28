import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';

class MyPresentViewHelper {
  static void presentView<T>({
    String title = "Popup",
    bool isFullScreen = true,
    bool useRootContext = false,
    bool hasInsetBottom = true,
    bool enableDrag = true,
    Color? contentColor,
    EdgeInsets? contentPadding,
    Function(T result)? onChanged,
    required BuildContext context,
    required Builder builder,
  }) async {
    final result = await showModalBottomSheet<T>(
        context: context,
        useSafeArea: true,
        enableDrag: enableDrag,
        isScrollControlled: isFullScreen,
        // backgroundColor: contentColor,
        builder: (BuildContext context) {
          return SafeArea(
            bottom: hasInsetBottom,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppBar(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              backgroundColor: Colors.white,
                              title: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              automaticallyImplyLeading: false,
                              actions: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(Icons.close))
                              ],
                            ),
                            Expanded(
                              child: ColoredBox(
                                color: contentColor ?? Colors.white,
                                child: Padding(
                                  padding: contentPadding ??
                                      const EdgeInsets.all(16),
                                  child: useRootContext
                                      ? builder.build(context)
                                      : builder,
                                ),
                              ),
                              // child:
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.viewInsetsOf(context).bottom,
                  )
                ],
              );
            }),
          );
        });
    if (result != null && onChanged != null) {
      onChanged(result);
    }
  }

  static void presentScrollView<T>({
    String title = "Popup",
    bool isFullScreen = true,
    ScrollPhysics? physics,
    Function(T result)? onChanged,
    required BuildContext context,
    required List<Widget> slivers,
  }) async {
    final result = await showModalBottomSheet<T>(
        context: context,
        useSafeArea: true,
        isScrollControlled: isFullScreen,
        builder: (BuildContext context) {
          return SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  AppBar(
                    title: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    automaticallyImplyLeading: false,
                    actions: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close))
                    ],
                  ),
                  Expanded(
                    child: CustomScrollView(
                      physics: physics,
                      // slivers: <Widget>[
                      //   SliverToBoxAdapter(
                      //     child: builder,
                      //   ),
                      // ],

                      slivers: slivers,
                    ),
                  ),
                ],
              );
            }),
          );
        });
    if (result != null && onChanged != null) {
      onChanged(result);
    }
  }

  static Future<void> presentSheet<T>({
    String title = "Popup",
    bool isFullScreen = true,
    bool useRootContext = false,
    Color? contentColor,
    EdgeInsets? contentPadding,
    Function(T result)? onChanged,
    required BuildContext context,
    required Builder builder,
  }) async {
    final result = await showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.94, -0.34),
            end: Alignment(-0.94, 0.34),
            colors: [
              Color(0xFFFFFAF6),
              Color(0xFFFFF8F1),
              Color(0xFFFFF9F3),
              Color(0xFFFFE5CD)
            ],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.85),
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // AppBar(
                  //   shape: const RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.vertical(
                  //       top: Radius.circular(10),
                  //     ),
                  //   ),
                  //   elevation: 1,
                  //   backgroundColor: Colors.white,
                  //   title: Padding(
                  //       padding: const EdgeInsets.all(0),
                  //       child: Text(
                  //         title,
                  //         style: GoogleFonts.beVietnamPro(
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       )),
                  //   automaticallyImplyLeading: false,
                  //   actions: [
                  //     IconButton(
                  //         onPressed: () {
                  //           Navigator.of(context).pop();
                  //         },
                  //         icon: const Icon(Icons.close),)
                  //   ],
                  // ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        color: MyColors.mainColor,
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.sizeOf(context).height * 0.85 -
                            64 -
                            MediaQuery.viewInsetsOf(context).bottom),
                    child: SizedBox(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: contentPadding ?? EdgeInsets.zero,
                          child: Column(
                            children: [
                              useRootContext ? builder.build(context) : builder,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    if (result != null && onChanged != null) {
      onChanged(result);
    }
  }

  static showBranchSelectionSheet(
      {required BuildContext context,
      required String title,
      required Widget child}) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (BuildContext context) {
        return Column(
          children: [
            AppBar(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              elevation: 1,
              backgroundColor: Colors.white,
              title: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    title,
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}
