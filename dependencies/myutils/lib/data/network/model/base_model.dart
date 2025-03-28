
abstract class BaseModel {
  BaseModel();
  BaseModel.init();
  BaseModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
