import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_dto.freezed.dart';
part 'image_dto.g.dart';

@freezed
class ImageDTO with _$ImageDTO {
  const factory ImageDTO({
    required String imgName,
    required String directoryName,
    required String downloadUrl,
    //@Default('') String downloadUrl,
  }) = _ImageDTO;

//fromJson --> Just define the signature method for 'fromJson()'
  factory ImageDTO.fromJson(Map<String, dynamic> json) =>
      _$ImageDTOFromJson(json);
}