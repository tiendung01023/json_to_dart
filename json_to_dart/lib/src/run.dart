import 'dart:convert';

import 'package:json_to_dart/src/model/class_model.dart';
import 'package:json_to_dart/src/model/define_field_model.dart';
import 'package:json_to_dart/src/model/field_model.dart';
import 'package:json_to_dart/src/services/class_converter.dart';

String? run({
  required String className,
  required String json,
  required String formClass,
  required String defineFunction,
}) {
  print('[run - run] run');
  try {
    final dynamic _jsonDecode = jsonDecode(json);

    Map<String, dynamic>? map;
    if (_jsonDecode is Map<String, dynamic>) {
      map = _jsonDecode;
    } else if (_jsonDecode is List) {
      if (_jsonDecode.isNotEmpty) {
        final dynamic first = _jsonDecode.first;
        if (first is Map<String, dynamic>) {
          map = first;
        }
      }
    }
    if (map != null) {
      final ClassConverter converter = ClassConverter();
      final ClassModel classModel = converter.parseMap(
        name: className,
        map: map,
      );
      final listDefineField = _getDefineFieldList(defineFunction);

      final List<ClassModel> listClassModel = _getListClassModel(classModel);
      final rs = listClassModel
          .map((ClassModel e) => _listClassToString(
                listDefineField: listDefineField,
                formClass: formClass,
                model: e,
              ))
          .join('\n\n');
      return rs;
    }
  } catch (e, stackTrace) {
    print('[run - run] $e \n$stackTrace');
  }
}

/// Lấy thông tin define cách xử lý model từ file define.json
List<DefineFieldModel> _getDefineFieldList(String jsonData) {
  print('[run - _getDefineFieldList] run');
  final json = jsonDecode(jsonData) as Map<String, dynamic>;
  final field = (json['field'] as List)
      .map((e) => DefineFieldModel.fromJson(e as Map<String, dynamic>))
      .toList();
  return field;
}

/// Chuyển từ ClassModel lồng nhau thành danh sách các ClassModel lẻ
List<ClassModel> _getListClassModel(ClassModel model) {
  print('[run - _getListClassModel] run');
  final List<ClassModel> list = <ClassModel>[];
  list.add(model);

  final listField = model.listField;
  for (final FieldModel field in listField) {
    final classModel = field.classModel;
    if (classModel != null) {
      list.addAll(_getListClassModel(classModel));
    }
  }
  return list;
}

/// Chuyển từng ClassModel sang String hiển thị lên màn hình
String _listClassToString({
  required String formClass,
  required List<DefineFieldModel> listDefineField,
  required ClassModel model,
}) {
  print('[run - _listClassToString] run');
  final List<String> listResult = <String>[];

  final lines = formClass.split('\n');
  for (final String line in lines) {
    String rs = line;

    /// Biến gán không lặp
    final className = model.className;
    final defineMap = _fieldModelToMap(
      listDefineField: listDefineField,
      listField: model.listField,
    );
    final classMap = {
      "className": className,
    };
    classMap.addAll(defineMap);

    for (var entry in classMap.entries) {
      rs = rs.replaceAll('{${entry.key}}', entry.value);
    }

    /// Biến gán lặp
    final listField = model.listField;

    final List<String> lineInField = <String>[];
    for (final FieldModel field in listField) {
      String data = rs;
      for (var entry in field.toJson().entries) {
        if (data.contains(entry.key)) {
          data = data.replaceAll('{${entry.key}}', entry.value ?? '');
        }
      }
      // Nếu không có thay đổi thì không add
      if (data != rs) {
        lineInField.add(data);
      }
    }

    /// Nếu không có thay đổi thì để như cũ
    if (lineInField.isNotEmpty) {
      rs = lineInField.join('\n');
    }

    listResult.add(rs);
  }
  return listResult.join('\n');
}

Map<String, String> _fieldModelToMap({
  required List<FieldModel> listField,
  required List<DefineFieldModel> listDefineField,
}) {
  print('[run - _fieldModelToMap] run');
  final listValiableDefine = listDefineField.map((defineFieldModel) {
    final lines = <String>[];

    for (final FieldModel field in listField) {
      final Iterable<DefineCaseModel> caseUsing =
          defineFieldModel.caseList.where(
        (e) => e.type == field.fieldTypeName,
      );
      String process;
      if (caseUsing.isNotEmpty) {
        process = caseUsing.first.process;
      } else {
        process = defineFieldModel.caseDefault;
      }

      for (final entry in field.toJson().entries) {
        process = process.replaceAll('{${entry.key}}', entry.value ?? '');
      }
      lines.add(process);
    }

    final value = lines.join(defineFieldModel.join);
    return MapEntry(defineFieldModel.name, value);
  });

  final Map<String, String> map = <String, String>{};
  map.addEntries(listValiableDefine);
  return map;
}
