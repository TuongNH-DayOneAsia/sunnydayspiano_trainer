import 'dart:io' show Platform;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/data/cache_helper/cache_helper.dart';
import 'package:myutils/data/network/model/output/api_key_output.dart';
import 'package:myutils/data/network/model/output/user_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/helpers/extension/image_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:myutils/utils/widgets/my_button.dart';
import 'package:permission_handler/permission_handler.dart';

class MyQrCodeScreen extends BaseStatelessScreenV2 {
  final DataUserInfo? dataUserInfo;
  static String route = '/my-qr-code';

  const MyQrCodeScreen(
      {super.key, this.dataUserInfo, super.appColorTransparent = true});

  @override
  // TODO: implement title
  String? get title => 'profile.myQRCode'.tr();

  // @override
  // String get title => 'profile.contractInfo'.tr();

  @override
  Widget buildBody(BuildContext pageContext) {
    return _BuildBody(
      dataUserInfo: dataUserInfo,
    );
  }
}

class _BuildBody extends StatefulWidget {
  final DataUserInfo? dataUserInfo;

  const _BuildBody({this.dataUserInfo});

  @override
  State<_BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends State<_BuildBody> {
  final GlobalKey _globalKey = GlobalKey();
  LocaleManager localeManager = injector();

  bool get inReleaseIOSFromApi => (((localeManager
              .loadSavedObject(
                  StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
              ?.firebaseConfigData
              .inReleaseProgress ??
          false)) &&
      Platform.isIOS);
  bool _isCapturing = false;

  @override
  Widget build(BuildContext context) {
    final dataUserInfo = widget.dataUserInfo;
    return Column(
      children: [
        Expanded(
          child: RepaintBoundary(
            key: _globalKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [
                    Color(0xFFFFA63D),
                    Color(0xFFFF8B00),
                    Color(0xFFEE8100)
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 110.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 30.w, horizontal: 47.w),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'packages/common_resource/assets/images/sunnydayspiano.png',
                            height: 40.h,
                          ),
                          SizedBox(height: 16.h),
                          MyImage.cachedImgFromUrl(
                            hasPlaceholder: false,
                            url: dataUserInfo?.qrcodePath ?? '',
                          ),
                          SizedBox(height: 24.h),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${dataUserInfo?.name ?? ''}\n',
                                  style: TextStyle(
                                    color: MyColors.mainColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          InfoCard(dataUserInfo: dataUserInfo),
                        ],
                      ),
                    ),
                    if (!_isCapturing)
                      Visibility(
                        visible: !inReleaseIOSFromApi,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Platform.isIOS ? 30 : 20,
                              horizontal: 25.w),
                          child: MyButton(
                            width:
                                Dimens.getProportionalScreenWidth(context, 295),
                            fontSize: 14,
                            leadingIcon: MyAppIcon.iconNamedCommon(
                                iconName: 'profile/download.svg',
                                color: Colors.white),
                            text: 'profile.saveToDevice'.tr(),
                            border: Border.all(color: Colors.white),
                            height: 40.h,
                            onPressed: (value) async {
                              if (dataUserInfo?.qrcodePath == null ||
                                  dataUserInfo?.qrcodePath == '') {
                                return;
                              }
                              setState(() {
                                _isCapturing = true;
                              });
                              await Future.delayed(
                                  const Duration(milliseconds: 100));
                              await ToolHelper.captureAndSaveWidget(
                                  context, _globalKey);
                              setState(() {
                                _isCapturing = false;
                              });
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showPermanentlyDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Yêu cầu quyền truy cập'),
        content: const Text(
            'Cần quyền truy cập thư viện ảnh để lưu hình ảnh. Vui lòng bật nó trong cài đặt ứng dụng.'),
        actions: [
          TextButton(
            child: const Text('Hủy'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Mở Cài đặt'),
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
              'This app needs photo library access to save images. Please enable it in the settings.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class InfoCard extends StatelessWidget {
  final DataUserInfo? dataUserInfo;

  const InfoCard({super.key, this.dataUserInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
              'profile.studentCode'.tr(), dataUserInfo?.studentCode ?? '---'),
          const Divider(color: Color(0xFFE1E1E1), thickness: 0.5),
          _buildInfoRow(
              'profile.timeStart'.tr(), dataUserInfo?.dateStart ?? '---'),
          const Divider(color: Color(0xFFE1E1E1), thickness: 0.5),
          _buildInfoRow('profile.timeEnd'.tr(), dataUserInfo?.dateEnd ?? '---'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF3B3B3B),
              fontSize: 12.sp,
              fontFamily: 'Be Vietnam Pro',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: const Color(0xFF6A6A6A),
              fontSize: 12.sp,
              fontFamily: 'Be Vietnam Pro',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
