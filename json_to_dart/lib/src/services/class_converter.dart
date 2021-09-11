import 'package:json_to_dart/src/model/class_model.dart';
import 'package:json_to_dart/src/model/field_model.dart';

class ClassConverter {
  ClassModel parseMap({
    required String name,
    required Map<String, dynamic> map,
  }) {
    final listField = <FieldModel>[];
    final entries = map.entries;
    for (final MapEntry<String, dynamic> entry in entries) {
      final String key = entry.key;
      final dynamic value = entry.value;
      FieldModel fieldModel;
      if (value is bool) {
        fieldModel = FieldModel(
          name: key,
          fieldTypeCode: "bool",
        );
      } else if (value is int) {
        fieldModel = FieldModel(
          name: key,
          fieldTypeCode: "int",
        );
      } else if (value is double) {
        fieldModel = FieldModel(
          name: key,
          fieldTypeCode: "double",
        );
      } else if (value is String) {
        fieldModel = FieldModel(
          name: key,
          fieldTypeCode: "String",
        );
      } else if (value is Map<String, dynamic>) {
        fieldModel = FieldModel(
          name: key,
          fieldTypeCode: "Class",
          classModel: parseMap(name: key, map: value),
        );
      } else if (value is List) {
        final valueFirst = value.firstWhere(
          (element) => element != null,
          orElse: () => null,
        );
        if (valueFirst is bool) {
          fieldModel = FieldModel(
            name: key,
            fieldTypeCode: "List<bool>",
          );
        } else if (valueFirst is int) {
          fieldModel = FieldModel(
            name: key,
            fieldTypeCode: "List<int>",
          );
        } else if (valueFirst is double) {
          fieldModel = FieldModel(
            name: key,
            fieldTypeCode: "List<double>",
          );
        } else if (valueFirst is String) {
          fieldModel = FieldModel(
            name: key,
            fieldTypeCode: "List<String>",
          );
        } else if (valueFirst is Map<String, dynamic>) {
          fieldModel = FieldModel(
            name: key,
            fieldTypeCode: "List<Class>",
            classModel: parseMap(name: key, map: valueFirst),
          );
        } else {
          fieldModel = FieldModel(
            name: key,
            fieldTypeCode: "List<dynamic>",
          );
        }
      } else {
        fieldModel = FieldModel(
          name: key,
          fieldTypeCode: "dynamic",
        );
      }
      listField.add(fieldModel);
    }

    return ClassModel(
      name: name,
      listField: listField,
    );
  }
}
