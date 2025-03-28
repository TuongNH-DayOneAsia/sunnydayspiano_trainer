import 'package:equatable/equatable.dart';
import 'package:myutils/data/network/model/base_output.dart';

class OtpState extends Equatable {
  final BaseOutput? baseOutput;

  const OtpState(this.baseOutput);

  @override
  // TODO: implement props
  List<Object?> get props => [baseOutput];
}
