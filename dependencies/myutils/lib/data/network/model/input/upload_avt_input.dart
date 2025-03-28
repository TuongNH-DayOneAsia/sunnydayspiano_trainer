import 'package:dio/dio.dart';


class UploadAvtInput  {
  UploadAvtInput({
    this.file,
  });
  UploadAvtInput.fromJson(dynamic json) {
    file = json['file'];
  }

  MultipartFile? file;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['file'] = file;
    return map;
  }
}