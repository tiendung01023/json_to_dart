String enumToString(dynamic e) {
  if (e != null) {
    try {
      return e.toString().split('.').last;
    } catch (e) {
      print('[enumToString] $e');
    }
  }
  return "";
}
