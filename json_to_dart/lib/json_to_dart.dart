library json_to_dart;

export 'src/exceptions/logic_exception.dart';

import 'package:json_to_dart/src/run.dart';

String? jsonToDart({
  required String className,
  required String json,
  required String formClass,
  required String defineFunction,
}) {
  print('[main - generateClass] run');
  return run(
    className: className,
    json: json,
    formClass: formClass,
    defineFunction: defineFunction,
  );
}
