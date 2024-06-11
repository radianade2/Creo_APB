import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool? _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 70),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Register',
                style: TextStyle(fontSize: 22.0, fontFamily: 'Roboto', fontWeight: FontWeight.w700,),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Create your profile here',
                style: TextStyle(fontSize: 14.0, fontFamily: 'Roboto', fontWeight: FontWeight.w600, letterSpacing: 0.50,),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20,),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
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
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
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
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone",
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
              SizedBox(height: 20,),
              SizedBox(
                height: 50,
                child: TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: const EdgeInsets.all(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (newValue) {
                      setState(() {
                        _isChecked = newValue;
                      });
                    },
                  ),
                  const Text('I accept terms of use and privacy policy', style: TextStyle(color: Color(0xFF595959)),),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  signUp();
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
                  'Create Account',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?', style: TextStyle(color: Color(0xFF595959),),),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp() async {
    String nameC = _nameController.text;
    String usernameC = _usernameController.text;
    String emailC = _emailController.text;
    String phoneC = _phoneController.text;
    String passwordC = _passwordController.text;
    String confirmPasswordC = _confirmPasswordController.text;

    if(nameC.isNotEmpty && emailC.isNotEmpty && passwordC.isNotEmpty && confirmPasswordC.isNotEmpty){
      if(nameC.length >=4 && usernameC.length >= 6)
        if(passwordC == confirmPasswordC){
          try {
            final usernameQuery = await firestore.collection("user").where("username", isEqualTo: usernameC).get();

            if (usernameQuery.docs.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text('Username Sudah Digunakan'))
              );
              return; 
            }

            final userCredential = await auth.createUserWithEmailAndPassword(
              email: emailC,
              password: passwordC,
            );

            if(userCredential.user != null){
              String uid = userCredential.user!.uid;

              await firestore.collection("user").doc(uid).set({
                "name": nameC,
                "username": usernameC,
                "email": emailC,
                "phone" : phoneC,
                "uid": uid,
                "creator": false,
                "profile": null,
                "createdAt": DateTime.now().toIso8601String(),
              });

              await userCredential.user!.sendEmailVerification();
            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Silahkan Konfirmasi Email yang Telah Dikirimkan'),
              )
            );
            print(userCredential);
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text('Password Terlalu Lemah'))
              );
            } else if (e.code == 'email-already-in-use') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text('Email Telah Digunakan'))
              );
              return;
            }
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text('Tidak Dapat Menambahkan Email'))
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Password Tidak Sesuai'))
          );
        }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Nama Kurang Dari 4 Huruf / Username Kurang Dari 6 Huruf'))
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Data Tidak Boleh Kosong'))
      );
    }
  }
}
