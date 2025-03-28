import 'package:dayoneasia/screen/notification/cubit/notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/data/network/model/output/notifications_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';


class NotificationScreen extends StatefulWidget {
  static const String route = '/notification';

  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Scaffold(body: ReminderList());
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class ReminderList extends BaseStatelessScreenV2 {
  const ReminderList({
    super.key,
  });

  @override
  String? get title => 'Thông báo';

  @override
  Color? get backgroundColor => Colors.white;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit()
        ..initNotifications()
        ..checkPermission(context),
      child: super.build(context),
    );
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.error != null) {
          return Center(child: Text(state.error!));
        }

        return IgnorePointer(
          ignoring: state.isLoading || state.isLoadingMore,
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 16.h),
              const Expanded(child: NotificationListView()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildUnreadSwitch(),
          _buildMarkAsReadButton(),
        ],
      ),
    );
  }

  Widget _buildUnreadSwitch() {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        return Row(
          children: [
            StyledSwitch(
              value: state.switchValue,
              onToggled: (isToggled) => {
                context.read<NotificationsCubit>().switchSeen(isToggled),
              },
            ),
            const SizedBox(width: 6),
            const Text(
              'Chỉ chưa đọc',
              style: TextStyle(
                color: Color(0xFF3B3B3B),
                fontSize: 12,
                fontFamily: 'Be Vietnam Pro',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMarkAsReadButton() {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        // if (state.notificationsOutput?.data?.notifications?.isEmpty ?? true) {
        //   return const SizedBox();
        // }
        return InkWell(
          onTap: () {
            context.read<NotificationsCubit>()
              ..allSeen()
              ..resetSwitch();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(93),
            ),
            child: Row(
              children: [
                MyAppIcon.iconNamedCommon(iconName: 'message-read.svg'),
                const SizedBox(width: 3),
                Text(
                  'Đánh dấu đã đọc',
                  style: TextStyle(
                    color: const Color(0xFF2A2A2A),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NotificationListView extends StatefulWidget {
  const NotificationListView({super.key});

  @override
  State<NotificationListView> createState() => _NotificationListViewState();
}

class _NotificationListViewState extends State<NotificationListView> {
  late final ScrollController _scrollController;

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
  }

  void _scrollToTop(List<DataNotifications>? list) {
    if (list?.isEmpty == true) {
      return;
    }
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final notifications =
            state.notificationsOutput?.data?.notifications ?? [];
        return RefreshIndicator(
          color: MyColors.mainColor,
          onRefresh: () async {
            context.read<NotificationsCubit>().refreshNotifications();
            return Future.delayed(const Duration(milliseconds: 1000));
          },
          child: notifications.isNotEmpty == true
              ? NotificationListener(
                  child: NotificationListener(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo is ScrollEndNotification) {
                        if (_scrollController.position.pixels >=
                                _scrollController.position.maxScrollExtent &&
                            !state.isLoadingMore) {
                          context.read<NotificationsCubit>().loadMore();
                        }
                      }
                      return state.isLoadingMore;
                    },
                    child: SizedBox(
                      child: Stack(
                        children: [
                          ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            controller: _scrollController,
                            itemCount: notifications.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 0.h),
                            itemBuilder: (context, index) {
                              final item = notifications[index];
                              return _buildNotificationItem(item);
                            },
                          ),
                          if (state.isLoadingMore)
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                color: Colors.white.withOpacity(0.8),
                                child: const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.2),
                      child: Column(
                        children: [
                          MyAppIcon.iconNamedCommon(iconName: 'noti-empty.svg'),
                          SizedBox(height: 16.h),
                          Text(
                            'Hiện bạn chưa có thông báo!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF8D8D8D),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  void navigateToDetail({required DataNotifications item}) {
    final cubit = context.read<NotificationsCubit>();
    final params = cubit.getNavigationParams(item);
    final route = params['route'];
    final extra = params['extra'];

    if (route != null) {
      context.push(route, extra: extra);
    }
  }

  void handleNotificationTap({required DataNotifications item}) {
    if (!item.isSeen) {
      context.read<NotificationsCubit>().seenNotification(
            slug: item.slug ?? '',
            onSuccess: () {
              LocalStream.shared.refreshApiProfile();
              context
                  .read<NotificationsCubit>()
                  .updateNotificationStatus(item.slug ?? '');
              navigateToDetail(item: item);
            },
          );
    } else {
      navigateToDetail(item: item);
    }
  }

  Widget _buildNotificationItem(DataNotifications item) {
    final cubit = context.read<NotificationsCubit>();

    return InkWell(
      onTap: () {
        if (cubit.canHandleNotification(item)) {
          handleNotificationTap(item: item);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        color: (!item.isSeen) ? const Color(0xFFFFFAF6) : Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (!item.isSeen) ? MyColors.mainColor : Colors.transparent,
              ),
            ),
            SizedBox(width: 4.w),
            MyAppIcon.iconNamedCommon(
              iconName: 'remind-booking.svg',
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2A2A2A),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        item.sentAt ?? '',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.content ?? '',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF757575),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item.booking?.bookingCode ?? '',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF757575),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StyledSwitch extends StatefulWidget {
  final void Function(bool isToggled) onToggled;
  final bool value;

  const StyledSwitch({
    super.key,
    required this.onToggled,
    required this.value,
  });

  @override
  State<StyledSwitch> createState() => _StyledSwitchState();
}

class _StyledSwitchState extends State<StyledSwitch> {
  bool isToggled = false;

  double size = 20;
  double innerPadding = 0;

  @override
  void initState() {
    isToggled = widget.value;

    innerPadding = size / 10;
    super.initState();
  }

  @override
  void didUpdateWidget(StyledSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      isToggled = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => isToggled = !isToggled);
        widget.onToggled(isToggled);
      },
      onPanEnd: (b) {
        setState(() => isToggled = !isToggled);
        widget.onToggled(isToggled);
      },
      child: AnimatedContainer(
        height: size,
        width: 33.w,
        padding: EdgeInsets.all(innerPadding),
        alignment: isToggled ? Alignment.centerRight : Alignment.centerLeft,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: isToggled ? Colors.orange.shade100 : Colors.grey.shade300,
        ),
        child: Container(
          width: size - innerPadding * 2,
          height: size - innerPadding * 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: isToggled ? Colors.orange.shade600 : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}
