/// branch_id : 1
/// page : 1
/// limit : 1

class CoachesInput {
  CoachesInput({
      this.branchId, 
      this.page,
    this.key,
      this.limit,});

  CoachesInput.fromJson(dynamic json) {
    branchId = json['branch_id'];
    page = json['page'];
    limit = json['limit'];
    key = json['key'];
  }
  int? branchId;
  int? page;
  int? limit;
  String? key;
CoachesInput copyWith({  int? branchId,
  int? page,
  int? limit,
  String? key,
}) => CoachesInput(  branchId: branchId ?? this.branchId,
  page: page ?? this.page,
  limit: limit ?? this.limit,
  key: key ?? this.key,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['branch_id'] = branchId;
    map['page'] = page;
    map['limit'] = limit;
    map['key'] = key;
    return map;
  }

}