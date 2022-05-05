import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationHandler {
  static final AuthenticationHandler _instance = AuthenticationHandler._();
  AuthenticationHandler._();

  static void initialize() {
  }

  static AuthenticationHandler getInstance() {
    return _instance;
  }

  Future<User?> signInUsingEmailPassword({required String email, required String password,}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on Exception catch (e) {
      print(e);
    }
    return user;
  }

  Future<bool> isUserSignedIn() async {
    if(FirebaseAuth.instance.currentUser == null){
      return false;
    }else {
      return true;
    }
  }

  Future<User?> getCurrentUser() async{
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> signOut() async {
    try {
      FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

}
