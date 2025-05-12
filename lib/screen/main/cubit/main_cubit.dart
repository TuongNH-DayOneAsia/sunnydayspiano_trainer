import 'dart:ui';

import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/model/output/user_output.dart';
import 'package:myutils/data/repositories/profile_repository.dart';

part 'main_state.dart';

class MainCubit extends WidgetCubit<MainState> {
  MainCubit() : super(widgetState: const MainState());

  final ProfileRepository profileRepository = injector();

  Future<void> callApiGetProfileInformation({bool? showLoading, VoidCallback? goToUpdatePassWord}) async {
    emit(state.copyWith(isLoading: true));
    try {
      print('callApiGetProfileInformation');
      // final request = await fetchApi(() => profileRepository.getProfileInformation(slug), showLoading: showLoading ?? true);
      final request = await fetchApi(() => profileRepository.getProfileInformation(slug), showLoading: false);
      if (request?.statusCode == ApiStatusCode.success && request?.data?.slug?.isNotEmpty == true) {
        // setUserInCrashlytics(
        //   userId: request.data?.slug.toString() ?? '',
        //   userName: request.data?.name ?? '',
        //   userEmail: request.data?.email ?? '',
        //   phone: request.data?.phone ?? '',
        // );
        // goToUpdatePassWord?.call();

        if (request?.data?.newAccount == true) {
          goToUpdatePassWord?.call();
        }

        emit(state.copyWith(userOutput: request, isLoading: false));
      }
    } catch (e) {
      print('error: $e');
    }
  }



  void updateAvt(String imagePath) async {
    final updatedUserOutput = state.userOutput?.copyWith(data: state.userOutput?.data?.copyWith(avatar: imagePath));
    emit(state.copyWith(userOutput: updatedUserOutput));
  }

  @override
  void onWidgetCreated() {
    if (slug.isEmpty || accessToken.isEmpty || apiKeyPrivate.isEmpty) {
      clearCacheGoToLogin();
    } else {
      EventBus.shared.setLoggedIn(true);
    }
  }
}
