import 'package:flutter/cupertino.dart';

import '../db/db_helper.dart';
import '../models/app_user.dart';

class UserProvider with ChangeNotifier{
List<AppUser> users = [];

  //1) Get All Users
getAllUsers() {
    DbHelper.getAllUsers().listen((event) {
      users = List.generate(event.docs.length,
              (index) => AppUser.fromJson(event.docs[index].data()));
      notifyListeners();
    });
  }

}