class ApiResponseNoData {
  final bool success;
  final String message;

  ApiResponseNoData({required this.success, required this.message});

  factory ApiResponseNoData.fromJson(Map<String, dynamic> json) {
    return ApiResponseNoData(
      success: json['success'],
      message: json['message'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }
}
