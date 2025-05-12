import 'package:flutter/material.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';

import 'my_button.dart';

class CustomFlutterErrorWidget extends StatelessWidget {
  const CustomFlutterErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 100.0
          ),
          const SizedBox(height: 20.0),
          const Text(
            "Đã xảy ra lỗi. Vui lòng thử lại sau.",
            style: TextStyle(fontSize: 14.0),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          MyButton(
            text: "Quay lại",
            borderRadius: 20,
            color: MyColors.mainColor,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            border: Border.all(color: MyColors.mainColor, width: 1),
            colorText: Colors.white,
            onPressed: (_) => Navigator.of(context).maybePop(),
          )
        ],
      ),
    );
  }
}
