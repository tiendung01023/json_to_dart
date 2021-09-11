import 'package:json_to_dart/src/model/base_model.dart';
import 'package:json_to_dart/src/common/string_extension.dart';
import 'package:json_to_dart/src/model/class_model.dart';

class FieldModel extends BaseModel {
  String get fieldName => name.toFieldName();
  String get fieldJson => name;

  /// Định danh sử dụng với model
  final String fieldTypeCode;
  String get fieldTypeCode_0 => fieldTypeCode.split('<').first;
  String? get fieldTypeCode_1 {
    final list = fieldTypeCode.split('<');
    if (list.length >= 2) {
      return list.elementAt(1).replaceAll('>', '');
    }
  }

  /// Định danh sau khi parse thành class
  String get fieldType {
    String rs;
    if (fieldTypeCode_0 == "dynamic") {
      rs = "$fieldTypeCode_0";
    } else if (fieldTypeCode_1 != null) {
      rs = "$fieldTypeCode_0<$fieldTypeCode_1>?";
    } else {
      rs = "$fieldTypeCode_0?";
    }
    rs = rs.replaceAll('Class', className ?? '');
    return rs;
  }

  String? get className => classModel?.className;
  String? get classFieldName => classModel?.classFieldName;
  String? get classFieldJson => classModel?.classFieldJson;

  final ClassModel? classModel;

  FieldModel({
    required String name,
    required this.fieldTypeCode,
    this.classModel,
  }) : super(name: name);

  Map<String, String?> toJson() => {
        "fieldName": fieldName,
        "fieldJson": fieldJson,
        "fieldType": fieldType,
        "fieldTypeCode": fieldTypeCode,
        "fieldTypeCode_0": fieldTypeCode_0,
        "fieldTypeCode_1": fieldTypeCode_1,
        "className": className,
        "classFieldName": classFieldName,
        "classFieldJson": classFieldJson,
      };
}
