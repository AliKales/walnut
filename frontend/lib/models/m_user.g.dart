// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MUser _$MUserFromJson(Map json) => MUser(
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      confirmed: json['confirmed'] as bool?,
      blocked: json['blocked'] as bool?,
      createdAt:
          JsonConvertersFrom.toLocalDateTime(json['createdAt'] as String),
      updatedAt:
          JsonConvertersFrom.toLocalDateTime(json['updatedAt'] as String),
    )..role = _getRole(json, 'role') as String?;

Map<String, dynamic> _$MUserToJson(MUser instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'confirmed': instance.confirmed,
      'blocked': instance.blocked,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'role': instance.role,
    };
