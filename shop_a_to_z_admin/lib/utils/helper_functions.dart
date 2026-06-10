import 'package:shop_a_to_z/models/image_dto.dart';

class Helpers{

  static num priceAfterDiscount(num price, num discount)=> price - (price * discount / 100);

  static List<Map<String, dynamic>> toImageMapList(List<ImageDTO> imageModels) {
    return List.generate(imageModels.length, (index)=> imageModels[index].toJson());
  }
}