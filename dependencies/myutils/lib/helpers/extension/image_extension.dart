import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:lottie/lottie.dart';

const String myResource = 'my_resource';
const String commonResource = 'common_resource';

extension MyImage on Image {
  static Image imgFromSupplier(
      {required String assetName, double? width, double? height, BoxFit? fit}) {
    return Image.asset(
      MyString.pathForAsset(myResource, assetName),
      width: width,
      height: height,
      fit: fit,
    );
  }

  static Widget svgFromAsset(
      {required String assetPath,
      double? width,
      double? height,
      BoxFit fit = BoxFit.contain,
      Color? color}) {
    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget svgFromSupplier(
      {required String assetName,
      double? width,
      double? height,
      BoxFit fit = BoxFit.contain,
      Color? color}) {
    return SvgPicture.asset(
      MyString.pathForAsset(myResource, assetName),
      width: width,
      height: height,
      fit: fit,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Image imgFromCommon(
      {required String assetName, double? width, double? height, BoxFit? fit, Color? color}) {
    return Image.asset(
      color: color,
      MyString.pathForAsset(commonResource, assetName),
      width: width,
      height: height,
      fit: fit,
    );
  }

  static Widget svgFromCommon(
      {required String assetName,
      double? width,
      double? height,
      BoxFit fit = BoxFit.contain,
      Color? color}) {
    return SvgPicture.asset(
      MyString.pathForAsset(commonResource, assetName),
      width: width,
      height: height,
      fit: fit,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Image giftFromSupplier({required String assetName, BoxFit? boxFit}) {
    return Image.asset(
      MyString.pathForAsset(myResource, assetName),
      gaplessPlayback: true,
      fit: boxFit,
    );
  }

  static Image giftFromCommon({required String assetName, BoxFit? boxFit}) {
    return Image.asset(
      MyString.pathForAsset(commonResource, assetName),
      gaplessPlayback: true,
      fit: boxFit,
    );
  }

  static Image imgFromUrl(String url, {BoxFit boxFit = BoxFit.fitWidth}) {
    var img = Image.network(
      url,
      fit: boxFit,
    );
    return img;
  }

  static Widget svgFromUrl(String url, {BoxFit boxFit = BoxFit.fitWidth}) {
    var img = SvgPicture.network(
      url,
      fit: boxFit,
    );
    return img;
  }

  static Widget cachedImgFromUrl(
      {required String url,
      double? width,
      double? height,
      BoxFit fit = BoxFit.cover,
       bool hasPlaceholder = true,
        Widget errorWidget = const Icon(Icons.error),
      Alignment alignment = Alignment.center}) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      useOldImageOnUrlChange: true,
      fit: fit,
      alignment: alignment,
      placeholder: hasPlaceholder ?  (context, url) => const CircularProgressIndicator() : null,
      errorWidget: (context, url, error) => errorWidget,
    );
  }

  static Widget cachedImgUrlWithPlaceholder({
    required String url,
    Widget? placeholder,
    Widget? errorWidget,
    BoxFit? fit,
  }) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (context, url) =>
          placeholder ??
          Container(
            width: 270,
            height: 90,
            color: Colors.white,
          ),
      errorWidget: (context, url, error) =>
          errorWidget ?? const Icon(Icons.error),
    );
  }

  // static Image imgFromAsset({required String pathResource, double? width, double? height, BoxFit? fit, Color? color}) {
  //   return Image.asset(
  //     pathResource,
  //     width: width,
  //     height: height,
  //     color: color,
  //     fit: fit,
  //   );
  // }

  // static Widget svgFromAsset(
  //     {required String pathResource, double? width, double? height, BoxFit fit = BoxFit.contain, Color? color}) {
  //   return SvgPicture.asset(
  //     pathResource,
  //     width: width,
  //     height: height,
  //     fit: fit,
  //     colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
  //   );
  // }

  //MARK: Using for Lottie Json from Adobe Effect or network
  static Widget assetAnimated(
      {required String assetName,
      double? width,
      double? height,
      BoxFit? fit,
      AnimationController? controller,
      bool? repeat,
      bool? reverse}) {
    return Lottie.asset(MyString.pathForAsset(myResource, assetName),
        controller: controller,
        repeat: repeat,
        reverse: reverse,
        width: width,
        height: height,
        fit: fit);
  }

  static Widget networkAnimated(
      {required String assetName,
      double? width,
      double? height,
      BoxFit? fit,
      AnimationController? controller,
      bool? repeat,
      bool? reverse}) {
    return Lottie.network(MyString.pathForAsset(myResource, assetName),
        controller: controller,
        repeat: repeat,
        reverse: reverse,
        fit: fit,
        width: width,
        height: height);
  }
}
