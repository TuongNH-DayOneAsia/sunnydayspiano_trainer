import 'dart:io';
import 'dart:ui';

import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/model/output/user_output.dart';
import 'package:myutils/data/repositories/authen_repository.dart';
import 'package:myutils/data/repositories/profile_repository.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:permission_handler/permission_handler.dart';

part 'info_contract_state.dart';

class InfoContractCubit extends WidgetCubit<InfoContractState> {
  InfoContractCubit() : super(widgetState: const InfoContractState());

  final ImagePicker _picker = ImagePicker();
  final AuthenRepository authenRepository = injector();
  final ProfileRepository profileRepository = injector();
  var reloadAvatar = false;
  bool isFirstDenied = true;

  void choseImage({required Function() onSuccess, required VoidCallback isDenied}) async {
    try {
      final XFile? xFile = await _picker.pickImage(source: ImageSource.gallery);
      final xFileLength = await xFile?.length();
      print('xFileLength : $xFileLength');

      if (xFile != null) {
        final File file = File(xFile.path);
        final File fileResize = await ToolHelper.resizeImageFromFile(file);
        final length = await fileResize.length();
        print('fileResize : $length');

        final request = await fetchApi(() => profileRepository.uploadAvt(fileResize.path));
        if (request?.statusCode == ApiStatusCode.success) {
          reloadAvatar = true;
          onSuccess();
          callApiGetProfileInformation();
          // update state main cubit
          // mainCubit.updateAvt(request.data?.path ?? '');
        }
      }
    } catch (e) {
      var status = await Permission.photos.status;

      if ((status.isDenied || status.isPermanentlyDenied)) {
        // if (!isFirstDenied) {
        isDenied();
        // }
        // isFirstDenied = false;
      }
    }
  }

  Future<void> callApiGetProfileInformation() async {
    emit(state.copyWith(isLoading: true));
    try {
      print('callApiGetProfileInformation');
      final request = await fetchApi(
        () => profileRepository.getProfileInformation(slug),showLoading: false, millisecondsDelay: 1000
      );
      if (request?.statusCode == ApiStatusCode.success) {
        emit(state.copyWith(userOutput: request, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      print('error: $e');
    }
  }

  @override
  void onWidgetCreated() {
    // TODO: implement onWidgetCreated
  }
}
