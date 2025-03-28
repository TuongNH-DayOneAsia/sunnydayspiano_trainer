abstract class CachedWidgetState {
  CachedWidgetState.empty();
  CachedWidgetState? fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
