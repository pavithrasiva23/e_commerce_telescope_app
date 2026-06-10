import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:shop_a_to_z_user/models/rating_model.dart';
import '../db/db_helper.dart';
import '../models/app_user.dart';
import '../models/brand_model.dart';
import '../models/image_dto.dart';
import '../models/telescope_model.dart';
import '../utils/constants.dart';

class TelescopeProvider with ChangeNotifier{
List<BrandModel> brandList = [];
List<TelescopeModel> telescopeList = [];

//Add Brands
Future<void> addBrand(String name){
  final brand = BrandModel(name: name);
  return DbHelper.addBrand(brand);
}

//Get All Brands
getAllBrands() {
  //like after future function is done, 'then method' is called, same like for 'stream' will use 'listen method' pass snapshot
  //Anonymous function- Great thing about 'listen' : whenever anything changed (doc deleted, modified, added etc..) inside the particular collection
  //And every time for every changes we get a new snapshot
  DbHelper.getAllBrands().listen((snapshot){
    brandList = List.generate(snapshot.docs.length, (index)=> BrandModel.fromJson(snapshot.docs[index].data()));
    notifyListeners();
  });
}

//upload the images to firestore
// Future<ImageDTO> uploadImages(String imgLocalPath) async {
//   final String imageName = 'image_${DateTime.now().millisecondsSinceEpoch}';
//   //Photo Reference: //Getting root reference + directory name + image name
//   final photoRef = FirebaseStorage
//       .instance
//       .ref().child('$telescopeImageDirectory$imageName');
//   //Uploading the image to firestore
//   final uploadTask = photoRef.putFile(File(imgLocalPath));
//   //will get a snapshot; whenComplete() is called once upload is completed
//   final snapshot = await uploadTask.whenComplete(()=> null);
//   //Get downloadUrl from the snapshot
//   final downloadUrl = '';
//
//   //await snapshot.ref.getDownloadURL();
//   return ImageDTO(imgName: imageName, directoryName: telescopeImageDirectory, downloadUrl: downloadUrl);
// }

  Future<ImageDTO> uploadImages(String imgLocalPath) async {
    return ImageDTO(
      imgName: 'dummy',
      directoryName: 'dummy',
      downloadUrl: dummyImage,
    );
  }

//Add Telescope
Future<void> addTelescope(TelescopeModel telescope) {
  return DbHelper.addTelescope(telescope);
}

//Get All Telescopes
getAllTelescopes() {
  DbHelper.getAllTelescopes().listen((snapshot){
      telescopeList = List.generate(snapshot.docs.length, (index)=> TelescopeModel.fromJson(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  TelescopeModel findTelescopeById(String telescopeId) =>
      telescopeList.firstWhere((element)=> element.id == telescopeId);

//Update Telescope field by telescope
Future<void> updateTelescopeField(String id, String field, dynamic value) {
  return  DbHelper.updateTelescopeField(id, {field : value});
}

//Delete images from the additional images
Future<void> deleteImage(String telescopeId, ImageDTO imageModel) async {
  //firebase storage reference as like (photoref)
  final photoRef = FirebaseStorage.instance.ref()
  .child('${imageModel.directoryName}${imageModel.imgName}');
  return photoRef.delete();
}

//Add Rating
Future<void> addRating(String telescopeId, AppUser appUser, num rating) async {
  final ratingModel = RatingModel(appUser: appUser, rating: rating);
  await DbHelper.addRating(telescopeId, ratingModel);
  //Calculate All Ratings for this telescopeId (product)
  final snapShot = await DbHelper.getAllRatings(telescopeId);
  //Convert Snapshot to List<RatingModel>
  final List<RatingModel> ratingList = List.generate(snapShot.docs.length,
          (index)=> RatingModel.fromJson(snapShot.docs[index].data()));
  num total = 0.0;
  for(final rating in ratingList){
    total += rating.rating;
  }
  final avgRating = total / ratingList.length;
  return DbHelper.updateTelescopeField(telescopeId, {'avgRating': avgRating});
}
}