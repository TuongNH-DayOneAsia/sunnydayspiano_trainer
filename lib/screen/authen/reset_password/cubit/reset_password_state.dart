import 'package:equatable/equatable.dart';
import 'package:myutils/data/network/model/base_output.dart';

class ResetPasswordState extends Equatable {
  final BaseOutput? baseOutput;

  const ResetPasswordState(this.baseOutput);

  @override
  // TODO: implement props
  List<Object?> get props => [baseOutput];
}
