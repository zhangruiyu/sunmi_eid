class IDCardInfoResult {
  final int code;
  final String data;

  IDCardInfoResult({required this.code, required this.data});

  factory IDCardInfoResult.fromMap(Map<dynamic, dynamic>? map) {
    final code = map?['code'];
    final data = map?['data'];
    return IDCardInfoResult(
      code: code is int ? code : int.tryParse(code?.toString() ?? '') ?? -1,
      data: data?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'code': code,
        'data': data,
      };

  @override
  String toString() => 'IDCardInfoResult(code: ' + code.toString() + ', data: ' + data + ')';
}
