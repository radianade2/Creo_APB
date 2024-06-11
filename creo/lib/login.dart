import 'dart:math';
import 'package:flutter/material.dart';
import 'register.dart';
import 'forget_password.dart';
import 'home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 70),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 22.0, fontFamily: 'Roboto', fontWeight: FontWeight.w700,),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'Please login to continue',
                    style: TextStyle(fontSize: 14.0, fontFamily: 'Roboto', fontWeight: FontWeight.w600, letterSpacing: 0.50,),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      autocorrect: false,
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Forget Password'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      signIn();
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Or login with',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      signInWithGoogle();
                    },
                    icon: const FaIcon(FontAwesomeIcons.google, size: 14,),
                    label: const Text('Google'),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Color(0xFF350A49)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signIn() async {
    String emailC = _emailController.text;
    String passwordC = _passwordController.text;

    if(emailC.isNotEmpty && passwordC.isNotEmpty){
      try {
        final userCredential = await auth.signInWithEmailAndPassword(
          email: emailC,
          password: passwordC
        );

        if(userCredential.user != null){
          if(userCredential.user!.emailVerified == true){
            Navigator.pushReplacement(
              context,
              // MaterialPageRoute(builder: (context) => const Screen()),
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Akun Belum Terverifikasi, Silahkan Cek Email Terlebih Dahulu'),
                action: SnackBarAction(
                  label: 'Kirim Ulang Verifikasi', 
                  onPressed: () async {
                    try{
                      await userCredential.user!.sendEmailVerification();
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: const Text('Email Verifikasi Berhasil Terkirim'))
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: const Text('Tidak Dapat Mengirim Email Verifikasi'))
                      );
                    }
                  },
                ),
              )
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Email / Password Salah'))
          );
        } else if (e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Format Email Salah'))
          );
        } else if(e.code == 'too-many-requests') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Terlalu Banyak Percobaan, Coba Lagi Nanti'))
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Tidak Dapat Login'))
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Email / Password Kosong'))
      );
    }
  }

  Future<void> signInWithGoogle() async {
    String randomStr;
    const String _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random _rnd = Random();

    randomStr = String.fromCharCodes(Iterable.generate( 6,
      (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
    ));

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google [UserCredential]
      final UserCredential userCredential = await auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final emailQuery = await firestore.collection("user").where("email", isEqualTo: user.email).get();

        if (emailQuery.docs.isNotEmpty) {
          Navigator.push(
            context,
            // MaterialPageRoute(builder: (context) => const Screen()),
            MaterialPageRoute(builder: (context) => HomeScreen())
          );
        } else {
          await firestore.collection("user").doc(user.uid).set({
            "name": user.displayName,
            "username": "user_$randomStr",
            "email": user.email,
            "phone" : user.phoneNumber,
            "uid": user.uid,
            "creator": false,
            "profile": user.photoURL,
            "createdAt": DateTime.now().toIso8601String(),
          });
          Navigator.push(
            context,
            // MaterialPageRoute(builder: (context) => const Screen()),
            MaterialPageRoute(builder: (context) => HomeScreen())
          );
          print('User signed in: ${user.email}');
        }
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

}