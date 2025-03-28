import 'package:dayoneasia/screen/booking/booking_select_piano/booking_select_piano_screen.dart';
import 'package:flutter/material.dart';

extension MyColors on Colors {
  static LinearGradient appGradient(BuildContext context) => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: const [0.1, 1],
        colors: [
          Theme.of(context).extension<MyAppGradientColor>()?.startColor ??
              mainColor,
          Theme.of(context).extension<MyAppGradientColor>()?.endColor ??
              mainColor
        ],
      );

  static Color appMainColor(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  static Color mainColor = const Color(0xFFFF8B00);
  // static Color backgroundColor = const Color(0xFFF4F4F4);
  static Color backgroundColor = const Color(0xFFF3F3F3);
  static Color grayColor = const Color(0xFF808080);
  static Color accentColor = const Color(0xFFFF911E);
  static Color darkGrayColor = const Color(0xFF3B3B3B);
  static Color lightGrayColor = const Color(0xFFB6B6B6);
  static Color lightGrayColor3 = const Color(0xffF0F0F0);

  static Color lightGrayColor2 = const Color(0xff6a6a6a);
  static Color emeraldGreenColor = const Color(0xFF3BA771);

  static Color redColor = const Color(0xFFFF4444);
  static Color redLogoutColor = const Color(0xFFFF4545);
  static Color subOrange = const Color(0xFFE69464);
  static Color greenColor = const Color(0xFF28A745);
  static Color grey = const Color(0xFFEAE9E8);
  static Color winterWhite = const Color(0xFFf9fafb);
  static Color steelGrey = const Color(0xFF6c727f);
  static Color cloudyGrey = const Color(0xFFe5e7ea);
  static Color inkBlack = const Color(0xFF121826);
  static Color blueGrey = const Color(0xFFE5E7EB);
  static Color slateGrey = const Color(0xFF9398A3);
  static Color crimsonRed = const Color(0xFFDB0D0D);
  static Color snowGrey = const Color(0xFFF3F4F6);
  static Color stormGray = const Color(0xFFB4BAC4);
  static Color whiteWash = const Color(0xFFF5F5F5);
  static Color pumpkinOrange = const Color(0xFFF47920);
  static Color amber = const Color(0xFFFBB21B);
  static Color emerald = const Color(0xFF1AA260);
  static Color blue = const Color(0xFF0158A9);


}

class MyAppGradientColor extends ThemeExtension<MyAppGradientColor> {
  const MyAppGradientColor({
    required this.startColor,
    required this.endColor,
  });

  final Color startColor;
  final Color endColor;

  @override
  MyAppGradientColor copyWith({
    Color? startColor,
    Color? endColor,
  }) {
    return MyAppGradientColor(
      startColor: startColor ?? this.startColor,
      endColor: endColor ?? this.endColor,
    );
  }

  @override
  MyAppGradientColor lerp(MyAppGradientColor? other, double t) {
    if (other is! MyAppGradientColor) {
      return this;
    }
    return MyAppGradientColor(
      startColor: Color.lerp(startColor, other.startColor, t)!,
      endColor: Color.lerp(endColor, other.endColor, t)!,
    );
  }

  // Optional
  @override
  String toString() =>
      'MyColorStatus(success: $startColor, pending: $endColor)';
}
