//Nạp thư viện để tương tác với HTML
import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:js';

import 'package:json_to_dart/json_to_dart.dart';

final jsonInput = querySelector('#jsonInput') as TextAreaElement;
final converterClassInput =
    querySelector('#converterClassInput') as TextAreaElement;
final converterFunctionInput =
    querySelector('#converterFunctionInput') as TextAreaElement;
final converterClassInputReadOnly =
    querySelector('#converterClassInputReadOnly')!;
final converterFunctionInputReadOnly =
    querySelector('#converterFunctionInputReadOnly')!;
final converterType = querySelector('#converterType') as SelectElement;
final classOutput = querySelector('#classOutput') as TextAreaElement;
final classOutputHidden =
    querySelector('#classOutputHidden') as TextAreaElement;

final classOutputDiv = querySelector('#classOutputDiv') as DivElement;

final btnSubmit = querySelector('#submit') as ButtonElement;
final btnClose = querySelector('#close') as DivElement;

Future<void> runDemo() async {
  String demo = await _readJsonFile("assets/json/demo_1.json");

  /// Pretty Json
  demo = _prettyJson(demo);
  jsonInput.value = demo;
}

void main() {
  runDemo();
  _showOutputDiv(false);

  loadConverterType();

  /// Sự kiện nhấn submit
  btnSubmit.addEventListener(
    'click',
    (_) => _onSubmit(),
  );
  btnClose.addEventListener(
    'click',
    (_) {
      _showOutputDiv(false);
      final value = converterType.value;
      print(value);
      _setTextDefineInput(value ?? '');
    },
  );
  converterType.addEventListener(
    'change',
    (_) {
      _showOutputDiv(false);
      final value = converterType.value;
      print(value);
      _setTextDefineInput(value ?? '');

      context.callMethod('setValueLocal', ["converterType", value]);

      final converterClassInputValue = converterClassInput.value;
      context.callMethod(
          'setValueLocal', ["converterClassInput", converterClassInputValue]);
      converterClassInputReadOnly.text = converterClassInputValue;

      final converterFunctionInputValue = converterFunctionInput.value;
      context.callMethod('setValueLocal',
          ["converterFunctionInput", converterFunctionInputValue]);
      converterFunctionInputReadOnly.text = converterFunctionInputValue;
    },
  );
  converterClassInput.addEventListener(
    'input',
    (_) {
      final converterClassInputValue = converterClassInput.value;
      context.callMethod(
          'setValueLocal', ["converterClassInput", converterClassInputValue]);
      converterClassInputReadOnly.text = converterClassInputValue;
    },
  );
  converterFunctionInput.addEventListener(
    'input',
    (_) {
      final converterFunctionInputValue = converterFunctionInput.value;
      context.callMethod('setValueLocal',
          ["converterFunctionInput", converterFunctionInputValue]);
      converterFunctionInputReadOnly.text = converterFunctionInputValue;
    },
  );
}

void loadConverterType() {
  /// Thêm option cho converter type
  converterType
      .append(OptionElement(data: "Private fields", value: "private_fields"));
  converterType
      .append(OptionElement(data: "Public fields", value: "public_fields"));
  converterType.append(OptionElement(data: "Custom", value: "custom"));

  /// Lấy value người dùng đã chọn
  String? value = context.callMethod('getValueLocal', ["converterType"]);
  value ??= 'private_fields';
  converterType.value = value;
  print('value: $value');
  if (value == 'custom') {
    converterClassInputReadOnly.text = converterClassInput.value =
        context.callMethod('getValueLocal', ["converterClassInput"]);
    converterFunctionInputReadOnly.text = converterFunctionInput.value =
        context.callMethod('getValueLocal', ["converterFunctionInput"]);
  }
  _setTextDefineInput(value);
}

void _showOutputDiv(bool show) {
  classOutputDiv.hidden = !show;
}

Future<void> _onSubmit() async {
  print('[web - main - _onSubmit] run');
  try {
    final jsonInputValue = jsonInput.value ?? '';
    final formClass = converterClassInput.value ?? '';
    final defineFunction = converterFunctionInput.value ?? '';

    print("jsonInput: $jsonInputValue");
    print("defineFunction: $defineFunction");
    print("formClass: $formClass");

    String? rs = jsonToDart(
      className: 'ClassName',
      json: jsonInputValue,
      formClass: formClass,
      defineFunction: defineFunction,
    );
    classOutputHidden.value = rs ?? '';
    classOutput.value = rs ?? '';
    _showOutputDiv(true);
  } catch (e) {
    print('[web - main - _onSubmit] $e');
    String message;
    if (e is LogicException) {
      message = e.message.toString();
    } else {
      message = e.toString();
    }
    context.callMethod('alert', [message]);
  }
}

Future<void> _setTextDefineInput(String type) async {
  print('[_setTextDefineInput] run $type');

  if (type == "custom") {
    converterClassInput.hidden = false;
    converterFunctionInput.hidden = false;
    converterClassInputReadOnly.hidden = true;
    converterFunctionInputReadOnly.hidden = true;
  } else {
    converterClassInput.hidden = true;
    converterFunctionInput.hidden = true;
    converterClassInputReadOnly.hidden = false;
    converterFunctionInputReadOnly.hidden = false;
    String formClass = '';
    String defineFunction = '';
    try {
      formClass = await _readFileTxt("assets/define/$type/form_class");
      defineFunction =
          await _readJsonFile("assets/define/$type/define_function.json");

      /// Pretty Json
      defineFunction = _prettyJson(defineFunction);
    } catch (e) {
      print('[_setTextDefineInput] $e');
    }

    print('[_setTextDefineInput] formClass $formClass');
    print('[_setTextDefineInput] defineFunction $defineFunction');

    converterClassInput.value = formClass;
    converterFunctionInput.value = defineFunction;
    converterClassInputReadOnly.text = formClass;
    converterFunctionInputReadOnly.text = defineFunction;
  }
}

String _prettyJson(String text) {
  final object = jsonDecode(text);
  return JsonEncoder.withIndent('  ').convert(object);
}

Future<String> _readFileTxt(String filePath) {
  Completer<String> c = Completer<String>();
  context.callMethod("readFile", [filePath, c.complete]);
  return c.future;
}

Future<String> _readJsonFile(String filePath) {
  Completer<String> c = Completer<String>();
  context.callMethod("readFile", [
    filePath,
    (object) {
      final map = _jsObjectToMap(object);
      final text = jsonEncode(map);
      return c.complete(text);
    }
  ]);
  return c.future;
}

Map _jsObjectToMap(JsObject object) {
  final rs = jsonDecode(context['JSON'].callMethod('stringify', [object]));
  return rs;
}
