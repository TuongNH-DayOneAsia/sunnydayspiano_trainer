/// branch_id : 1
/// coach_slug : "123"
/// current_date : "kjhjkh"
/// key : "iuhiuhiu"

class ListTimeBooking11Input {
  ListTimeBooking11Input({
      this.branchId, 
      this.coachSlug, 
      this.currentDate, 
      this.key,});

  ListTimeBooking11Input.fromJson(dynamic json) {
    branchId = json['branch_id'];
    coachSlug = json['coach_slug'];
    currentDate = json['current_date'];
    key = json['key'];
  }
  int? branchId;
  String? coachSlug;
  String? currentDate;
  String? key;
ListTimeBooking11Input copyWith({  int? branchId,
  String? coachSlug,
  String? currentDate,
  String? key,
}) => ListTimeBooking11Input(  branchId: branchId ?? this.branchId,
  coachSlug: coachSlug ?? this.coachSlug,
  currentDate: currentDate ?? this.currentDate,
  key: key ?? this.key,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['branch_id'] = branchId;
    map['coach_slug'] = coachSlug;
    map['current_date'] = currentDate;
    map['key'] = key;
    return map;
  }

}