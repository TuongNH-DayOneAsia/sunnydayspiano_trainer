extension MyNum on num {
 static num? parseNum(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value;
    if (value is String) {
      return num.tryParse(value);
    }
    return 0;
  }

}