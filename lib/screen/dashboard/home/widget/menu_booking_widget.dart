import 'dart:math';
import 'package:dayoneasia/screen/booking/booking_class/class_list/booking_class_list_screen.dart';
import 'package:dayoneasia/screen/booking/booking_practice/practice_list/booking_practice_list_screen.dart';
import 'package:dayoneasia/screen/dashboard/home/contracts/contracts_screen.dart';
import 'package:dayoneasia/screen/dashboard/home/cubit/home/home_state.dart';
import 'package:dayoneasia/screen/dashboard/home/widget/booking/booking_widget.dart';
import 'package:dayoneasia/screen/main/cubit/main_cubit.dart';
import 'package:dayoneasia/screen/main/main_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/data/network/model/output/list_products_output.dart';
import 'package:myutils/data/network/model/output/menus_in_home_output.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import '../cubit/home/home_cubit.dart';

class MenuBookingWidget extends StatefulWidget {
  const MenuBookingWidget({super.key});

  @override
  State<MenuBookingWidget> createState() => _MenuBookingWidgetState();
}

class _MenuBookingWidgetState extends State<MenuBookingWidget> {
  @override
  Widget build(BuildContext context) {
    return _buildBookingWidget(context);
  }

  void _handleBookingClass() {
    final mainCubit = context.read<MainCubit>();
    final userData = mainCubit.state.userOutput?.data;

    if (userData?.isBookClass == true) {
      context.push(BookingClassListScreen.route).then(_handleBookingResult);
    } else {
      _showPopupHtml(
        title: 'Tính năng đã bị tạm khóa',
        context: context,
        description: userData?.textIsBookClassLimitMonth ?? '',
      );
    }
  }

  void _handleBookingRoom() {
    final mainCubit = context.read<MainCubit>();
    if (mainCubit.state.userOutput?.data?.isBookPractice == true) {
      context.push(BookingPracticeListScreen.route).then(_handleBookingResult);
    } else {
      _showPopupHtml(
        title: 'Tính năng đã bị tạm khóa',
        context: context,
        description:
            mainCubit.state.userOutput?.data?.textIsBookPracticeLimitMonth ??
                '',
      );
    }
  }

  void _handleBookingResult(dynamic value) {
    if (value != null && value is bool && value) {
      final mainPageState =
          (context.findAncestorStateOfType<MainPageState>() as MainPageState);
      mainPageState.onItemTapped(1);
    }
  }

  Widget _buildBookingWidget(BuildContext contextHomeCubit) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return BookingClassTypesV3Screen(
          onPressedItem: (data) {
            _onPressedItem(
                data: data, contextHomeCubit: contextHomeCubit, state: state);
          },
        );
      },
    );
  }

  _onPressedItem(
      {required DataMenuV3 data,
      required BuildContext contextHomeCubit,
      required HomeState state}) {
    if (data.isBooking == true) {
      final mainCubit = contextHomeCubit.read<MainCubit>();
      final userData = mainCubit.state.userOutput?.data;
      if (data.key == 'CLASS_PRACTICE' || data.key == 'CLASS') {
        if (userData?.isActive == true) {
          if (data.key == 'CLASS_PRACTICE') {
            contextHomeCubit.read<HomeCubit>().handleFeatureAccess(
                  userData: userData,
                  router: data.router ?? BookingClassListScreen.route,
                  key: data.key,
                  isBooking: data.isBooking ?? false,
                  showPopup: (title, description) => _showPopupHtml(
                    title: title,
                    context: contextHomeCubit,
                    description: description,
                  ),
                  navigateTo: (route, extra) async {
                    context.push(route, extra: data).then(_handleBookingResult);
                  },
                );
          } else if (data.key == "CLASS") {
            if (state.classContract?.data?.items == null ||
                state.classContract?.data?.items?.isEmpty == true) {
              return;
            }
            if (state.classContract?.data?.items?.length == 1 &&
                state.classContract?.data?.items?.first.isBooking == true) {
              contextHomeCubit.read<HomeCubit>().handleFeatureAccess(
                    userData: userData,
                    router: data.router ?? BookingClassListScreen.route,
                    key: data.key,
                    isBooking: data.isBooking ?? false,
                    showPopup: (title, description) => _showPopupHtml(
                      title: title,
                      context: contextHomeCubit,
                      description: description,
                    ),
                    navigateTo: (route, extra) async {
                      if (state.classContract?.data?.items?.first != null) {
                        context
                            .push(route,
                                extra: state.classContract?.data?.items?.first)
                            .then(_handleBookingResult);
                      }
                    },
                  );
              return;
            }
            context.push(ContractsScreen.route, extra: {
              'title': 'Chọn hợp đồng lớp Nhóm',
              'data': state.classContract?.data,
              'message_empty': state.classContract?.data?.messages ?? ''
            });
          }
        } else {
          if (state.practiceContract?.data == null ||
              state.practiceContract?.data?.items?.isEmpty == true) {
            _showPopupHtml(
              title: 'Chưa có thông tin',
              context: context,
              description: data.key == 'CLASS_PRACTICE'
                  ? state.practiceContract?.data?.messages ??
                      'Vui lòng liên hệ VH để được hỗ trợ'
                  : state.classContract?.data?.messages ??
                      'Vui lòng liên hệ VH để được hỗ trợ',
            );
            return;
          }
          context.push(
            ContractsScreen.route,
            extra: {
              'title': data.key == 'CLASS_PRACTICE'
                  ? 'Chọn hợp đồng luyện đàn'
                  : 'Chọn hợp đồng lớp Nhóm',
              'data': data.key == 'CLASS_PRACTICE'
                  ? state.practiceContract?.data
                  : state.classContract?.data,
              'message_empty': data.key == 'CLASS_PRACTICE'
                  ? state.practiceContract?.data != null
                      ? state.practiceContract?.data?.messages ?? ''
                      : state.practiceContract?.message ?? ''
                  : state.classContract?.data != null
                      ? state.classContract?.data?.messages ?? ''
                      : state.classContract?.message ?? '',
            },
          );
        }
      } else {
        if (state.oneOneContract?.data == null) {
          _showPopupHtml(
            title: 'Chưa có thông tin',
            context: context,
            description: data.key == 'CLASS_PRACTICE'
                ? state.practiceContract?.data?.messages ??
                    'Vui lòng liên hệ VH để được hỗ trợ'
                : state.classContract?.data?.messages ??
                    'Vui lòng liên hệ VH để được hỗ trợ',
          );
          return;
        }
        // Handle other booking types (1:1)
        context.push(ContractsScreen.route, extra: {
          'title': 'booking11.selectContract11'.tr(),
          'data': state.oneOneContract?.data,
          'message_empty': state.oneOneContract?.data?.messages ?? ''
        });
      }
    } else {
      _showPopupHtml(
        title: data.textBlockBooking?.isNotEmpty == true
            ? data.textBlockBooking ?? ''
            : 'bookingClass.confirmBooking'.tr(),
        context: context,
        description: data.message?.isNotEmpty == true
            ? data.message ?? ''
            : 'bookingClass.confirmBooking'.tr(),
      );
    }
  }

  void _showPopupHtml({
    required String title,
    required BuildContext context,
    required String description,
  }) {
    MyPopupMessage.confirmPopUpHTML(
      isTextTitleCenter: true,
      colorIcon: Colors.grey,
      iconAssetPath: 'dashboard/lock.svg',
      cancelText: 'bookingClass.goBack'.tr(),
      width: Dimens.getScreenWidth(context),
      fontWeight: FontWeight.w500,
      confirmText: 'bookingClass.cancelBooking'.tr(),
      title: title,
      context: context,
      barrierDismissible: false,
      description: 'bookingClass.confirmCancelBookingMessage'.tr(),
      htmlContent: description,
    );
  }
}

class ListItemData {
  final IconData icon;
  final String title;

  ListItemData({
    required this.icon,
    required this.title,
  });
}

class CustomListView extends StatelessWidget {
  const CustomListView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ListItemData> items = [
      ListItemData(
        icon: Icons.group,
        title: 'Lớp Nhóm',
      ),
      ListItemData(
        icon: Icons.calendar_today,
        title: 'Trải nghiệm HLV',
      ),
    ];

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildListItem(
          icon: items[index].icon,
          title: items[index].title,
          onTap: () {
            // Xử lý khi nhấn vào item
          },
        );
      },
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.orange,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.orange,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.orange,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

void showPackageBottomSheet(
    {required BuildContext context,
    required List<Products> products,
    Products? productSelected,
    required Function(Products) onSelected}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.7,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => PackageSelectionSheet(
        products: products,
        onSelected: onSelected,
        productSelected: productSelected),
  );
}

class PackageSelectionSheet extends StatefulWidget {
  final List<Products> products;
  final Products? productSelected;

  final Function(Products data) onSelected;

  const PackageSelectionSheet({
    super.key,
    required this.products,
    required this.onSelected,
    this.productSelected,
  });

  @override
  State<PackageSelectionSheet> createState() => _PackageSelectionSheetState();
}

class _PackageSelectionSheetState extends State<PackageSelectionSheet> {
  int? selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIndex = max(
        widget.products
            .indexWhere((item) => item.id == widget.productSelected?.id),
        0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Header
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Center(
                  child: Text(
                    'Chọn gói dịch vụ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Row(
                  children: [
                    Icon(Icons.close, size: 20, color: Colors.orange),
                    SizedBox(width: 4),
                    Text(
                      'Đóng',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.products.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final package = widget.products[index];
              return Container(
                decoration: BoxDecoration(
                  gradient: selectedIndex == index
                      ? const LinearGradient(
                          begin: Alignment(-0.98, -0.18),
                          end: Alignment(0.98, 0.18),
                          colors: [
                            Color(0xFFFFE6CF),
                            Color(0xFFFFF9F3),
                            Color(0xFFFFF0E2)
                          ],
                        )
                      : null,
                  color: selectedIndex == index ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: selectedIndex == index
                        ? Colors.transparent
                        : Colors.grey[300]!,
                  ),
                ),
                child: RadioListTile(
                  title: Text(
                    package.product?.name ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  value: index,
                  groupValue: selectedIndex,
                  onChanged: (value) {
                    setState(() {
                      selectedIndex = value as int;
                    });
                  },
                  activeColor: Colors.orange,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: selectedIndex != null
                  ? () {
                      final selectedProduct = widget.products[selectedIndex!];
                      widget.onSelected(selectedProduct);
                      Navigator.pop(context);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Chọn',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
