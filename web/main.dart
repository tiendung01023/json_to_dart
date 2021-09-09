//Nạp thư viện để tương tác với HTML
import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:js';

import 'package:json_to_dart/json_to_dart.dart';

Future<void> runDemo() async {
  final demo = await _readJsonFile("assets/json/demo_1.json");
  querySelector('#jsonInput')?.text = demo;
}

void main() {
  // runDemo();

  querySelector('#converterType')
      ?.append(OptionElement(data: "Private fields", value: "private_fields"));
  querySelector('#converterType')
      ?.append(OptionElement(data: "Public fields", value: "public_fields"));

  querySelector('#submit')?.addEventListener('click', (e) => _onSubmit());
}

Future<void> _onSubmit() async {
  print('[web - main - _onSubmit] run');
  try {
    final jsonInput = querySelector('#jsonInput')?.text;
    final converterType =
        JsObject(context['jQuery'], ['#converterType']).callMethod('val');
    final defineFunction =
        await _readJsonFile("assets/define/$converterType/define_function.json");
    String formClass =
        await _readFileTxt("assets/define/$converterType/form_class");
    formClass = formClass.replaceAll('"', '');
    if (jsonInput != null) {
      String? rs = jsonToDart(
        className: 'ClassName',
        json: jsonInput,
        formClass: formClass,
        defineFunction: defineFunction,
      );
      querySelector('#classOutputHidden')?.text = rs ?? '';
      querySelector('#classOutput')?.text = rs ?? '';
      querySelector('#copyToClipboard')?.hidden = false;
    }
  } catch (e) {
    print('[web - main - _onSubmit] $e');
  }
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
