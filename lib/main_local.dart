import 'package:dayoneasia/config/firebase_config.dart';
import 'package:dayoneasia/router/my_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:myutils/config/app_config.dart';
import 'package:myutils/config/day_one_application.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/utils/app_bloc_observer/app_bloc_observer.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  await _initializeApp();
  runApp(DayOneApplication(appRouter: myRouter));
}

Future<void> _initializeApp() async {
  var logger = Logger();
  logger.d('main');

  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getTemporaryDirectory(),
  );
  try {
    await initFirebase();
  } catch (e) {
    logger.e('Firebase initialization failed: $e');
  }
  await Future.wait([
    initializeDependencies(Flavor.local),
  ]);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  configureEasyLoading();
  Bloc.observer = AppBlocObserver();
}
