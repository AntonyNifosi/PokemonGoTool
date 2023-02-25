import 'package:json_annotation/json_annotation.dart';
part 'api_version.g.dart';

@JsonSerializable()
class ApiVersion {
  Map<String, String> versions;
  ApiVersion(this.versions);

  static Map<String, dynamic> toJson(ApiVersion apiVersion) => _$ApiVersionToJson(apiVersion);
  static ApiVersion fromJson(Map<String, dynamic> json) => _$ApiVersionFromJson(json);
}
