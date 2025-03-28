class NotificationsInput {
  final num page;
  final num limit;

  NotificationsInput({
    required this.page,
    required this.limit,
  });

  //to json
  Map<String, dynamic> toJsonAll() {
    final map = <String, dynamic>{};
    map['page'] = page;
    map['limit'] = limit;
    return map;
  }

  Map<String, dynamic> toJsonJustSeen() {
    final map = <String, dynamic>{};
    map['page'] = page;
    map['limit'] = limit;
    map['seen'] = 0;
    return map;
  }

  //copy with
  NotificationsInput copyWith({
    num? page,
    num? limit,
  }) =>
      NotificationsInput(
        page: page ?? this.page,
        limit: limit ?? this.limit,
      );
}