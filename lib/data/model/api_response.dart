import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

ApiResponse apiResponseFromJson(String str) => ApiResponse.fromJson(json.decode(str));

@JsonSerializable()
class ApiResponse {
  final bool error;
  final String message;

  ApiResponse({
    required this.error,
    required this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => _$ApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}
