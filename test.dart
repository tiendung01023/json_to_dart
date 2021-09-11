class ClassName {
  final String? username;
  final String? url;
  final String? htmlUrl;
  final String? apb;
  final String? aaa;
  final dynamic empty;
  final int? favouriteInteger;
  final double? favouriteDouble;
  final List<bool>? randomBools;
  final List<String>? randomStrings;
  final List<int>? randomIntegers;
  final List<double>? randomDoubles;
  final List<dynamic>? randomNulls;
  final List<dynamic>? abc2;
  final PersonalInfo? personalInfo;

  ClassName({
    required this.username,
    required this.url,
    required this.htmlUrl,
    required this.apb,
    required this.aaa,
    required this.empty,
    required this.favouriteInteger,
    required this.favouriteDouble,
    required this.randomBools,
    required this.randomStrings,
    required this.randomIntegers,
    required this.randomDoubles,
    required this.randomNulls,
    required this.abc2,
    required this.personalInfo,
  });

  ClassName copyWith({
    String? username,
    String? url,
    String? htmlUrl,
    String? apb,
    String? aaa,
    dynamic empty,
    int? favouriteInteger,
    double? favouriteDouble,
    List<bool>? randomBools,
    List<String>? randomStrings,
    List<int>? randomIntegers,
    List<double>? randomDoubles,
    List<dynamic>? randomNulls,
    List<dynamic>? abc2,
    PersonalInfo? personalInfo,
  }) {
    return ClassName(
      username: username ?? this.username,
      url: url ?? this.url,
      htmlUrl: htmlUrl ?? this.htmlUrl,
      apb: apb ?? this.apb,
      aaa: aaa ?? this.aaa,
      empty: empty ?? this.empty,
      favouriteInteger: favouriteInteger ?? this.favouriteInteger,
      favouriteDouble: favouriteDouble ?? this.favouriteDouble,
      randomBools: randomBools ?? this.randomBools,
      randomStrings: randomStrings ?? this.randomStrings,
      randomIntegers: randomIntegers ?? this.randomIntegers,
      randomDoubles: randomDoubles ?? this.randomDoubles,
      randomNulls: randomNulls ?? this.randomNulls,
      abc2: abc2 ?? this.abc2,
      personalInfo: personalInfo ?? this.personalInfo,
    );
  }

  ClassName.fromJson(Map<String, dynamic> json)
    : username = json['Username'] as String?,
      url = json['url'] as String?,
      htmlUrl = json['html_url'] as String?,
      apb = json['__apb'] as String?,
      aaa = json['_aaa'] as String?,
      empty = json['empty'],
      favouriteInteger = json['favouriteInteger'] as int?,
      favouriteDouble = json['favouriteDouble'] as double?,
      randomBools = json['randomBools'] as List<bool>?,
      randomStrings = json['randomStrings'] as List<String>?,
      randomIntegers = json['randomIntegers'] as List<int>?,
      randomDoubles = json['randomDoubles'] as List<double>?,
      randomNulls = json['randomNulls'] as List<dynamic>?,
      abc2 = json['_abc2__'] as List<dynamic>?,
      personalInfo = json['personalInfo'] as PersonalInfo?;

  Map<String, dynamic> toJson() => {
    'Username' : username,
    'url' : url,
    'html_url' : htmlUrl,
    '__apb' : apb,
    '_aaa' : aaa,
    'empty' : empty,
    'favouriteInteger' : favouriteInteger,
    'favouriteDouble' : favouriteDouble,
    'randomBools' : randomBools,
    'randomStrings' : randomStrings,
    'randomIntegers' : randomIntegers,
    'randomDoubles' : randomDoubles,
    'randomNulls' : randomNulls,
    '_abc2__' : abc2,
    'personalInfo' : personalInfo
  };
}

class PersonalInfo {
  final String? firstName;
  final String? lastName;
  final String? location;
  final Abc? abc;
  final List<Phones>? phones;

  PersonalInfo({
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.abc,
    required this.phones,
  });

  PersonalInfo copyWith({
    String? firstName,
    String? lastName,
    String? location,
    Abc? abc,
    List<Phones>? phones,
  }) {
    return PersonalInfo(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      location: location ?? this.location,
      abc: abc ?? this.abc,
      phones: phones ?? this.phones,
    );
  }

  PersonalInfo.fromJson(Map<String, dynamic> json)
    : firstName = json['firstName'] as String?,
      lastName = json['lastName'] as String?,
      location = json['location'] as String?,
      abc = json['abc'] as Abc?,
      phones = json['phones'] as List<Phones>?;

  Map<String, dynamic> toJson() => {
    'firstName' : firstName,
    'lastName' : lastName,
    'location' : location,
    'abc' : abc,
    'phones' : phones
  };
}

class Abc {
  final String? test;

  Abc({
    required this.test,
  });

  Abc copyWith({
    String? test,
  }) {
    return Abc(
      test: test ?? this.test,
    );
  }

  Abc.fromJson(Map<String, dynamic> json)
    : test = json['test'] as String?;

  Map<String, dynamic> toJson() => {
    'test' : test
  };
}

class Phones {
  final String? type;
  final String? number;
  final bool? shouldCall;

  Phones({
    required this.type,
    required this.number,
    required this.shouldCall,
  });

  Phones copyWith({
    String? type,
    String? number,
    bool? shouldCall,
  }) {
    return Phones(
      type: type ?? this.type,
      number: number ?? this.number,
      shouldCall: shouldCall ?? this.shouldCall,
    );
  }

  Phones.fromJson(Map<String, dynamic> json)
    : type = json['type'] as String?,
      number = json['number'] as String?,
      shouldCall = json['shouldCall'] as bool?;

  Map<String, dynamic> toJson() => {
    'type' : type,
    'number' : number,
    'shouldCall' : shouldCall
  };
}