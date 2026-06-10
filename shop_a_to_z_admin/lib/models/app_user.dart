import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shop_a_to_z/models/user_address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model_converter/timestamp_converter.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@unfreezed
class AppUser with _$AppUser {
  @JsonSerializable(explicitToJson: true)
  factory AppUser({
    required String uid,
    required String email,
    UserAddress? userAddress,
    String? userName,
    String? phoneNumber,
    @TimestampConverter() Timestamp? userCreationTime
}) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}