part of 'blog_detail_cubit.dart';

class BlocDetailState extends Equatable {
  final bool isLoading;

  final BlogDetailOutput? newDetailOutput;

  const BlocDetailState({this.newDetailOutput,this.isLoading = false});

  BlocDetailState copyWith({
    bool? isLoading,
    String? error,
    BlogDetailOutput? newDetailOutput,
  }) {
    return BlocDetailState(
      isLoading: isLoading ?? this.isLoading,
      newDetailOutput: newDetailOutput ?? this.newDetailOutput,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [isLoading, newDetailOutput];
}
