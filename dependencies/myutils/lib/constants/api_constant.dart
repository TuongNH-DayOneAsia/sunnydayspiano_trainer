class RequestMethod {
  static const get = 'GET';
  static const post = 'POST';
  static const put = 'PUT';
  static const delete = 'DELETE';
  static const update = 'UPDATE';
  static const download = 'DOWNLOAD';
}
class ApiStatusCode {
  static const int success = 200;
  static const int refreshToken = 403;
  static const int tokenExpired = 405;
  static const int blockBooking = 429;
  static const int requiredFieldMissing = 422;
  static const int requiredForeUpdate = 426;
}
class ApiConstant {
  static const token = 'token';
  static const refreshToken = 'refreshToken';
  static const authorization = 'Authorization';
  static const keyPrivate = 'keyPrivate';
  static const contentType = 'Content-Type';
  static const statusCode = 'status_code';
  static const message = 'message';
  static const data = 'data';
  static const extoken = 'extoken';
  static const isAuthed = 'isAuthed';
  static const grantType = 'grantType';
  static const userToken = 'userToken';
  static const accessToken = 'accessToken';
}




