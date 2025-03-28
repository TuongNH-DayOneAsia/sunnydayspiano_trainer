import 'package:equatable/equatable.dart';
import 'package:myutils/data/network/model/input/blog_input.dart';
import 'package:myutils/data/network/model/output/booking_class_types_output.dart';
import 'package:myutils/data/network/model/output/booking_class_types_v2_output.dart';
import 'package:myutils/data/network/model/output/menus_in_home_output.dart';
import 'package:myutils/data/network/model/output/booking_class_types_v4_output.dart';
import 'package:myutils/data/network/model/output/contracts/booking_class_type_v5_output.dart';
import 'package:myutils/data/network/model/output/list_class_output.dart';
import 'package:myutils/data/network/model/output/list_products_output.dart';
import 'package:myutils/data/network/model/output/news_categories_output.dart';
import 'package:myutils/data/network/model/output/news_output.dart';
import 'package:myutils/data/network/model/output/remind_booking_output.dart';

// class HomeState extends Equatable implements CachedWidgetState {
class HomeState extends Equatable {
  final RemindBookingOutput? remindBookingOutput;
  final BlogCategoriesOutput? newsCategoriesOutput;
  final BlogOutput? newsOutput;
  final BlogInput? newsInput;
  final int? currentTabIndex;
  final MenuInHomeOutput? menusInHome;
  final BookingClassTypesV5Output? classContract;
  final BookingClassTypesV5Output? practiceContract;
  final BookingClassTypesV5Output? oneOneContract;

  const HomeState(
      {this.currentTabIndex,
      this.remindBookingOutput,
      this.newsCategoriesOutput,
      this.newsOutput,
      this.newsInput,
      this.classContract,
      this.menusInHome,
      this.practiceContract,this.oneOneContract});

  @override
  List<Object?> get props => [
        remindBookingOutput,
        newsCategoriesOutput,
        newsOutput,
        newsInput,
        currentTabIndex,
        classContract,
        menusInHome,
        practiceContract,
        oneOneContract
      ];

  HomeState copyWith({
    RemindBookingOutput? remindBookingOutput,
    BlogCategoriesOutput? newsCategoriesOutput,
    BlogOutput? newsOutput,
    BlogInput? newsInput,
    int? currentTabIndex,
    MenuInHomeOutput? menusInHome,
    BookingClassTypesV5Output? classContract,
    BookingClassTypesV5Output? practiceContract,
    BookingClassTypesV5Output? oneOneContract,
  }) {
    return HomeState(
      remindBookingOutput: remindBookingOutput ?? this.remindBookingOutput,
      newsCategoriesOutput: newsCategoriesOutput ?? this.newsCategoriesOutput,
      newsOutput: newsOutput ?? this.newsOutput,
      newsInput: newsInput ?? this.newsInput,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      menusInHome: menusInHome ?? this.menusInHome,
      classContract: classContract ?? this.classContract,
      practiceContract: practiceContract ?? this.practiceContract,
      oneOneContract:  oneOneContract ?? this.oneOneContract
    );
  }

  // @override
  // CachedWidgetState? fromJson(Map<String, dynamic> json) {
  //   return HomeState(
  //     banners: json['banners'] != null
  //         ? (json['banners'] as List)
  //             .map((e) => DataInfoNameBooking.fromJson(e))
  //             .toList()
  //         : null,
  //     remindBookingOutput: json['remindBookingOutput'] != null
  //         ? RemindBookingOutput.fromJson(
  //             json['remindBookingOutput'] as Map<String, dynamic>)
  //         : null,
  //     newsCategoriesOutput: json['newsCategoriesOutput'] != null
  //         ? BlogCategoriesOutput.fromJson(
  //             json['newsCategoriesOutput'] as Map<String, dynamic>)
  //         : null,
  //     newsOutput: json['newsOutput'] != null
  //         ? BlogOutput.fromJson(json['newsOutput'] as Map<String, dynamic>)
  //         : null,
  //     newsInput: json['newsInput'] != null
  //         ? BlogInput.fromJson(json['newsInput'] as Map<String, dynamic>)
  //         : null,
  //     currentTabIndex: json['currentTabIndex'] != null
  //         ? json['currentTabIndex'] as int
  //         : null,
  //     bookingClassTypesOutput: json['bookingClassTypesOutput'] != null
  //         ? BookingClassTypesOutput.fromJson(
  //             json['bookingClassTypesOutput'] as Map<String, dynamic>)
  //         : null,
  //     listProductsOutput: json['listProductsOutput'] != null
  //         ? ListProductsOutput.fromJson(
  //             json['listProductsOutput'] as Map<String, dynamic>)
  //         : null,
  //     bookingClassTypesV2Output: json['bookingClassTypesV2Output'] != null
  //         ? BookingClassTypesV2Output.fromJson(
  //             json['bookingClassTypesV2Output'] as Map<String, dynamic>)
  //         : null,
  //     productSelected: json['productSelected'] != null
  //         ? Products.fromJson(json['productSelected'] as Map<String, dynamic>)
  //         : null,
  //     titleProduct:
  //         json['titleProduct'] != null ? json['titleProduct'] as String : null,
  //     bookingClassTypesV3Output: json['bookingClassTypesV3Output'] != null
  //         ? BookingClassTypesV3Output.fromJson(
  //             json['bookingClassTypesV3Output'] as Map<String, dynamic>)
  //         : null,
  //     bookingClassTypesV4Output: json['bookingClassTypesV4Output'] != null
  //         ? BookingClassTypesV4Output.fromJson(
  //         json['bookingClassTypesV4Output'] as Map<String, dynamic>)
  //         : null,
  //   );
  // }
  //
  // @override
  // Map<String, dynamic> toJson() {
  //   return {
  //     'banners': banners,
  //     'remindBookingOutput': remindBookingOutput?.toJson(),
  //     'newsCategoriesOutput': newsCategoriesOutput?.toJson(),
  //     'newsOutput': newsOutput?.toJson(),
  //     'newsInput': newsInput?.toJson(),
  //     'currentTabIndex': currentTabIndex,
  //     'bookingClassTypesOutput': bookingClassTypesOutput?.toJson(),
  //     'listProductsOutput': listProductsOutput?.toJson(),
  //     'bookingClassTypesV2Output': bookingClassTypesV2Output?.toJson(),
  //     'productSelected': productSelected?.toJson(),
  //     'titleProduct': titleProduct,
  //     'bookingClassTypesV3Output': bookingClassTypesV3Output?.toJson(),
  //     'bookingClassTypesV4Output': bookingClassTypesV4Output?.toJson(),
  //   };
  // }
}
// class HomeState extends Equatable  {
//   final List<DataInfoNameBooking>? banners;
//   final RemindBookingOutput? remindBookingOutput;
//   final BlogCategoriesOutput? newsCategoriesOutput;
//   final BookingClassTypesOutput? bookingClassTypesOutput;
//   final BlogOutput? newsOutput;
//   final BlogInput? newsInput;
//   final int? currentTabIndex;
//   final String? titleProduct;
//   final ListProductsOutput? listProductsOutput;
//   final Products? productSelected;
//   final BookingClassTypesV2Output? bookingClassTypesV2Output;
//   final BookingClassTypesV3Output? bookingClassTypesV3Output;
//
//   const HomeState({
//     this.titleProduct,
//     this.currentTabIndex,
//     this.banners,
//     this.remindBookingOutput,
//     this.newsCategoriesOutput,
//     this.newsOutput,
//     this.newsInput,
//     this.bookingClassTypesOutput,
//     this.listProductsOutput,
//     this.bookingClassTypesV2Output,
//     this.bookingClassTypesV3Output,
//
//     this.productSelected,
//   });
//
//   @override
//   List<Object?> get props => [
//     banners,
//     remindBookingOutput,
//     newsCategoriesOutput,
//     newsOutput,
//     newsInput,
//     currentTabIndex,
//     bookingClassTypesOutput,
//     listProductsOutput,
//     bookingClassTypesV2Output,
//     bookingClassTypesV3Output,
//     productSelected,
//     titleProduct
//   ];
//
//   // copyWith method
//   HomeState copyWith(
//       {List<DataInfoNameBooking>? banners,
//         RemindBookingOutput? remindBooking,
//         BlogCategoriesOutput? newsCategoriesOutput,
//         BlogOutput? newsOutput,
//         BlogInput? newsInput,
//         int? currentTabIndex,
//         BookingClassTypesOutput? bookingClassTypesOutput,
//         ListProductsOutput? listProductsOutput,
//         BookingClassTypesV2Output? bookingClassTypesV2Output,
//         BookingClassTypesV3Output? bookingClassTypesV3Output,
//         Products? productSelected,
//         String? titleProduct}) {
//     return HomeState(
//         remindBookingOutput: remindBooking ?? this.remindBookingOutput,
//         banners: banners ?? this.banners,
//         newsCategoriesOutput: newsCategoriesOutput ?? this.newsCategoriesOutput,
//         newsOutput: newsOutput ?? this.newsOutput,
//         newsInput: newsInput ?? this.newsInput,
//         currentTabIndex: currentTabIndex ?? this.currentTabIndex,
//         bookingClassTypesOutput:
//         bookingClassTypesOutput ?? this.bookingClassTypesOutput,
//         listProductsOutput: listProductsOutput ?? this.listProductsOutput,
//         bookingClassTypesV2Output: bookingClassTypesV2Output ?? this.bookingClassTypesV2Output,
//         bookingClassTypesV3Output: bookingClassTypesV3Output ?? this.bookingClassTypesV3Output,
//
//         productSelected: productSelected ?? this.productSelected,
//         titleProduct: titleProduct ?? this.titleProduct);
//   }
//
// }
