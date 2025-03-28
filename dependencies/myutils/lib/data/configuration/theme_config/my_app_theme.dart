// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/utils/dimens.dart';

import '../color_config/colors_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class MyThemeData {
  static ThemeData myLightTheme(BuildContext context) {
    return ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        // labelStyle: const TextStyle(
        //   // color: MyColors.lightGrayColor,
        //   fontSize: 18,
        //   fontWeight: FontWeight.w400,
        // ),
        // suffixStyle: const TextStyle(
        //   // color: MyColors.lightGrayColor,
        //   fontSize: 18,
        //   fontWeight: FontWeight.w400,
        // ),
        // prefixStyle: const TextStyle(
        //   // color: MyColors.lightGrayColor,
        //   fontSize: 18,
        //   fontWeight: FontWeight.w400,
        // ),
        // hintStyle: const TextStyle(
        //   // color: MyColors.lightGrayColor,
        //   fontSize: 13,
        //   fontWeight: FontWeight.w400,
        // ),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(
            color: MyColors.lightGrayColor,
            width: 0.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.lightGrayColor, width: 0.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: MyColors.lightGrayColor, width: 0.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: MyColors.darkGrayColor, width: 0.5),
        ),
      ),
      // textTheme: TextTheme(
      //   bodyLarge: TextStyle(fontSize: Dimens.getAdaptiveFontSize(context, 16)),
      //   bodyMedium: TextStyle(fontSize: Dimens.getAdaptiveFontSize(context, 12)),
      //   bodySmall: TextStyle(fontSize: Dimens.getAdaptiveFontSize(context, 12)),
      //   titleLarge: TextStyle(fontSize: Dimens.getAdaptiveFontSize(context, 20)),
      //   titleMedium: TextStyle(fontSize: Dimens.getAdaptiveFontSize(context, 18)),
      //   titleSmall: TextStyle(fontSize: Dimens.getAdaptiveFontSize(context, 16)),
      // ),

      textTheme: GoogleFonts.beVietnamProTextTheme(),
      // fontFamily: MyString.pathForAsset(myResource, 'assets/fonts/Inter'),
      //     fontFamily: MyString.pathForAsset(myResource, 'Inter'),
      // fontFamily: 'Be Vietnam Pro',
      scaffoldBackgroundColor: Colors.grey.shade50,
      // fontFamily: AppFonts.fontInter,
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
      }),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 1,
        selectedItemColor: MyColors.mainColor,
        unselectedItemColor: MyColors.darkGrayColor,
        selectedLabelStyle: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400),
        unselectedLabelStyle: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400),
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      tabBarTheme: TabBarTheme(
        indicatorColor: MyColors.mainColor,
        labelColor: MyColors.mainColor,
        unselectedLabelColor: Colors.grey,
        labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        // indicator: BoxDecoration(
        //   color: MyColors.mainColor,
        //   borderRadius: BorderRadius.circular(12),
        // ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Color.fromRGBO(18, 24, 38, 1),
        ),
        iconTheme: IconThemeData(
          color: Color.fromRGBO(18, 24, 38, 1),
        ),
        color: Colors.transparent,
        // backgroundColor: Colors.transparent,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        scrolledUnderElevation: 0,
      ),
      // colorScheme: _colorScheme(GtdAppSupplier.b2c, ThemeMode.light),
      useMaterial3: false,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(38.0),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: CustomColors.dividerColor,
        thickness: 1,
        space: 0,
      ),
      dividerColor: CustomColors.dividerColor,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      indicatorColor: MyColors.mainColor,
      progressIndicatorTheme: ProgressIndicatorThemeData(color: MyColors.mainColor),
      primaryColor: MyColors.mainColor,
      // textTheme: TextTheme(
      //   headlineLarge:
      //       const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      //   headlineMedium:
      //       const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      //   headlineSmall:
      //       const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      //   bodySmall: TextStyle(
      //       fontSize: 12,
      //       fontWeight: FontWeight.w500,
      //       color: Colors.grey.shade500),
      // ),
      cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          shadowColor: Colors.black26,
          surfaceTintColor: Colors.white),
      // RefreshIndicator
    );
  }
}
