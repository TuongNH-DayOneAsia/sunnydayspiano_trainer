import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myutils/base/bloc/local_state.dart';

import '../../constants/locale_keys_enum.dart';


class LocalCubit extends WidgetCubit<LocalState> {
  LocalCubit() : super(widgetState:  LocalInitState());



  void initSetting() async {

    localeManager.setStringValue(StorageKeys.cachedLang, language);

    // await CacheHelper.shared.cacheLanguage(lang);
  }

  @override
  Future<void> close() {
    return super.close();
  }

  @override
  void onWidgetCreated() {
    // TODO: implement onWidgetCreated
  }
}
