import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestPer {

 static Future<bool> requestPhotoPermission(BuildContext context) async {
    PermissionStatus status = await Permission.photos.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      status = await Permission.photos.request();
      if (status.isGranted) {
        return true;
      }
    }

    if (status.isPermanentlyDenied) {
      bool openSettings = await showSettingsDialog(context);
      if (openSettings) {
        await openAppSettings();
      }
      return false;
    }

    return false;
  }

 static Future<bool> showSettingsDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Quyền truy cập ảnh bị từ chối'),
        content: Text('Để sử dụng tính năng này, vui lòng cấp quyền truy cập ảnh trong cài đặt ứng dụng.'),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Mở cài đặt'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    ) ?? false;
  }
}