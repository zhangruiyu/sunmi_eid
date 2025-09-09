class EidConstants {
  // Reading flow codes
  static const int READ_CARD_READY = 10000000;
  static const int READ_CARD_START = 10000001;
  static const int READ_CARD_SUCCESS = 30000003;
  static const int READ_CARD_FAILED = 90000009;
  static const int READ_CARD_DELAY = 40000004;
  static const int READ_CARD_DELAY_FAILED = 40000005;

  // Init
  static const int INIT_SUCCESS = 50000000;
  static const int INIT_FAIL = 50000001;

  // Generic success markers used by SDK for certain APIs
  static const int EID_INIT_SUCCESS = 1;
  static const int DECODE_SUCCESS = 1;

  // Error codes
  static const int ERR_APP_ID_NULL = 4001;
  static const int ERR_DNS_EXCEPTION = 4002;
  static const int ERR_NETWORK_EXCEPTION = 4003;
  static const int ERR_INNER_CID = 4004;
  static const int ERR_NETWORK_CONNECT_TIMEOUT = 4005;
  static const int ERR_IDCARD_DATA_NULL = 4006;
  static const int ERR_IDCARD_DATA_DECODE_EXCEPTION = 4007;
  static const int ERR_NETWORK_NOT_CONNECTED = 4008;
  static const int ERR_DEVICE_INFO_NULL = 4009;
  static const int ERR_NFC_NOT_SUPPORT = 4010;
  static const int ERR_NFC_CLOSED = 4011;
  static const int ERR_PERMISSION_NOT_GRANTED = 4012;
  static const int FINANCE_SDK_NOT_FOUND = 4013;
  static const int HTTP_UNKNOWN_ERROR = 4014;
  static const int ERR_NOT_INIT = 4015;
  static const int ERR_TRAVEL_PARAMS_ERROR = 4016;
  static const int ERR_ACCOUNT_EXCEPTION = 5001;

}
