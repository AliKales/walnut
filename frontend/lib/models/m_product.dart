import 'package:caroby/caroby.dart';
import 'package:frontend/env.dart';
import 'package:json_annotation/json_annotation.dart';

import '../core/json_converters.dart';

part 'm_product.g.dart';

Object? _getImage(json, field) {
  String? url = json['image']?['url'];

  if (url.isEmptyOrNull) return null;

  return BASE_URL + url!;
}

@JsonSerializable()
class MProduct {
  int? id;
  String? name;
  double? price;
  String? description;
  @JsonKey(fromJson: JsonConvertersFrom.toLocalDateTime)
  DateTime? createdAt;
  @JsonKey(name: "user_id")
  int? userId;
  @JsonKey(readValue: _getImage)
  String? image;

  MProduct({
    this.id,
    this.name,
    this.price,
    this.description,
    this.createdAt,
    this.userId,
  });

  factory MProduct.fromJson(Map<String, dynamic> json) =>
      _$MProductFromJson(json);

  Map<String, dynamic> toJson() => _$MProductToJson(this);
}
