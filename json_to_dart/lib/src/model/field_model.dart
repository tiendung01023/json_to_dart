import 'package:json_to_dart/src/common/utils.dart';
import 'package:json_to_dart/src/enums/type_enum.dart';
import 'package:json_to_dart/src/model/base_model.dart';
import 'package:json_to_dart/src/common/string_extension.dart';
import 'package:json_to_dart/src/model/class_model.dart';

class FieldModel extends BaseModel {
  String get fieldName => name.toFieldName();
  String get fieldJson => name;

  /// Định danh sử dụng với model
  String get fieldTypeName => enumToString(type);
  String get fieldType_0 => fieldTypeName.split('_').first;
  String? get fieldType_1 {
    final list = fieldTypeName.split('_');
    if (list.length >= 2) {
      return list.elementAt(1);
    }
  }

  /// Định danh sau khi parse thành class
  String get fieldType {
    String rs;
    if (fieldType_0 == "dynamic") {
      rs = "$fieldType_0";
    } else if (fieldType_1 != null) {
      rs = "$fieldType_0<$fieldType_1>?";
    } else {
      rs = "$fieldType_0?";
    }
    rs = rs.replaceAll('Class', className ?? '');
    return rs;
  }

  String? get className => classModel?.className;
  String? get classFieldName => classModel?.classFieldName;
  String? get classFieldJson => classModel?.classFieldJson;

  final TypeEnum type;
  final ClassModel? classModel;

  FieldModel({
    required String name,
    required this.type,
    this.classModel,
  }) : super(name: name);

  Map<String, String?> toJson() => {
        "fieldName": fieldName,
        "fieldJson": fieldJson,
        "fieldType": fieldType,
        "fieldTypeName": fieldTypeName,
        "fieldType_0": fieldType_0,
        "fieldType_1": fieldType_1,
        "className": className,
        "classFieldName": classFieldName,
        "classFieldJson": classFieldJson,
      };
}
