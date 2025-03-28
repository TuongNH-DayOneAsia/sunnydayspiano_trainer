import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/model/output/user_output.dart';
import 'package:myutils/data/repositories/profile_repository.dart';

part 'update_information_state_state.dart';

// Cubit

class UpdateInformationStateCubit extends WidgetCubit<UpdateInformationStateState> {
  final ProfileRepository _profileRepository = ProfileRepository();

  final DataUserInfo? dataUserInfo;

  UpdateInformationStateCubit({this.dataUserInfo}) : super(widgetState: const UpdateInformationStateState()) {
    if (dataUserInfo != null) {
      print('dataUserInfo: $dataUserInfo');
      emit(
        state.copyWith(
          fullName: dataUserInfo!.name,
          gender: dataUserInfo?.gender ?? 'Nam',
          phoneNumber: dataUserInfo!.phone,
          email: dataUserInfo!.email,
          idNumber: dataUserInfo!.cccd,
          birthDate: dataUserInfo!.birthday != null ? DateFormat("dd/MM/yyyy").parse(dataUserInfo?.birthday ?? '') : null,
          dateOfIssue:
              dataUserInfo!.cccdDateIssue != null ? DateFormat("dd/MM/yyyy").parse(dataUserInfo?.cccdDateIssue ?? '') : null,
        ),
      );
    }
  }

  void updateField(String field, String value) {
    switch (field) {
      case 'name':
        emit(state.copyWith(fullName: value));
        break;
      case 'phone':
        emit(state.copyWith(phoneNumber: value));
        break;
      case 'email':
        emit(state.copyWith(email: value));
        break;
      case 'cccd':
        emit(state.copyWith(idNumber: value));
        break;
      case 'cccd_place_issue':
        emit(state.copyWith(placeOfIssue: value));
        break;
    }
  }

  void updateGender(String gender) {
    emit(state.copyWith(gender: gender));
  }

  void updateBirthDate(DateTime date) {
    emit(state.copyWith(birthDate: date));
  }

  void updateDateOfIssue(DateTime date) {
    emit(state.copyWith(dateOfIssue: date));
  }

  Future<void> submitForm({required Function() onSuccess, required Function(String error) onError}) async {
    try {
      var gender = state.gender == 'Nam' ? 0 : (state.gender == 'Nữ' ? 1 : 2);

      final data = {
        if (state.fullName?.isNotEmpty == true) 'name': state.fullName!,
        if (state.phoneNumber?.isNotEmpty == true) 'phone': state.phoneNumber!,
        if (state.email?.isNotEmpty == true) 'email': state.email!,
        if (state.idNumber?.isNotEmpty == true) 'cccd': state.idNumber!,
        if (state.placeOfIssue?.isNotEmpty == true) 'cccd_place_issue': state.placeOfIssue!,
        if (state.gender?.isNotEmpty == true) 'gender': gender,
        if (state.birthDate != null) 'birthday': DateFormat('dd/MM/yyyy').format(state.birthDate!),
        if (state.dateOfIssue != null) 'cccd_date_issue': DateFormat('dd/MM/yyyy').format(state.dateOfIssue!),
      };
      final request = await fetchApi(() => _profileRepository.updateUser(data), showLoading: true);

      if (request?.statusCode == ApiStatusCode.success) {
        onSuccess();
        emit(state.copyWith(isSubmitted: true, error: null, msgSuccess: request?.message ?? 'Cập nhật thông tin thành công'));
      } else {
        onError(request?.message ?? 'Có lỗi xảy ra');
        emit(state.copyWith(error: request?.message ?? 'Có lỗi xảy ra'));
      }
    } catch (e) {
      onError(e.toString());
      emit(state.copyWith(error: 'Lỗi kết nối: $e'));
    }
  }

  bool _validateForm() {
    return state.fullName != null &&
        state.fullName!.isNotEmpty &&
        state.phoneNumber != null &&
        RegExp(r'^0\d{9}$').hasMatch(state.phoneNumber!) &&
        state.email != null &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(state.email!) &&
        state.idNumber != null &&
        RegExp(r'^\d+$').hasMatch(state.idNumber!) &&
        state.placeOfIssue != null &&
        state.placeOfIssue!.isNotEmpty &&
        state.gender != null &&
        state.birthDate != null &&
        state.dateOfIssue != null;
  }

  @override
  void onWidgetCreated() {
    // TODO: implement onWidgetCreated
  }
//updateUserInformation
}
