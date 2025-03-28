import 'dart:typed_data'; // Thêm dòng này

import 'package:flutter/material.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/helpers/extension/image_extension.dart';
import 'package:photo_manager/photo_manager.dart';

class AvatarWidget extends StatelessWidget {
  final Function()? onTap;
  final double? size;
  final String urlAvt;
  final bool isUpload;
  final EdgeInsetsGeometry? padding;

  const AvatarWidget({super.key, required this.urlAvt, this.size, this.onTap, this.isUpload = false, this.padding});

  @override
  Widget build(BuildContext context) {
    final double avatarSize = size ?? 60;

    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          ClipOval(
            child: MyImage.cachedImgFromUrl(
              url: urlAvt,
              width: avatarSize,
              height: avatarSize,
              fit: BoxFit.cover,
              errorWidget: Container(
                padding: padding ?? const EdgeInsets.all(8),
                width: avatarSize,
                height: avatarSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipOval(
                  child: MyAppIcon.iconNamedCommon(iconName: "dashboard/user.svg", color: MyColors.mainColor),
                ),
              ),
            ),
          ),
          if (isUpload)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: avatarSize * 0.25,
                height: avatarSize * 0.25,
                decoration: const BoxDecoration(
                  color: Color(0xFFE1E1E1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: avatarSize * 0.16,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PhotoPickerPage extends StatefulWidget {
  const PhotoPickerPage({super.key});

  @override
  _PhotoPickerPageState createState() => _PhotoPickerPageState();
}

class _PhotoPickerPageState extends State<PhotoPickerPage> {
  List<AssetEntity> _photos = [];
  int _currentPage = 0;
  final int _pageSize = 60;
  bool _isLoading = false;
  AssetEntity? _selectedPhoto;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndFetchPhotos();
  }

  Future<void> _requestPermissionAndFetchPhotos() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      await _fetchPhotos();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Không có quyền truy cập'),
          content: Text('Ứng dụng cần quyền truy cập thư viện ảnh để hoạt động.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _fetchPhotos() async {
    setState(() {
      _isLoading = true;
    });

    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: true);
    if (albums.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final AssetPathEntity album = albums.first;
    final List<AssetEntity> photos = await album.getAssetListPaged(page: _currentPage, size: _pageSize);

    setState(() {
      _photos.addAll(photos);
      _currentPage++;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            itemCount: _photos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
            ),
            itemBuilder: (context, index) {
              return FutureBuilder<Uint8List?>(
                future: _photos[index].thumbnailData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPhoto = _photos[index];
                        });
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.memory(snapshot.data!, fit: BoxFit.cover),
                          if (_selectedPhoto == _photos[index])
                            Container(
                              color: Colors.blue.withOpacity(0.3),
                              child: const Icon(Icons.check, color: Colors.white),
                            ),
                        ],
                      ),
                    );
                  }
                  return Container(color: Colors.grey[300]);
                },
              );
            },
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        ElevatedButton(
          onPressed: _selectedPhoto != null
              ? () async {
                  final file = await _selectedPhoto!.file;
                  if (file != null) {
                    print('Đường dẫn ảnh đã chọn: ${file.path}');
                    // Xử lý file ảnh đã chọn ở đây
                  }
                }
              : null,
          child: const Text('Chọn ảnh'),
        ),
      ],
    );
  }
}
