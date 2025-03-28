part of 'update_information_state_cubit.dart';

class UpdateInformationStateState extends Equatable {
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final String? idNumber;
  final String? placeOfIssue;
  final String? gender;
  final DateTime? birthDate;
  final DateTime? dateOfIssue;
  final bool isSubmitted;
  final String? error;
  final String? msgSuccess;

  const UpdateInformationStateState({
    this.fullName,
    this.phoneNumber,
    this.email,
    this.idNumber,
    this.placeOfIssue,
    this.gender,
    this.birthDate,
    this.dateOfIssue,
    this.isSubmitted = false,
    this.msgSuccess,
    this.error,
  });

  UpdateInformationStateState copyWith(
      {String? fullName,
      String? phoneNumber,
      String? email,
      String? idNumber,
      String? placeOfIssue,
      String? gender,
      DateTime? birthDate,
      DateTime? dateOfIssue,
      String? error,
        String? msgSuccess,
      bool? isSubmitted}) {
    return UpdateInformationStateState(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      idNumber: idNumber ?? this.idNumber,
      placeOfIssue: placeOfIssue ?? this.placeOfIssue,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      dateOfIssue: dateOfIssue ?? this.dateOfIssue,
      error: error ?? this.error,
      msgSuccess: msgSuccess ?? this.msgSuccess,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  @override
  List<Object?> get props =>
      [fullName, phoneNumber, email, idNumber, placeOfIssue, gender, birthDate, dateOfIssue, isSubmitted, error, msgSuccess];
}
