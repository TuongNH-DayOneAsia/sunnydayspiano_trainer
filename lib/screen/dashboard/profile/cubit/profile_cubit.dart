import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:dayoneasia/screen/main/cubit/main_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/data/network/model/output/api_key_output.dart';
import 'package:myutils/data/repositories/authen_repository.dart';
import 'package:myutils/data/repositories/profile_repository.dart';
import 'package:myutils/helpers/extension/string_extension.dart';

part 'profile_state.dart';

class ProfileCubit extends WidgetCubit<ProfileState> {
  final MainCubit mainCubit;

  ProfileCubit({required this.mainCubit})
      : super(widgetState: const ProfileState());

  final AuthenRepository authenRepository = injector();
  final ProfileRepository profileRepository = injector();
  final ImagePicker _picker = ImagePicker();

  String get companyEmail =>
      localeManager
          .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
          ?.companyEmail ??
      '';

  String get hotline =>
      localeManager
          .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
          ?.companyHotline ??
      '';

  @override
  void onWidgetCreated() {
    // TODO: implement onWidgetCreated
  }

  Future<void> callApiLogout(
      {Function()? onSuccess,
      required Function(String message) onError}) async {
    var data = {"virtual": ""};
    try {
      final request = await fetchApi(() => authenRepository.logout(data));
      if (request?.statusCode == ApiStatusCode.success) {
        localeManager.clearDataLocalLogout();
        EventBus.shared.setLoggedIn(false);
        // await HydratedBloc.storage.clear();
        onSuccess?.call();
      } else {
        onError.call(request?.message ?? '');
      }
    } catch (e) {
      onError.call(isDebug ? e.toString() : MyString.messageError);

      print('error: $e');
    }
  }

  Future<void> deleteAccount(
      {required Function() onSuccess,
      required Function(String message) onError}) async {
    try {
      final request = await fetchApi(() => authenRepository
          .appDeleteAccount(mainCubit.state.userOutput?.data?.slug ?? ''));
      if (request?.statusCode == ApiStatusCode.success) {
        localeManager.clearDataLocalLogout();
        EventBus.shared.setLoggedIn(false);

        onSuccess.call();
      } else {
        onError.call(request?.message ?? '');
      }
    } catch (e) {
      onError.call(isDebug ? e.toString() : MyString.messageError);
    }
  }
}
