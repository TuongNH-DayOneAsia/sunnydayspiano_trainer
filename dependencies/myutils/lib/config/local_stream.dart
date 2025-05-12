import 'package:rxdart/rxdart.dart';

typedef MyVoidCallback<T> = void Function();
typedef MyVoidCallbackWithSlug = void Function(String slug);

enum RefreshAction {
  refreshClassList,
  refreshHistory,
  refreshDataInHome,
  refreshPracticeList,
  refreshBooking11List
}

class EventBus {
  EventBus._() {}

  static final shared = EventBus._();
  final isLoggedInStream = BehaviorSubject<bool>.seeded(false);
  final localeStream = BehaviorSubject<String>.seeded('vi');

  late MyVoidCallback goToScreenHistory;
  late MyVoidCallback refreshHistory;
  late MyVoidCallback refreshClassList;
  late MyVoidCallback refreshDataInHome;
  late MyVoidCallback refreshBannerInHome;
  late MyVoidCallback refreshPracticeList;
  late MyVoidCallback refreshBooking11List;
  late MyVoidCallback refreshApiProfile;
  late MyVoidCallback forceUpdate;
  late MyVoidCallbackWithSlug handleSlugCallback;

  setLoggedIn(bool isLoggedIn) {
    isLoggedInStream.add(isLoggedIn);
  }

  setLocale(String locale) {
    localeStream.add(locale);
  }

  void handleAction(RefreshAction action) {
    switch (action) {
      case RefreshAction.refreshClassList:
        refreshClassList();
        refreshDataInHome();
        goToScreenHistory();
        refreshHistory();
        refreshApiProfile();
        break;
      case RefreshAction.refreshHistory:
        refreshHistory();
        refreshApiProfile();
        break;
      case RefreshAction.refreshDataInHome:
        refreshDataInHome();
        refreshHistory();
        refreshApiProfile();
        break;
      case RefreshAction.refreshPracticeList:
        refreshPracticeList();
        refreshDataInHome();
        refreshHistory();
        refreshApiProfile();
        goToScreenHistory();
        break;

      case RefreshAction.refreshBooking11List:
        refreshBooking11List();
        refreshDataInHome();
        refreshHistory();
        refreshApiProfile();
        goToScreenHistory();
        break;
    }
  }
}
