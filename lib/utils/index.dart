class Util {
  static bool isEmpty(dynamic? data) {
    if (data == null) return true;
    if (data is List || data is String) {
      return data.isEmpty;
    }
    return true;
  }

  static T? testKey<T>(Map<String, dynamic>? data, String key) {
    if (data == null) return null;
    if (data.containsKey(key) && data[key] != null) {
      T source = data[key];
      if (source is List) {
        return source.isEmpty ? null : source;
      }
      if (source is String) {
        return source.isEmpty ? null : source;
      }
      return source;
    }
    return null;
  }
}
