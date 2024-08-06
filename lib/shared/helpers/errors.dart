import 'package:teja/domain/entities/app_error.dart';

class StaticErrorCodes {
  static const String NETWORK_ERROR = 'NETWORK_ERROR';
  static const String UNKNOWN_ERROR = 'UNKNOWN_ERROR';
  static const String AUTHENTICATION_ERROR = 'AUTHENTICATION_ERROR';
  static const String NO_RECOVERY_CODE = 'NO_RECOVERY_CODE';
  // Add more static error codes as needed
}

final maps = <String, String>{
  StaticErrorCodes.AUTHENTICATION_ERROR: "Authentication Error",
  StaticErrorCodes.NO_RECOVERY_CODE: "Recovery Code",
  StaticErrorCodes.NETWORK_ERROR: 'Network Error',
};

AppError createAppError(dynamic serverResponse) {
  print("serverResponse ${serverResponse}");
  if (serverResponse is Map<String, dynamic>) {
    if (maps[serverResponse['code']] != null) {
      serverResponse['code'] = maps[serverResponse['code']];
      return AppError.fromJson(serverResponse);
    }
    return AppError.fromJson(serverResponse);
  } else if (serverResponse is String) {
    return AppError(
      code: StaticErrorCodes.UNKNOWN_ERROR,
      message: serverResponse,
    );
  } else {
    return AppError(
      code: StaticErrorCodes.UNKNOWN_ERROR,
      message: 'An unknown error occurred',
    );
  }
}
