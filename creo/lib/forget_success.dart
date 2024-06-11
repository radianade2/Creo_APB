import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class ForgetSuccessScreen extends StatefulWidget {
  final String email;
  const ForgetSuccessScreen({super.key, required this.email});

  @override
  ForgetSuccessScreenState createState() => ForgetSuccessScreenState();
}

class ForgetSuccessScreenState extends State<ForgetSuccessScreen> {
 
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'We\'ve sent Reset Password Link',
                style: TextStyle(fontSize: 22.0, fontFamily: 'Roboto', fontWeight: FontWeight.w700,),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Check your email',
                style: TextStyle(fontSize: 14.0, fontFamily: 'Roboto', fontWeight: FontWeight.w600, letterSpacing: 0.50,),
                textAlign: TextAlign.center,
              ),
              const Padding(padding: EdgeInsets.only(top: 30)),
              Container(
                width: 130, height: 306,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/forget2.png'),
                    fit: BoxFit.contain,
                  )
                ),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
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
                  'Done',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              TextButton(
                onPressed: () {
                  sendEmail();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: const Text('Link Telah Dikirim Ulang'))
                  );
                },
                child: Text('Resend Link',
                  style: TextStyle(color: Color(0xFF911348), fontSize: 14.0, fontFamily: 'Roboto', fontWeight: FontWeight.w600, letterSpacing: 0.50,),
                  textAlign: TextAlign.center,
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendEmail() async {
    if(widget.email.isNotEmpty){
      try{
        await auth.sendPasswordResetEmail(email: widget.email);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Tidak Dapat Mengirim Email Reset Password'))
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Silahkan Isi Email'))
      );
    }
  }
}