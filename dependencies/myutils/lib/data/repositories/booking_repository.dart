import 'package:dayoneasia/screen/notification/cubit/notifications_cubit.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/base_repository.dart';
import 'package:myutils/data/network/model/base_output.dart';
import 'package:myutils/data/network/model/input/list_booking_input.dart';
import 'package:myutils/data/network/model/input/list_history_input.dart';
import 'package:myutils/data/network/model/input/blog_input.dart';
import 'package:myutils/data/network/model/input/notifications_input.dart';
import 'package:myutils/data/network/model/output/banner_class_type_output.dart';
import 'package:myutils/data/network/model/output/booking_class_types_output.dart';
import 'package:myutils/data/network/model/output/class_detail_output.dart';
import 'package:myutils/data/network/model/output/booking_output.dart';
import 'package:myutils/data/network/model/output/contracts/booking_class_type_v5_output.dart';
import 'package:myutils/data/network/model/output/count_cancel_booking_output.dart';
import 'package:myutils/data/network/model/output/durations_output.dart';
import 'package:myutils/data/network/model/output/history_booking_output.dart';
import 'package:myutils/data/network/model/output/list_class_output.dart';
import 'package:myutils/data/network/model/output/branches_output.dart';
import 'package:myutils/data/network/model/output/currrent_week_output.dart';
import 'package:myutils/data/network/model/output/list_piano_output.dart';
import 'package:myutils/data/network/model/output/new_detail_output.dart';
import 'package:myutils/data/network/model/output/news_categories_output.dart';
import 'package:myutils/data/network/model/output/news_output.dart';
import 'package:myutils/data/network/model/output/notifications_output.dart';
import 'package:myutils/data/network/model/output/remind_booking_output.dart';
import 'package:myutils/data/network/model/output/statistics_output.dart';
import 'package:myutils/data/network/model/output/statistics_years_output.dart';
import 'package:myutils/data/network/model/output/status_history_output.dart';

import '../network/model/input/booking_11_input.dart';
import '../network/model/input/coaches_input.dart';
import '../network/model/input/list_time_booking_11_input.dart';
import '../network/model/output/booking_11/booking_11_detail_output.dart';
import '../network/model/output/booking_11/booking_11_output.dart';
import '../network/model/output/booking_11/coaches_output.dart';
import '../network/model/output/booking_11/contracts_output.dart';
import '../network/model/output/booking_11/list_time_11_output.dart';
import '../network/model/output/booking_class_types_v2_output.dart';
import '../network/model/output/menus_in_home_output.dart';
import '../network/model/output/booking_detail_practice_output.dart';
import '../network/model/output/list_products_output.dart';

class BookingRepository extends BaseRepository {
  BookingRepository() : super('');

  Future<BranchesOutput> branches() async {
    return BranchesOutput.fromJson(await request(
        method: RequestMethod.get, path: 'api/students/branches'));
  }

  Future<BranchesOutput> branchesV2(Map<String, dynamic> data) async {
    return BranchesOutput.fromJson(await request(
        method: RequestMethod.get,
        path: 'api/students/v2/branches',
        queryParameters: data));
  }

  Future<CurrentWeekOutput> currentWeek(Map<String, dynamic>? data) async {
    return CurrentWeekOutput.fromJson(await request(
        method: RequestMethod.get,
        path: 'api/schedules/current-week',
        queryParameters: data));
  }

  Future<ListClassOutput> listBookingClass(Map<String, dynamic> data) async {
    return ListClassOutput.fromJson(await request(
        method: RequestMethod.get,
        path: 'api/students/calendars',
        queryParameters: data));
  }

  Future<ClassDetailOutput> classDetail(String id) async {
    return ClassDetailOutput.fromJson(
        await request(method: RequestMethod.get, path: 'api/calendars/$id'));
  }

  Future<BaseOutput> classLessonRequestChange(Map<String, String> data) async {
    return BaseOutput.fromJson(await request(
        method: RequestMethod.post,
        path: 'api/students/class-lesson-request-changes',
        data: data));
  }

  Future<ClassDetailOutput> bookingDetail(String id) async {
    return ClassDetailOutput.fromJson(
        await request(method: RequestMethod.get, path: 'api/bookings/$id'));
  }

  //BookingOutput
  Future<BookingOutput> bookingClass(Map<String, String> data) async {
    return BookingOutput.fromJson(await request(
        method: RequestMethod.post, path: 'api/bookings', data: data));
  }

  Future<BookingOutput> bookingPractice(Map<String, dynamic> data) async {
    return BookingOutput.fromJson(await request(
        method: RequestMethod.post,
        path: 'api/booking-practice/booking',
        data: data));
  }

  Future<BookingDetailPracticeOutput> bookingDetailPractice(
      String bookingCode) async {
    return BookingDetailPracticeOutput.fromJson(await request(
        method: RequestMethod.get, path: 'api/booking-practice/$bookingCode'));
  }

  Future<HistoryBookingOutput> histories(ListHistoryInput data) async {
    return HistoryBookingOutput.fromJson(await request(
        method: RequestMethod.get,
        path: 'api/bookings/histories',
        queryParameters: ((data.statusBooking ?? 0) == -1)
            ? data.toJsonAll()
            : data.toJson()));
  }

  Future<BaseOutput> cancelBooking(Map<String, String> data) async {
    return BaseOutput.fromJson(await request(
        method: RequestMethod.post, path: 'api/bookings/cancel', data: data));
  }

  Future<BaseOutput> cancelBooking11(Map<String, String> data) async {
    return BaseOutput.fromJson(await request(
        method: RequestMethod.post,
        path: 'api/booking-one-one/cancel',
        data: data));
  }

  Future<StatusHistoryOutput> statusHistory() async {
    return StatusHistoryOutput.fromJson(await request(
      method: RequestMethod.get,
      path: 'api/bookings/status-history',
    ));
  }

  Future<RemindBookingOutput> remindBooking() async {
    return RemindBookingOutput.fromJson(await request(
      method: RequestMethod.get,
      path: 'api/bookings/remind-booking',
    ));
  }

  Future<ListPianoOutput> listPiano(ListBookingInput data) async {
    return ListPianoOutput.fromJson(await request(
      method: RequestMethod.get,
      path: 'api/booking-practice',
      queryParameters: data.toJsonPiano(),
    ));
  }

  //students/booking-cancel/count
  Future<CountCancelBookingOutput> cancelBookingPractice(
      Map<String, String> data) async {
    return CountCancelBookingOutput.fromJson(await request(
        method: RequestMethod.get,
        path: 'api/students/booking-cancel/count',
        queryParameters: data));
  }

  //StatisticsOutput
  Future<StatisticsOutput> statistics(
      Map<String, String> data, bool isBooking11) async {
    return StatisticsOutput.fromJson(await request(
        method: RequestMethod.get,
        path: 'api/statistics',
        queryParameters: data));
  }

  //StatisticsYearsOutput
  Future<StatisticsYearsOutput> statisticsYears() async {
    return StatisticsYearsOutput.fromJson(
        await request(method: RequestMethod.get, path: 'api/statistics/years'));
  }

//DurationsOutput
  Future<DurationsOutput> durations() async {
    return DurationsOutput.fromJson(await request(
        method: RequestMethod.get, path: 'api/booking-practice/durations'));
  }

  //NewsCategoriesOutput
  Future<BlogCategoriesOutput> blogCategories() async {
    return BlogCategoriesOutput.fromJson(
        await request(method: RequestMethod.get, path: 'api/news-categories'));
  }

  //NewsOutput
  Future<BlogOutput> blog(BlogInput newInput) async {
    return BlogOutput.fromJson(await request(
        method: RequestMethod.get,
        path: 'api/news/',
        queryParameters: newInput.toJson()));
  }

  //NewDetailOutput
  Future<BlogDetailOutput> blogDetail(String slug) async {
    return BlogDetailOutput.fromJson(
        await request(method: RequestMethod.get, path: 'api/news/$slug'));
  }

  //BannerClassTypeOutput
  Future<BannerClassTypeOutput> bannerClassType(
      Map<String, String> data) async {
    return BannerClassTypeOutput.fromJson(await request(
        method: RequestMethod.get,
        path: 'api/class-types/banners',
        queryParameters: data));
  }

  //api/program-categories

  Future<BlogCategoriesOutput> promotionCategories() async {
    return BlogCategoriesOutput.fromJson(await request(
        method: RequestMethod.get, path: 'api/program-categories'));
  }

  Future<BlogOutput> promotions(BlogInput newInput) async {
    return BlogOutput.fromJson(await request(
        method: RequestMethod.get,
        path: 'api/programs/',
        queryParameters: newInput.toJson()));
  }

  Future<BlogDetailOutput> promotionDetail(String slug) async {
    return BlogDetailOutput.fromJson(
        await request(method: RequestMethod.get, path: 'api/programs/$slug'));
  }

  ///api/notifications
  Future<NotificationsOutput> notifications(
      NotificationsInput data, bool? isSeen) async {
    print('isSeen: $isSeen');
    return NotificationsOutput.fromJson(await request(
        method: RequestMethod.get,
        path: 'api/notifications',
        queryParameters:
            (isSeen == true) ? data.toJsonJustSeen() : data.toJsonAll()));
  }

  // api/notifications/seen/147
  Future<BaseOutput> seenNotification(String slug) async {
    return BaseOutput.fromJson(await request(
        method: RequestMethod.put, path: 'api/notifications/seen/$slug'));
  }

  // api/app-error-log
  Future<BaseOutput> saveLogs(Map<String, String?> data) async {
    return BaseOutput.fromJson(await request(
        method: RequestMethod.post, path: 'api/app-error-log', data: data));
  }

  Future<ListProductsOutput> listProducts() async {
    return ListProductsOutput.fromJson(await request(
        method: RequestMethod.get, path: 'api/contracts/list-products'));
  }

  Future<BookingClassTypesOutput> bookingClassTypes() async {
    return BookingClassTypesOutput.fromJson(
        await request(method: RequestMethod.get, path: 'api/class-types'));
  }

  Future<BookingClassTypesV2Output> bookingClassTypesV2(String slug) async {
    return BookingClassTypesV2Output.fromJson(await request(
        method: RequestMethod.get, path: 'api/class-types/menu/$slug'));
  }

  Future<MenuInHomeOutput> bookingClassTypesV3() async {
    return MenuInHomeOutput.fromJson(
        await request(method: RequestMethod.get, path: 'api/v2/class-types'));
  }

  Future<MenuInHomeOutput> menusInHome() async {
    return MenuInHomeOutput.fromJson(
        await request(method: RequestMethod.get, path: 'api/class-types/v3'));
  }

  Future<CoachesOutput> coaches(CoachesInput data) async {
    return CoachesOutput.fromJson(await request(
        method: RequestMethod.get,
        path: 'api/coaches',
        queryParameters: data.toJson()));
  }

  Future<ListTime11Output> listTimeBooking11(
      ListTimeBooking11Input data) async {
    return ListTime11Output.fromJson(await request(
        method: RequestMethod.get,
        path: 'api/booking-one-one/time-coach',
        queryParameters: data.toJson()));
  }

  //Booking11Output
  Future<Booking11Output> booking11(DataBooking11Detail data) async {
    return Booking11Output.fromJson(await request(
        method: RequestMethod.post,
        path: 'api/booking-one-one',
        data: data.bookingToJson()));
  }

  //Booking11DetailOutput
  Future<Booking11DetailOutput> booking11Detail(String bookingCode) async {
    return Booking11DetailOutput.fromJson(await request(
        method: RequestMethod.get, path: 'api/booking-one-one/$bookingCode'));
  }

  //ContractsOutput
  Future<BookingClassTypesV5Output> contracts11() async {
    return BookingClassTypesV5Output.fromJson(await request(
        method: RequestMethod.get,
        path: 'api/contracts/v2/list-contracts?key=ONE_ONE'));
  }

  //{{URL}}/contracts/list-contract-booking?key=CLASS_PRACTICE
  Future<BookingClassTypesV5Output> bookingClassTypesV5(
      Map<String, String?> data) async {
    return BookingClassTypesV5Output.fromJson(await request(
        method: RequestMethod.get,
        path: 'api/contracts/list-contract-booking',
        queryParameters: data));
  }


}
