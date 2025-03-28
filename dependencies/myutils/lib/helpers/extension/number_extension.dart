import 'package:intl/intl.dart';

extension MyDouble on double {
  String toCurrency({String? lang}) {
    return '${NumberFormat.decimalPattern().format(this)} VND';
  }

  String toCurrencyWithPrefix({String? lang}) {
    return this == 0 ? toCurrency() : '${this > 0 ? "+" : "-"}${NumberFormat.decimalPattern().format(this)} VND';
  }

  String compactFormat() {
    return NumberFormat.compact().format(this);
  }
}

extension MyInt on int {
  String toCurrency({String? lang}) {
    return '${NumberFormat.decimalPattern().format(this)} VND';
  }
}
