class BaseOutput {
  int? statusCode;
  String? message;
  String? status;
  List<String>? errors;
  Exception? exception;

  BaseOutput({
    this.statusCode,
    this.message,
    this.status,
    this.errors
  });

  factory BaseOutput.fromJson(Map<String, dynamic>? json) {
    return BaseOutput(
      statusCode: json?['statusCode'] as int?,
      message: json?['message'] as String?,
      status: json?['status'] as String?,
      errors: json?['errors'] as List<String>?,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'status': status,
      'errors': errors,
    };
  }

  BaseOutput._withError({this.exception});

  factory BaseOutput.withError(Exception exception) {
    return BaseOutput._withError(exception: exception);
  }

  bool? get isSuccess => statusCode == 1;
  bool? get isFailed => statusCode != 1;
  bool? get isTokenExpired => statusCode == 3;
  bool? get isError => exception != null;
}
