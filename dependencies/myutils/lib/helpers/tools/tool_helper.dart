import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter/services.dart'
    show Clipboard, ClipboardData, Uint8List, rootBundle;
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:translator/translator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../data/network/model/output/api_key_output.dart';

class ToolHelper {
  static final GoogleTranslator _translator = GoogleTranslator();

  static Future<void> checkNotificationPermission(BuildContext context) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Handle different permission statuses
    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        print('User granted permission');
        break;

      case AuthorizationStatus.provisional:
        print('User granted provisional permission');
        break;

      case AuthorizationStatus.denied:
        // Show permission denied popup
        showSettingsPopupOpenSetting(
            context: context,
            title: 'Thông báo',
            description:
                'Ứng dụng yêu cầu quyền thông báo để nhận thông báo về các lịch, luyện tập đàn!');
        break;
      default:
        showSettingsPopupOpenSetting(
            context: context,
            title: 'Thông báo',
            description:
                'Ứng dụng yêu cầu quyền thông báo để nhận thông báo về các lịch, luyện tập đàn!');
    }
  }

  static Future<void> captureAndSaveWidget(
      BuildContext context, GlobalKey globalKey) async {
    try {
      bool isPermissionGranted = await _requestPermission(
          Platform.isIOS ? Permission.photos : Permission.storage);
      if (!isPermissionGranted) {
        showSettingsPopupOpenSetting(context: context);
        return;
      }

      RenderRepaintBoundary boundary =
      globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception("Không thể lấy dữ liệu từ ảnh.");
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();
      await FlutterImageGallerySaver.saveImage(pngBytes);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu hình ảnh vào thư viện ảnh')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(e.toString())),
      );

    }
  }
  static Future<void> forceUpdate({
    required BuildContext context,
    required DataKeyPrivate data,
  }) async {
    bool isForceUpdate = data.isForceUpdate ?? false;
    if (!isForceUpdate) return;
    String latestVersion = Platform.isIOS
        ? data.appLastVersioniOS ?? ''
        : data.appLastVersionAndroid ?? '';
    bool isRequireForceUpdate = data.isRequireForceUpdate ?? false;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (packageInfo.version != latestVersion) {
      MyPopupMessage.confirmPopUp(
        isForceUpdate: true,
        cancelText: (isRequireForceUpdate == true) ? '' : 'Huỷ',
        confirmText: 'Đồng ý',
        title: 'Cập nhật ứng dụng',
        context: context,
        barrierDismissible: false,
        description: 'Có phiên bản mới. Bạn có muốn cập nhật không?',
        onConfirm: () => ToolHelper.openAppStore(
            urlAndroid: data.appLinkAndroid, urlIOS: data.appLinkiOS),
      );
    }
  }
  static bool isIpad() {
    return Platform.isIOS &&
        (MediaQueryData.fromView(ui.window).size.shortestSide >= 600);
  }

  static Future<bool> _requestPermission(Permission permission) async {
    if (Platform.isIOS) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.photos.request();
      }
      return status.isGranted;
    } else {
      final status = await Permission.photos.request();
      print('status: $status');
      return status.isGranted;
    }
  }

  static void showSettingsPopupOpenSetting(
      {required BuildContext context, String? title, String? description}) {
    MyPopupMessage.confirmPopUp(
      cancelText: 'Huỷ',
      confirmText: 'Xác nhận',
      title: title ?? 'Mở quyền truy cập thư viện ảnh',
      context: context,
      barrierDismissible: false,
      description: description ??
          'Cho phép ứng dụng truy cập vào thư viện ảnh để lưu hình ảnh',
      onConfirm: () {
        openAppSettings();
      },
    );
  }

  static Future<String> getDeviceInfo() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String deviceString = '';
      String osString = Platform.isAndroid ? 'Android' : 'iOS';

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceString =
            '${androidInfo.model} - Android ${androidInfo.version.release} ($osString)';
        print('getDeviceId Device: ${androidInfo.model}');
        print('getDeviceId Android version: ${androidInfo.version.release}');
      }

      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceString =
            '${iosInfo.name} - iOS ${iosInfo.systemVersion} ($osString)';
        print('getDeviceId Device: ${iosInfo.name}');
        print('getDeviceId iOS version: ${iosInfo.systemVersion}');
      }

      return deviceString; //  "iPhone 15 - iOS 17 (iOS)" or "Samsung Galaxy S21 - Android 13 (Android)"
    } catch (e) {
      print('Error getting device info: $e');
      return 'Unknown Device';
    }
  }

  static Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'Unknown';
    } else {
      return 'Unsupported platform';
    }
  }

  static Future<File> resizeImageFromFile(File? file) async {
    try {
      final fileSize = file?.lengthSync() ?? 0;
      print('fileSize: $fileSize');
      if (fileSize > 1000000) {
        final result = await compressImage(
          file!,
          // file!.absolute.path,
          quality: 80,
          targetWidth: 1200,
          targetHeight: 1200,
        );
        return result;
      }
      return file!;
    } catch (e) {
      rethrow;
    }
  }

  static Future<File> compressImage(File file,
      {int quality = 80,
      int targetWidth = 1200,
      int targetHeight = 1200}) async {
    // Read the file as Uint8List
    Uint8List imageBytes = await file.readAsBytes();

    // Decode the image
    img.Image? image = img.decodeImage(imageBytes);

    if (image == null) return file;

    // Resize the image
    img.Image resized = img.copyResize(
      image,
      width: targetWidth,
      height: targetHeight,
    );

    // Encode the image to JPEG with the specified quality
    List<int> compressedBytes = img.encodeJpg(resized, quality: quality);

    // Get temporary directory
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;

    // Create a new file in temporary directory
    File compressedFile = File(
        '$tempPath/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');

    // Write compressed data to file
    await compressedFile.writeAsBytes(compressedBytes);

    return compressedFile;
  }

  //get list image from assets 'assets/$path
  static Future<List<File>> getListImageFileFromAssets(
      List<String> listPath) async {
    final listResizeImage = Future.wait(listPath.map((element) async {
      // final byteData = await rootBundle.load('assets/$element');
      final byteData = await rootBundle.load('assets/$element');

      final file = File('${(await getTemporaryDirectory()).path}/$element');
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      return file;
    }));
    return listResizeImage;
  }

  static Future<List<File>> getImageFilesFromAssets(List<String> paths) async {
    final temporaryDirectory = await getTemporaryDirectory();

    final futures = paths.map((path) async {
      final byteData = await rootBundle.load('assets/$path');
      // final byteData = await rootBundle.load('$path');

      final file = File('${temporaryDirectory.path}/$path');
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      return file;
    });

    final files = await Future.wait(futures);
    return files.toList();
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  static String stringToBase64Encode(String originalString) {
    return base64Encode(utf8.encode(originalString));
  }

  static String decodeBase64String(String base64String) {
    return utf8.decode(base64.decode(base64String));
  }

  static Future<Map<String, dynamic>> translateJson(
      Map<String, dynamic> vietnameseJson,
      {List<String> excludeKeys = const []}) async {
    Map<String, dynamic> englishJson = {};

    for (var key in vietnameseJson.keys) {
      if (vietnameseJson[key] is String && !excludeKeys.contains(key)) {
        final translation = await _translator.translate(vietnameseJson[key],
            from: 'vi', to: 'en');
        englishJson[key] = translation.text;
      } else {
        englishJson[key] = vietnameseJson[key];
      }
    }

    return englishJson;
  }

  static Future<String> translateText(String vietnameseText) async {
    try {
      if (vietnameseText.isEmpty) return vietnameseText;
      final translation =
          await _translator.translate(vietnameseText, from: 'vi', to: 'en');
      return translation.text;
    } catch (e) {
      return vietnameseText;
    }
  }

  static Future<void> clipboard(BuildContext context, String textToCopy) async {
    if (textToCopy.isNotEmpty) {
      try {
        await Clipboard.setData(ClipboardData(text: textToCopy));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$textToCopy đã được sao chép')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to copy to clipboard.')),
        );
      }
    }
  }

  static Future<String> getBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print('packageInfo.buildNumber: ${packageInfo.buildNumber}');
    print('packageInfo.version: ${packageInfo.version}');
    print('packageInfo.appName: ${packageInfo.appName}');
    return packageInfo.version;
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    // String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;
  }

  static Future<void> launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  static Future<void> launchPhone(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    } else {
      throw 'Could not launch $phoneLaunchUri';
    }
  }

  static Future<bool> checkImageWithoutHttp(String imageUrl) {
    final Completer<bool> completer = Completer();
    final image = NetworkImage(imageUrl);

    image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (ImageInfo info, bool _) {
              completer.complete(true);
            },
            onError: (dynamic exception, StackTrace? stackTrace) {
              completer.complete(false);
            },
          ),
        );

    return completer.future;
  }

  static Future<void> openAppStore({String? urlAndroid, String? urlIOS}) async {
    final storeUrl = Platform.isIOS
        ? urlIOS ?? 'https://apps.apple.com/vn/app/piano-trainer/id6739237486'
        : urlAndroid ??
        'https://play.google.com/store/apps/details?id=com.sunnydays.piano.coach';
    try {
      if (await canLaunchUrl(Uri.parse(storeUrl))) {
        await launchUrl(Uri.parse(storeUrl),
            mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Could not launch store: $e');
    }
  }
}
