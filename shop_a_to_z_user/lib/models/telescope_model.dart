import 'package:freezed_annotation/freezed_annotation.dart';
import 'brand_model.dart';
import 'image_dto.dart';

part 'telescope_model.freezed.dart';
part 'telescope_model.g.dart';

@unfreezed
class TelescopeModel with _$TelescopeModel{
  @JsonSerializable(explicitToJson: true) //Using json serailizable library
  factory TelescopeModel({
    String? id,
    required String model,
    required BrandModel brand,
    required String type,
    required String dimension,
    required num weightInPound,
    required String focusType,
    required num lensDiameterInMM,
    required String mountDescription,
    required num price,
    required num stock,
    @Default(0.0) num avgRating,
    @Default(0) num discount, //percent
    required ImageDTO thumbnail,
    required List<ImageDTO> additionalImage,
    String? description
}) = _TelescopeModel;

factory TelescopeModel.fromJson(Map<String, dynamic> json)=>
    _$TelescopeModelFromJson(json);
}