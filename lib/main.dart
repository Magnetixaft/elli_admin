import 'package:elli_admin/authentication_handler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:elli_admin/firebase_handler.dart';
import 'package:elli_admin/home.dart';
import 'package:elli_admin/theme_elicit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // Firebase options related to FirebaseDB
      options: const FirebaseOptions(
          apiKey: "AIzaSyD71VJDiqwq5e2y7gpaszs4um91jR6tN1g",
          authDomain: "agilequeen-82096.firebaseapp.com",
          projectId: "agilequeen-82096",
          storageBucket: "agilequeen-82096.appspot.com",
          messagingSenderId: "883336254219",
          appId: "1:883336254219:web:7d2de78527260bb27e080e"));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Room Bookings',
      theme: elicitTheme(),
      home: FutureBuilder(
        //Initializes Firebase
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          //If Connection with Firebase failed
          if (snapshot.hasError) {
            print("Firebase initialization error");
          }
          //Checks connection to Firebase and when done loads HomePage
          if (snapshot.connectionState == ConnectionState.done) {
            print("Firebase initialized correctly");
            return const MyHomePage(
              title: "Room Bookings",
            );
          }
          //Waiting for connection with Firebase
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthenticationHandler authenticationHandler = AuthenticationHandler
      .getInstance();

  ///Checks loginstatus when page loads, skips login if true
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => checkLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Container(
            width: 700,
            child: Column(
              children: [
                Expanded(
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 80, 40, 20),
                        child: Image.asset('assets/images/elicit_logo.png'),
                      )),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () => {login()},
                              child: const Text(
                                "Login",
                              )),
                        ),
                        //TODO remove, logout for testing
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () => {logOut()},
                              child: const Text(
                                "logout",
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  ///Opens Azure popup and checks if user is admin, if true navigate to home
  Future<void> login() async {
    //Since Firebase is not dependent on which admin is logged in, skip getting name
    if (await authenticationHandler.loginWithAzure() != null) {
      FirebaseHandler.initialize("Admin");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
              const Home()));
    }
  }

  ///Checks if user is logged in and is admin, if true navigate to home
  Future<void> checkLoggedIn() async {
    //Since Firebase is not dependent on which admin is logged in, skip getting name
    if (await authenticationHandler.isUserSignedIn() == true) {
      FirebaseHandler.initialize("Admin");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
              const Home()));
    }
  }
  //TODO remove, logout for testing
  Future<void> logOut() async {
    authenticationHandler.signOut();
  }
}
