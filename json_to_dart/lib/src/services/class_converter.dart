import 'package:json_to_dart/src/enums/type_enum.dart';
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
          type: TypeEnum.bool,
        );
      } else if (value is int) {
        fieldModel = FieldModel(
          name: key,
          type: TypeEnum.int,
        );
      } else if (value is double) {
        fieldModel = FieldModel(
          name: key,
          type: TypeEnum.double,
        );
      } else if (value is String) {
        fieldModel = FieldModel(
          name: key,
          type: TypeEnum.String,
        );
      } else if (value is Map<String, dynamic>) {
        fieldModel = FieldModel(
          name: key,
          type: TypeEnum.Class,
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
            type: TypeEnum.List_bool,
          );
        } else if (valueFirst is int) {
          fieldModel = FieldModel(
            name: key,
            type: TypeEnum.List_int,
          );
        } else if (valueFirst is double) {
          fieldModel = FieldModel(
            name: key,
            type: TypeEnum.List_double,
          );
        } else if (valueFirst is String) {
          fieldModel = FieldModel(
            name: key,
            type: TypeEnum.List_String,
          );
        } else if (valueFirst is Map<String, dynamic>) {
          fieldModel = FieldModel(
            name: key,
            type: TypeEnum.List_Class,
            classModel: parseMap(name: key, map: valueFirst),
          );
        } else {
          fieldModel = FieldModel(
            name: key,
            type: TypeEnum.List_dynamic,
          );
        }
      } else {
        fieldModel = FieldModel(
          name: key,
          type: TypeEnum.dynamic,
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
