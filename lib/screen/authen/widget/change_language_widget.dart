import 'package:flutter/material.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';

class ChangeLanguageWidget extends StatelessWidget {
  final String code;
  final VoidCallback onTap;

  const ChangeLanguageWidget({super.key, required this.onTap, required this.code});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: ShapeDecoration(
              color: Colors.black.withOpacity(0.10000000149011612),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyAppIcon.iconNamedCommon(
                    fit: BoxFit.contain,
                    iconName: code == 'vi' ? 'profile/en_flag.svg' : 'profile/vi_flag.svg',
                    width: 24,
                    height: 24),
                const SizedBox(width: 4),
                Text(
                  code.toUpperCase() == 'VI' ? 'EN' : 'VI',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
