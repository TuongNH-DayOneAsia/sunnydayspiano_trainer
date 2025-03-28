import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/base_repository.dart';
import 'package:myutils/data/network/model/base_output.dart';


class NotificationRepository extends BaseRepository {
  NotificationRepository() : super('');


  Future<BaseOutput> updateFcmToken(Map<String, dynamic> data) async {
    return BaseOutput.fromJson(await request(method: RequestMethod.post, path: 'api/notifications/update-fcm-token', data: data));
  }

}
