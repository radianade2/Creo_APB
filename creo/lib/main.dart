// import 'package:creo/home.dart';
import 'package:creo/home.dart';
import 'package:creo/onboarding.dart';
import 'package:creo/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

// import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ZIMKit().init(
    appID: 862758829, // your appid
    appSign: "a235dd7056542e8c628c2666940841290f66e407ab85f512ac88c1db3dc63a51", // your appSign
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  OnBoardingScreenState().isShowed = true;

  runApp(
    StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ); 
        }
        return MaterialApp(
          title: "Creo",
          home: snapshot.data != null
              ? (snapshot.data!.emailVerified ? HomeScreen() : LoginScreen())
              : (OnBoardingScreenState().isShowed ? LoginScreen() : OnBoardingScreen()),
        );
      },
    ),
  );
}