import 'package:json_to_dart/src/model/base_model.dart';
import 'package:json_to_dart/src/common/string_extension.dart';
import 'package:json_to_dart/src/model/field_model.dart';

class ClassModel extends BaseModel {
  String get className => name.toClassName();
  String get classFieldJson => name;
  String get classFieldName => name.toFieldName();

  final List<FieldModel> listField;

  ClassModel({
    required String name,
    required this.listField,
  }) : super(name: name);
}
