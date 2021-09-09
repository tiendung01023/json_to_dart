extension StringExtension on String {
  String capitalize() {
    if (isNotEmpty) {
      return '${this[0].toUpperCase()}${substring(1)}';
    } else {
      return '';
    }
  }

  String uncapitalize() {
    if (isNotEmpty) {
      return '${this[0].toLowerCase()}${substring(1)}';
    } else {
      return '';
    }
  }

  /// Viết hoa mỗi chữ cái đầu
  String get capitalizeFirstofEach => replaceAll('_', ' ')
      .replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((String str) => str.capitalize())
      .join(' ')
      .replaceAll(' ', '');

  String toClassName() {
    return capitalizeFirstofEach.capitalize();
  }

  String toFieldName() {
    final String rs = capitalizeFirstofEach.uncapitalize();
    return rs;
  }
}
