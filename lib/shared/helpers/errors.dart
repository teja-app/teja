import 'package:teja/domain/entities/app_error.dart';

class StaticErrorCodes {
  static const String NETWORK_ERROR = 'NETWORK_ERROR';
  static const String UNKNOWN_ERROR = 'UNKNOWN_ERROR';
  static const String AUTHENTICATION_ERROR = 'AUTHENTICATION_ERROR';
  // Add more static error codes as needed
}

final maps = <String, String>{
  StaticErrorCodes.AUTHENTICATION_ERROR: "Authentication Error",
};

AppError createAppError(dynamic serverResponse) {
  if (serverResponse is Map<String, dynamic>) {
    if (maps[serverResponse['code']]!.isNotEmpty) {
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
