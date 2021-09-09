class LogicException {
  LogicException({this.message, this.data});

  dynamic data;

  String? message;

  @override
  String toString() {
    final map = {
      'message': message,
      'data': data,
    };
    return '$map';
  }
}
