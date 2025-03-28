import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/data/network/model/output/api_key_output.dart';

part 'welcome_state.dart';

class WelcomeCubit extends WidgetCubit<WelcomeState> {
  WelcomeCubit() : super(widgetState: WelcomeInitial());

  String get bannerApp => localeManager.loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)?.bannerApp ?? '';

  @override
  void onWidgetCreated() {

    // TODO: implement onWidgetCreated
  }
}
