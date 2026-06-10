import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_a_to_z_user/auth/auth_service.dart';
import 'package:shop_a_to_z_user/models/app_user.dart';
import '../db/db_helper.dart';

class UserProvider extends ChangeNotifier{
  AppUser? appUser;
//1) Add User
Future<void> addUser({required User user, String? name, String? phoneNumber}) {
  final appUser = AppUser(
      uid: user.uid,
      email: user.email!,
      userName: name,
    phoneNumber: phoneNumber,
    userCreationTime: Timestamp.fromDate(user.metadata.creationTime!), //fromData --> convert DateTime to Timestamp
  );
  return DbHelper.addUser(appUser);
}

//2) Does user exist or not -->   //Returns future boolean
  Future<bool> doesUserExist(String userId) => DbHelper.doesUserExist(userId);

//3) Get User Info
getUserInfo(){
  DbHelper.getUserInfo(AuthService.currentUser!.uid).listen((event) {
    if(event.exists){
      //Fetch map from this snapshot and pass it to the 'fromJson constructor' for our 'AppUser'
      appUser = AppUser.fromJson(event.data()!);
      notifyListeners(); //call the notifyListeners
    }
  }

  );
}
}