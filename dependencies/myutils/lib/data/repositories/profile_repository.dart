import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/base_repository.dart';
import 'package:myutils/data/network/model/base_output.dart';
import 'package:myutils/data/network/model/output/contract_output.dart';
import 'package:myutils/data/network/model/output/user_output.dart';
import 'package:myutils/data/network/model/output/upload_avt_output.dart';

class ProfileRepository extends BaseRepository {
  ProfileRepository() : super('');

  Future<UserOutput> getProfileInformation(String slug) async {
    return UserOutput.fromJson(await request(method: RequestMethod.get, path: 'api/students/$slug'));
  }

  Future<UploadAvtOutput> uploadAvt(String filePath) async {
    String fileExtension = filePath.split('.').last;
    MediaType mediaType;
    if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
      mediaType = MediaType('image', 'jpeg');
    } else if (fileExtension == 'png') {
      mediaType = MediaType('image', 'png');
    } else if (fileExtension == 'heic') {
      mediaType = MediaType('image', 'heic');
    } else {
      throw UnsupportedError('Unsupported file extension');
    }
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: 'avt.$fileExtension', contentType: mediaType),
    });
    return UploadAvtOutput.fromJson(
        await requestFormData(method: RequestMethod.post, path: 'api/uploads/avatar', data: formData));
  }

  Future<ContractOutput> contract() async {
    return ContractOutput.fromJson(await request(method: RequestMethod.get, path: 'api/contracts'));
  }

  Future<BaseOutput> updateUser(Map<String, dynamic> data) async {
    return BaseOutput.fromJson(await request(method: RequestMethod.post, path: 'api/students/request-changes', data: data));
  }
}
