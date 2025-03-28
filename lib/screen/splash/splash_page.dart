import 'package:dayoneasia/screen/authen/login/login_screen.dart';
import 'package:dayoneasia/screen/dashboard/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/config/app_config.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/data/cache_helper/cache_helper.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/utils/dimens.dart';

class SplashScreen extends StatefulWidget {
  static const String route = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  String urlImageLogo = MyString.iconApp();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 2)).then((value) {
      LocaleManager localeManager = injector();
      final accessToken = localeManager.getString(StorageKeys.accessToken);
      if (accessToken == null) {
        context.pushReplacement(LoginScreen.route);

        // context.pushReplacement(WelcomeScreen.route);
      } else {
        context.pushReplacement(HomeScreen.route);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(AssetImage(urlImageLogo), context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final env = injector<AppConfig>().flavor;

    if (env != Flavor.prod) {
      return ColoredBox(
        color: Colors.white,
        child: SizedBox(
            height: size.height,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image(
                    height: Dimens.getProportionalScreenHeight(context, 260),
                    image: AssetImage(urlImageLogo),
                  ),
                ),
                Text(
                  (env?.name ?? '').toUpperCase(),
                  style: TextStyle(color: Colors.black, fontSize: 20.sp),
                )
              ],
            )),
      );
    } else {
      return ColoredBox(
        color: Colors.white,
        child: SizedBox(
            height: size.height,
            width: size.width,
            child: Center(
              child: Image(
                height: Dimens.getProportionalScreenHeight(context, 260),
                image: AssetImage(urlImageLogo),
              ),
            )),
      );
    }
  }
}
