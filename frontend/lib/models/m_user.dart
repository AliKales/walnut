import 'package:frontend/core/json_converters.dart';
import 'package:json_annotation/json_annotation.dart';
part 'm_user.g.dart';

Object? _getRole(json, field) => json['role']['type'];

@JsonSerializable()
class MUser {
  int? id;
  String? username;
  String? email;
  bool? confirmed;
  bool? blocked;
  @JsonKey(fromJson: JsonConvertersFrom.toLocalDateTime)
  DateTime? createdAt;
  @JsonKey(fromJson: JsonConvertersFrom.toLocalDateTime)
  DateTime? updatedAt;
  @JsonKey(readValue: _getRole)
  String? role;

  MUser({
    this.id,
    this.username,
    this.email,
    this.confirmed,
    this.blocked,
    this.createdAt,
    this.updatedAt,
  });

  factory MUser.fromJson(Map<String, dynamic> json) => _$MUserFromJson(json);

  Map<String, dynamic> toJson() => _$MUserToJson(this);
}
