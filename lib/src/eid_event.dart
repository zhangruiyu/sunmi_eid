class EidEvent {
  final int code;
  final String msg;

  EidEvent({required this.code, required this.msg});

  factory EidEvent.fromMap(Map<dynamic, dynamic> map) {
    final code = map['code'];
    final msg = map['msg'];
    return EidEvent(
      code: code is int ? code : int.tryParse(code?.toString() ?? '') ?? -1,
      msg: msg?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'code': code,
        'msg': msg,
      };

  @override
  String toString() => 'EidEvent(code: ' + code.toString() + ', msg: ' + msg + ')';
}
