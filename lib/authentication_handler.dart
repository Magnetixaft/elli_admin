import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';

/// A singleton handler for Azure-login functionality.
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
      return await getAdminList();

  }

  ///Checks if user is logged in and has adming privileges
  Future<bool> isUserSignedIn() async {
    List<String> adminList = await getAdmins();
    if(FirebaseAuth.instance.currentUser != null && await adminList.contains(await FirebaseAuth.instance.currentUser?.email)){
      return true;
    }else {
      return false;
    }
  }

  ///Gets the currently signed in user
  Future<User?> getCurrentUser() async{
    return FirebaseAuth.instance.currentUser;
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

  ///Gets a list of all users with admin privileges
  Future<List<String>> getAdminList() async {
    var data = await FirebaseFirestore.instance.collection('Admins').where('Permissions', isEqualTo: "all").get();
    List<String> adminList = [];
    for (var doc in data.docs) {
      adminList.add(doc.id);
    }
    return adminList;
  }

}
