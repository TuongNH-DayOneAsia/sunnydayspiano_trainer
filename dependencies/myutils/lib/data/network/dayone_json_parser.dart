class JsonParser {
  static T jsonToModel<T>(T Function(Map<String, dynamic> map) fromJson, Map response) {
    try {
      return fromJson(response.cast());
    } on TypeError catch (e) {
      print('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      throw FormatException('Failed to parse JSON: $e');
    } catch (e) {
      rethrow;
    }
  }

  static List<T> jsonArrayToModel<T>(T Function(Map<String, dynamic> map) fromJson, List data) {
    try {
      return data.map((e) => fromJson((e as Map).cast())).toList();
    } on TypeError catch (e) {
      print('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      throw FormatException('Failed to parse JSON array: $e');
    } catch (e) {
      rethrow;
    }
  }
}