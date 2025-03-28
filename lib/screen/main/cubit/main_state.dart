part of 'main_cubit.dart';

class MainState extends Equatable {
  final bool isLoading;
  final UserOutput? userOutput;

  const MainState({
    this.userOutput,
    this.isLoading = false,
  });

  //copyWith
  MainState copyWith({
    UserOutput? userOutput,
    bool? isLoading,
  }) {
    return MainState(
      userOutput: userOutput ?? this.userOutput,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [userOutput, isLoading];
}
