import 'dart:convert';

import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/data/network/model/output/api_key_output.dart';
import 'package:myutils/data/network/model/output/booking_11/contracts_output.dart';
import 'package:myutils/data/network/model/output/firebase_config_model.dart';
import 'package:myutils/data/repositories/booking_repository.dart';

part 'contracts_state.dart';

class ContractsCubit extends WidgetCubit<ContractsState> {
  ContractsCubit() : super(widgetState: const ContractsState());
  final BookingRepository _bookingRepository = injector();

  bool hideTotalLearned() {
    final data = localeManager.loadSavedObject(
        StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson);
    final firebaseConfig =
        FirebaseConfigData.fromJson(json.decode(data?.isDeploy ?? '{}'));
    return firebaseConfig.hideTotalLearned ?? false;
  }

  @override
  void onWidgetCreated() {}
}
