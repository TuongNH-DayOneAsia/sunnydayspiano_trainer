import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

class MultipartFileExtended extends MultipartFile {
  final String? filePath; //this one!

  MultipartFileExtended(
    super.stream,
    super.length, {
    super.filename,
    this.filePath,
    super.contentType,
  });

  static MultipartFileExtended fromFileSync(
    String filePath, {
    String? filename,
    MediaType? contentType,
  }) =>
      multipartFileFromPathSync(filePath,
          filename: filename?.replaceAll(RegExp('[.](?=.*[.])'), ''), contentType: contentType);
}

MultipartFileExtended multipartFileFromPathSync(
  String filePath, {
  String? filename,
  MediaType? contentType,
}) {
  filename ??= p.basename(filePath);
  final file = File(filePath);
  final length = file.lengthSync();
  final stream = file.openRead();
  return MultipartFileExtended(
    stream,
    length,
    filename: filename,
    contentType: contentType,
    filePath: filePath,
  );
}
