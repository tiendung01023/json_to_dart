//Nạp thư viện để tương tác với HTML
import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:js';

import 'package:json_to_dart/json_to_dart.dart';

Future<void> runDemo() async {
  String demo = await _readJsonFile("assets/json/demo_1.json");

  /// Pretty Json
  demo = _prettyJson(demo);
  (querySelector('#jsonInput') as TextAreaElement).value = demo;
}

void main() {
  runDemo();
  showOutput(false);
  showConverterInput(false);

  loadConverterType();

  /// Sự kiện nhấn submit
  querySelector('#submit')?.addEventListener('click', (_) => _onSubmit());
  querySelector('#close')?.addEventListener('click', (e) {
    showOutput(false);
    final element = querySelector('#converterType') as SelectElement;
    final value = element.value;
    print(value);
    _setTextDefineInput(value ?? '');
  });
  querySelector('#converterType')?.addEventListener('change', (_) {
    final element = querySelector('#converterType') as SelectElement;
    final value = element.value;
    print(value);
    _setTextDefineInput(value ?? '');

    final key = "converterType";
    context.callMethod('setValueLocal', [key, value]);
  });
  querySelector('#converterClassInput')?.addEventListener('input', (_) {
    final value = querySelector('#converterClassInput');
    context.callMethod('setValueLocal', ["converterClassInput", value]);
  });
  querySelector('#converterFunctionInput')?.addEventListener('input', (_) {
    final value = querySelector('#converterFunctionInput');
    context.callMethod('setValueLocal', ["converterFunctionInput", value]);
  });
}

void loadConverterType() {
  final key = "converterType";

  final element = querySelector('#converterType') as SelectElement;

  /// Thêm option cho converter type
  element
      .append(OptionElement(data: "Private fields", value: "private_fields"));
  element.append(OptionElement(data: "Public fields", value: "public_fields"));
  element.append(OptionElement(data: "Custom", value: "custom"));

  /// Lấy value người dùng đã chọn
  String? value = context.callMethod('getValueLocal', [key]);
  value ??= 'private_fields';
  element.value = value;
  print('value: $value');
  if (value == 'custom') {
    String? converterClassInput =
        context.callMethod('getValueLocal', ["converterClassInput"]);
    String? converterFunctionInput =
        context.callMethod('getValueLocal', ["converterFunctionInput"]);
    querySelector('#converterClassInput')?.text = converterClassInput;
    querySelector('#converterFunctionInput')?.text = converterFunctionInput;
  }
  _setTextDefineInput(value);
}

void showOutput(bool show) {
  querySelector('#classOutputDiv')?.hidden = !show;
  if (show) {
    querySelector('#converterInputDiv')?.hidden = true;
  }
}

void showConverterInput(bool show) {
  querySelector('#converterInputDiv')?.hidden = !show;
  if (show) {
    querySelector('#classOutputDiv')?.hidden = true;
  }
}

Future<void> _onSubmit() async {
  print('[web - main - _onSubmit] run');
  try {
    final jsonInput = (querySelector('#jsonInput') as TextAreaElement).value;
    final formClass =
        (querySelector('#converterClassInput') as TextAreaElement).value ?? '';
    final defineFunction =
        (querySelector('#converterFunctionInput') as TextAreaElement).value ??
            '';

    print("jsonInput: $jsonInput");
    if (jsonInput != null) {
      String? rs = jsonToDart(
        className: 'ClassName',
        json: jsonInput,
        formClass: formClass,
        defineFunction: defineFunction,
      );
      querySelector('#classOutputHidden')?.text = rs ?? '';
      querySelector('#classOutput')?.text = rs ?? '';
      showOutput(true);
    }
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
  print('[_setTextDefineInput] run');
  final classElement = querySelector('#converterClassInput') as TextAreaElement;
  final functionElement =
      querySelector('#converterFunctionInput') as TextAreaElement;
  final div = querySelector('#converterInputDiv');

  if (type == "custom") {
    div?.hidden = false;
  } else {
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

    classElement.text = formClass;
    functionElement.text = defineFunction;
    div?.hidden = true;
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
