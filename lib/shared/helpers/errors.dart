import 'package:teja/domain/entities/app_error.dart';

class StaticErrorCodes {
  static const String networkError = 'NETWORK_ERROR';
  static const String unknownError = 'UNKNOWN_ERROR';
  static const String authenticationError = 'AUTHENTICATION_ERROR';
  static const String noRecoveryCode = 'NO_RECOVERY_CODE';
  // Add more static error codes as needed
}

final maps = <String, String>{
  StaticErrorCodes.authenticationError: "Authentication Error",
  StaticErrorCodes.noRecoveryCode: "Recovery Code",
  StaticErrorCodes.networkError: 'Network Error',
};

AppError createAppError(dynamic serverResponse) {
  if (serverResponse is Map<String, dynamic>) {
    if (maps[serverResponse['code']] != null) {
      serverResponse['code'] = maps[serverResponse['code']];
      return AppError.fromJson(serverResponse);
    }
    return AppError.fromJson(serverResponse);
  } else if (serverResponse is String) {
    return AppError(
      code: StaticErrorCodes.unknownError,
      message: serverResponse,
    );
  } else {
    return AppError(
      code: StaticErrorCodes.unknownError,
      message: 'An unknown error occurred',
    );
  }
}
