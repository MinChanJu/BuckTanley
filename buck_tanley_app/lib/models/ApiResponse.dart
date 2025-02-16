class ApiResponse<T> {
  final int status;
  final bool success;
  final String message;
  final T? data;

  ApiResponse({
    required this.status,
    required this.success,
    required this.message,
    this.data,
  });

  // 🔍 단일 객체 변환
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  // 🔍 리스트 변환 (반환 타입을 `ApiResponse<List<T>>`로 변경)
  static ApiResponse<List<T>> fromJsonList<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    if (json['data'] != null && json['data'] is List) {
      final List<dynamic> jsonData = json['data'];
      final List<T> list = jsonData.map((item) => fromJsonT(item as Map<String, dynamic>)).toList();

      return ApiResponse<List<T>>(
        status: json['status'] as int,
        success: json['success'] as bool,
        message: json['message'] as String,
        data: list,
      );
    } else {
      throw Exception('Invalid JSON format for List<$T>');
    }
  }

  // 🔍 객체 → JSON
  Map<String, dynamic> toJson(Object Function(T) toJsonT) => {
        'status': status,
        'success': success,
        'message': message,
        'data': data != null ? toJsonT(data as T) : null,
      };

  @override
  String toString() {
    return 'ApiResponse(status: $status, success: $success, message: $message, data: $data)';
  }
}