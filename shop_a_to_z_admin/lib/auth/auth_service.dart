import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_a_to_z/db/db_helper.dart';

class AuthService{
  //get FirebaseAuth instance
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  //get current logged in user
  static User? get currentUser => _auth.currentUser;

  //get credentials --> Firebase Authentication Service by providing the email and password
  static Future<bool> loginAdmin(String email, String password) async {
    final credentials = await _auth.signInWithEmailAndPassword(email: email, password: password); //returns credentials object
    return DbHelper.isAdmin(credentials.user!.uid);
  }

  //logout
  static Future<void> logout() {
    return _auth.signOut();
}
}