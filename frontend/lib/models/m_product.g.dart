// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MProduct _$MProductFromJson(Map json) => MProduct(
      id: json['id'] as int?,
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      description: json['description'] as String?,
      createdAt:
          JsonConvertersFrom.toLocalDateTime(json['createdAt'] as String),
      userId: json['user_id'] as int?,
    )..image = _getImage(json, 'image') as String?;

Map<String, dynamic> _$MProductToJson(MProduct instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'description': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
      'user_id': instance.userId,
      'image': instance.image,
    };
