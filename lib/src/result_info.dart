class BaseInfo {
  final String? idType;
  final String? name;
  final String? sex;
  final String? nation;
  final String? birthDate;
  final String? address;
  final String? idnum;
  final String? signingOrganization;
  final String? beginTime;
  final String? endTime;

  const BaseInfo({
    this.idType,
    this.name,
    this.sex,
    this.nation,
    this.birthDate,
    this.address,
    this.idnum,
    this.signingOrganization,
    this.beginTime,
    this.endTime,
  });

  factory BaseInfo.fromJson(Map<String, dynamic>? json) {
    final j = json ?? const <String, dynamic>{};
    return BaseInfo(
      idType: j['idType']?.toString(),
      name: j['name']?.toString(),
      sex: j['sex']?.toString(),
      nation: j['nation']?.toString(),
      birthDate: j['birthDate']?.toString(),
      address: j['address']?.toString(),
      idnum: j['idnum']?.toString(),
      signingOrganization: j['signingOrganization']?.toString(),
      beginTime: j['beginTime']?.toString(),
      endTime: j['endTime']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'idType': idType,
        'name': name,
        'sex': sex,
        'nation': nation,
        'birthDate': birthDate,
        'address': address,
        'idnum': idnum,
        'signingOrganization': signingOrganization,
        'beginTime': beginTime,
        'endTime': endTime,
      }..removeWhere((key, value) => value == null);

  BaseInfo copyWith({
    String? idType,
    String? name,
    String? sex,
    String? nation,
    String? birthDate,
    String? address,
    String? idnum,
    String? signingOrganization,
    String? beginTime,
    String? endTime,
  }) {
    return BaseInfo(
      idType: idType ?? this.idType,
      name: name ?? this.name,
      sex: sex ?? this.sex,
      nation: nation ?? this.nation,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
      idnum: idnum ?? this.idnum,
      signingOrganization: signingOrganization ?? this.signingOrganization,
      beginTime: beginTime ?? this.beginTime,
      endTime: endTime ?? this.endTime,
    );
  }

  @override
  String toString() {
    return 'BaseInfo{'
        + "idType='" + (idType ?? 'null') + "'"
        + ", name='" + (name ?? 'null') + "'"
        + ", sex='" + (sex ?? 'null') + "'"
        + ", nation='" + (nation ?? 'null') + "'"
        + ", birthDate='" + (birthDate ?? 'null') + "'"
        + ", address='" + (address ?? 'null') + "'"
        + ", idnum='" + (idnum ?? 'null') + "'"
        + ", signingOrganization='" + (signingOrganization ?? 'null') + "'"
        + ", beginTime='" + (beginTime ?? 'null') + "'"
        + ", endTime='" + (endTime ?? 'null') + "'"
        + "}";
  }
}

class ResultInfo {
  /// Mirrors Java: @SerializedName("base_info") public BaseInfo info;
  final BaseInfo? info;

  /// public String dn;
  final String? dn;

  /// public String picture;
  final String? picture;

  /// public String appeidcode;
  final String? appeidcode;

  /// @SerializedName("sub_msg") public String msg = "";
  final String msg;

  /// @SerializedName("sub_code") public int code;
  final int code;

  const ResultInfo({
    this.info,
    this.dn,
    this.picture,
    this.appeidcode,
    this.msg = '',
    this.code = 0,
  });

  factory ResultInfo.fromJson(Map<String, dynamic> json) {
    return ResultInfo(
      info: json.containsKey('base_info') && json['base_info'] is Map
          ? BaseInfo.fromJson((json['base_info'] as Map).cast<String, dynamic>())
          : null,
      dn: (json['dn']?.toString()),
      picture: (json['picture']?.toString()),
      appeidcode: (json['appeidcode']?.toString()),
      msg: (json['sub_msg']?.toString()) ?? '',
      code: _parseInt(json['sub_code']),
    );
  }

  Map<String, dynamic> toJson() => {
        'base_info': info?.toJson(),
        'dn': dn,
        'picture': picture,
        'appeidcode': appeidcode,
        'sub_msg': msg,
        'sub_code': code,
      }..removeWhere((key, value) => value == null);

  ResultInfo copyWith({
    BaseInfo? info,
    String? dn,
    String? picture,
    String? appeidcode,
    String? msg,
    int? code,
  }) {
    return ResultInfo(
      info: info ?? this.info,
      dn: dn ?? this.dn,
      picture: picture ?? this.picture,
      appeidcode: appeidcode ?? this.appeidcode,
      msg: msg ?? this.msg,
      code: code ?? this.code,
    );
  }

  static int _parseInt(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  @override
  String toString() {
    final baseInfoStr = info?.toString() ?? 'null';
    return "ResultInfo{baseInfo='" + baseInfoStr + "', dn='" + (dn ?? 'null') + "', picture='" + (picture ?? 'null') + "', appeidcode='" + (appeidcode ?? 'null') + "', msg='" + msg + "', code='" + code.toString() + "'}";
  }
}
