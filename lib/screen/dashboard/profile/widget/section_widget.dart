import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionWidget extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const SectionWidget({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title?.isNotEmpty == true)
          Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Text(title!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
          ),
        Card(
          elevation: 0,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: List.generate(children.length, (index) {
              final isLastItem = index == children.length - 1;
              return Column(
                children: [
                  children[index],
                  if (!isLastItem && children.length > 1) const Divider(),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
