import 'package:get_it/get_it.dart';
import 'package:myutils/data/cache_helper/cache_helper.dart';
import 'package:myutils/data/repositories/authen_repository.dart';
import 'package:myutils/data/repositories/booking_repository.dart';
import 'package:myutils/data/repositories/notification_repository.dart';
import 'package:myutils/data/repositories/otp/otp_service.dart';
import 'package:myutils/data/repositories/profile_repository.dart';
import 'package:myutils/helpers/tools/remote_config_manager.dart';

import '../../data/network/network_manager.dart';
import 'app_config.dart';

final injector = GetIt.instance;

Future<void> initializeDependencies(Flavor appFlavor) async {
  //init local storage
  await LocaleManager.init();
  injector.registerSingleton<LocaleManager>(LocaleManager.instance);

  injector.registerSingleton<AppConfig>(await AppConfig.create(appFlavor));
  injector.registerSingleton<NetworkManager>(NetworkManager());
  injector.registerLazySingleton<AuthenRepository>(AuthenRepository.new);
  injector.registerLazySingleton<ProfileRepository>(ProfileRepository.new);
  injector.registerLazySingleton<BookingRepository>(BookingRepository.new);
  injector.registerLazySingleton<NotificationRepository>(NotificationRepository.new);
  injector.registerLazySingleton<OtpService>(OtpService.new);
  injector.registerSingleton<RemoteConfigManager>(RemoteConfigManager.init());
}
