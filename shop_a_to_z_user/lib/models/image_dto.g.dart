// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ImageDTOImpl _$$ImageDTOImplFromJson(Map<String, dynamic> json) =>
    _$ImageDTOImpl(
      imgName: json['imgName'] as String,
      directoryName: json['directoryName'] as String,
      downloadUrl: json['downloadUrl'] as String,
    );

Map<String, dynamic> _$$ImageDTOImplToJson(_$ImageDTOImpl instance) =>
    <String, dynamic>{
      'imgName': instance.imgName,
      'directoryName': instance.directoryName,
      'downloadUrl': instance.downloadUrl,
    };
