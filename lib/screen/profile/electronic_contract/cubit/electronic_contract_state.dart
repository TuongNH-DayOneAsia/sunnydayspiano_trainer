part of 'electronic_contract_cubit.dart';

class ElectronicContractState   {
  final bool isLoading;
  final ContractOutput? contractOutput;

  ElectronicContractState({
    this.contractOutput,
    this.isLoading = false,
  });

  //copyWith method
  ElectronicContractState copyWith({
    ContractOutput? contractOutput,
    bool? isLoading,
  }) {
    return ElectronicContractState(
      contractOutput: contractOutput ?? this.contractOutput,
      isLoading: isLoading ?? this.isLoading,
    );
  }
  // @override
  // // TODO: implement props
  // List<Object?> get props => [userOutput, isLoading];
}
