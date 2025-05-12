import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:dayoneasia/screen/booking/booking_class/class_list/booking_class_list_screen.dart';
import 'package:dayoneasia/screen/booking/booking_practice/practice_list/booking_practice_list_screen.dart';
import 'package:dayoneasia/screen/dashboard/home/contracts/contracts_screen.dart';
import 'package:dayoneasia/screen/dashboard/home/cubit/home/home_state.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/data/network/model/input/blog_input.dart';
import 'package:myutils/data/network/model/output/api_key_output.dart';
import 'package:myutils/data/network/model/output/contracts/booking_class_type_v5_output.dart';
import 'package:myutils/data/network/model/output/list_products_output.dart';
import 'package:myutils/data/network/model/output/news_output.dart';
import 'package:myutils/data/network/model/output/remind_booking_output.dart';
import 'package:myutils/data/network/model/output/user_output.dart';
import 'package:myutils/data/repositories/booking_repository.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeCubit extends WidgetCubit<HomeState> {
  HomeCubit()
      : super(
          widgetState: const HomeState(),
        ) {
    // loadInitialData();
  }
  final BookingRepository _bookingRepository = injector();

  @override
  void onWidgetCreated() {}

  goMessenger() async {
    final url = localeManager
            .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
            ?.linkMessenger ??
        '';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Không thể mở Messenger';
    }
  }

  Future<void> loadInitialData({bool? isRefresh}) async {
    remindBooking();
    newsCategories();
    menusInHome();
    contracts();
  }

  void handleFeatureAccess({
    required String router,
    required String? key,
    required bool isBooking,
    required DataUserInfo? userData,
    required Function(String title, String description) showPopup,
    required Function(String route, String? extra) navigateTo,
  }) {
    final isClassRoute = router == BookingClassListScreen.route;
    final isPracticeRoute = router == BookingPracticeListScreen.route;

    bool isFeatureBlocked = (isClassRoute && userData?.isBookClass == false) ||
        (isPracticeRoute && userData?.isBookPractice == false);

    String description = isClassRoute
        ? (userData?.textIsBookClassLimitMonth ?? '')
        : (isPracticeRoute
            ? (userData?.textIsBookPracticeLimitMonth ?? '')
            : '');

    if (isFeatureBlocked) {
      showPopup('Tính năng đã bị tạm khóa', description);
    } else if (isBooking) {
      navigateTo(router, key);
    } else {
      navigateTo(router, key);
    }
  }

  Future<void> remindBooking() async {
    try {
      var remindBooking = await fetchApi(
          () => _bookingRepository.remindBooking(),
          showLoading: false);
      if (remindBooking?.statusCode == ApiStatusCode.success) {
        if (language == 'en') {
          if (remindBooking?.data?.isNotEmpty == true) {
            remindBooking?.data = await _processBookingData(remindBooking.data);
          } else {
            remindBooking?.message =
                await ToolHelper.translateText(remindBooking.message ?? '');
          }
        }
      }
      emit(state.copyWith(remindBookingOutput: remindBooking));
    } catch (e) {
      print('');
    }
  }

  Future<List<DataRemindBooking>> _processBookingData(
      List<DataRemindBooking>? bookings) async {
    if (bookings == null) return [];
    final processedData = await Future.wait(
      bookings.map((booking) async {
        return booking.copyWith(
          classType: await ToolHelper.translateText(booking.classType ?? ''),
          classLessonStartDate: await ToolHelper.translateText(
              booking.classLessonStartDate ?? ''),
        );
      }),
    );

    return processedData;
  }

  Future<void> refreshData() async {
    await loadInitialData();
  }

  Future<void> newsCategories() async {
    try {
      final newsCategoriesResult = await fetchApi(
          () => _bookingRepository.blogCategories(),
          showLoading: false);
      if (newsCategoriesResult?.statusCode == ApiStatusCode.success &&
          newsCategoriesResult?.data?.isNotEmpty == true) {
        newsCategoriesResult?.data
            ?.removeWhere((element) => element.slug == null);
        final newResult = await blogs(
            slug: newsCategoriesResult?.data?.first.slug ?? '',
            showLoading: false);
        emit(
          state.copyWith(
              newsCategoriesOutput: newsCategoriesResult,
              newsOutput: newResult,
              currentTabIndex: 0),
        );
      }
    } catch (e) {
      print('error: $e');
    }
  }

  Future<BlogOutput?> blogs({required String slug, bool? showLoading}) async {
    try {
      final newsResult = await fetchApi(
          () => _bookingRepository
              .blog(BlogInput(page: 1, limit: 10, slug: slug)),
          showLoading: showLoading ?? true,
          millisecondsDelay: 1000);
      return newsResult?.statusCode == ApiStatusCode.success &&
              newsResult?.data?.isNotEmpty == true
          ? newsResult
          : BlogOutput(data: []);
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> filterBlogs(int indexTab) async {
    final list = state.newsCategoriesOutput?.data ?? [];
    if (list.isEmpty) return;
    final newResult = await blogs(slug: list[indexTab].slug ?? '');
    emit(
      state.copyWith(
        newsOutput: newResult,
        currentTabIndex: indexTab,
      ),
    );
  }

  Future<void> menusInHome() async {
    try {
      final result = await fetchApi(
        () => _bookingRepository.menusInHome(),
        showLoading: false,
      );
      if (result?.statusCode == ApiStatusCode.success &&
          result?.data?.arrayMenu?.isNotEmpty == true) {
        emit(state.copyWith(menusInHome: result));
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> contracts() async {
    try {
      final results = await Future.wait([
        fetchApi(
          () =>
              _bookingRepository.bookingClassTypesV5({"key": "CLASS_PRACTICE"}),
          showLoading: false,
        ),
        fetchApi(
          () => _bookingRepository.bookingClassTypesV5({"key": "CLASS"}),
          showLoading: false,
        ),
        fetchApi(
          () => _bookingRepository.contracts11(),
          showLoading: false,
        ),
      ]);

      final practiceResult = results[0];
      final classResult = results[1];
      final oneOneResult = results[2];

      emit(state.copyWith(
          practiceContract: practiceResult,
          classContract: classResult,
          oneOneContract: oneOneResult));
    } catch (e) {
      print('Error: $e');
    }
  }
}
