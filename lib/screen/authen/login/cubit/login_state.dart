import 'package:equatable/equatable.dart';
import 'package:myutils/data/network/model/output/api_key_output.dart';

class LoginState extends Equatable {
  final ApiKeyOutput? apiKeyOutput;

  const LoginState(this.apiKeyOutput);

  @override
  // TODO: implement props
  List<Object?> get props => [apiKeyOutput];
}
