import 'package:elli_admin/authentication_handler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:elli_admin/firebase_handler.dart';
import 'package:elli_admin/theme.dart';
import 'package:elli_admin/menu_bar.dart';

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

/// The main widget for ELLI admin
///
/// This widget is presented when the app is started and, whilst Firebase is initializing, a [CircularProgressIndicator] i returned.
/// Once Firebase is initialized, [MyHomePage] is returned.
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Room Bookings',
      theme: ElliTheme.lightTheme,
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

/// The login page
///
/// A login page that navigates to [Home] when login is successful.
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthenticationHandler authenticationHandler =
      AuthenticationHandler.getInstance();

  /// Checks if admin is signed in when page loads, skips login if true
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
                  child: Image.asset('assets/images/elli_logo_large.png'),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  /// Logs the user in using Azure.
  ///
  /// Navigates to [MenuBar] when login is successful. Initializes the [FirebaseHandler]
  Future<void> login() async {
    if (await authenticationHandler.loginWithAzure() != null) {
      //Since Firebase is not dependent on which admin is logged in, skip getting name
      FirebaseHandler.initialize("Admin");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MenuBar()));
    }
  }

  /// Checks if user is logged in and is admin
  ///
  /// Navigates to [MenuBar] when if true is successful. Initializes the [FirebaseHandler]
  Future<void> checkLoggedIn() async {
    if (await authenticationHandler.isUserSignedIn() == true) {
      //Since Firebase is not dependent on which admin is logged in, skip getting name
      FirebaseHandler.initialize("Admin");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MenuBar()));
    }
  }
}
