import 'package:elli_admin/firebase_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';

class AuthenticationHandler {
  static final AuthenticationHandler _instance = AuthenticationHandler._();
  AuthenticationHandler._();

  static void initialize() {
  }

  static AuthenticationHandler getInstance() {
    return _instance;
  }

  ///Opens Azure popup and logs in, if user has admin privileges return the user
  Future<User?> loginWithAzure() async {
    try{
      List<String> adminList = await getAdmins();
      User? user = await FirebaseAuthOAuth().openSignInFlow("microsoft.com", ["openid profile offline_access"], {'tenant': '48306bc3-49ff-43e2-8964-4bd7d2dbba92'});
      print(user?.email);
      if(adminList.contains(user?.email)){
        return user;
      }else{
        return null;
      }
    } on FirebaseAuthException catch (e){
      print(e.message);
    }
  }

  ///Gets list of users with admin privileges
  Future<List<String>> getAdmins() async{
    return await FirebaseHandler.getInstance().getAdminList();
  }

  ///Checks if user is logged in and has adming privileges
  Future<bool> isUserSignedIn() async {
    List<String> adminList = await getAdmins();
    if(FirebaseAuth.instance.currentUser != null && await adminList.contains(await FirebaseAuth.instance.currentUser?.email)){
      return false;
    }else {
      return true;
    }
  }

  ///Gets the currently signed in user
  Future<User?> getCurrentUser() async{
    return await FirebaseAuth.instance.currentUser;
  }

  ///Signs a user out
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print(await isUserSignedIn());
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

}