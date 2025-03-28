import 'package:flutter/cupertino.dart';

class InfoRowBookingDetailWidget extends StatelessWidget {
  const InfoRowBookingDetailWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        InfoRow(label: "Mã đặt chỗ:", value: "SND - 01234"),
        InfoRow(label: "Họ và tên:", value: "Phan Thi Ngoc Lan"),
        InfoRow(label: "Sđt:", value: "0335492192"),
        InfoRow(label: "Phòng:", value: "Class Studio 1"),
        InfoRow(label: "Buổi tập:", value: "17:30 - 19:00"),
        InfoRow(label: "Ngày:", value: "24/07/2024"),
        InfoRow(label: "Chi nhánh:", value: "111 Bầu cát, phường 14, Tân Bình, tp.HCM"),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final String? label, value;
  final TextStyle? valueStyle;

  const InfoRow({super.key, this.label, this.value, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label ?? '',
            ),
          ),
          Expanded(flex: 7, child: Text(value ?? '', style: valueStyle ?? const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
