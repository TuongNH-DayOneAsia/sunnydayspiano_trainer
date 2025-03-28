part of 'info_contract_cubit.dart';

class InfoContractState extends Equatable {
  final UserOutput? userOutput;
  final bool isLoading;

  const InfoContractState({this.userOutput, this.isLoading = false});

  //copyWith
  InfoContractState copyWith({
    UserOutput? userOutput,
    bool? isLoading,
  }) {
    return InfoContractState(
      userOutput: userOutput ?? this.userOutput,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [userOutput, isLoading];
}
