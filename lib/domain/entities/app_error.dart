class AppError {
  final String code;
  final String message;
  final Map<String, dynamic>? details;
  final DateTime timestamp;

  AppError({
    required this.code,
    required this.message,
    this.details,
  }) : timestamp = DateTime.now();

  factory AppError.fromJson(Map<String, dynamic> json) {
    return AppError(
      code: json['code'] ?? 'UNKNOWN_ERROR',
      message: json['message'] ?? 'An unknown error occurred',
      details: json['details'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AppError && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;
}
