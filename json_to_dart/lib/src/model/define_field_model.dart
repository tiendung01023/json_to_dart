class DefineFieldModel {
  final String name;
  final String join;
  final String caseDefault;
  final List<DefineCaseModel> caseList;

  DefineFieldModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        join = json['join'] as String,
        caseDefault = json['case_default'] as String,
        caseList = (json['case_list'] as List?)
                ?.map(
                    (e) => DefineCaseModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
}

class DefineCaseModel {
  final String type;
  final String process;

  DefineCaseModel.fromJson(Map<String, dynamic> json)
      : type = json['type'] as String,
        process = json['process'] as String;
}
